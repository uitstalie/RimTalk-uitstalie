# 模板对照分析：我们 vs 社区

> 对照对象：`output/DeepSeek Chat_preset.v2.json`（9 条目）
> 社区样本：r33Cy `RimTalk Default Revised`（8 条目 / 28.6KB）、`Medieval Fantasy`（8 条目 / 33.6KB）
> 所有变量可用性均已用源码或实测核验，核验依据见 `variables-from-source.md`

---

## 1. 条目架构对照

| 社区（8 条） | role | 我们的对应 | 差异 |
|---|---|---|---|
| `Persona` | System | `World Background` + `Base Instruction` | 社区合成一条；我们拆两条 |
| `Profiles` | System | `Pawn Profiles` | **深度差距最大**（见 §3） |
| `Conversation History` | **Assistant** | `Chat History`（User，内容不渲染） | 社区用 Assistant 且内容真渲染 |
| `Colony Status` | System | `Recent Events` | 社区依赖 Event+ 三变量 |
| `Execution` | System | `Dialogue Generation Rules` | 社区 18-22.6KB vs 我们 1.6KB |
| `Format` | System | `JSON 输出规范` | 社区动态生成 schema |
| `Trigger` | User | `Dialogue Prompt` | 社区含执行协议 |
| `Chat History` | User | — | 社区留作禁用占位（`isMainChatHistory=true`） |

**两种可行组织**：社区用「层」（`[PERSONA LAYER]` / `[PAWN PROFILES LAYER]` / `[HISTORY LAYER]` / `[SCENE CONTEXT]`）分段；我们用「条目名 + 中文标题」。都成立。

---

## 2. 三条互不重叠的技术路线

变量使用交集**只有 9 个**（我们 39 / 社区 45）：

| 路线 | 社区 | 我们 |
|---|---|---|
| 主体 | 真实属性深挖（`p.profile`、`p.inventory`、`p.needs.AllNeeds`、`p.mindState`、`p.ageTracker`） | 扁平魔法键（`pawn.health`、`pawn.traits`、`pawn.mood`…） |
| 数据整形 | 主动清洗：`StripFormattingTags`、重命名冲突标签、`array.offset` 切片 | 原样输出 |
| schema | 动态 enum（从 `pawns` 生成合法 `name`/`target`） | 静态示例 |

**关键机制确认**（决定上表第三行是否可行）：

- 被遮蔽的只有 7 个名字：`skills`/`health`/`equipment`/`genes`/`surroundings`/`social`/`relations`
- `inventory`/`needs`/`story`/`mindState`/`ageTracker`/`guest`/`ideo` 是**真实属性，可深挖**
- 输出格式：`JsonStreamParser` 用**花括号配对**扫描（`IndexOf('{')` + `FindMatchingBrace`），
  故 **JSONL 与 JSON 数组都能解析** —— 社区用数组不算偏差

---

## 3. 不足点（按影响排序）

### 3.1 对话对象只有一行，没有档案 —— 最大不足

`PawnContext.FromTalkRequest`：`CurrentPawn = request?.Initiator`，而
`ApiHistory.cs:143` 确认 `Participants = [initiator, recipient]`。

所以 `pawns` **包含** recipient，但我们的 `Pawn Profiles` 对 `p` 只输出
一行摘要（姓名/性别/年龄/种族/心情/工作），**没有对方的心情、特质、处境、想法**。

社区 `Profiles` 用 `{{ for p in pawns }}` 对**每个**参与者输出 `p.profile` 全档 + 需求 + 状态 + 记忆。

后果：模型知道"谁在说话"，但**不了解"在跟谁说话"** —— 而对话质量高度依赖对方是谁。

### 3.2 未使用 `p.profile`（现成的完整档案）

`profile` → `PromptService.CreatePawnContext(pawn, Normal)`，是引擎已格式化好的整段文本。
我们一个字段一个字段拼，既漏信息又重复劳动。

### 3.3 缺状态与资格信号

社区为每个参与者输出：`IsColonist` / `IsPrisoner` / `IsSlave` / `IsBaby` / `IsVisitor` / `IsEnemy` /
`InCombat` / `InDanger` / `IsTalkEligible`（过滤器调用形式 `{{ IsTalkEligible p }}`）。

我们完全没有。模型无法判断"这人是否该用敌对语气""是否在战斗中""是否婴儿"。

### 3.4 JSON schema 无动态约束

社区从 `pawns` 生成 `"enum": ["名字1","名字2",...]`，把 `name`/`target` 限死在真实参与者上。
我们用静态示例，模型**可以幻觉角色名或目标名** —— 而 `act`/`target` 直接驱动社交效果。

