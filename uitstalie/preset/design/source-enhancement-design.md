# 源码级增强设计（讨论稿）

> 状态：**设计阶段，未动手改任何源码**
> 前提：预设将与自有的 RimTalk 增强版配合使用（用户已确认）
> 用户已定约束：**尽量保持对上游兼容**
> 本文目的：把"兼容性"拆成可决策的谱系，供选择要做什么

---

## 0. 一句话结论

**兼容与简洁存在结构性冲突，无法两全。** 出路是分层：
把"加新能力"（天然兼容）与"改既有行为"（天然不兼容）分开，
前者可放心做，后者必须明示代价。

---

## 1. 兼容性谱系

按"对上游的破坏程度"分四档：

| 档 | 做法 | 上游兼容 | 我们能否受益 |
|---|---|---|---|
| **A. 纯增量** | 新增变量名/过滤器/schema 字段 | ✅ 完全兼容 | ✅ 受益 |
| **B. 补齐取值** | 不改类型，只把 null 补成 `""` | ⚠️ 边界变化 | ✅ 受益 |
| **C. 并存表示** | 新增对象型访问器，保留原字符串 | ✅ 完全兼容 | ⚠️ 部分受益 |
| **D. 改既有语义** | 改现有变量的类型或含义 | ❌ 破坏 | ✅ 最大受益 |

**关键点**：A 和 C 是真正的"免费午餐"——上游 preset 照常工作，我们的 preset 用新名字。
B 是灰色地带。D 最诱人但代价明确。

---

## 2. 候选清单（对照上一轮发现的缺陷）

### 候选 1：空串真值规范化　【B 或 D】

**问题**：`GetMagicPawnValue` 对 `health`/`thoughts`/`ideology` 用 `?? ""`，
而 `ContextBuilder.*Context` 会 `return null`。Scriban 把 `""` 当真值，
于是必须写 `{{ if x != null && x != "" }}`。

**做法选项**：

| 选项 | 内容 | 档 |
|---|---|---|
| 1a | 统一为 `?? null`（空串→null） | B/D（取决于上游是否有 preset 依赖空串真值） |
| 1b | 统一为 `?? ""`（null→空串） | B/D（同左） |
| 1c | 不动源码，模板继续写双条件 | — |

**收益**：模板守卫从 60 字符/处 降到 8 字符/处；消除一整类隐蔽缺陷。
**风险**：上游可能有 preset 依赖当前行为；且改后我们的 preset 在官方版行为不同。
**未定项**：需先确认真实取值分布（哪些字段实际返回 null、哪些返回 `""`）。

---

### 候选 2：遮蔽字段的并存访问器　【A 或 C】← 最推荐

**问题**：`MemberFilter` 屏蔽了 `Pawn` 的 7 个真实属性
（`skills`/`health`/`equipment`/`genes`/`surroundings`/`social`/`relations`），
`GetMagicPawnValue` 对同名键返回格式化字符串并优先命中，导致**子树整个不可用**：

```
{{ pawn.health.State }}              → 抛异常
{{ pawn.skills.skills[0].Level }}    → 抛异常
```

**做法**：**不改原键**，新增并存名字。源码里已存在别名映射机制
（`NormalizePawnMember`：`healthtracker→health`、`skilltracker→skills`、`genetracker→genes` 等）。

方案：让别名的语义反过来 —— 原键保持"格式化字符串"，别名的**反向写法**或新增后缀提供对象：

| 新名字（示例） | 返回 | 上游影响 |
|---|---|---|
| `pawn.healthTracker` | `Pawn_HealthTracker` 对象 | 无 |
| `pawn.skillTracker` | `Pawn_SkillTracker` 对象 | 无 |
| `pawn.relationTracker` | `Pawn_RelationsTracker` 对象 | 无 |
| `pawn.geneTracker` | `Pawn_GeneTracker` 对象 | 无 |

**注意**：需处理 `MemberFilter` —— 它按 `m.DeclaringType == typeof(Pawn)` 判断名字，
而 `healthTracker` 的声明类型是 `Pawn` 且名字不同，**不会被现有过滤命中**，故可直接访问。

**收益**：文档 `preset.md` 里那整张"level 2 遮蔽字段"表（约 40 行）从不解析变为可用。
**风险**：极低 —— 纯新增。
**待核验**：`pawn.healthTracker` 这类名字当前是否已可用（若可用则无需改源码）。

---

### 候选 3：结构化 profile　【A】

**问题**：`pawn.profile` → `PromptService.CreatePawnContext(...)`
返回**预格式化的大段文本**。社区模板要 `string.split nl | array.offset 2` 切片才能用
（`array.offset 2` 这步就是在猜"头部有几行"——脆弱）。

**做法**：新增 `pawn.profileSections`，返回**分节结构化对象**，
如 `{ identity, health, mood, relations, ... }` 各自独立字符串。

**收益**：模板可选择性地取节，不必切片猜行号；也便于按场景裁剪（如战斗时只要 health）。
**风险**：纯新增。
**规模**：中等 —— 需要把 `CreatePawnContext` 的输出重构为分节。

