import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import {
  PROTOTYPE_DISCLOSURE,
  KNOWLEDGE_SEED,
  KNOWLEDGE_GAPS,
  CAPTURE_CHANNELS,
  CAPABILITIES,
  CALENDAR_DAYS,
  CALENDAR_MOCK,
  CALENDAR_MONTH,
  TODO_MOCK,
  TODAY,
  dayLabel,
  SENSING_MOCK_LINES,
  KNOWLEDGE_MAP_5D,
  COGNITIVE_MAP_9D,
  agentReply,
  draftCandidate,
  nextDay,
  referenceReply,
} from "./fixtures.js";

// ---------------------------------------------------------------------------
// Interaction state machine (mirrors INTERACTION_STATE_MAP.md):
//   FIRST_VIEW → ASK_AGENT
//   FIRST_VIEW → CAPTURE
//   CAPTURE → CANDIDATE_KNOWLEDGE
//   CANDIDATE_KNOWLEDGE → CONFIRMED
//   CONFIRMED → KNOWLEDGE_CONTEXT_UPDATED
//   KNOWLEDGE_CONTEXT_UPDATED → KNOWLEDGE_WORK
//   AGENT_CONTEXT → CAPABILITY_WORK
//   CAPABILITY_WORK → AGENT_CONTEXT_RESTORED
// ---------------------------------------------------------------------------

const STATE_CHIP_CLASS = {
  AVAILABLE: "state-chip state-available",
  NOT_CONNECTED: "state-chip state-not-connected",
  PLANNED: "state-chip state-planned",
  PROTOTYPE_ONLY: "state-chip state-prototype-only",
  CONFIRMED: "state-chip state-available",
  CANDIDATE: "state-chip state-planned",
};

function StateChip({ state }) {
  return <span className={STATE_CHIP_CLASS[state] || "state-chip"} data-state={state}>{state}</span>;
}

function Header({ knowledgeCount }) {
  return (
    <header className="app-header" data-testid="agent-identity">
      <span className="brand-mark" aria-hidden="true">脑</span>
      <div className="identity-text">
        <strong>灵犀 · KnowME</strong>
        <small>个人知识 Agent · 当前知识上下文 {knowledgeCount} 条</small>
      </div>
      <span className="disclosure-pill" data-testid="prototype-disclosure">{PROTOTYPE_DISCLOSURE}</span>
    </header>
  );
}

function ContextStrip({ knowledge, gaps, onOpenKnowledge }) {
  return (
    <section className="context-strip" aria-label="当前知识上下文" data-testid="knowledge-context-summary">
      <button type="button" className="context-summary" onClick={onOpenKnowledge} data-testid="context-summary-button">
        <strong>{knowledge.length} 条知识</strong>
        <small>{knowledge.reduce((acc, item) => acc + item.links.length, 0)} 条连接 · 持续生长</small>
      </button>
      <div className="gap-row" aria-label="已知与未知">
        {gaps.map((gap) => (
          <span key={gap.id} className="gap-chip" data-testid={`gap-${gap.id}`}>
            未知 · {gap.label}
          </span>
        ))}
        <span className="known-chip">已知 · AOG 响应基线 30 分钟 / 4 小时</span>
      </div>
    </section>
  );
}

function Message({ message, onNextAction }) {
  if (message.role === "user") {
    return (
      <div className="msg msg-user" data-testid="message-user">
        <small>你</small>
        {message.quote && (
          <div className="msg-quote" data-testid="message-quote">
            📎 引用{message.quote.kind}「{message.quote.title}」 · {message.quote.when}
          </div>
        )}
        <p>{message.text}</p>
      </div>
    );
  }
  return (
    <div className="msg msg-agent" data-testid="message-agent">
      <span className="msg-avatar" aria-hidden="true">灵</span>
      <div className="msg-body">
        <small>灵犀 · 确定性 Mock 回答{message.refs?.length ? ` · 引用 ${message.refs.length} 条知识` : ""}</small>
        <p>{message.text}</p>
        {message.refs?.length > 0 && (
          <div className="msg-refs" data-testid="agent-refs">
            {message.refs.map((ref) => <span key={ref} className="ref-chip">{ref}</span>)}
          </div>
        )}
        {message.nextAction && (
          <button
            type="button"
            className="next-action"
            data-testid="agent-next-action"
            onClick={() => onNextAction(message.nextAction)}
          >
            {message.nextAction.label} →
          </button>
        )}
      </div>
    </div>
  );
}

// Continuous background voice sensing strip (Owner-directed 2026-09-16).
// Simulated deterministic stream; honestly disclosed as PROTOTYPE_ONLY mock —
// no real microphone, no ASR, nothing written to knowledge automatically.
function SensingStrip({ sensingOn, line }) {
  return (
    <div className="sensing-strip" data-testid="sensing-strip" data-sensing={sensingOn ? "on" : "off"}>
      <i className={sensingOn ? "signal-live" : "signal-idle"} aria-hidden="true" />
      <div className="sensing-text">
        <small>{sensingOn ? "后台持续感知中" : "感知已暂停"}</small>
        <span data-testid="sensing-line">{sensingOn ? line : "点击麦克风恢复持续感知"}</span>
      </div>
      <span className="state-chip state-prototype-only">模拟感知 · 无真实 ASR</span>
    </div>
  );
}

function Composer({ onSend, onVoiceKey, sensingOn, thinking }) {
  const [value, setValue] = useState("");
  const send = () => {
    const text = value.trim();
    if (!text || thinking) return;
    onSend(text);
    setValue("");
  };
  return (
    <div className="composer" data-testid="ask-agent-entry">
      <button
        type="button"
        className={`voice-key ${sensingOn ? "sensing" : ""}`}
        aria-label={sensingOn ? "暂停后台语音感知" : "恢复后台语音感知"}
        data-testid="voice-key"
        title="语音感知为 PROTOTYPE_ONLY:模拟持续感知,无真实 ASR / 声纹"
        onClick={onVoiceKey}
      >
        🎙
      </button>
      <input
        aria-label="向灵犀提问"
        data-testid="composer-input"
        value={value}
        onChange={(event) => setValue(event.target.value)}
        onKeyDown={(event) => { if (event.key === "Enter") send(); }}
        placeholder={thinking ? "正在连接知识上下文…" : "问灵犀,或用下方捕获入口记录新信息"}
        disabled={thinking}
      />
      <button type="button" className="send" data-testid="composer-send" onClick={send} disabled={thinking}>
        发送
      </button>
    </div>
  );
}

