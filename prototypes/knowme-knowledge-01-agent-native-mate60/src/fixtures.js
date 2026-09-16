// Deterministic fixtures for the GOAL-KK-01 interactive prototype.
// All content is prototype mock data. No real Owner data, no real backends.

export const PROTOTYPE_DISCLOSURE = "0.1 PROTOTYPE · 确定性 Mock · 非真实数据";

export const KNOWLEDGE_SEED = [
  {
    id: "k-aog-moc",
    kind: "MOC",
    title: "AOG 航材保障",
    group: "工作",
    updated: "刚刚",
    summary: "围绕响应时限、供应风险、升级路径和复盘形成的主题入口。",
    tags: ["AOG", "保障", "MOC"],
    links: ["k-supplier-sla", "k-decision-parallel"],
    evidence: 18,
    source: "原型种子数据 · MOCK_SOURCE",
    state: "CONFIRMED",
    keywords: ["aog", "航材", "保障", "供应"],
  },
  {
    id: "k-supplier-sla",
    kind: "WIKI",
    title: "供应商与 SLA",
    group: "知识",
    updated: "12 分钟前",
    summary: "ABC 与备用供应商的服务承诺、历史履约和切换约束。",
    tags: ["供应商", "SLA"],
    links: ["k-aog-moc", "k-risk-note"],
    evidence: 11,
    source: "原型种子数据 · MOCK_SOURCE",
    state: "CONFIRMED",
    keywords: ["供应商", "sla", "abc", "履约"],
  },
  {
    id: "k-decision-parallel",
    kind: "WIKI",
    title: "历史决策:双线并行",
    group: "决策",
    updated: "今天 18:20",
    summary: "上一轮 AOG 中断的方案比较、选择依据、结果与反方证据。",
    tags: ["决策", "复盘"],
    links: ["k-aog-moc", "k-risk-note"],
    evidence: 9,
    source: "原型种子数据 · MOCK_SOURCE",
    state: "CONFIRMED",
    keywords: ["决策", "双线", "复盘", "反方"],
  },
  {
    id: "k-sla-baseline",
    kind: "WIKI",
    title: "AOG 响应基线",
    group: "规则",
    updated: "昨天",
    summary: "30 分钟确认影响,4 小时形成首个可执行处置方案。",
    tags: ["基线", "时限"],
    links: ["k-aog-moc"],
    evidence: 7,
    source: "原型种子数据 · MOCK_SOURCE",
    state: "CONFIRMED",
    keywords: ["基线", "时限", "30 分钟", "4 小时"],
  },
  {
    id: "k-risk-note",
    kind: "NOTE",
    title: "供应风险记录",
    group: "行动",
    updated: "刚刚",
    summary: "ABC 供应商通知关键件可能延迟两天,影响周四装机窗口。",
    tags: ["风险", "行动"],
    links: ["k-supplier-sla", "k-decision-parallel"],
    evidence: 4,
    source: "原型种子数据 · MOCK_SOURCE",
    state: "CONFIRMED",
    keywords: ["风险", "延迟", "abc", "装机"],
  },
  {
    id: "k-preference",
    kind: "WIKI",
    title: "我的决策偏好",
    group: "个人",
    updated: "7 月 18 日",
    summary: "高风险建议必须显示证据、反方观点、成本与可逆性。",
    tags: ["偏好", "个人"],
    links: ["k-decision-parallel"],
    evidence: 12,
    source: "原型种子数据 · MOCK_SOURCE",
    state: "CONFIRMED",
    keywords: ["偏好", "证据", "成本", "可逆"],
  },
];

export const KNOWLEDGE_GAPS = [
  { id: "gap-1", label: "备用供应商最新报价", status: "UNKNOWN" },
  { id: "gap-2", label: "周四装机窗口余量", status: "UNKNOWN" },
];

