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

        # Correct path exists and works
        page.get_by_test_id("candidate-correct").click()
        page.get_by_test_id("correct-block").wait_for()
        page.get_by_test_id("correct-title").fill("备用供应商 XYZ 报价(已修正)")
        page.get_by_test_id("correct-save").click()
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
        check("KNOWLEDGE_NAVIGATION_VIEW",
              page.get_by_test_id("knowledge-nav-view").is_visible()
              and "AOG 航材保障" in page.get_by_test_id("nav-group-moc").inner_text()
              and "供应商与 SLA" in page.get_by_test_id("nav-group-wiki").inner_text(),
              "MOC/WIKI/NOTE navigation groups render real items")
        check("CAPTURED_ITEM_IN_NAV",
              "周四装机窗口剩余" in page.get_by_test_id("nav-group-note").inner_text(),
              "confirmed capture appears under 笔记与捕获 navigation")
        shot("P10-KNOWLEDGE-NAVIGATION")
        page.get_by_test_id("knowledge-tab-calendar").click()
        page.get_by_test_id("knowledge-calendar-view").wait_for()
        today_group = page.get_by_test_id("knowledge-day-2026-09-16").inner_text()
        check("KNOWLEDGE_CALENDAR_VIEW",
              "AOG 航材保障" in today_group and "供应风险记录" in today_group,
              "knowledge grouped under 今天 (2026-09-16)")
        check("VALUE_LOOP_CAPTURED_VISIBLE_BY_CALENDAR",
              "周四装机窗口剩余" in today_group and "备用供应商 XYZ 报价" in today_group,
              "both confirmed captures land on today's calendar view")
        yesterday = page.get_by_test_id("knowledge-day-2026-09-15").inner_text()
        check("KNOWLEDGE_CALENDAR_OTHER_DAYS", "AOG 响应基线" in yesterday, "昨天 group holds its item")
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
        page.get_by_test_id("knowledge-item-k-risk-note").click()
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
        page.get_by_test_id("work-surface-back").click()
        page.get_by_test_id("knowledge-detail").wait_for()
        page.get_by_test_id("knowledge-detail-close").click()
        page.get_by_test_id("knowledge-sheet").wait_for()
        page.get_by_test_id("knowledge-sheet-close").click()
        page.wait_for_timeout(300)
        check("RETURN_PRESERVES_CONTEXT",
              page.get_by_test_id("message-user").count() == msg_count_before
              and "ABC 供应商延迟" in page.get_by_test_id("conversation").inner_text(),
              "conversation intact after knowledge -> work surface -> back")

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
        # Owner-directed: visual calendar links schedule and todos per day
        check("CALENDAR_VISUAL_WEEK_STRIP",
              page.get_by_test_id("calendar-week-strip").is_visible()
              and "今天" in page.get_by_test_id("calendar-week-strip").inner_text(),
              "visual day strip rendered")
        check("CALENDAR_TODO_LINKED_ON_DAY",
              page.get_by_test_id("calendar-todo-t-1").is_visible()
              and "补齐备用供应商成本证据" in page.get_by_test_id("calendar-day-todos").inner_text(),
              "today's todos appear on the calendar day")
        page.get_by_test_id("calendar-day-2026-09-18").click()
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
        page.get_by_test_id("capability-sheet-calendar-close").click()
        page.wait_for_timeout(300)
        check("STATE_CONTEXT_RESTORED",
              page.get_by_test_id("app-root").get_attribute("data-journey-state") == "AGENT_CONTEXT_RESTORED",
              page.get_by_test_id("app-root").get_attribute("data-journey-state"))

        page.get_by_test_id("nav-todo").click()
        page.get_by_test_id("capability-sheet-todo").wait_for()
        before = page.get_by_test_id("todo-toggle-t-1").get_attribute("aria-pressed")
        page.get_by_test_id("todo-toggle-t-1").click()
        after = page.get_by_test_id("todo-toggle-t-1").get_attribute("aria-pressed")
        check("TODO_STATE_CHANGES", before != after, f"aria-pressed {before} -> {after}")
        # Owner-directed: todo deep-links into the visual calendar day
        page.get_by_test_id("todo-calendar-link-t-3").click()
        page.get_by_test_id("capability-sheet-calendar").wait_for()
        check("TODO_DEEP_LINKS_TO_CALENDAR_DAY",
              "active" in (page.get_by_test_id("calendar-day-2026-09-18").get_attribute("class") or "")
              and page.get_by_test_id("calendar-todo-t-3").is_visible(),
              "todo opened its own day on the visual calendar")
        shot("P09-TODO-CALENDAR-LINK")
        page.get_by_test_id("capability-sheet-calendar-close").click()
        page.wait_for_timeout(300)

        page.get_by_test_id("nav-skills").click()
        page.get_by_test_id("capability-sheet-skills").wait_for()
        check("SKILLS_PLANNED_DISCLOSED",
              "PLANNED" in page.get_by_test_id("capability-sheet-skills").inner_text(),
              "skills honestly PLANNED, no fake work surface")
        page.get_by_test_id("capability-sheet-skills-close").click()
        page.wait_for_timeout(200)
        shot("P07-RETURN-CONTEXT-PRESERVED")

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