function BottomNav({ onOpen, activeSheet }) {
  const items = [
    { id: "capture", label: "捕获", testid: "nav-capture" },
    { id: "knowledge", label: "知识", testid: "nav-knowledge" },
    { id: "calendar", label: "日历", testid: "nav-calendar" },
    { id: "todo", label: "待办", testid: "nav-todo" },
    { id: "skills", label: "技能", testid: "nav-skills" },
  ];
  return (
    <nav className="bottom-nav" aria-label="捕获与能力入口" data-testid="capability-nav">
      {items.map((item) => (
        <button
          key={item.id}
          type="button"
          className={activeSheet === item.id ? "active" : ""}
          data-testid={item.testid}
          onClick={() => onOpen(item.id)}
        >
          {item.label}
        </button>
      ))}
    </nav>
  );
}

function Sheet({ title, testid, onClose, children, footer, sensing }) {
  return (
    <div className="sheet-backdrop" role="presentation" onClick={onClose}>
      <section
        className="sheet"
        role="dialog"
        aria-modal="true"
        aria-label={title}
        data-testid={testid}
        onClick={(event) => event.stopPropagation()}
      >
        <header className="sheet-header">
          <h2>{title}</h2>
          <button type="button" className="sheet-close" data-testid={`${testid}-close`} onClick={onClose} aria-label={`关闭${title}`}>✕</button>
        </header>
        {sensing && (
          <div className="sheet-sensing" data-testid="sheet-sensing-strip" data-sensing={sensing.sensingOn ? "on" : "paused"}>
            <i className={sensing.sensingOn ? "signal-live" : "signal-idle"} aria-hidden="true" />
            <span className="sheet-sensing-text" data-testid="sheet-sensing-status">
              {sensing.sensingOn ? `后台持续感知中 · ${sensing.line}` : "感知已暂停"}(模拟 · 无真实 ASR)
            </span>
            <button
              type="button"
              className="sheet-sensing-toggle"
              data-testid="sheet-sensing-toggle"
              aria-label={sensing.sensingOn ? "暂停后台语音感知" : "恢复后台语音感知"}
              onClick={sensing.onToggle}
            >
              {sensing.sensingOn ? "暂停" : "恢复"}
            </button>
          </div>
        )}
        <div className="sheet-body">{children}</div>
        {footer && <footer className="sheet-footer">{footer}</footer>}
      </section>
    </div>
  );
}

function CaptureSheet({ candidate, correcting, onDraft, onConfirm, onCorrectStart, onCorrectSave, onReject, onClose, sensing }) {
  const [text, setText] = useState("");
  const [fix, setFix] = useState({ title: "", summary: "" });
  return (
    <Sheet title="捕获 · 信息进入知识" testid="capture-sheet" onClose={onClose} sensing={sensing}>
      <div className="channel-row" aria-label="捕获通道">
        {CAPTURE_CHANNELS.map((channel) => (
          <div key={channel.id} className="channel-card" data-testid={`capture-channel-${channel.id}`}>
            <strong>{channel.label}</strong>
            <StateChip state={channel.state} />
            <small>{channel.note}</small>
          </div>
        ))}
      </div>
      {!candidate && (
        <div className="capture-input-block">
          <textarea
            aria-label="输入要捕获的文本"
            data-testid="capture-input"
            rows={3}
            placeholder="输入一段要进入知识上下文的信息(文本通道为原型可用)"
            value={text}
            onChange={(event) => setText(event.target.value)}
          />
          <button
            type="button"
            className="primary-action"
            data-testid="capture-submit"
            disabled={!text.trim()}
            onClick={() => onDraft(text)}
          >
            生成候选知识
          </button>
        </div>
      )}
      {candidate && (
        <div className="candidate-card" data-testid="candidate-card">
          <div className="pipeline" aria-label="入库流程">
            <span className="done">已采集</span> → <span className="active">AI 整理草稿</span> → <span>确认后入库</span>
          </div>
          <StateChip state="CANDIDATE" />
          {!correcting ? (
            <>
              <h3 data-testid="candidate-title">{candidate.title}</h3>
              <p data-testid="candidate-summary">{candidate.summary}</p>
              <div className="tag-row">{candidate.tags.map((tag) => <span key={tag} className="tag">{tag}</span>)}</div>
              <small className="source-line">来源:{candidate.source}</small>
              <div className="candidate-actions">
                <button type="button" className="primary-action" data-testid="candidate-confirm" onClick={onConfirm}>确认入库</button>
                <button
                  type="button"
                  className="secondary-action"
                  data-testid="candidate-correct"
                  onClick={() => { setFix({ title: candidate.title, summary: candidate.summary }); onCorrectStart(); }}
                >
                  修正
                </button>
                <button type="button" className="danger-action" data-testid="candidate-reject" onClick={onReject}>拒绝</button>
              </div>
            </>
          ) : (
            <div className="correct-block" data-testid="correct-block">
              <label>
                标题
                <input data-testid="correct-title" value={fix.title} onChange={(e) => setFix({ ...fix, title: e.target.value })} />
              </label>
              <label>
                内容
                <textarea data-testid="correct-summary" rows={3} value={fix.summary} onChange={(e) => setFix({ ...fix, summary: e.target.value })} />
              </label>
              <div className="candidate-actions">
                <button
                  type="button"
                  className="primary-action"
                  data-testid="correct-save"
                  disabled={!fix.title.trim() || !fix.summary.trim()}
                  onClick={() => onCorrectSave(fix)}
                >
                  保存修正
                </button>
                <button type="button" className="danger-action" data-testid="correct-reject" onClick={onReject}>拒绝</button>
              </div>
              <small className="muted-line" data-testid="correct-save-hint">保存修正仅更新候选内容并返回候选卡,不会直接入库;点击「确认入库」后才会进入知识上下文。</small>
            </div>
          )}
        </div>
      )}
    </Sheet>
  );
}