---

### 候选 4：多行字段返回数组　【A】

**问题**：`surroundings`、`thoughts` 等是多行字符串。社区被迫发明：

```scriban
{{~ capture nl ~}}{{ end ~}}          # 把换行符捕获成变量
lines = ctx.DialogueType | string.split nl
{{- for line in (profile_text | string.split nl | array.offset 2) }}
```

`capture nl` 这个技巧之所以存在，就是因为源码没提供结构化数据。

**做法**：新增 `pawn.surroundingsList`、`pawn.thoughtsList` 等，直接返回 `string[]`。
模板可写 `{{ for line in pawn.surroundingsList }}`。

**收益**：消除社区模板里最别扭的一段；也去掉 `StripFormattingTags` 的手工清洗需求
（可在生成数组时清洗每项）。
**风险**：纯新增。
**待核验**：Scriban 对 `string[]` 的迭代与当前 `pawns`（`List<Pawn>`）是否一致。

---

### 候选 5：`recipient` 非空保证　【B】

**问题**：`recipient` = `context.TalkRequest?.Recipient`，独白时为 null。
不加守卫直接 `{{ recipient.name }}` 会抛异常（已实测）。

**做法选项**：

| 选项 | 内容 | 档 |
|---|---|---|
| 5a | 独白时给一个空壳对象而非 null | B（上游可能依赖 `if recipient` 判空） |
| 5b | 新增 `recipientOrSelf` | A（完全兼容） |
| 5c | 保留现状 | — |

**收益**：省掉每处守卫。
**风险**：5a 会破坏官方 README 推荐的 `{{ if recipient }}` 写法 —— **不建议**。
**建议**：选 5b，或干脆不做。

---

### 候选 6：JSON schema 助手　【A】

**问题**：社区从 `pawns` 动态生成 enum（限制 `name`/`target` 只能是真实参与者）。
我们目前是静态示例，模型可幻觉名字。

**做法**：新增 `{{ json.participantNames }}` 等，直接给出合法参与者名单数组；
或提供 `{{ json.schema participants }}` 这样的过滤器输出完整 schema。
**收益**：模板不必自己拼 enum 字符串（社区那段 `array.insert_at 0 "" | array.uniq` 很绕）。
**风险**：纯新增。

---

## 3. 我的推荐次序

若决定动手，建议按"收益/风险比"排序：

| 序 | 候选 | 档 | 理由 |
|---|---|---|---|
| 1 | 候选 2（遮蔽并存访问器） | A/C | 收益大、风险近零、纯加法 |
| 2 | 候选 4（多行字段数组） | A | 消除最别扭的模板技巧 |
| 3 | 候选 6（schema 助手） | A | 消除幻觉名字，纯加法 |
| 4 | 候选 3（结构化 profile） | A | 收益大但工作量大 |
| 5 | 候选 5（recipient） | A | 小改善，可选 |
| 6 | 候选 1（空串规范化） | B/D | **收益最大但与"保持兼容"直接冲突，须单独决策** |

**候选 1 必须单独决定**：它要么放弃兼容，要么维持双条件写法（即现状）。
不存在"既兼容又修好"的方案。

---

## 4. 动手前的未决问题

1. **候选 1 的取舍**：接受不兼容以换取模板大幅简化，还是维持兼容？
2. **真实取值分布**：需实测确认哪些 `pawn.*` 实际返回 null、哪些返回 `""`
   （目前只有源码推断，没有运行期数据）
3. **交付形态**：增强版是 fork 上直接改，还是做成独立附加 mod？
   - 直接改 fork：简单，但同步上游时会冲突
   - 独立 mod：需用 `RimTalkPromptAPI`（`RegisterPawnVariable` / `RegisterEnvironmentVariable` /
     `RegisterContextVariable` / `RegisterPawnHook` / `InjectPawnSection`），
     **无需改 RimTalk 源码，天然兼容，且不依赖 fork**
   - ⚠️ 这一点值得重新评估：若所有候选都能用 API 实现，则**根本不需要改源码**
4. **编译方案**：本机需装 .NET SDK（用户已同意）；项目为 `net48`，
   需确认 `Krafs.Rimworld.Ref` 能否在无游戏本体的机器上提供程序集参考

---

## 5. 一个重要反省

候选 2/4/6 全部是"纯新增"，而 `RimTalkPromptAPI` 已经提供了注册新变量的官方途径
（见官方 README 的 Modder API 一节，本次已核验）。

**这意味着：这些增强很可能不需要改 RimTalk 源码，做成独立附加 mod 即可。**

| 方式 | 上游兼容 | 维护成本 | 同步上游 |
|---|---|---|---|
| 改 fork 源码 | 差 | 中 | 会冲突 |
| 独立附加 mod | **好** | 中 | 无冲突 |
| 混合（能 API 就 API） | 好 | 低 | 仅必要处冲突 |

用户已表示"改 fork 源码很棒"，但**在"保持上游兼容"的约束下，
独立 mod 路线可能更契合**。这个矛盾需要在动手前澄清。