export const CAPTURE_CHANNELS = [
  { id: "text", label: "文本", state: "AVAILABLE", note: "本原型可用(本地状态)" },
  { id: "voice", label: "语音", state: "PROTOTYPE_ONLY", note: "无真实 ASR / 声纹,仅展示入口" },
  { id: "files", label: "文件", state: "PROTOTYPE_ONLY", note: "无真实解析管线,仅展示入口" },
  { id: "website", label: "网页", state: "PROTOTYPE_ONLY", note: "无真实抓取,仅展示入口" },
];

export const CAPABILITIES = [
  { id: "knowledge", label: "知识", state: "AVAILABLE", note: "原型知识上下文,可打开工作面" },
  { id: "calendar", label: "日历", state: "NOT_CONNECTED", note: "无真实日历后端;展示 Mock 日程工作面" },
  { id: "todo", label: "待办", state: "NOT_CONNECTED", note: "无真实待办后端;展示 Mock 待办工作面" },
  { id: "skills", label: "技能", state: "PLANNED", note: "个人 Skill 工厂为后续 Goal,本轮不实现" },
];

export const CALENDAR_MOCK = [
  { time: "09:30", title: "确认 ABC 延误影响", meta: "25 分钟 · AOG", state: "done" },
  { time: "11:00", title: "比较备用供应方案", meta: "45 分钟 · 决策", state: "active" },
  { time: "14:00", title: "Q3 航材保障评审", meta: "60 分钟 · 会议", state: "next" },
  { time: "17:30", title: "KnowMe MVP 证据复核", meta: "45 分钟 · 项目", state: "next" },
];

export const TODO_MOCK = [
  { id: "t-1", title: "补齐备用供应商成本证据", meta: "关联:供应商与 SLA", done: false },
  { id: "t-2", title: "评审前生成一页摘要", meta: "关联:AOG 航材保障", done: false },
  { id: "t-3", title: "确认周四装机窗口余量", meta: "关联:供应风险记录", done: true },
];

// Deterministic mock Agent. Keyword-matches the current knowledge context and
// always answers with explicit references plus one next action. No model, no
// network, no randomness.
export function agentReply(question, knowledge) {
  const q = question.toLowerCase();
  const hits = knowledge.filter((item) =>
    item.keywords.some((kw) => q.includes(kw)) ||
    item.title.toLowerCase().split(/\s+/).some((w) => w.length > 1 && q.includes(w))
  );
  const used = hits.length > 0 ? hits : knowledge.slice(0, 2);
  const refs = used.map((item) => item.title);
  let text;
  if (hits.length > 0) {
    text = `基于当前知识上下文中的「${refs.join("」「")}」:ABC 关键件可能延迟两天。按「AOG 响应基线」,先在 30 分钟内确认影响范围,4 小时内形成首个可执行方案;紧急调拨先保留为升级路径。`;
  } else {
    text = `当前知识上下文里没有直接覆盖「${question}」的条目,这是一个已知空白。我先引用最接近的「${refs.join("」「")}」作为参照;你可以把新信息通过捕获入口交给我,确认后我会把它并入知识上下文。`;
  }
  const nextAction = hits.length > 0
    ? { kind: "knowledge", targetId: used[0].id, label: `打开「${used[0].title}」工作面` }
    : { kind: "capture", label: "把这个问题捕获为候选知识" };
  return { text, refs, nextAction };
}

// Deterministic candidate-knowledge draft from free text capture.
export function draftCandidate(text) {
  const trimmed = text.trim();
  const title = trimmed.length > 18 ? `${trimmed.slice(0, 18)}…` : trimmed;
  const related = KNOWLEDGE_SEED.filter((item) =>
    item.keywords.some((kw) => trimmed.toLowerCase().includes(kw))
  ).map((item) => item.id);
  return {
    kind: "NOTE",
    title,
    summary: trimmed,
    tags: ["捕获", "待确认"],
    links: related.slice(0, 3),
    source: "Owner 文本捕获 · 原型本地状态",
  };
}