// Owner-directed (KnowMe-NJX-Demo authority): the knowledge navigation carries
// the 五维知识地图 (five life dimensions) and 九维认知图谱 (nine cognitive
// dimensions). Counts are computed live from the knowledge context; each
// dimension expands to its real items, which open the same knowledge detail.
function DimensionMap({ title, testid, dims, knowledge, openDim, onToggle, onOpenItem, numbered }) {
  return (
    <section className="dim-map" data-testid={testid}>
      <header className="dim-map-header">
        <strong>{title}</strong>
        <span>{dims.length} 维</span>
      </header>
      {dims.map((dim) => {
        const items = knowledge.filter((item) => item[numbered ? "dim9" : "dim5"] === dim.id);
        const open = openDim === dim.id;
        return (
          <div key={dim.id} className={`dim-row-block ${open ? "open" : ""}`}>
            <button
              type="button"
              className="dim-row"
              data-testid={`${testid}-${dim.id}`}
              aria-expanded={open}
              onClick={() => onToggle(open ? null : dim.id)}
            >
              <span className="dim-num">{numbered ? dim.num : "◆"}</span>
              <div>
                <strong>{dim.label}</strong>
                {dim.question && <small>{dim.question}</small>}
              </div>
              <span className="dim-count">{items.length}</span>
            </button>
            {open && (
              <div className="dim-items" data-testid={`${testid}-items-${dim.id}`}>
                {items.length === 0 && <small className="muted-line">这个维度还没有知识(真实计数,不虚构)。</small>}
                {items.map((item) => (
                  <button
                    key={item.id}
                    type="button"
                    className="knowledge-item"
                    data-testid={`knowledge-item-${item.id}`}
                    onClick={() => onOpenItem(item.id)}
                  >
                    <span className={`kind-badge kind-${item.kind.toLowerCase()}`}>{item.kind}</span>
                    <div>
                      <strong>{item.title}</strong>
                      <small>{item.group} · {item.updated}</small>
                    </div>
                    <StateChip state={item.state} />
                  </button>
                ))}
              </div>
            )}
          </div>
        );
      })}
    </section>
  );
}

// Owner-directed: knowledge navigation IS the 五维知识地图 + 九维认知图谱
// (R5: no extra MOC/WIKI groupings — the two maps are the navigation).
// Knowledge is also viewable by calendar with 月/周/日 three views (R5),
// mirroring the schedule calendar. Both views open the same knowledge detail.
function KnowledgeSheet({ knowledge, onOpenItem, onClose, sensing }) {
  const [tab, setTab] = useState("nav");
  const [openDim, setOpenDim] = useState(null);
  const [calView, setCalView] = useState("day");
  const [kDay, setKDay] = useState(TODAY);

  // September 2026 month grid, Monday-first, astronomically correct weekdays.
  const monthCells = useMemo(() => {
    const { year, month } = CALENDAR_MONTH;
    const daysInMonth = new Date(year, month, 0).getDate();
    const firstOffset = (new Date(year, month - 1, 1).getDay() + 6) % 7; // Monday-first
    const cells = [];
    for (let i = 0; i < firstOffset; i += 1) cells.push(null);
    for (let d = 1; d <= daysInMonth; d += 1) {
      const date = `${year}-${String(month).padStart(2, "0")}-${String(d).padStart(2, "0")}`;
      cells.push({
        date,
        dayNum: d,
        isToday: date === TODAY,
        hasItems: knowledge.some((item) => item.day === date),
      });
    }
    return cells;
  }, [knowledge]);

  // Days holding knowledge outside the current month (honest reachability).
  const otherDays = useMemo(
    () => [...new Set(knowledge.map((item) => item.day))]
      .filter((day) => !day.startsWith(`${CALENDAR_MONTH.year}-${String(CALENDAR_MONTH.month).padStart(2, "0")}`))
      .sort(),
    [knowledge]
  );

  const openDay = (date) => {
    setKDay(date);
    setCalView("day");
  };

  const dayItems = knowledge.filter((item) => item.day === kDay);

  const renderItem = (item) => (
    <button
      key={item.id}
      type="button"
      className="knowledge-item"
      data-testid={`knowledge-item-${item.id}`}
      onClick={() => onOpenItem(item.id)}
    >
      <span className={`kind-badge kind-${item.kind.toLowerCase()}`}>{item.kind}</span>
      <div>
        <strong>{item.title}</strong>
        <small>{item.group} · {item.updated}</small>
      </div>
      <StateChip state={item.state} />
    </button>
  );

  return (
    <Sheet title="知识 · 持续生长的上下文" testid="knowledge-sheet" onClose={onClose} sensing={sensing}>
      <div className="sheet-tabs" role="tablist" aria-label="知识视图">
        <button type="button" className={tab === "nav" ? "active" : ""} data-testid="knowledge-tab-nav" onClick={() => setTab("nav")}>知识导航</button>
        <button type="button" className={tab === "calendar" ? "active" : ""} data-testid="knowledge-tab-calendar" onClick={() => setTab("calendar")}>按日历查看</button>
      </div>
      {tab === "nav" && (
        <div className="knowledge-nav" data-testid="knowledge-nav-view">
          <DimensionMap
            title="五维知识地图"
            testid="dim5-map"
            dims={KNOWLEDGE_MAP_5D}
            knowledge={knowledge}
            openDim={openDim}
            onToggle={setOpenDim}
            onOpenItem={onOpenItem}
            numbered={false}
          />
          <DimensionMap
            title="九维认知图谱"
            testid="dim9-map"
            dims={COGNITIVE_MAP_9D}
            knowledge={knowledge}
            openDim={openDim}
            onToggle={setOpenDim}
            onOpenItem={onOpenItem}
            numbered
          />
        </div>
      )}
      {tab === "calendar" && (
        <div className="knowledge-calendar" data-testid="knowledge-calendar-view">
          <div className="sheet-tabs three" role="tablist" aria-label="知识日历视图" data-testid="knowledge-cal-view-switcher">
            <button type="button" className={calView === "day" ? "active" : ""} data-testid="knowledge-cal-view-day" onClick={() => setCalView("day")}>日</button>
            <button type="button" className={calView === "week" ? "active" : ""} data-testid="knowledge-cal-view-week" onClick={() => setCalView("week")}>周</button>
            <button type="button" className={calView === "month" ? "active" : ""} data-testid="knowledge-cal-view-month" onClick={() => setCalView("month")}>月</button>
          </div>

          {calView === "month" && (
            <div className="month-view" data-testid="knowledge-cal-month-view">
              <header className="month-header"><strong>{CALENDAR_MONTH.label}</strong><small>点击某天进入日视图</small></header>
              <div className="month-grid" role="grid" aria-label={`${CALENDAR_MONTH.label}知识月视图`}>
                {["一", "二", "三", "四", "五", "六", "日"].map((w) => (
                  <span key={w} className="month-weekday">{w}</span>
                ))}
                {monthCells.map((cell, idx) =>
                  cell ? (
                    <button
                      key={cell.date}
                      type="button"
                      className={`month-cell ${cell.isToday ? "today" : ""} ${cell.date === kDay ? "selected" : ""}`}
                      data-testid={`knowledge-month-day-${cell.date}`}
                      onClick={() => openDay(cell.date)}
                    >
                      {cell.dayNum}
                      {cell.hasItems && <i className="month-dot" aria-label="当日有知识" />}
                    </button>
                  ) : (
                    <span key={`blank-${idx}`} className="month-cell blank" aria-hidden="true" />
                  )
                )}
              </div>
              <p className="muted-line">月视图圆点 = 当日有知识入库;「今天」为 {TODAY}。</p>
              {otherDays.length > 0 && (
                <section className="detail-block" data-testid="knowledge-cal-other-days">
                  <h3>本月之外有知识的日期</h3>
                  {otherDays.map((day) => (
                    <button
                      key={day}
                      type="button"
                      className="todo-day-link"
                      data-testid={`knowledge-cal-other-${day}`}
                      onClick={() => openDay(day)}
                    >
                      📅 {dayLabel(day)}({day}) · {knowledge.filter((item) => item.day === day).length} 条
                    </button>
                  ))}
                </section>
              )}
            </div>
          )}

          {calView === "week" && (
            <div className="week-view" data-testid="knowledge-cal-week-view">
              {CALENDAR_DAYS.map((d) => {
                const items = knowledge.filter((item) => item.day === d.day);
                return (
                  <button
                    key={d.day}
                    type="button"
                    className={`week-row ${d.day === kDay ? "active" : ""}`}
                    data-testid={`knowledge-week-day-${d.day}`}
                    onClick={() => openDay(d.day)}
                  >
                    <header><strong>{d.label}</strong><small>{d.day.slice(5)}</small></header>
                    <div className="week-row-items">
                      {items.length === 0 && <small className="muted-line">无知识入库</small>}
                      {items.map((item) => (
                        <span key={item.id} className="week-item">{item.title}</span>
                      ))}
                      {items.length > 0 && <span className="week-item todo">✎ 知识 {items.length} 条</span>}
                    </div>
                  </button>
                );
              })}
              <p className="muted-line">周视图点击任意一天进入对应日视图。</p>
            </div>
          )}

          {calView === "day" && (
            <>
              <div className="week-strip" role="tablist" aria-label="选择知识日期" data-testid="knowledge-cal-week-strip">
                {CALENDAR_DAYS.map((d) => (
                  <button
                    key={d.day}
                    type="button"
                    className={d.day === kDay ? "active" : ""}
                    data-testid={`knowledge-cal-day-${d.day}`}
                    onClick={() => setKDay(d.day)}
                  >
                    {d.label}
                  </button>
                ))}
              </div>
              <section className="day-group" data-testid={`knowledge-day-${kDay}`}>
                <header><strong>{dayLabel(kDay)}</strong><span>{kDay} · {dayItems.length} 条</span></header>
                {dayItems.length === 0 && <p className="muted-line">这一天没有知识入库(真实计数,不虚构)。</p>}
                {dayItems.map(renderItem)}
              </section>
            </>
          )}
        </div>
      )}
    </Sheet>
  );
}

