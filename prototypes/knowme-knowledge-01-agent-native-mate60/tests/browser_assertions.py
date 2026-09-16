#!/usr/bin/env python3
"""GOAL-KK-01 browser technical assertions (engineering_required evidence).

Operates the real running prototype over HTTP in a real Chromium browser at a
Mate60-class portrait viewport (simulation, not an on-device measurement).
Records console errors and page errors. Emits a JSON receipt.

Usage:
  python3 browser_assertions.py --url http://127.0.0.1:5173 \
      --out <receipt.json> [--shots <screenshot_dir>] [--prefix ED|LE]
"""
import argparse
import json
import sys
import time
from datetime import datetime, timezone

from playwright.sync_api import sync_playwright

VIEWPORT = {"width": 360, "height": 780}  # Mate60-class portrait SIMULATION

results = []
console_errors = []
page_errors = []


def check(name, ok, detail=""):
    results.append({"assertion": name, "pass": bool(ok), "detail": detail})
    print(("PASS" if ok else "FAIL"), name, "-", detail)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--url", required=True)
    parser.add_argument("--out", required=True)
    parser.add_argument("--shots", default=None)
    parser.add_argument("--prefix", default="ED")
    args = parser.parse_args()

    with sync_playwright() as pw:
        browser = pw.chromium.launch()
        page = browser.new_page(viewport=VIEWPORT)
        page.on("console", lambda msg: console_errors.append(msg.text) if msg.type == "error" else None)
        page.on("pageerror", lambda err: page_errors.append(str(err)))

        page.goto(args.url, wait_until="networkidle")

        def shot(name):
            if args.shots:
                page.screenshot(path=f"{args.shots}/{args.prefix}-{name}.png")

        # --- Journey A: First Encounter ---
        check("FIRST_VIEW_AGENT_IDENTITY",
              page.get_by_test_id("agent-identity").is_visible()
              and "个人知识 Agent" in page.get_by_test_id("agent-identity").inner_text(),
              "header shows personal knowledge Agent identity")
        check("PROTOTYPE_STATE_DISCLOSED",
              page.get_by_test_id("prototype-disclosure").is_visible()
              and "PROTOTYPE" in page.get_by_test_id("prototype-disclosure").inner_text(),
              page.get_by_test_id("prototype-disclosure").inner_text())
        check("FIRST_VIEW_KNOWLEDGE_CONTEXT",
              page.get_by_test_id("knowledge-context-summary").is_visible(),
              "current knowledge context summary visible")
        check("FIRST_VIEW_KNOWN_UNKNOWN",
              page.get_by_test_id("gap-gap-1").is_visible(),
              "known/unknown gaps visible")
        check("FIRST_VIEW_CAPTURE_ENTRY", page.get_by_test_id("nav-capture").is_visible(), "capture entry")
        check("FIRST_VIEW_ASK_ENTRY", page.get_by_test_id("ask-agent-entry").is_visible(), "ask-Agent entry")
        check("FIRST_VIEW_CAPABILITIES",
              all(page.get_by_test_id(f"nav-{n}").is_visible() for n in ("knowledge", "calendar", "todo", "skills")),
              "capability entries visible")
        check("STATE_FIRST_VIEW",
              page.get_by_test_id("app-root").get_attribute("data-journey-state") == "FIRST_VIEW",
              page.get_by_test_id("app-root").get_attribute("data-journey-state"))
        # Owner-directed (R4): brand renamed 懂我 -> 灵犀 (KnowMe-NJX-Demo authority)
        header_text = page.get_by_test_id("agent-identity").inner_text()
        first_agent_msg = page.get_by_test_id("message-agent").first.inner_text()
        check("BRAND_RENAMED_LINGXI",
              "灵犀" in header_text and "懂我" not in header_text
              and "我是灵犀" in first_agent_msg and "懂我" not in first_agent_msg,
              "header + opening message use 灵犀; 懂我 fully retired")

        # Owner-directed: continuous background voice sensing, honestly disclosed
        strip = page.get_by_test_id("sensing-strip")
        check("SENSING_STRIP_VISIBLE", strip.is_visible(), "persistent sensing strip mounted")
        check("SENSING_CONTINUOUS_BY_DEFAULT",
              strip.get_attribute("data-sensing") == "on" and "后台持续感知中" in strip.inner_text(),
              strip.inner_text().replace("\n", " "))
        check("SENSING_HONESTLY_MOCK",
              "无真实 ASR" in strip.inner_text(), "simulated sensing never claims real ASR")
        check("SENSING_STREAM_TICKS", "模拟感知" in page.get_by_test_id("sensing-line").inner_text(),
              page.get_by_test_id("sensing-line").inner_text())
        shot("P01-FIRST-ENCOUNTER")

        # --- Journey B: Ask the Agent ---
        page.get_by_test_id("composer-input").fill("ABC 供应商延迟会影响什么?")
        page.get_by_test_id("composer-send").click()
        page.get_by_test_id("message-agent").last.wait_for()
        page.wait_for_timeout(700)
        agent_msgs = page.get_by_test_id("message-agent")
        last = agent_msgs.last.inner_text()
        check("ASK_AGENT_WORKS", agent_msgs.count() >= 2 and "ABC" in last, last[:60])
        check("AGENT_RESPONSE_REFERENCES_CONTEXT",
              page.get_by_test_id("agent-refs").last.is_visible()
              and "供应商与 SLA" in page.get_by_test_id("agent-refs").last.inner_text(),
              page.get_by_test_id("agent-refs").last.inner_text())
        check("STATE_ASK_AGENT",
              page.get_by_test_id("app-root").get_attribute("data-journey-state") == "ASK_AGENT",
              page.get_by_test_id("app-root").get_attribute("data-journey-state"))
        shot("P02-ASK-AGENT")

        # Next action opens contextual work without replacing conversation
        page.get_by_test_id("agent-next-action").last.click()
        page.get_by_test_id("knowledge-detail").wait_for()
        check("NEXT_ACTION_OPENS_CONTEXTUAL_WORK", page.get_by_test_id("knowledge-detail").is_visible(),
              "next action opened knowledge detail overlay")
        check("CONVERSATION_PRESERVED_UNDER_OVERLAY", page.get_by_test_id("conversation").is_visible(),
              "conversation DOM still mounted under overlay")
        page.get_by_test_id("knowledge-detail-close").click()
        page.get_by_test_id("knowledge-sheet").wait_for()
        page.get_by_test_id("knowledge-sheet-close").click()
        page.wait_for_timeout(300)

        # --- Journey C: Information enters knowledge ---
        page.get_by_test_id("nav-capture").click()
        page.get_by_test_id("capture-sheet").wait_for()
        check("TEXT_CAPTURE_WORKS", page.get_by_test_id("capture-input").is_visible(), "capture sheet opens")
        check("STATE_CAPTURE",
              page.get_by_test_id("app-root").get_attribute("data-journey-state") == "CAPTURE",
              page.get_by_test_id("app-root").get_attribute("data-journey-state"))
        check("CAPTURE_CHANNELS_DISCLOSED",
              "PROTOTYPE_ONLY" in page.get_by_test_id("capture-channel-voice").inner_text(),
              page.get_by_test_id("capture-channel-voice").inner_text().replace("\n", " "))
        page.get_by_test_id("capture-input").fill("备用供应商 XYZ 报价每台便宜 8%,但需要提前两周下单。")
        page.get_by_test_id("capture-submit").click()
        page.get_by_test_id("candidate-card").wait_for()
        check("CANDIDATE_KNOWLEDGE_CREATED",
              page.get_by_test_id("app-root").get_attribute("data-journey-state") == "CANDIDATE_KNOWLEDGE",
              page.get_by_test_id("candidate-title").inner_text())
        shot("P03-CANDIDATE-KNOWLEDGE")

        # Correct path exists and works — KK-PX-R5-03 (model A): 保存修正只更新
        # 候选并返回候选卡,绝不直接入库;入库只能由显式「确认入库」触发
        page.get_by_test_id("candidate-correct").click()
        page.get_by_test_id("correct-block").wait_for()
        check("CORRECT_SAVE_HINT_VISIBLE",
              "不会直接入库" in page.get_by_test_id("correct-save-hint").inner_text(),
              "user can predict before click: save does NOT ingest")
        page.get_by_test_id("correct-title").fill("备用供应商 XYZ 报价(已修正)")
        page.get_by_test_id("correct-save").click()
        page.get_by_test_id("candidate-card").wait_for()
        check("CORRECT_SAVE_RETURNS_TO_CANDIDATE",
              page.get_by_test_id("candidate-title").inner_text() == "备用供应商 XYZ 报价(已修正)"
              and page.get_by_test_id("app-root").get_attribute("data-journey-state") == "CANDIDATE_KNOWLEDGE",
              "save correction returns to candidate card, still awaiting explicit confirm")
        check("CORRECT_SAVE_NO_DIRECT_INGEST",
              "6 条知识" in page.get_by_test_id("knowledge-context-summary").inner_text(),
              "knowledge count unchanged after 保存修正 (KK-PX-R5-03)")
        # Explicit 确认入库 is the ONLY ingest path
        page.get_by_test_id("candidate-confirm").click()
        page.wait_for_timeout(400)
        check("CORRECT_WORKS", page.get_by_test_id("conversation").inner_text().find("已修正") >= 0,
              "corrected candidate confirmed into context")
        check("CONFIRMED_KNOWLEDGE_CHANGES_CONTEXT",
              "7 条知识" in page.get_by_test_id("knowledge-context-summary").inner_text(),
              page.get_by_test_id("context-summary-button").inner_text())
        check("AGENT_EXPLAINS_CONTEXT_CHANGE",
              "已确认入库" in page.get_by_test_id("message-agent").last.inner_text(),
              page.get_by_test_id("message-agent").last.inner_text()[:60])
        check("STATE_CONTEXT_UPDATED",
              page.get_by_test_id("app-root").get_attribute("data-journey-state") == "KNOWLEDGE_CONTEXT_UPDATED",
              page.get_by_test_id("app-root").get_attribute("data-journey-state"))
        shot("P04-KNOWLEDGE-CONTEXT-CHANGED")

        # Reject path works (second capture)
        page.get_by_test_id("nav-capture").click()
        page.get_by_test_id("capture-input").fill("一条将被拒绝的测试信息。")
        page.get_by_test_id("capture-submit").click()
        page.get_by_test_id("candidate-card").wait_for()
        page.get_by_test_id("candidate-reject").click()
        page.wait_for_timeout(300)
        check("REJECT_WORKS", "已拒绝" in page.get_by_test_id("message-agent").last.inner_text(),
              page.get_by_test_id("message-agent").last.inner_text()[:50])
        check("REJECT_DOES_NOT_GROW_CONTEXT",
              "7 条知识" in page.get_by_test_id("knowledge-context-summary").inner_text(),
              "count unchanged after reject")
        # Confirm main path (third capture, direct confirm)
        page.get_by_test_id("capture-input").fill("周四装机窗口剩余 28 分钟确认时间。")
        page.get_by_test_id("capture-submit").click()
        page.get_by_test_id("candidate-card").wait_for()
        page.get_by_test_id("candidate-confirm").click()
        page.wait_for_timeout(300)
        check("CONFIRM_WORKS",
              "8 条知识" in page.get_by_test_id("knowledge-context-summary").inner_text(),
              page.get_by_test_id("context-summary-button").inner_text())

        # --- Owner-directed: knowledge navigation + knowledge by calendar ---
        page.get_by_test_id("nav-knowledge").click()
        page.get_by_test_id("knowledge-sheet").wait_for()
        # R5: navigation IS the two maps — no extra MOC/WIKI/NOTE groupings
        check("KNOWLEDGE_NAVIGATION_VIEW",
              page.get_by_test_id("knowledge-nav-view").is_visible()
              and page.get_by_test_id("dim5-map").is_visible()
              and page.get_by_test_id("dim9-map").is_visible(),
              "navigation view renders the two Owner-defined maps")
        check("KNOWLEDGE_NAV_NO_LEGACY_GROUPS",
              page.get_by_test_id("nav-group-moc").count() == 0
              and page.get_by_test_id("nav-group-wiki").count() == 0
              and page.get_by_test_id("nav-group-note").count() == 0,
              "R5: no extra MOC/WIKI/NOTE groups beyond 五维/九维 maps")
        # Owner-directed (KnowMe-NJX-Demo authority): 五维知识地图 + 九维认知图谱
        dim5 = page.get_by_test_id("dim5-map")
        check("KNOWLEDGE_NAV_FIVE_DIM_MAP",
              dim5.is_visible()
              and all(x in dim5.inner_text() for x in ["工作记录", "生活感悟", "人生规划", "系统思考", "行业洞察"]),
              "five-dimension knowledge map renders all five life dimensions")
        dim9 = page.get_by_test_id("dim9-map")
        check("KNOWLEDGE_NAV_NINE_DIM_COGNITIVE",
              dim9.is_visible()
              and all(x in dim9.inner_text() for x in ["身份角色", "价值认知", "能力复用", "人物关系",
                                                       "知识与工具", "行为与表达", "目标与项目", "决策与反馈", "动态与情景"]),
              "nine-dimension cognitive graph renders all nine dimensions")
        dim5_work = page.get_by_test_id("dim5-map-d5-work")
        check("CAPTURED_ITEM_IN_FIVE_DIM",
              dim5_work.inner_text().strip().endswith("5"),
              "工作记录 count = 3 seeds + 2 confirmed captures = 5 (live count): " + dim5_work.inner_text().replace("\n", " "))
        dim5_work.click()
        page.get_by_test_id("dim5-map-items-d5-work").wait_for()
        check("DIM_ROW_EXPAND_LISTS_REAL_ITEMS",
              "AOG 航材保障" in page.get_by_test_id("dim5-map-items-d5-work").inner_text()
              and "周四装机窗口剩余" in page.get_by_test_id("dim5-map-items-d5-work").inner_text(),
              "dimension expands to its real items incl. today's capture")
        shot("P10-KNOWLEDGE-NAVIGATION")
        # R5: captured item also reachable via the nine-dim cognitive graph
        page.get_by_test_id("dim9-map-d9-09").click()
        page.get_by_test_id("dim9-map-items-d9-09").wait_for()
        check("CAPTURED_ITEM_IN_NAV",
              "周四装机窗口剩余" in page.get_by_test_id("dim9-map-items-d9-09").inner_text(),
              "confirmed capture appears under 九维 09 动态与情景")
        # dimension item opens the same knowledge detail
        page.get_by_test_id("dim9-map-items-d9-09").get_by_test_id("knowledge-item-k-risk-note").click()
        page.get_by_test_id("knowledge-detail").wait_for()
        check("DIM_ITEM_OPENS_DETAIL",
              "供应风险记录" in page.get_by_test_id("knowledge-detail").inner_text(),
              "dimension item opens knowledge detail")
        page.get_by_test_id("knowledge-detail-close").click()
        page.get_by_test_id("knowledge-sheet").wait_for()
        page.get_by_test_id("knowledge-tab-calendar").click()
        page.get_by_test_id("knowledge-calendar-view").wait_for()
        # R5: knowledge calendar has 日/周/月 three views like the schedule calendar
        check("KNOWLEDGE_CAL_VIEW_SWITCHER",
              all(page.get_by_test_id(f"knowledge-cal-view-{v}").is_visible() for v in ("day", "week", "month")),
              "knowledge calendar day / week / month view switcher rendered")
        today_group = page.get_by_test_id("knowledge-day-2026-09-16").inner_text()
        check("KNOWLEDGE_CALENDAR_VIEW",
              "AOG 航材保障" in today_group and "供应风险记录" in today_group,
              "knowledge day view defaults to 今天 (2026-09-16)")
        check("VALUE_LOOP_CAPTURED_VISIBLE_BY_CALENDAR",
              "周四装机窗口剩余" in today_group and "备用供应商 XYZ 报价" in today_group,
              "both confirmed captures land on today's calendar view")
        page.get_by_test_id("knowledge-cal-day-2026-09-15").click()
        page.wait_for_timeout(200)
        yesterday = page.get_by_test_id("knowledge-day-2026-09-15").inner_text()
        check("KNOWLEDGE_CALENDAR_OTHER_DAYS", "AOG 响应基线" in yesterday, "昨天 day view holds its item")
        # month view: grid, dots on days with knowledge, today highlighted
        page.get_by_test_id("knowledge-cal-view-month").click()
        page.get_by_test_id("knowledge-cal-month-view").wait_for()
        kmonth_text = page.get_by_test_id("knowledge-cal-month-view").inner_text()
        check("KNOWLEDGE_CAL_MONTH_VIEW",
              "2026 年 9 月" in kmonth_text
              and page.get_by_test_id("knowledge-month-day-2026-09-01").is_visible()
              and page.get_by_test_id("knowledge-month-day-2026-09-30").is_visible()
              and "today" in (page.get_by_test_id("knowledge-month-day-2026-09-16").get_attribute("class") or "")
              and page.get_by_test_id("knowledge-month-day-2026-09-16").locator(".month-dot").count() == 1
              and page.get_by_test_id("knowledge-month-day-2026-09-17").locator(".month-dot").count() == 0,
              "September 2026 knowledge month grid, dot only where knowledge exists, today highlighted")
        # month cell deep-opens that day's knowledge view
        page.get_by_test_id("knowledge-month-day-2026-09-15").click()
        page.wait_for_timeout(250)
        check("KNOWLEDGE_CAL_MONTH_CELL_OPENS_DAY",
              "AOG 响应基线" in page.get_by_test_id("knowledge-day-2026-09-15").inner_text(),
              "clicking 09-15 in knowledge month view opens its day view")
        # knowledge outside the month stays honestly reachable
        page.get_by_test_id("knowledge-cal-view-month").click()
        page.get_by_test_id("knowledge-cal-other-2026-07-18").click()
        page.wait_for_timeout(250)
        check("KNOWLEDGE_CAL_OTHER_MONTH_DAY",
              "我的决策偏好" in page.get_by_test_id("knowledge-day-2026-07-18").inner_text(),
              "knowledge on 2026-07-18 reachable via 本月之外 list")
        # week view: full Mon-Sun rows with per-day knowledge
        page.get_by_test_id("knowledge-cal-view-week").click()
        page.get_by_test_id("knowledge-cal-week-view").wait_for()
        check("KNOWLEDGE_CAL_WEEK_VIEW",
              all(page.get_by_test_id(f"knowledge-week-day-2026-09-{d}").is_visible() for d in range(14, 21))
              and "AOG 航材保障" in page.get_by_test_id("knowledge-week-day-2026-09-16").inner_text()
              and "知识" in page.get_by_test_id("knowledge-week-day-2026-09-16").inner_text(),
              "full week rows 周一..周日 with real knowledge items and counts")
        # back to day view on 昨天 for the detail-open check below
        page.get_by_test_id("knowledge-week-day-2026-09-15").click()
        page.wait_for_timeout(250)
        shot("P08-KNOWLEDGE-CALENDAR-VIEW")
        # open an item from the calendar view into the same detail surface
        page.get_by_test_id("knowledge-day-2026-09-15").get_by_test_id("knowledge-item-k-sla-baseline").click()
        page.get_by_test_id("knowledge-detail").wait_for()
        check("KNOWLEDGE_DETAIL_HAS_DAY",
              "昨天" in page.get_by_test_id("knowledge-day-label").inner_text(),
              page.get_by_test_id("knowledge-day-label").inner_text())
        page.get_by_test_id("knowledge-detail-close").click()
        page.get_by_test_id("knowledge-sheet").wait_for()
        page.get_by_test_id("knowledge-sheet-close").click()
        page.wait_for_timeout(300)

        # --- Journey D: Work from knowledge ---
        msg_count_before = page.get_by_test_id("message-user").count()
        page.get_by_test_id("nav-knowledge").click()
        page.get_by_test_id("knowledge-sheet").wait_for()
        # R5: navigation is the two maps — expand the dimension to reach the item
        page.get_by_test_id("dim5-map-d5-work").click()
        page.get_by_test_id("dim5-map-items-d5-work").wait_for()
        page.get_by_test_id("dim5-map-items-d5-work").get_by_test_id("knowledge-item-k-risk-note").click()
        page.get_by_test_id("knowledge-detail").wait_for()
        check("KNOWLEDGE_ITEM_OPENS", "供应风险记录" in page.get_by_test_id("knowledge-detail").inner_text(),
              "knowledge detail opened")
        check("SOURCE_STATE_VISIBLE",
              "MOCK_SOURCE" in page.get_by_test_id("knowledge-source-state").inner_text()
              and "CONFIRMED" in page.get_by_test_id("knowledge-source-state").inner_text(),
              page.get_by_test_id("knowledge-source-state").inner_text().replace("\n", " ")[:80])
        page.get_by_test_id("open-work-surface").click()
        page.get_by_test_id("work-surface").wait_for()
        check("WORK_SURFACE_OPENS", page.get_by_test_id("work-surface").is_visible(), "contextual work surface")
        shot("P05-KNOWLEDGE-WORK-SURFACE")
        # KK-PX-R5-04 (path 1: knowledge navigation): 「返回 Agent 对话」真的
        # 直接返回 Agent 对话,而不是先回到上层知识面板
        page.get_by_test_id("work-surface-back").click()
        page.wait_for_timeout(300)
        check("WORK_BACK_LABEL_MATCHES_TARGET_NAV_PATH",
              page.get_by_test_id("work-surface").count() == 0
              and page.get_by_test_id("knowledge-detail").count() == 0
              and page.get_by_test_id("knowledge-sheet").count() == 0
              and page.get_by_test_id("conversation").is_visible()
              and page.get_by_test_id("app-root").get_attribute("data-journey-state") == "AGENT_CONTEXT_RESTORED",
              "back from work surface lands DIRECTLY on Agent conversation")
        check("RETURN_PRESERVES_CONTEXT",
              page.get_by_test_id("message-user").count() == msg_count_before
              and "ABC 供应商延迟" in page.get_by_test_id("conversation").inner_text(),
              "conversation intact after knowledge -> work surface -> back to Agent")

        # --- Journey E: Capability attachment ---
        page.get_by_test_id("nav-calendar").click()
        page.get_by_test_id("capability-sheet-calendar").wait_for()
        check("CAPABILITY_OPENS_CONTEXTUAL_WORK",
              page.get_by_test_id("calendar-work-surface").is_visible()
              and "Q3 航材保障评审" in page.get_by_test_id("calendar-work-surface").inner_text(),
              "calendar concrete work surface")
        check("NOT_CONNECTED_NOT_CONNECTED",
              "NOT_CONNECTED" in page.get_by_test_id("capability-sheet-calendar").inner_text()
              and "CONNECTED" not in page.get_by_test_id("capability-sheet-calendar").inner_text().replace("NOT_CONNECTED", ""),
              "calendar honestly NOT_CONNECTED")
        # Owner-directed: calendar has 月/周/日 three views
        check("CALENDAR_VIEW_SWITCHER",
              all(page.get_by_test_id(f"calendar-view-{v}").is_visible() for v in ("day", "week", "month")),
              "day / week / month view switcher rendered")
        # Month view: September 2026 grid, correct weekdays, today highlighted
        page.get_by_test_id("calendar-view-month").click()
        page.get_by_test_id("calendar-month-view").wait_for()
        month_text = page.get_by_test_id("calendar-month-view").inner_text()
        check("CALENDAR_MONTH_VIEW",
              "2026 年 9 月" in month_text
              and page.get_by_test_id("month-day-2026-09-01").is_visible()
              and page.get_by_test_id("month-day-2026-09-30").is_visible()
              and "today" in (page.get_by_test_id("month-day-2026-09-16").get_attribute("class") or ""),
              "September 2026 month grid (30 days), today 09-16 highlighted")
        check("CALENDAR_MONTH_EVENT_DOTS",
              page.get_by_test_id("month-day-2026-09-16").locator(".month-dot").count() == 1
              and page.get_by_test_id("month-day-2026-09-17").locator(".month-dot").count() == 1
              and page.get_by_test_id("month-day-2026-09-15").locator(".month-dot").count() == 0,
              "days with schedule/todos carry dots; empty days do not")
        shot("P11-CALENDAR-MONTH-VIEW")
        # Month cell deep-opens the day view
        page.get_by_test_id("month-day-2026-09-17").click()
        page.wait_for_timeout(250)
        check("CALENDAR_MONTH_DAY_OPENS_DAY_VIEW",
              "装机窗口复核" in page.get_by_test_id("calendar-day-schedule").inner_text(),
              "clicking 周四 09-17 in month view opens its day view")
        # Week view: full Mon-Sun rows with per-day schedule and todo counts
        page.get_by_test_id("calendar-view-week").click()
        page.get_by_test_id("calendar-week-view").wait_for()
        check("CALENDAR_WEEK_VIEW",
              all(page.get_by_test_id(f"week-day-2026-09-{d}").is_visible() for d in range(14, 21))
              and "Q3 航材保障评审" in page.get_by_test_id("week-day-2026-09-16").inner_text()
              and "装机窗口复核" in page.get_by_test_id("week-day-2026-09-17").inner_text()
              and "关联待办" in page.get_by_test_id("week-day-2026-09-16").inner_text(),
              "full week rows 周一..周日 with real schedule and todo counts")
        shot("P12-CALENDAR-WEEK-VIEW")
        page.get_by_test_id("week-day-2026-09-16").click()
        page.wait_for_timeout(250)
        # Owner-directed: visual calendar links schedule and todos per day
        check("CALENDAR_VISUAL_WEEK_STRIP",
              page.get_by_test_id("calendar-week-strip").is_visible()
              and "今天" in page.get_by_test_id("calendar-week-strip").inner_text(),
              "visual day strip rendered")
        check("CALENDAR_TODO_LINKED_ON_DAY",
              page.get_by_test_id("calendar-todo-t-1").is_visible()
              and "补齐备用供应商成本证据" in page.get_by_test_id("calendar-day-todos").inner_text(),
              "today's todos appear on the calendar day")
        page.get_by_test_id("calendar-day-2026-09-17").click()
        page.wait_for_timeout(200)
        check("CALENDAR_DAY_SWITCH",
              "装机窗口复核" in page.get_by_test_id("calendar-day-schedule").inner_text()
              and page.get_by_test_id("calendar-todo-t-3").is_visible(),
              "周四 shows its schedule + linked todo")
        # Owner-directed: background sensing survives capability navigation
        check("SENSING_RUNS_IN_BACKGROUND",
              page.get_by_test_id("sensing-strip").get_attribute("data-sensing") == "on",
              "sensing strip still on while calendar sheet is open")
        shot("P06-CAPABILITY-WORK-SURFACE")
        check("STATE_CAPABILITY_WORK",
              page.get_by_test_id("app-root").get_attribute("data-journey-state") == "CAPABILITY_WORK",
              page.get_by_test_id("app-root").get_attribute("data-journey-state"))

        # --- R5 Owner-directed: schedule quick actions + 引用对话 ---
        # Quick action 1: complete/undo toggle on the 周四 schedule item
        page.get_by_test_id("schedule-toggle-s-5").click()
        page.wait_for_timeout(200)
        check("SCHEDULE_QUICK_ACTION_COMPLETE",
              page.get_by_test_id("schedule-toggle-s-5").get_attribute("aria-pressed") == "true"
              and "done" in (page.get_by_test_id("schedule-item-s-5").get_attribute("class") or ""),
              "装机窗口复核 marked done via quick action")
        # Quick action 2: postpone one day (周四 09-17 -> 周五 09-18)
        page.get_by_test_id("schedule-postpone-s-5").click()
        page.wait_for_timeout(250)
        check("SCHEDULE_QUICK_ACTION_POSTPONE",
              "装机窗口复核" not in page.get_by_test_id("calendar-day-schedule").inner_text()
              and "没有 Mock 日程" in page.get_by_test_id("calendar-day-schedule").inner_text(),
              "postponed item leaves 周四 day view")
        page.get_by_test_id("calendar-day-2026-09-18").click()
        page.wait_for_timeout(200)
        check("SCHEDULE_POSTPONED_VISIBLE_ON_NEXT_DAY",
              "装机窗口复核" in page.get_by_test_id("calendar-day-schedule").inner_text(),
              "postponed item appears on 周五 09-18")
        # 引用对话: reference the schedule item into the Agent conversation
        page.get_by_test_id("schedule-reference-s-5").click()
        page.wait_for_timeout(900)
        check("SCHEDULE_REFERENCE_TO_CHAT",
              page.get_by_test_id("capability-sheet-calendar").count() == 0
              and "装机窗口复核" in page.get_by_test_id("message-quote").last.inner_text()
              and "供应风险记录" in page.get_by_test_id("message-agent").last.inner_text(),
              "schedule item quoted into conversation; 灵犀 answers with linked knowledge")
        check("STATE_CONTEXT_RESTORED",
              page.get_by_test_id("app-root").get_attribute("data-journey-state") == "AGENT_CONTEXT_RESTORED",
              page.get_by_test_id("app-root").get_attribute("data-journey-state"))

        page.get_by_test_id("nav-todo").click()
        page.get_by_test_id("capability-sheet-todo").wait_for()
        before = page.get_by_test_id("todo-toggle-t-1").get_attribute("aria-pressed")
        page.get_by_test_id("todo-toggle-t-1").click()
        after = page.get_by_test_id("todo-toggle-t-1").get_attribute("aria-pressed")
        check("TODO_STATE_CHANGES", before != after, f"aria-pressed {before} -> {after}")
        # R5 quick action: postpone todo one day (09-16 -> 09-17)
        page.get_by_test_id("todo-postpone-t-2").click()
        page.wait_for_timeout(200)
        check("TODO_QUICK_ACTION_POSTPONE",
              "2026-09-17" in page.get_by_test_id("todo-item-t-2").inner_text()
              or "周四" in page.get_by_test_id("todo-item-t-2").inner_text(),
              page.get_by_test_id("todo-item-t-2").inner_text().replace("\n", " ")[:60])
        # Owner-directed: todo deep-links into the visual calendar day
        page.get_by_test_id("todo-calendar-link-t-3").click()
        page.get_by_test_id("capability-sheet-calendar").wait_for()
        check("TODO_DEEP_LINKS_TO_CALENDAR_DAY",
              "active" in (page.get_by_test_id("calendar-day-2026-09-17").get_attribute("class") or "")
              and page.get_by_test_id("calendar-todo-t-3").is_visible(),
              "todo opened its own day on the visual calendar")
        shot("P09-TODO-CALENDAR-LINK")
        page.get_by_test_id("capability-sheet-calendar-close").click()
        page.wait_for_timeout(300)

        # R5 引用对话 from a todo item
        page.get_by_test_id("nav-todo").click()
        page.get_by_test_id("capability-sheet-todo").wait_for()
        page.get_by_test_id("todo-reference-t-1").click()
        page.wait_for_timeout(900)
        check("TODO_REFERENCE_TO_CHAT",
              page.get_by_test_id("capability-sheet-todo").count() == 0
              and "补齐备用供应商成本证据" in page.get_by_test_id("message-quote").last.inner_text()
              and "供应商与 SLA" in page.get_by_test_id("message-agent").last.inner_text(),
              "todo item quoted into conversation; 灵犀 answers with linked knowledge")

        page.get_by_test_id("nav-skills").click()
        page.get_by_test_id("capability-sheet-skills").wait_for()
        check("SKILLS_PLANNED_DISCLOSED",
              "PLANNED" in page.get_by_test_id("capability-sheet-skills").inner_text(),
              "skills honestly PLANNED, no fake work surface")
        page.get_by_test_id("capability-sheet-skills-close").click()
        page.wait_for_timeout(200)
        shot("P07-RETURN-CONTEXT-PRESERVED")

        # ============================================================
        # PX findings correction (Contract R2 exploratory findings)
        # KK-PX-R5-01 semantic consistency / -02 sensing visibility /
        # -03 confirm semantics / -04 return-target label match
        # ============================================================

        # --- KK-PX-R5-01: two clearly different synthetic topics ---
        def capture_and_confirm(text):
            page.get_by_test_id("nav-capture").click()
            page.get_by_test_id("capture-sheet").wait_for()
            page.get_by_test_id("capture-input").fill(text)
            page.get_by_test_id("capture-submit").click()
            page.get_by_test_id("candidate-card").wait_for()
            page.get_by_test_id("candidate-confirm").click()
            page.wait_for_timeout(400)

        capture_and_confirm("读书笔记复核:复利曲线在长期主义第三章的论证结构。")
        check("PX01_CAPTURE_CONFIRM_TOPIC_A",
              "读书笔记复核" in page.get_by_test_id("conversation").inner_text(),
              "topic A captured and confirmed")
        capture_and_confirm("健身计划:每周三次力量训练,周日拉伸恢复。")
        check("PX01_CAPTURE_CONFIRM_TOPIC_B",
              "健身计划" in page.get_by_test_id("conversation").inner_text(),
              "topic B captured and confirmed")

        # exact-title query binds strictly to its own item
        page.get_by_test_id("composer-input").fill("读书笔记复核")
        page.get_by_test_id("composer-send").click()
        page.wait_for_timeout(900)
        last = page.get_by_test_id("message-agent").last.inner_text()
        check("PX01_EXACT_TITLE_QUERY_BINDS_OWN_ITEM",
              "读书笔记复核" in last and "复利曲线" in last, last[:60])
        check("PX01_NO_CROSS_TOPIC_LEAKAGE",
              "ABC" not in last and "AOG" not in last and "供应商" not in last,
              "no AOG/ABC template leakage into unrelated topic")
        check("PX01_HONEST_NO_CONCLUSION",
              "没有可模拟的确定性结论" in last,
              "honest note when the item has no deterministic conclusion")

        # natural-wording query binds to topic B, again no leakage
        page.get_by_test_id("composer-input").fill("健身计划一周练几次?")
        page.get_by_test_id("composer-send").click()
        page.wait_for_timeout(900)
        last = page.get_by_test_id("message-agent").last.inner_text()
        check("PX01_NATURAL_QUERY_BINDS_OWN_ITEM",
              "健身计划" in last and "每周三次" in last, last[:60])
        check("PX01_NATURAL_QUERY_NO_LEAKAGE",
              "ABC" not in last and "AOG" not in last and "读书笔记" not in last,
              "topic B answer contains neither AOG nor topic A content")

        # unknown topic: honest gap, zero unrelated references
        page.get_by_test_id("composer-input").fill("火星基地什么时候建成?")
        page.get_by_test_id("composer-send").click()
        page.wait_for_timeout(900)
        last_msg = page.get_by_test_id("message-agent").last
        check("PX01_UNKNOWN_NO_UNRELATED_REFS",
              "已知空白" in last_msg.inner_text()
              and last_msg.get_by_test_id("agent-refs").count() == 0,
              "unknown topic yields honest gap with no unrelated refs")

        # captured item detail: own content, one trustworthy CONFIRMED state
        page.get_by_test_id("nav-knowledge").click()
        page.get_by_test_id("knowledge-sheet").wait_for()
        page.get_by_test_id("dim5-map-d5-work").click()
        page.get_by_test_id("dim5-map-items-d5-work").wait_for()
        page.get_by_test_id("dim5-map-items-d5-work").get_by_text("读书笔记复核").first.click()
        page.get_by_test_id("knowledge-detail").wait_for()
        detail_text = page.get_by_test_id("knowledge-detail").inner_text()
        check("PX01_DETAIL_OWN_CONTENT",
              "复利曲线" in detail_text and "ABC" not in detail_text,
              "detail renders the item's own content only")
        check("PX03_CONFIRMED_NO_PENDING_TAG",
              "已确认" in detail_text and "待确认" not in detail_text and "CONFIRMED" in detail_text,
              "confirmed item never shows 待确认 semantics (KK-PX-R5-03)")
        # its work surface: own summary + honest conclusion + no fabricated conflict
        page.get_by_test_id("open-work-surface").click()
        page.get_by_test_id("work-surface").wait_for()
        ws_text = page.get_by_test_id("work-surface").inner_text()
        check("PX01_WORK_SURFACE_OWN_CONTENT",
              "复利曲线" in page.get_by_test_id("work-item-content").inner_text()
              and "ABC" not in ws_text and "AOG" not in ws_text,
              "work surface bound to the captured item's own content")
        check("PX01_WORK_SURFACE_HONEST_CONCLUSION",
              "没有可模拟的确定性结论" in page.get_by_test_id("work-conclusion").inner_text(),
              "no unrelated template conclusion for captured topic")
        check("PX01_WORK_SURFACE_NO_FABRICATED_CONFLICT",
              "0 项" in page.get_by_test_id("work-conflict").inner_text(),
              "conflict count never fabricated")
        page.get_by_test_id("work-surface-back").click()
        page.wait_for_timeout(300)

        # seed item keeps its own deterministic conclusion on the work surface
        page.get_by_test_id("nav-knowledge").click()
        page.get_by_test_id("knowledge-sheet").wait_for()
        page.get_by_test_id("dim5-map-d5-think").click()
        page.get_by_test_id("dim5-map-items-d5-think").wait_for()
        page.get_by_test_id("dim5-map-items-d5-think").get_by_test_id("knowledge-item-k-sla-baseline").click()
        page.get_by_test_id("knowledge-detail").wait_for()
        page.get_by_test_id("open-work-surface").click()
        page.get_by_test_id("work-surface").wait_for()
        check("PX01_SEED_WORK_SURFACE_OWN_CONCLUSION",
              "30 分钟" in page.get_by_test_id("work-conclusion").inner_text()
              and "AOG 响应基线" in page.get_by_test_id("work-surface").inner_text(),
              "seed AOG item work surface shows its own conclusion")
        page.get_by_test_id("work-surface-back").click()
        page.wait_for_timeout(300)

        # --- KK-PX-R5-02: sensing status visible + pause/resume reachable ---
        def check_sheet_sensing(name):
            strip = page.get_by_test_id("sheet-sensing-strip")
            check(f"PX02_SENSING_VISIBLE_{name}",
                  strip.is_visible()
                  and strip.get_attribute("data-sensing") == "on"
                  and "后台持续感知中" in strip.inner_text()
                  and "无真实 ASR" in strip.inner_text(),
                  f"sensing status + disclosure visible inside {name}")
            page.get_by_test_id("sheet-sensing-toggle").click()
            page.wait_for_timeout(200)
            check(f"PX02_PAUSE_REACHABLE_{name}",
                  strip.get_attribute("data-sensing") == "paused"
                  and "感知已暂停" in strip.inner_text()
                  and "无真实 ASR" in strip.inner_text()
                  and page.get_by_test_id("sensing-strip").get_attribute("data-sensing") == "off",
                  f"pause reachable inside {name}; global strip in sync")
            page.get_by_test_id("sheet-sensing-toggle").click()
            page.wait_for_timeout(200)
            check(f"PX02_RESUME_REACHABLE_{name}",
                  strip.get_attribute("data-sensing") == "on"
                  and page.get_by_test_id("sensing-strip").get_attribute("data-sensing") == "on",
                  f"resume reachable inside {name}")

        page.get_by_test_id("nav-knowledge").click()
        page.get_by_test_id("knowledge-sheet").wait_for()
        check_sheet_sensing("KNOWLEDGE")
        page.get_by_test_id("dim5-map-d5-work").click()
        page.get_by_test_id("dim5-map-items-d5-work").wait_for()
        page.get_by_test_id("dim5-map-items-d5-work").get_by_test_id("knowledge-item-k-risk-note").click()
        page.get_by_test_id("knowledge-detail").wait_for()
        check_sheet_sensing("KNOWLEDGE_DETAIL")
        page.get_by_test_id("open-work-surface").click()
        page.get_by_test_id("work-surface").wait_for()
        check_sheet_sensing("WORK_SURFACE")
        page.get_by_test_id("work-surface-back").click()
        page.wait_for_timeout(300)
        page.get_by_test_id("nav-calendar").click()
        page.get_by_test_id("capability-sheet-calendar").wait_for()
        check_sheet_sensing("CALENDAR")
        page.get_by_test_id("capability-sheet-calendar-close").click()
        page.wait_for_timeout(300)
        page.get_by_test_id("nav-todo").click()
        page.get_by_test_id("capability-sheet-todo").wait_for()
        check_sheet_sensing("TODO")
        page.get_by_test_id("capability-sheet-todo-close").click()
        page.wait_for_timeout(300)

        # --- KK-PX-R5-04 path 2: Agent next action -> detail/work -> back ---
        page.get_by_test_id("composer-input").fill("ABC 供应商延迟会影响什么?")
        page.get_by_test_id("composer-send").click()
        page.wait_for_timeout(900)
        page.get_by_test_id("agent-next-action").last.click()
        page.get_by_test_id("knowledge-detail").wait_for()
        page.get_by_test_id("open-work-surface").click()
        page.get_by_test_id("work-surface").wait_for()
        page.get_by_test_id("work-surface-back").click()
        page.wait_for_timeout(300)
        check("PX04_AGENT_PATH_BACK_MATCHES_LABEL",
              page.get_by_test_id("work-surface").count() == 0
              and page.get_by_test_id("knowledge-detail").count() == 0
              and page.get_by_test_id("conversation").is_visible()
              and page.get_by_test_id("app-root").get_attribute("data-journey-state") == "AGENT_CONTEXT_RESTORED"
              and "读书笔记复核" in page.get_by_test_id("conversation").inner_text(),
              "Agent-route work surface back lands on conversation; context preserved")

        # --- PX P3 (low-risk): postponed schedule stays time-ordered ---
        page.get_by_test_id("nav-calendar").click()
        page.get_by_test_id("capability-sheet-calendar").wait_for()
        page.get_by_test_id("calendar-day-2026-09-16").click()
        page.wait_for_timeout(250)
        page.get_by_test_id("schedule-postpone-s-3").click()  # 14:00: 09-16 -> 09-17
        page.wait_for_timeout(250)
        page.get_by_test_id("calendar-day-2026-09-17").click()
        page.wait_for_timeout(250)
        page.get_by_test_id("schedule-postpone-s-3").click()  # 14:00: 09-17 -> 09-18
        page.wait_for_timeout(250)
        page.get_by_test_id("calendar-day-2026-09-18").click()
        page.wait_for_timeout(250)
        # 09-18 array order is [s-3 (14:00), s-5 (10:00)] — rendering must sort
        times = page.get_by_test_id("calendar-day-schedule").locator("article time").all_inner_texts()
        check("PX_P3_POSTPONED_SCHEDULE_TIME_ORDERED",
              times == ["10:00", "14:00"],
              f"09-18 schedule times ordered: {times}")
        page.get_by_test_id("capability-sheet-calendar-close").click()
        page.wait_for_timeout(300)

        # --- Mobile usability / hygiene ---
        # Unknown-topic question: Agent must acknowledge the gap and route to capture
        page.get_by_test_id("composer-input").fill("今晚吃什么?")
        page.get_by_test_id("composer-send").click()
        page.wait_for_timeout(800)
        last_agent = page.get_by_test_id("message-agent").last.inner_text()
        check("UNKNOWN_TOPIC_ACKNOWLEDGES_GAP", "已知空白" in last_agent, last_agent[:60])
        check("UNKNOWN_TOPIC_NEXT_ACTION_CAPTURE",
              "捕获" in page.get_by_test_id("agent-next-action").last.inner_text(),
              page.get_by_test_id("agent-next-action").last.inner_text())

        # Voice key toggles the continuous background sensing (honest, no fake recording)
        page.get_by_test_id("voice-key").click()
        page.wait_for_timeout(200)
        check("VOICE_KEY_PAUSES_SENSING",
              page.get_by_test_id("sensing-strip").get_attribute("data-sensing") == "off"
              and "感知已暂停" in page.get_by_test_id("sensing-strip").inner_text(),
              page.get_by_test_id("sensing-strip").inner_text().replace("\n", " "))
        page.get_by_test_id("voice-key").click()
        page.wait_for_timeout(200)
        check("VOICE_KEY_RESUMES_SENSING",
              page.get_by_test_id("sensing-strip").get_attribute("data-sensing") == "on",
              "continuous background sensing resumed")

        overflow = page.evaluate("document.documentElement.scrollWidth > document.documentElement.clientWidth")
        check("NO_HORIZONTAL_BLOCKING_OVERFLOW", not overflow,
              f"scrollWidth={page.evaluate('document.documentElement.scrollWidth')}, clientWidth={page.evaluate('document.documentElement.clientWidth')}")
        check("NO_UNCAUGHT_PAGE_ERROR", len(page_errors) == 0, "; ".join(page_errors)[:200])
        check("NO_BLOCKING_CONSOLE_ERROR", len(console_errors) == 0, "; ".join(console_errors)[:200])

        # Critical controls must be real buttons/inputs, not hover-only affordances
        critical = ["nav-capture", "nav-knowledge", "nav-calendar", "nav-todo", "nav-skills",
                    "composer-input", "composer-send", "voice-key", "context-summary-button"]
        tags = {t: page.get_by_test_id(t).evaluate("el => el.tagName") for t in critical}
        check("NO_HOVER_ONLY_CRITICAL_ACTION",
              all(tag in ("BUTTON", "INPUT") for tag in tags.values()), json.dumps(tags))

        browser.close()

    passed = sum(1 for r in results if r["pass"])
    receipt = {
        "protocol_version": "DELIVERY-LIFECYCLE-1.0",
        "artifact": "BROWSER_TECHNICAL_ASSERTIONS",
        "url": args.url,
        "viewport": {**VIEWPORT, "kind": "MATE60_CLASS_SIMULATION"},
        "assertions": results,
        "console_errors": console_errors,
        "page_errors": page_errors,
        "passed": passed,
        "failed": len(results) - passed,
        "issued_at": datetime.now(timezone.utc).isoformat(),
    }
    with open(args.out, "w", encoding="utf-8") as fh:
        json.dump(receipt, fh, ensure_ascii=False, indent=2)
    print(f"\n{passed}/{len(results)} assertions passed -> {args.out}")
    sys.exit(0 if passed == len(results) else 1)


if __name__ == "__main__":
    main()