### 3.5 缺数据整形，游戏格式噪音直接进 prompt

社区明确做三件事：
- `StripFormattingTags` —— 去 XML/富文本标签
- `string.replace "Memory:" "Current Mood Modifiers:"` —— 规避与 RimTalk 原版 `memory` 语义冲突
- `array.offset 2` —— 切掉 profile 头部冗余行

我们原样输出。

### 3.6 缺空白控制 `{{~ ~}}`

社区大量使用 `{{~` / `~}}` 裁剪标签两侧空白。我们依赖 `{{` 的自然换行，
在长档案下会累积**纯空白行**，属 token 浪费。

### 3.7 浪费一整个条目

`Chat History` 条目的 `content`（`【对话历史 - 仅作为背景参考】\n{{ctx.history}}`）
在 `IsMainChatHistory` 分支被**完全忽略**（已核验），每次请求都带着这段死文本。

### 3.8 缺身份驱动的语气约束

社区有「角色原型」（Prisoner/Slave/Visitor/Enemy 各自语气规则 + 称谓）。
我们的 `Dialogue Generation Rules` 第 8 条提了俘虏/奴隶，但**未建模"对谁用什么称谓"**，
也没有"奴隶须称 Master"这类硬约束。

### 3.9 `Dialogue Prompt` 每次多输出空标签

实测确认（`build_preset.ps1` CASE 1/2）：`pawn.surroundings` 为空时，输出里
仍有字面 `周围：` 一行。守卫挡住了值没挡住标签。

---

## 4. 优点

### 4.1 空值守卫写法比社区更正确 ← 最重要的优点

社区用单条件：`{{ if eventplus_threats != "" }}`、`{{ if p.social != "" }}`。

而 Scriban 1.0.0.0 **把空字符串当真值**（已实测）：单条件在 `null`（或 `""`）其中一种输入下
必然泄漏标签字面量。我们的双条件 `!= null && != ""` 在两种输入下都正确 ——
这是本轮修复中最有价值的一条，见 `preset_diff.md` §4.3。

### 4.2 显式使用 mod 内置格式机制

我们用 `{{ json.format }}` + `{{ json.anchor }}`（`PromptPresetAssembler` 的尾部锚定）。
社区自己写 `Format` 条目、**未用**这两个 token，等于绕开了 mod 的机制
（`directives` schema 与尾部强化）。

### 4.3 可通过 `tools/build_preset.ps1` 复现验证

社区 preset **没有任何验证链路** —— 它们的条件写法缺陷无从发现。
我们有静态检查 + 用 mod 自带 Scriban.dll 的渲染实测，5 场景 × null/空串。

### 4.4 中文原生，且世界观为独立创作

社区是英文设计（并且 `Default Revised` 反过来要求输出拉丁字符、禁 CJK）。
我们的 `World Background` 中"炒饭智能"设定、`Dialogue Generation Rules` 的
**非人类种族口癖**（猫/狐狸）是社区没有的中文原生内容。

### 4.5 体量与可读性

9 条目 / 5,135 字符 vs 社区 8 条目 / 18-22.6KB 的 `Execution`。
我们的规则集可被人类读完并修改；社区的近乎不可维护。

### 4.6 `act`/`target` 与社交效果

我们显式列出 `act` 四个中文取值与 `target`，与 `ApplyMoodAndSocialEffects` 对接意图明确。

---

## 5. 摘要

| 维度 | 我们 | 社区 |
|---|---|---|
| 空值守卫正确性 | ✅ 双条件 | ❌ 单条件 |
| mod 内置机制 | ✅ 用 json token | ❌ 自己写 |
| 可验证性 | ✅ 脚本化实测 | ❌ 无 |
| 中文原生 | ✅ | ❌（英文，禁 CJK） |
| 体量可维护 | ✅ 5.1KB | ❌ 18-22.6KB |
| **对话对象档案深度** | ❌ 仅一行 | ✅ 全档 |
| 状态/资格信号 | ❌ 无 | ✅ 完整 |
| schema 动态约束 | ❌ 静态 | ✅ enum |
| 数据清洗 | ❌ 无 | ✅ 三项 |
| 空白控制 | ❌ 无 | ✅ `{{~ ~}}` |
| 死条目 | ❌ 1 个 | ✅ 无 |

**结论方向**：我们的**正确性与可维护性优于社区，信息密度显著低于社区**。
差距集中在"给模型多少上下文"（§3.1-3.4），而非"写得对不对"。