function KnowledgeDetail({ item, knowledge, onOpenLinked, onOpenWork, onBack, sensing }) {
  return (
    <Sheet title={`知识详情 · ${item.title}`} testid="knowledge-detail" onClose={onBack} sensing={sensing}>
      <p className="detail-summary">{item.summary}</p>
      <div className="tag-row">{item.tags.map((tag) => <span key={tag} className="tag">{tag}</span>)}</div>
      <section className="detail-block" data-testid="knowledge-source-state">
        <h3>来源与状态</h3>
        <dl>
          <div><dt>来源</dt><dd>{item.source}</dd></div>
          <div><dt>状态</dt><dd><StateChip state={item.state} /></dd></div>
          <div><dt>日期</dt><dd data-testid="knowledge-day-label">{dayLabel(item.day)}({item.day})</dd></div>
          <div><dt>证据</dt><dd>{item.evidence ?? 1} 条(Mock)</dd></div>
          <div><dt>更新</dt><dd>{item.updated}</dd></div>
        </dl>
      </section>
      <section className="detail-block">
        <h3>关联知识</h3>
        <div className="related-links">
          {item.links.length === 0 && <small>暂无关联(候选知识确认后将自动建立连接)</small>}
          {item.links.map((id) => {
            const linked = knowledge.find((entry) => entry.id === id);
            if (!linked) return null;
            return (
              <button key={id} type="button" data-testid={`linked-${id}`} onClick={() => onOpenLinked(id)}>
                ⛓ {linked.title}
              </button>
            );
          })}
        </div>
      </section>
      <button type="button" className="primary-action" data-testid="open-work-surface" onClick={() => onOpenWork(item.id)}>
        打开上下文工作面
      </button>
    </Sheet>
  );
}

