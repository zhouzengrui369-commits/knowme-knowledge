# ED PERSONAL OPERATION RECEIPT — PX-KK02-R3-06 Final Exact-SHA 独立操作

```text
ED_CONTEXT_ID=ED-KK-GOAL02-R3-PX02-P2-CORRECTION-20260920-1645-A19D
CANDIDATE_SHA=3317469085d8dc10a88818369ffcc2922904079c
CANDIDATE_TREE=c688e8d6da0fe5fdaa12f2412158eb0c6d86ee15
BUILD_SHA256=05111cd04294f937839345e09b1af08aadefdc8b6cac1147f7eb4202622ca7f8（与 LE final 同一二进制，uninstall 后安装 LE 构建的 main hap）
ENVIRONMENT=OpenHarmony API 24 emulator 127.0.0.1:5555；bundle com.knowme.knowledge.voiceprototype 0.1.0；非真机
操作时间=2026-09-21 11:48–12:01 CST（Asia/Shanghai）
操作方式=ED 本人通过 hdc uitest 独立操作，独立截图（/tmp/kk02-r3/shots → screenshots/ed-personal/），未复用 LE 截图
```

## 操作记录（ACTIONS / OBSERVED_STATE / SCREENSHOT_REFS）

| # | 动作 | 观察到的状态 | 截图 | 结果 |
|---|---|---|---|---|
| ed-01 | 干净安装冷启动，观察首屏 | 拒绝态基线：「麦克风未授权」横幅+「去系统设置开启麦克风(可选)」+状态「需要麦克风权限」；手动输入可用；TEST_FIXTURE 入口可见 | ed-01-denied-baseline | PASS |
| ed-02 | 拒绝态生成 TEST_FIXTURE 候选 | 候选卡出现（⚠标注充分）；状态仍「需要麦克风权限」，横幅在 | ed-02-generate-keeps-denied | PASS |
| ed-03 | 修正候选 | 拒绝态保持（首次修正输入被键盘顶移落空，ed-05 重做成功） | ed-03-correct-keeps-denied | PASS |
| ed-04 | 丢弃候选 | Agent「已丢弃这段语音转写,知识没有变化。」；计数 +0；拒绝态与按钮文案真实 | ed-04-reject-plus-zero-keeps-denied | PASS |
| ed-05 | 重新生成并真实修正 | 候选文本含【修正】标记，仍未入库 | ed-05-correct-before-confirm | PASS |
| ed-06 | 确认候选 | 计数 0→1；「已入库…来源是模拟器测试转写(TEST_FIXTURE)…」；拒绝态保持 | ed-06-confirm-plus-one-keeps-denied | PASS |
| ed-07 | 拒绝态手动保存 | 「已记下:「ED本人手动条目乙」(手动文本)。」；计数 2；权限事实不塌缩（「麦克风未授权」横幅仍在） | ed-07-manual-save-while-denied, ed-07b-manual-count, ed-07c-mic-status-after-manual | PASS |
| ed-08 | 点「授权麦克风并开始说话」→ 系统弹窗 → 选「不允许」 | 弹窗「允许"灵犀语音原型"访问你的麦克风？」（文案=动作）；拒绝后深链系统设置应用信息页，麦克风 Toggle 关 | ed-08a-permission-dialog, ed-08b-after-deny | PASS |
| ed-09 | 设置中打开麦克风 Toggle → 返回应用 | Toggle checked=true；状态「权限已授予 · 待开始」；按钮变真实「点开始说话」；知识 2 条与来源徽标完好；Agent 上下文保留 | ed-09a-mic-granted-settings, ed-09b-granted-return | PASS |
| ed-10 | force-stop + 冷启动 | 知识 2 条+来源在；「已从本地恢复 2 条…」标记恰好一次；权限状态正确 | ed-10-cold-reopen | PASS |
| ed-11 | 终屏观察 | Agent-first：Agent 对话主区域、语音为附加能力、技术诊断折叠；披露条「模拟器/非 Mate60 真机/真机未验证/≠生产身份认证/全程本地/无云端上传」完整 | ed-11-agent-first-disclosure | PASS |
| ed-12 | 空输入点「记录」 | 无崩溃、无幽灵条目、计数仍 2（优雅 no-op） | ed-12-error-recovery-empty-input | PASS |
| ed-13 | 授权后真实录音：开始→停止；再开始→立即取消 | 「● 录音中」→停止后「已停止」→快速取消后「空闲 · 未录音」（授权事实下 IDLE 真实）；无崩溃、无残留、计数仍 2 | ed-13a-recording-attempt, ed-13b-after-stop, ed-13c-rapid-cancel | PASS |

附带验证（界面内联证据）：注册状态/本次验证状态分离——「注册档案:未注册 / 本次验证:—(尚未捕获)」（ed-08a、ed-09b 可见）。

## DEFECTS_FOUND

NONE（合同范围内）。操作层观察（非产品 defect）：模拟器键盘顶移导致 inputText 落点偏移一次，按既定追加标记法重试成功；模拟器声学链不产生真实转写为已知环境限制，TEST_FIXTURE 路径即为此设计。

## FINAL_TECHNICAL_JUDGMENT

PX-KK02-R3-06 在 exact candidate SHA/build 上工程回归通过：fixture 全流程权限事实真实、CTA 文案=实际动作、reject=+0/confirm=+1 语义不变、手动回退/权限往返/冷启动持久化/Agent-first/错误恢复全部如合同。未发现新的合同内 blocking defect。本人不声明 CANDIDATE_ADMITTED / PRODUCT_REVIEW_ELIGIBLE / PRODUCT_EXPERIENCE_PASS / HUMAN_OWNER_ACCEPTED / REAL_DEVICE_VALIDATED / MERGE / RELEASE / GOAL_CLOSED；最高声明 ENGINEERING_READY 所需之 ED 本人验证已完成。
