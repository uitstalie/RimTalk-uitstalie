# 社区 preset 建议收集（原始素材归档）

> 收集日期：本次会话
> 状态：**仅收集，未做取舍判断**
> 来源与可靠性：见每节标注。社区材料一律视为**参考**，不作为权威依据；
> 涉及变量可用性的结论已单独用源码/实测核验，核验结果标注在括号内。

---

## 1. 来源清单

| # | 来源 | 类型 | 本地文件 |
|---|---|---|---|
| S1 | [r33Cy/RimTalk-Community-Preset-Collection](https://github.com/r33Cy/RimTalk-Community-Preset-Collection) | GitHub 合集（**仅 1 位贡献者**） | `community-presets/` |
| S2 | 同上，`RimTalk Default Revised` preset | 完整 preset，28,620 B | [json](community-presets/default-revised/RimTalk%20Default%20Revised.json) / [txt](community-presets/default-revised/RimTalk%20Default%20Revised.txt) / [README](community-presets/default-revised/README.md) |
| S3 | 同上，`Medieval Fantasy` preset | 完整 preset，33,569 B | [json](community-presets/medieval-fantasy/Medieval%20Fantasy.json) / [txt](community-presets/medieval-fantasy/Medieval%20Fantasy.txt) / [README](community-presets/medieval-fantasy/README.md) |
| S4 | 合集贡献模板 | 投稿规范 | [CONTRIBUTER_README.md](community-presets/templates/CONTRIBUTER_README.md) |
| S5 | 官方 README @ v1.3.2 | 官方文档 | [v1.3.2-README.md](official/v1.3.2-README.md) |
| S6 | 官方 `preset.md`（删除前最后版） | 官方文档 | [preset.md-last-version.md](official/preset.md-last-version.md) |

社区讨论区（Steam / B站 / 贴吧）由另一路并行收集，结果另见 `community-discussion/`。

---

## 2. 社区 preset 的整体结构（S2/S3 共同）

两个 preset 结构**完全一致**，8 条目同名同角色，差异只在 `Execution` 条目长度（18,041 vs 22,623 字符）：

| # | 条目名 | role | 长度 | 备注 |
|---|---|---|---:|---|
| 0 | `Persona` | System | ~2,100 | 角色扮演总纲 |
| 1 | `Profiles` | System | 1,864 | 角色档案模板 |
| 2 | `Conversation History` | **Assistant** | 270 | 历史条目，用 Assistant 角色 |
| 3 | `Colony Status` | System | 1,507 | 殖民地状态 |
| 4 | `Execution` | System | 18k~22.6k | 主体规则集（人格锁、二元模式、摩擦协议…） |
| 5 | `Format` | System | 1,279 | 输出格式 |
| 6 | `Trigger` | User | ~1,636 | 触发段 |
| 7 | `Chat History` | User | 18 | **enabled=False**，但 `isMainChatHistory=True` |

**观察（仅陈述）**：条目名全部不是内置名（无 `Base Instruction` / `JSON Format` / `Recent Events`），
故这些 preset 属于**面向 Advanced 模式**的写法。第 7 条 `Chat History` 被禁用却保留 `isMainChatHistory=True`，
实际历史内容走第 2 条 `Conversation History`（role=Assistant）。

---

## 3. 社区提出的做法清单（按 README 原文归纳）

以下均为**社区声称的做法**，未做有效性判断。

### 3.1 S2 `RimTalk Default Revised`

| 做法 | README 原述 |
|---|---|
| 自然化词表（强制翻译） | 把引擎 UI 术语（如 "Ate without table"）转成世界内概念，禁止照念机制 |
| 科幻/RimWorld 术语优先 | 明确鼓励使用 charge rifle、drop pod、plasteel、mechanoid 等原生术语 |
| 角色原型强制 | 按 Colonist / Prisoner / Slave 分派语气；**奴隶必须称殖民者为 "Master"/"Mistress"** |
| 人格锁（Personality Lock） | 近 **50 种**人格覆写（Cold Rationalist / Hothead / Skeptical Scientist / Grumpy Elder…），决定用词、节奏、语法 |
| 二元社交模式 | Solo Mode（单句内心）与 Social Mode（**强制 4-8 轮**来回）自动切换 |
| 关系摩擦协议 | 心情过低或人格易怒时，允许对配偶/挚友发起争执或轻视 |
| "Show, Don't Tell" | 要求用台词直接表达情绪，禁止旁白式叙述 |
| 殖民地与世界感知 | 依赖 **Event+** mod，使 pawn 知晓威胁、地图状况、任务 |
| 性别锁定称谓 | 交叉引用 `[Gender]` 字段确保代词与称谓正确 |
| 场景执行协议 | 防止跑题、重复套路；历史层仅作背景连续性参考 |
| 档案工程 | 清洗原始游戏数据，把冲突标签改名为 "Current Mood Modifiers"，剥离技术性格式 |
| "Crowded Thought" 触发器 | 社交场合中若 pawn 有 thought，强制"低声自语"让旁人听见并触发对话链 |
| 野兽称呼逻辑 | 对动物使用本能/生存主义措辞 |
| 数据隔离协议 | 禁止照搬内部视角或编年事件的原文 |
| "Void Rule" | 交叉检查档案中的 `CanTalk` 状态，不可对话时锁定为 "None" 动作 |
| 仅拉丁字符限制 | 禁止 CJK 与 Unicode 符号混入输出 |
| 简短强制 | 每轮上限 30-40 词 |

### 3.2 S3 `Medieval Fantasy`

结构与 S2 对应，差异项：

| 做法 | README 原述 |
|---|---|
| 冷硬词表 + **1700 年否决权** | 禁现代俚语（okay/cool/guys）与工业/科幻词；工业革命后概念只能用材质+元素+功能描述 |
| 英式拼写锁定 | 强制 British English（Labour/Honour/Organise/Centre） |
| 角色原型 | 奴隶称 "Master"/"Mistress"；殖民者互称 "kin"/"comrade" |
| 人格锁 | **25+ 种**（Stoic / Abrasive / Haughty / Simpleton…），README 提到用"优化空白"排版 |
| 二元社交模式 | 同为 Solo / Social，Social 强制 4-8 轮 |
| 关系摩擦协议 | 同 S2 |
| 感官威胁重构 | 不直呼机制名（如 Toxic Fallout），改描述体感（"the choking yellow haze"）；但可点名人形反派 |
| 反"圣人"令 | 禁华丽旁白；thee/thou 仅限 High Noble 或 Scholar 背景 |
| 性别锁定亲缘称谓 | Sir / Dame / Brother / Sister |
| "Crowded Thought" 触发器 | 同 S2 |
| 野兽称呼逻辑 | 本能反应式短语、战术口令、粗野咒骂 |
| 数据隔离协议 | 用 "Component Blueprint" 强制生成全新台词 |
| "Void Rule" | 同 S2 |
| 仅拉丁字符限制 | 同 S2 |
| **双重翻译引擎** | 先解析中文意图数据 → 英译 → 再转中世纪方言（面向多语言 mod 环境） |
| 档案工程 | 同 S2 |

### 3.3 S1 顶层 README 的配置建议（非 preset 内容）

- **必需附加 mod**：RimTalk 本体、**Event+**、**Expand Memory**、**Expand Thoughts**
- **推荐附加 mod**：Expand Literature、Expand Relation、DynamicColors
- **模型**：Gemma-4-31B 或同级高能力模型；本地 TabbyAPI + exllamav3
- **上下文窗口 20k**、KV cache `4,4`、chunk 4096
- **采样参数**：temperature 0.85、min_p 0.05、repetition_penalty 1.05（range 8192）、DRY multiplier 0.4
- README 明确提示：规则集复杂，需搭配**高能力模型**才能不脱戏

### 3.4 S4 投稿模板要点

见 [CONTRIBUTER_README.md](community-presets/templates/CONTRIBUTER_README.md)（1,508 B）。

---

## 4. 社区 preset 实际引用的变量（已分类核验）

> 提取自 S2/S3 两个 JSON 的全部条目内容。
> 说明：初次粗提取混入了 Scriban 循环变量与局部变量，下表已剔除。

### 4.1 RimTalk 原生变量（社区用到、**源码核验存在**）

| 变量 | 来源核验 |
|---|---|
| `pawn` / `pawns` / `recipient` | 根级（`ScribanParser.cs` `scriptObject.Add`） |
| `chat.history` | `chat` 对象键 |
| `hour` / `day` / `quadrum` / `season` / `year` | 根级别名（`:75-76`） |
| `map.weather` / `map.Biome.label` | `map.*`（`map.Biome.label` 非魔法键，走真实属性） |
| `p.name` / `p.fullname` / `p.gender` / `p.age` / `p.faction` | `GetMagicPawnValue` 40 键之内 ✅ |
| `p.job` / `p.location` / `p.beauty` / `p.terrain` / `p.cleanliness` | 同上 ✅ |
| `p.memory` | 同上 ✅ |
| `p.needs.mood.MoodString` | 非遮蔽嵌套，实测同类可用 ✅ |
| `p.IsColonist` / `p.IsPrisoner` / `p.IsSlave` | Pawn 真实属性 ✅ |

### 4.2 过滤器（社区用法，源码核验存在）

```
InCombat: {{ IsInCombat p }}        → PawnUtil.IsInCombat ✅
InDanger: {{ IsInDanger p }}        → PawnUtil.IsInDanger ✅
CanTalk:  {{ IsTalkEligible p }}    → PawnUtil.IsTalkEligible ✅
{{ IsBaby p }} / {{ IsVisitor p }} / {{ IsEnemy p }}  → PawnUtil ✅
```

> **注**：S2 README 把这写作 "cross-checks the `CanTalk` status"，但 preset 内实际调用的是
> `IsTalkEligible` 过滤器。源码中 `CanTalk` 是 `CustomDialogueService.CanTalk(...)` 的
> **C# 方法**，**不是模板变量**。README 表述与实现不一致。

### 4.3 非 RimTalk 变量（属其他 mod 或 preset 自定义）

| 名称 | 判定 |
|---|---|
| `eventplus_threats` / `eventplus_conditions` / `eventplus_quests` | **RimTalk Event+ mod** 注册的变量 |
| `smart_history` | preset 自定义会话变量（`setvar`/`getvar`） |
| `intent` / `topic` | 疑似局部变量或 `ctx.Intent` 的简写（未逐处确认） |
| `p` / `line` / `need` / `n` / `medium` / `pn` | Scriban 循环变量与局部变量 |
| `line.LabelCap` / `need.Def` / `need.CurCategory` | 上述局部变量的属性 |

---

## 5. 与现状的对照（仅罗列差异，不含建议）

当前 preset（`output/DeepSeek Chat_preset.v2.json`，9 条目）**未使用**以下社区或官方材料中出现的变量：

```
recipient.*（对话对象档案）      ← 官方 README:90 与官方示例模板均使用
pawn.profile （完整档案）        ← 官方 preset.md
pawn.personality                ← 社区"人格锁"的基础变量
pawn.beauty / pawn.cleanliness / pawn.terrain / pawn.fullname / pawn.kind
pawn.fullthought / pawn.equipment / pawn.genes / pawn.notable_genes
pawn.mental_state / pawn.faction / pawn.lifestage
ctx.DialogueStatus / ctx.Intent / ctx.ConversationTopic / ctx.UserPrompt
game.wealth / wealth / year / time
map.Biome.label
过滤器：IsInCombat / IsInDanger / IsTalkEligible / IsBaby / IsVisitor / IsEnemy / Sanitize
会话变量：setvar / getvar / random
```

当前 preset 静态文本合计 **4,859 字符**（模板原文，非 prompt 实际长度），
其中 `Dialogue Generation Rules` 1,574 + `Pawn Profiles` 1,255 + `JSON 输出规范` 605 为最大的三块。

---

## 5.5 附加核验：「人格锁」的真实取值域（源码级）

社区两个 preset 的**最大建议块**是"人格锁"（Personality Lock，48/25+ 种覆写），
其基础变量是 `{{ pawn.personality }}`。本节为源码核验结果。

### 取值链路

```
Constant.Personalities[48]          每项 new("RimTalk.Persona.<Key>".Translate(), chattiness)
        ↓ 随机抽取（仅人类成年 pawn，且原人格为婴儿人格时触发）
PersonaService.GetPersonality(pawn) → Hediff_Persona.Personality
        ↓  或由 GeneratePersona() 调用 AI 生成一句自由文本
{{ pawn.personality }}              → GetMagicPawnValue "personality"
```

### 实测/源码事实

| 项 | 结论 |
|---|---|
| 内置人格数量 | **48 项**（`Constant.Personalities`），另有 4 个特殊：`Animal` / `Mech` / `NonHuman` / `Baby` |
| 取值形态 | **不是短标签，而是一整句语气描述**（见下表） |
| 语言 | 每项经 `.Translate()`，**返回当前游戏语言的本地化文本** |
| 中文可用性 | `Languages/ChineseSimplified/Keyed/Translation_ChineseSimplified.xml` 含 **52 条** `RimTalk.Persona.*` |
| 可否为空 | **可以**：`GetPersonality` 在 `hediff == null`、玩家且非 AIDriven 模式时返回 `""` |
| 可否为自由文本 | **可以**：`GeneratePersona()` 让 AI 生成一句 persona，**不限于 48 项** |

### 中文取值样例（实际会进入 prompt 的内容）

```
CheerfulHelper   → 活力充沛且热情开朗。对待任何人总是笑脸相迎、亲切随和。
Hothead          → 单细胞的暴脾气。性子虽急容易发作，但过后毫不在意绝不记仇。
ColdRationalist  → 寡言少语且理智淡漠。外表看似冷冰冰，内心却最在乎殖民地的实际存活。
GrumpyElder      → 爱发牢骚的老古板。嘴上咂舌训斥个不停，私底下却又默默关照。
SkepticalScientist → 沉着理性且重事实。比起毫无根据的奇思怪想，更笃信切实证据。
Animal           → 动物: 单纯且情绪化，本能优先。使用简短直观的感官语句。
Mech             → 机器人: 诊断精简，响应高效。沉稳且注重数据的语调。
Baby             → 婴儿: 单纯且感知优先。通过咿呀学语、笑闹与哭泣反应，关注饥饿、舒适与熟悉面孔。
```

（全 52 条见源码 `Languages/ChineseSimplified/Keyed/Translation_ChineseSimplified.xml`）

### 由此产生的三个客观约束

1. **社区"人格锁"用的是英文 key 名**（`Cold Rationalist` / `Grumpy Elder` / `Skeptical Scientist`），
   而中文游戏下 `{{ pawn.personality }}` 返回的是**中文整句**。按英文名做映射表在中文环境下**不匹配**。
2. **人格文本本身已含语气指导**（"使用简短直观的感官语句"、"沉稳且注重数据的语调"），
   故"把 persona 交给模型照做"与"维护映射表"是两种可行路径，前者不依赖固定取值域。
3. **AI 生成的人格是自由文本**，取值域**开放**，任何基于固定 48 项枚举的映射都会漏。

> 以上为事实陈述，不含采纳建议。

---

## 6. 待核验项（尚未验证的社区做法）

以下做法**未能通过源码直接判定有效性**，若后续采纳需实测：

1. S2/S3 的 `Execution` 条目达 18k~22.6k 字符，如此长的规则集对上下文的影响未评估
2. "人格锁"将 `{{ pawn.personality }}` 映射到近 50 种覆写 —— `personality` 的取值域未核验
   （源码为 `Cache.Get(pawn)?.Personality`，**可能为 null**，需确认实际取值集合）
3. `p.needs.mood.MoodString` 在 `needs.mood` 为 null 时的行为（未实测）
4. `eventplus_*` 需安装 Event+ 才有值，未安装时的行为未验证
5. 社区 preset 第 2 条用 `role=Assistant` 装历史 —— 该角色在装配器中的处理路径未核验
6. S3 的"双重翻译引擎"依赖中文意图数据，其数据来源未确认
7. 采样参数（temperature 0.85 / DRY 0.4 等）属 TabbyAPI 本地推理配置，与云端 DeepSeek 无关

---

## 7. 收集过程中的环境事实（供后续操作参考）

- 本沙箱内 **`raw.githubusercontent.com`、`github.com`、`cdn.jsdelivr.net` 均不可达**；
  PowerShell `Invoke-WebRequest` 对所有 HTTPS 主机 TLS 失败（schannel `SEC_E_NO_CREDENTIALS`）
- 唯一可用通道：**`api.github.com` + Node.js**（PowerShell/.NET 不可用）
- 因此 `preset.md` 未从网络获取，而是**从本地 git 历史恢复**（`cc4e8b2:preset.md`）——
  这也印证了：本地完整克隆比联网更可靠
- 未认证 GitHub API 限额 60 次/小时