// PX-correction (KK-PX-R5-01): the work surface renders only the selected
// item's own recorded content. Items without a deterministic conclusion get an
// honest prototype note instead of an unrelated template; conflict counts are
// never fabricated. PX-correction (KK-PX-R5-04): the back control really does
// return directly to the Agent conversation, matching its label.
function WorkSurface({ item, onBack, sensing }) {
  return (
    <Sheet title={`工作面 · ${item.title}`} testid="work-surface" onClose={onBack} sensing={sensing}>
      <header className="work-conclusion" data-testid="work-conclusion">
        <small>{item.conclusion ? "当前稳定结论(确定性 Mock)" : "结论状态(诚实说明)"}</small>
        <strong>{item.conclusion || "当前没有可模拟的确定性结论"}</strong>
        <span>{item.conclusion ? "🛡 来源可追溯 · 只读草案" : "原型说明:该条目为最近捕获的知识,不挂接无关主题模板"}</span>
      </header>
      <section className="detail-block" data-testid="work-item-content">
        <h3>条目内容</h3>
        <p className="detail-summary">{item.summary}</p>
        <small className="source-line">来源:{item.source}</small>
      </section>
      <div className="work-grid">
        <article><small>关联知识</small><strong>{item.links.length} 条</strong></article>
        <article><small>证据来源</small><strong>{item.evidence ?? 1} 条</strong></article>
        <article data-testid="work-conflict"><small>冲突</small><strong>{item.conflicts ?? 0} 项(无虚构)</strong></article>
        <article><small>更新</small><strong>{item.updated}</strong></article>
      </div>
      <section className="detail-block">
        <h3>可执行动作(原型)</h3>
        <p className="muted-line">工作面为上下文化浮层:点击下方按钮直接返回 Agent 对话,对话与知识上下文不丢失。</p>
      </section>
      <button type="button" className="secondary-action" data-testid="work-surface-back" onClick={onBack}>
        ← 返回 Agent 对话
      </button>
    </Sheet>
  );
}

// Owner-directed: the calendar has three views — 日 / 周 / 月 (day / week /
// month) — and schedule and todos share it. Selecting a day filters both;
// todos deep-link back into the calendar day view. R5: schedule and todo
// items carry quick actions (complete / postpone one day) and 引用对话
// (reference the item into the Agent conversation).
function CapabilitySheet({ capability, todos, schedule, calendarDay, onSelectDay, onToggleTodo, onPostponeTodo, onToggleSchedule, onPostponeSchedule, onReference, onOpenCalendarDay, onClose, sensing }) {
  const isCalendar = capability.id === "calendar";
  const isTodo = capability.id === "todo";
  const isSkills = capability.id === "skills";
  const [calView, setCalView] = useState("day");
  // PX P3 fix: after 顺延 the day list stays time-ordered.
  const daySchedule = schedule.filter((item) => item.day === calendarDay)
    .slice().sort((a, b) => a.time.localeCompare(b.time));
  const dayTodos = todos.filter((todo) => todo.day === calendarDay);

  // September 2026 month grid, Monday-first, astronomically correct weekdays.
  const monthCells = useMemo(() => {
    const { year, month } = CALENDAR_MONTH;
    const daysInMonth = new Date(year, month, 0).getDate();
    const firstOffset = (new Date(year, month - 1, 1).getDay() + 6) % 7; // Monday-first
    const cells = [];
    for (let i = 0; i < firstOffset; i += 1) cells.push(null);
    for (let d = 1; d <= daysInMonth; d += 1) {
      const date = `${year}-${String(month).padStart(2, "0")}-${String(d).padStart(2, "0")}`;
      cells.push({
        date,
        dayNum: d,
        isToday: date === TODAY,
        hasItems: schedule.some((item) => item.day === date) || todos.some((todo) => todo.day === date),
      });
    }
    return cells;
  }, [schedule, todos]);

  const openDay = (date) => {
    onSelectDay(date);
    setCalView("day");
  };

  return (
    <Sheet title={`能力 · ${capability.label}`} testid={`capability-sheet-${capability.id}`} onClose={onClose} sensing={sensing}>
      <div className="capability-state-row">
        <StateChip state={capability.state} />
        <small data-testid={`capability-note-${capability.id}`}>{capability.note}</small>
      </div>
      {isCalendar && (
        <div data-testid="calendar-work-surface">
          <div className="sheet-tabs three" role="tablist" aria-label="日历视图" data-testid="calendar-view-switcher">
            <button type="button" className={calView === "day" ? "active" : ""} data-testid="calendar-view-day" onClick={() => setCalView("day")}>日</button>
            <button type="button" className={calView === "week" ? "active" : ""} data-testid="calendar-view-week" onClick={() => setCalView("week")}>周</button>
            <button type="button" className={calView === "month" ? "active" : ""} data-testid="calendar-view-month" onClick={() => setCalView("month")}>月</button>
          </div>

          {calView === "month" && (
            <div className="month-view" data-testid="calendar-month-view">
              <header className="month-header"><strong>{CALENDAR_MONTH.label}</strong><small>点击某天进入日视图</small></header>
              <div className="month-grid" role="grid" aria-label={`${CALENDAR_MONTH.label}月视图`}>
                {["一", "二", "三", "四", "五", "六", "日"].map((w) => (
                  <span key={w} className="month-weekday">{w}</span>
                ))}
                {monthCells.map((cell, idx) =>
                  cell ? (
                    <button
                      key={cell.date}
                      type="button"
                      className={`month-cell ${cell.isToday ? "today" : ""} ${cell.date === calendarDay ? "selected" : ""}`}
                      data-testid={`month-day-${cell.date}`}
                      onClick={() => openDay(cell.date)}
                    >
                      {cell.dayNum}
                      {cell.hasItems && <i className="month-dot" aria-label="当日有日程或待办" />}
                    </button>
                  ) : (
                    <span key={`blank-${idx}`} className="month-cell blank" aria-hidden="true" />
                  )
                )}
              </div>
              <p className="muted-line">月视图圆点 = 当日有 Mock 日程或关联待办;「今天」为 {TODAY}。</p>
            </div>
          )}

          {calView === "week" && (
            <div className="week-view" data-testid="calendar-week-view">
              {CALENDAR_DAYS.map((d) => {
                const items = schedule.filter((item) => item.day === d.day)
                  .slice().sort((a, b) => a.time.localeCompare(b.time));
                const dayTodosCount = todos.filter((todo) => todo.day === d.day).length;
                return (
                  <button
                    key={d.day}
                    type="button"
                    className={`week-row ${d.day === calendarDay ? "active" : ""}`}
                    data-testid={`week-day-${d.day}`}
                    onClick={() => openDay(d.day)}
                  >
                    <header><strong>{d.label}</strong><small>{d.day.slice(5)}</small></header>
                    <div className="week-row-items">
                      {items.length === 0 && dayTodosCount === 0 && <small className="muted-line">无日程</small>}
                      {items.map((item) => (
                        <span key={`${item.day}-${item.time}`} className="week-item">{item.time} {item.title}</span>
                      ))}
                      {dayTodosCount > 0 && <span className="week-item todo">✓ 关联待办 {dayTodosCount} 项</span>}
                    </div>
                  </button>
                );
              })}
              <p className="muted-line">周视图点击任意一天进入对应日视图。</p>
            </div>
          )}

          {calView === "day" && (
            <>
              <div className="week-strip" role="tablist" aria-label="选择日期" data-testid="calendar-week-strip">
                {CALENDAR_DAYS.map((d) => (
                  <button
                    key={d.day}
                    type="button"
                    className={d.day === calendarDay ? "active" : ""}
                    data-testid={`calendar-day-${d.day}`}
                    onClick={() => onSelectDay(d.day)}
                  >
                    {d.label}
                  </button>
                ))}
              </div>
              <div className="plan-list" data-testid="calendar-day-schedule">
                {daySchedule.length === 0 && <p className="muted-line">这一天没有 Mock 日程。</p>}
                {daySchedule.map((item) => (
                  <article key={item.id} className={item.state} data-testid={`schedule-item-${item.id}`}>
                    <time>{item.time}</time>
                    <i />
                    <div><strong>{item.title}</strong><small>{item.meta}</small></div>
                    <span>{item.state === "done" ? "已完成" : item.state === "active" ? "进行中" : "已准备"}</span>
                    <div className="qa-row" aria-label="日程快速操作">
                      <button
                        type="button"
                        className="qa-btn"
                        data-testid={`schedule-toggle-${item.id}`}
                        aria-pressed={item.state === "done"}
                        onClick={() => onToggleSchedule(item.id)}
                      >
                        {item.state === "done" ? "↩ 重做" : "✓ 完成"}
                      </button>
                      <button
                        type="button"
                        className="qa-btn"
                        data-testid={`schedule-postpone-${item.id}`}
                        onClick={() => onPostponeSchedule(item.id)}
                      >
                        ⏭ 顺延一天
                      </button>
                      <button
                        type="button"
                        className="qa-btn"
                        data-testid={`schedule-reference-${item.id}`}
                        onClick={() => onReference({ kind: "日程", title: item.title, day: item.day, time: item.time, knowledgeRef: item.knowledgeRef || null })}
                      >
                        💬 引用到对话
                      </button>
                    </div>
                  </article>
                ))}
              </div>
              <section className="detail-block" data-testid="calendar-day-todos">
                <h3>当日关联待办({dayTodos.length})</h3>
                {dayTodos.length === 0 && <p className="muted-line">这一天没有关联待办。</p>}
                {dayTodos.map((todo) => (
                  <article key={todo.id} className={`calendar-todo ${todo.done ? "done" : ""}`} data-testid={`calendar-todo-${todo.id}`}>
                    <button
                      type="button"
                      className="todo-toggle"
                      data-testid={`calendar-todo-toggle-${todo.id}`}
                      aria-pressed={todo.done}
                      onClick={() => onToggleTodo(todo.id)}
                    >
                      {todo.done ? "✓" : "○"}
                    </button>
                    <div><strong>{todo.title}</strong><small>{todo.meta}</small></div>
                    <div className="qa-row" aria-label="待办快速操作">
                      <button
                        type="button"
                        className="qa-btn"
                        data-testid={`calendar-todo-postpone-${todo.id}`}
                        onClick={() => onPostponeTodo(todo.id)}
                      >
                        ⏭ 顺延一天
                      </button>
                      <button
                        type="button"
                        className="qa-btn"
                        data-testid={`calendar-todo-reference-${todo.id}`}
                        onClick={() => onReference({ kind: "待办", title: todo.title, day: todo.day, time: null, knowledgeRef: todo.knowledgeRef || null })}
                      >
                        💬 引用到对话
                      </button>
                    </div>
                  </article>
                ))}
              </section>
            </>
          )}
          <p className="muted-line">Mock 日程 · NOT_CONNECTED:无真实日历后端,不读写真实日历。月/周/日三视图与待办关联均为原型本地状态。</p>
        </div>
      )}
      {isTodo && (
        <div className="todo-list" data-testid="todo-work-surface">
          {todos.map((todo) => (
            <article key={todo.id} className={todo.done ? "done" : ""} data-testid={`todo-item-${todo.id}`}>
              <button
                type="button"
                className="todo-toggle"
                data-testid={`todo-toggle-${todo.id}`}
                aria-pressed={todo.done}
                onClick={() => onToggleTodo(todo.id)}
              >
                {todo.done ? "✓" : "○"}
              </button>
              <div>
                <strong>{todo.title}</strong>
                <small>{todo.meta}</small>
                <button
                  type="button"
                  className="todo-day-link"
                  data-testid={`todo-calendar-link-${todo.id}`}
                  onClick={() => onOpenCalendarDay(todo.day)}
                >
                  📅 {dayLabel(todo.day)} · 在可视化日历中查看
                </button>
                <div className="qa-row" aria-label="待办快速操作">
                  <button
                    type="button"
                    className="qa-btn"
                    data-testid={`todo-postpone-${todo.id}`}
                    onClick={() => onPostponeTodo(todo.id)}
                  >
                    ⏭ 顺延一天
                  </button>
                  <button
                    type="button"
                    className="qa-btn"
                    data-testid={`todo-reference-${todo.id}`}
                    onClick={() => onReference({ kind: "待办", title: todo.title, day: todo.day, time: null, knowledgeRef: todo.knowledgeRef || null })}
                  >
                    💬 引用到对话
                  </button>
                </div>
              </div>
            </article>
          ))}
          <p className="muted-line">Mock 待办 · NOT_CONNECTED:状态仅保存在本原型本地;日期关联展示在日历工作面。快速操作(完成/顺延)与引用对话均为原型本地状态。</p>
        </div>
      )}
      {isSkills && (
        <div className="planned-card" data-testid="skills-planned">
          <strong>个人 Skill 工厂</strong>
          <p>沉淀、模拟、批准与启停个人 Skill 的能力属于后续 Goal,本轮合同明确不实现。</p>
          <StateChip state="PLANNED" />
        </div>
      )}
    </Sheet>
  );
}

export default function App() {
  const [knowledge, setKnowledge] = useState(KNOWLEDGE_SEED);
  const [messages, setMessages] = useState([
    {
      role: "agent",
      text: "我是灵犀,你的个人知识 Agent。当前知识上下文有 6 条已确认知识、2 个已知空白。你可以直接问我,也可以通过「捕获」把新信息交给我确认入库。",
      refs: ["AOG 航材保障", "供应风险记录"],
      nextAction: null,
    },
  ]);
  const [thinking, setThinking] = useState(false);
  const [sheet, setSheet] = useState(null); // capture | knowledge | calendar | todo | skills
  const [detailId, setDetailId] = useState(null);
  const [workId, setWorkId] = useState(null);
  const [candidate, setCandidate] = useState(null);
  const [correcting, setCorrecting] = useState(false);
  const [todos, setTodos] = useState(TODO_MOCK);
  const [schedule, setSchedule] = useState(CALENDAR_MOCK);
  const [journeyState, setJourneyState] = useState("FIRST_VIEW");
  const [calendarDay, setCalendarDay] = useState(TODAY);
  const [sensingOn, setSensingOn] = useState(true);
  const [senseIdx, setSenseIdx] = useState(0);
  const idCounter = useRef(100);
  const threadRef = useRef(null);

  // Owner-directed: voice sensing runs continuously in the background
  // (simulated deterministic stream; survives sheet navigation; no real ASR).
  useEffect(() => {
    if (!sensingOn) return undefined;
    const timer = window.setInterval(() => {
      setSenseIdx((prev) => (prev + 1) % SENSING_MOCK_LINES.length);
    }, 4000);
    return () => window.clearInterval(timer);
  }, [sensingOn]);

  const toggleSensing = useCallback(() => {
    setSensingOn((prev) => !prev);
  }, []);

  const scrollThread = useCallback(() => {
    requestAnimationFrame(() => {
      const node = threadRef.current;
      if (node) node.scrollTop = node.scrollHeight;
    });
  }, []);

  const pushMessages = useCallback((next) => {
    setMessages((prev) => [...prev, ...next]);
    scrollThread();
  }, [scrollThread]);

  // Journey B — Ask the Agent
  const askAgent = useCallback((text) => {
    setJourneyState("ASK_AGENT");
    pushMessages([{ role: "user", text }]);
    setThinking(true);
    window.setTimeout(() => {
      const reply = agentReply(text, knowledge);
      pushMessages([{ role: "agent", ...reply }]);
      setThinking(false);
    }, 500);
  }, [knowledge, pushMessages]);

  const openSheet = useCallback((id) => {
    setDetailId(null);
    setWorkId(null);
    setSheet(id);
    if (id === "capture") setJourneyState("CAPTURE");
    if (id === "calendar" || id === "todo" || id === "skills") setJourneyState("CAPABILITY_WORK");
  }, []);

  const closeSheet = useCallback(() => {
    const wasCapability = sheet === "calendar" || sheet === "todo" || sheet === "skills";
    setSheet(null);
    setDetailId(null);
    setWorkId(null);
    setCandidate(null);
    setCorrecting(false);
    if (wasCapability) setJourneyState("AGENT_CONTEXT_RESTORED");
  }, [sheet]);

  // Journey C — capture → candidate → confirm / correct / reject
  const draftFromText = useCallback((text) => {
    setCandidate(draftCandidate(text));
    setCorrecting(false);
    setJourneyState("CANDIDATE_KNOWLEDGE");
  }, []);

  // PX-correction (KK-PX-R5-03, model A): 保存修正 only updates the candidate
  // draft and returns to the candidate card — it never ingests. Ingestion
  // happens ONLY through the explicit 确认入库 action, so the user always knows
  // before clicking whether the knowledge context will change.
  const saveCorrection = useCallback((fix) => {
    setCandidate((prev) => (prev ? { ...prev, title: fix.title.trim(), summary: fix.summary.trim() } : prev));
    setCorrecting(false);
    setJourneyState("CANDIDATE_KNOWLEDGE");
  }, []);

  const confirmCandidate = useCallback(() => {
    const id = `k-captured-${idCounter.current++}`;
    const newItem = {
      ...candidate,
      // One trustworthy state: confirmed items never keep 待确认 semantics.
      tags: [...candidate.tags.filter((tag) => tag !== "待确认"), "已确认"],
      id,
      group: "捕获",
      updated: "刚刚",
      day: TODAY,
      dim5: "d5-work",
      dim9: "d9-09",
      evidence: 1,
      state: "CONFIRMED",
      keywords: candidate.title.toLowerCase().split(/\s+/).filter((w) => w.length > 1),
    };
    setKnowledge((prev) => [...prev, newItem]);
    setCandidate(null);
    setCorrecting(false);
    setSheet(null);
    setJourneyState("KNOWLEDGE_CONTEXT_UPDATED");
    pushMessages([{
      role: "agent",
      text: `已确认入库:「${newItem.title}」现在是知识上下文的第 ${knowledge.length + 1} 条已确认知识${newItem.links.length ? `,并与 ${newItem.links.length} 条既有知识建立连接` : ""}。之后你问相关问题我会引用它。`,
      refs: [newItem.title],
      nextAction: { kind: "knowledge", targetId: id, label: `打开「${newItem.title}」工作面` },
    }]);
  }, [candidate, knowledge.length, pushMessages]);

  const rejectCandidate = useCallback(() => {
    const title = candidate?.title;
    setCandidate(null);
    setCorrecting(false);
    setJourneyState("CAPTURE");
    pushMessages([{
      role: "agent",
      text: `已拒绝候选知识「${title}」,它没有进入知识上下文。你可以重新输入或修正后再确认。`,
      refs: [],
      nextAction: null,
    }]);
  }, [candidate, pushMessages]);

  // Journey D — work from knowledge
  const openKnowledgeItem = useCallback((id) => {
    setSheet("knowledge");
    setDetailId(id);
    setWorkId(null);
    setJourneyState("KNOWLEDGE_WORK");
  }, []);

  const openWorkSurface = useCallback((id) => {
    setWorkId(id);
    setJourneyState("KNOWLEDGE_WORK");
  }, []);

  // PX-correction (KK-PX-R5-04, option A): the control is labeled
  // 「返回 Agent 对话」, so it returns DIRECTLY to the Agent conversation from
  // both entry paths (knowledge navigation and Agent next action). The
  // conversation and knowledge context persist — only the overlays close.
  const backFromWork = useCallback(() => {
    setSheet(null);
    setDetailId(null);
    setWorkId(null);
    setJourneyState("AGENT_CONTEXT_RESTORED");
  }, []);
  const backFromDetail = useCallback(() => { setDetailId(null); setWorkId(null); }, []);

  // Next action from Agent responses
  const handleNextAction = useCallback((action) => {
    if (action.kind === "knowledge") openKnowledgeItem(action.targetId);
    if (action.kind === "capture") openSheet("capture");
  }, [openKnowledgeItem, openSheet]);

  // Voice key toggles the continuous background sensing (simulated stream,
  // honestly disclosed in the persistent strip; no fake recording, no alert).
  const toggleTodo = useCallback((id) => {
    setTodos((prev) => prev.map((todo) => (todo.id === id ? { ...todo, done: !todo.done } : todo)));
  }, []);

  // R5 Owner-directed quick actions (prototype-local deterministic state):
  // complete/undo for schedule items, postpone one day for schedule + todos.
  const toggleSchedule = useCallback((id) => {
    setSchedule((prev) => prev.map((item) =>
      item.id === id ? { ...item, state: item.state === "done" ? "next" : "done" } : item));
  }, []);

  const postponeSchedule = useCallback((id) => {
    setSchedule((prev) => prev.map((item) =>
      item.id === id ? { ...item, day: nextDay(item.day) } : item));
  }, []);

  const postponeTodo = useCallback((id) => {
    setTodos((prev) => prev.map((todo) =>
      todo.id === id ? { ...todo, day: nextDay(todo.day) } : todo));
  }, []);

  // R5 Owner-directed: 引用对话 — reference a schedule/todo item into the
  // Agent conversation; the sheet closes and the Agent answers with the
  // linked knowledge context (deterministic mock).
  const referenceToConversation = useCallback((quote) => {
    const when = `${dayLabel(quote.day)}${quote.time ? ` ${quote.time}` : ""}`;
    setSheet(null);
    setDetailId(null);
    setWorkId(null);
    setJourneyState("AGENT_CONTEXT_RESTORED");
    pushMessages([{
      role: "user",
      text: `关于这个${quote.kind},帮我看看要注意什么。`,
      quote: { kind: quote.kind, title: quote.title, when },
    }]);
    setThinking(true);
    window.setTimeout(() => {
      pushMessages([{ role: "agent", ...referenceReply(quote, knowledge) }]);
      setThinking(false);
    }, 500);
  }, [knowledge, pushMessages]);

  // Todo → visual calendar deep link
  const openCalendarDay = useCallback((day) => {
    setCalendarDay(day);
    setDetailId(null);
    setWorkId(null);
    setSheet("calendar");
    setJourneyState("CAPABILITY_WORK");
  }, []);

  const detailItem = useMemo(
    () => knowledge.find((item) => item.id === detailId) || null,
    [knowledge, detailId]
  );
  const workItem = useMemo(
    () => knowledge.find((item) => item.id === workId) || null,
    [knowledge, workId]
  );
  const activeCapability = useMemo(
    () => (sheet === "calendar" || sheet === "todo" || sheet === "skills")
      ? CAPABILITIES.find((cap) => cap.id === sheet) || null
      : null,
    [sheet]
  );
  // PX-correction (KK-PX-R5-02): the continuous sensing state stays visible
  // and pause/resume stays reachable inside every work sheet overlay.
  const sensingProps = useMemo(
    () => ({ sensingOn, line: SENSING_MOCK_LINES[senseIdx], onToggle: toggleSensing }),
    [sensingOn, senseIdx, toggleSensing]
  );

  return (
    <div className="app-shell" data-testid="app-root" data-journey-state={journeyState}>
      <Header knowledgeCount={knowledge.length} />
      <ContextStrip knowledge={knowledge} gaps={KNOWLEDGE_GAPS} onOpenKnowledge={() => openSheet("knowledge")} />

      <main className="conversation" ref={threadRef} aria-label="Agent 对话" data-testid="conversation">
        {messages.map((message, index) => (
          <Message key={index} message={message} onNextAction={handleNextAction} />
        ))}
        {thinking && <div className="msg msg-agent thinking" data-testid="agent-thinking"><span className="msg-avatar">灵</span><div className="msg-body"><p>正在连接知识上下文…</p></div></div>}
      </main>

      <SensingStrip sensingOn={sensingOn} line={SENSING_MOCK_LINES[senseIdx]} />
      <Composer onSend={askAgent} onVoiceKey={toggleSensing} sensingOn={sensingOn} thinking={thinking} />
      <BottomNav onOpen={openSheet} activeSheet={sheet} />

      {sheet === "capture" && (
        <CaptureSheet
          candidate={candidate}
          correcting={correcting}
          onDraft={draftFromText}
          onConfirm={confirmCandidate}
          onCorrectStart={() => setCorrecting(true)}
          onCorrectSave={saveCorrection}
          onReject={rejectCandidate}
          onClose={closeSheet}
          sensing={sensingProps}
        />
      )}
      {sheet === "knowledge" && !detailItem && (
        <KnowledgeSheet knowledge={knowledge} onOpenItem={openKnowledgeItem} onClose={closeSheet} sensing={sensingProps} />
      )}
      {sheet === "knowledge" && detailItem && !workItem && (
        <KnowledgeDetail
          item={detailItem}
          knowledge={knowledge}
          onOpenLinked={openKnowledgeItem}
          onOpenWork={openWorkSurface}
          onBack={backFromDetail}
          sensing={sensingProps}
        />
      )}
      {sheet === "knowledge" && detailItem && workItem && (
        <WorkSurface item={workItem} onBack={backFromWork} sensing={sensingProps} />
      )}
      {activeCapability && (
        <CapabilitySheet
          capability={activeCapability}
          todos={todos}
          schedule={schedule}
          calendarDay={calendarDay}
          onSelectDay={setCalendarDay}
          onToggleTodo={toggleTodo}
          onPostponeTodo={postponeTodo}
          onToggleSchedule={toggleSchedule}
          onPostponeSchedule={postponeSchedule}
          onReference={referenceToConversation}
          onOpenCalendarDay={openCalendarDay}
          onClose={closeSheet}
          sensing={sensingProps}
        />
      )}
    </div>
  );
}
