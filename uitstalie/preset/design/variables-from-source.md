# RimTalk 变量权威表（从源码抽取）

> 生成依据：本地克隆 `code/RimTalk` @ v1.3.2（`5b3fe2a`）
> 抽取方式：直接从 `Source/` 源码正则提取，**不转述任何官方文档**
> 用途：preset 优化时的可用变量依据。官方 `preset.md` 已于 v1.3.2 删除，
> 且官方 README 部分示例与实现不符（见文末"已发现的文档-实现偏差"），故以源码为准。

---

## 1. 根级变量（`scriptObject.Add`，共 18 个）

来源：`Source/Prompt/Parser/ScribanParser.cs`

| 变量 | 源码取值 |
|---|---|
| `pawn` | `context.CurrentPawn` — 说话者 |
| `recipient` | `context.TalkRequest?.Recipient` — **可为 null，必须守卫** |
| `pawns` | `context.AllPawns` — 全部参与者 |
| `ctx` | `PromptContext` 对象本体 |
| `map` | `context.Map` |
| `context` | 说话者的格式化档案字符串（**与 `ctx.context` 不同层级但同义**） |
| `prompt` | `context.DialoguePrompt` 的简写 |
| `chat` | 对话历史对象，键 `history` / `history_simplified` / `history_raw` |
| `game` | 世界时钟对象，见 §4 |
| `json` | 键 `format` / `anchor` |
| `memory` | `GetMemoryDirective(context)` — 说话者与对象的互相印象 |
| `lang` | `Constant.Lang` |
| `is_user` / `is_from_user` | 玩家是否参与 |
| `settings` | `Settings.Get()` |
| `PawnsFinder` / `Find` / `GenDate` | RimWorld 静态类（谨慎使用） |

**根级别名**（`ScribanParser.cs:75-76`）：`time`、`hour`、`day`、`quadrum`、`year`、`season`、`weather`、`temperature`、`wealth`、`events` 均被提升为根级，与 `game.*` 同值。

**会话变量**：`setvar(key, value)` / `getvar(key)` / `random(min, max)`（`ScribanParser.cs:53-55`）。
另有 `VariableStore` 支撑的跨条目变量（`Source/Prompt/Data/VariableStore.cs`）。

---

## 2. `pawn.*` 魔法键（`GetMagicPawnValue`，共 40 个）

来源：`ScribanParser.cs:282-328`。**大小写不敏感**（`TryGetMember` → `NormalizePawnMember`）。

| 键 | 实现 |
|---|---|
| `name` | `LabelShort` |
| `fullname` | `Name.ToStringFull` |
| `def` | `def.defName` |
| `kind` | `kindDef.label` |
| `title` | `story?.Title` |
| `gender` | `gender.GetLabel()`（本地化） |
| `age` | `ageTracker.AgeBiologicalYears` |
| `chronological_age` | `ageTracker.AgeChronologicalYears` |
| `lifestage` | `ageTracker.CurLifeStage.label` |
| `faction` | `Faction?.Name` |
| `mental_state` | `MentalState?.def?.label` |
| `job` | `CurJob.GetReport(pawn)`（去尾部句点） |
| `race` | `genes?.XenotypeLabel ?? def?.label` |
| `role` | `GetRole(false)` |
| `mood` | `needs.mood.MoodString` |
| `moodpercent` | 心情百分比整数（**无 `%` 号**） |
| `personality` | `Cache.Get(pawn)?.Personality` |
| `profile` | `PromptService.CreatePawnContext(...)` — **完整档案** |
| `backstory` | `GetBackstoryContext` |
| `traits` | `GetTraitsContext` |
| `skills` | `GetSkillsContext` |
| `health` | `GetHealthContext` |
| `thoughts` | `GetThoughtsContext` |
| `fullthought` | `GetAllThoughtsContext` |
| `relations` | `GetRelationsContext` |
| `equipment` | `GetEquipmentContext` |
| `genes` | `GetAllGenesContext` |
| `notable_genes` | `GetNotableGenesContext` |
| `ideology` | `GetIdeologyContext` |
| `captive_status` | `GetPrisonerSlaveContext` |
| `social` | `RelationsService.GetRelationsString(pawn)` |
| `fullsocial` | `RelationsService.GetAllSocialString` |
| `fullrelation` | `RelationsService.GetAllRelationsString` |
| `fullinteraction` | `RelationsService.GetAllInteractionString` |
| `memory` | `GetMemoryDirectiveForPawn` |
| `location` | `PromptContextProvider.GetLocationString` |
| `terrain` | 当前格地形 `LabelCap` |
| `beauty` | `GetBeautyString` |
| `cleanliness` | `GetCleanlinessString` |
| `surroundings` | `ContextHelper.CollectNearbyContextText(pawn, 3)` |

**别名**（`NormalizePawnMember`，`ScribanParser.cs:408-420`）：
`skilltracker→skills`、`healthtracker→health`、`equipmenttracker→equipment`、`genetracker→genes`、`surroundingstracker→surroundings`。

### 2.1 空值来源（决定守卫写法）

`GetMagicPawnValue` 对**部分**键做了 `?? ""`，但**多数不做**，且被调用的 `ContextBuilder.*Context`
会 `return null`。实测确认的返回 null 的函数：

`GetRaceContext`、`GetNotableGenesContext`、`GetAllGenesContext`、`GetIdeologyContext`、
`GetBackstoryContext`、`GetTraitsContext`、`GetSkillsContext`、`GetHealthContext`、`GetMoodContext`、
`GetThoughtsContext`、`GetAllThoughtsContext`、`GetPrisonerSlaveContext`、`GetRelationsContext`、
`GetEquipmentContext`。

其中 `health` / `thoughts` / `ideology` 经 `?? ""` 后**恒为空字符串**（`ScribanParser.cs:307-314`）。

> ⚠️ 这直接决定守卫必须写成 `{{ if x != null && x != "" }}`：
> Scriban 1.0.0.0 **把空字符串当真值**，`{{ if x }}` 会在空串时判真并泄漏标签字面量；
> `{{ if x != "" }}` 会在 null 时判真。详见 `output/preset_diff.md` §4.3。

---

## 3. `ctx.*` 键（`GetMagicContextValue`，共 15 组别名）

来源：`ScribanParser.cs:422-440`。`PromptContext` 定义见 `Source/Prompt/Parser/PromptContext.cs`。

| 键（含别名） | 取值 |
|---|---|
| `DialogueType` / `dialogue_type` | `DialogueType` — 意图+话题的组合串 |
| `Intent` | `Intent` |
| `ConversationTopic` / `conversation_topic` | `ConversationTopic` |
| `DialogueStatus` / `dialogue_status` | `DialogueStatus` |
| `prompt` / `DialoguePrompt` / `dialogue_prompt` | `DialoguePrompt` |
| `context` / `PawnContext` / `pawn_context` | `PawnContext` — **格式化档案** |
| `UserPrompt` / `user_prompt` | `UserPrompt` — **仅玩家对话时非空**（`TalkType.IsFromUser()`） |
| `IsMonologue` / `is_monologue` | `TalkRequest?.IsMonologue ?? false` |
| `talk_type` / `TalkType` | `TalkType` 枚举 |
| `history` / `chat_history` / `ChatHistory` | `chat.history` 的别名 |
| `history_simplified` / `chat_history_simplified` … | 精简历史 |
| `history_raw` / `chat_history_raw` … | 原始 JSON 历史 |
| `pawn_count` / `PawnCount` | `AllPawns?.Count ?? 0` |
| `map_id` / `MapId` | `Map?.uniqueID ?? 0` |

`PromptContext` 另有可直接访问的属性：`IsFromUser`、`IsUser`、`Pawns`、`ScopedPawnIndex`、`IsPreview`。

---

## 4. `game.*` 键与 `map.*` 魔法键

`game`（`CreateGameState`，`ScribanParser.cs:354-382`）：
`time`、`hour`、`date`、`day`、`quadrum`、`year`、`season`、`weather`、`temperature`、`wealth`、`events`

`map.*` 魔法键（`GetMagicMapValue`，`ScribanParser.cs:390-406`，共 7 个）：
`time`、`date`、`season`、`weather`、`temperature`、`wealth`、`events`

---

## 5. 过滤器与工具函数

`PawnUtil` / `CommonUtil` 以 `renamer: m => m.Name` 导入（`ScribanParser.cs:60-61`），
故**方法名保持 PascalCase**。可作为过滤器（`{{ pawn | X }}`）或函数（`{{ X pawn }}`）调用。

**PawnUtil**（`Source/Util/PawnUtil.cs`）：
`IsTalkEligible`、`IsInDanger`、`IsDownedInPain`、`IsInCombatOrFire`、`IsInCombat`、
`GetRole`、`IsVisitor`、`GetTitle`、`IsEnemy`、`IsBaby`、`GetPawnStatusFull`、`GetPawnStatus`、
`HasActiveHostiles`、`GetHostileThreatInfo`、`GetHostilePawnNearBy`、`GetMapRole`、
`GetPrisonerSlaveStatus`、`IsPrisonBreaking`、`IsPlayer`、`HasVocalLink`、`GetHediffs`

**CommonUtil**（`Source/Util/CommonUtil.cs`）：
`Sanitize`、`StripFormattingTags`、`SplitByLine`、`SplitByString`、`GetInGameHour`、
`GetInGameHour12HString`、`EstimateTokenCount`、`GetMaxAllowedTokens`、`HasPassed`、
`GetTicksForDuration`、`GetInGameData`、`ShouldAiBeActiveOnSpeed`

> 注意：返回 `void` 的方法被 `filter` 排除；`GetPawnStatusFull` / `GetPawnStatus` /
> `GetHostileThreatInfo` 返回元组，模板中取值方式未验证，使用前需实测。

---

## 6. 字段遮蔽（shadowing）—— 实测确认

`MemberFilter`（`ScribanParser.cs:110-128`）主动屏蔽了 `Pawn` 上名为
`skills` / `health` / `equipment` / `genes` / `surroundings` / `social` / `relations` 的**真实属性**；
同时 `TryGetMember` 的 `GetMagicPawnValue` 对这些名字返回**格式化字符串**并优先命中。

**后果（实测）**：这些名字的子字段访问**全部抛异常**。

| 表达式 | 实测结果 |
|---|---|
| `{{ pawn.health.State }}` | **异常** |
| `{{ pawn.skills.Count }}` | **异常** |
| `{{ pawn.relations.ChildrenCount }}` | **异常** |
| `{{ pawn.needs.mood.CurLevelPercentage }}` | `0.8` ✅ |
| `{{ pawn.ageTracker.AgeBiologicalYears }}` | `28` ✅ |
| `{{ pawn.mindState.IsIdle }}` | `false` ✅ |
| `{{ pawn.story.Title }}` | `爵士` ✅ |
| `{{ pawn.guest.IsPrisoner }}` | `false` ✅ |

即：**遮蔽只影响这 7 个同名键**，其余嵌套字段（`ageTracker` / `mindState` / `needs` / `story` /
`guest` / `ideo` / `health.hediffSet` 之外的部分）可正常解析。

> 官方 `preset.md` 也标注了 `(shadowed parent)`，但未说明影响范围；此处为实测结论。

---

## 7. 已发现的"文档-实现"偏差

记录这些是为了说明**为什么不能依赖官方文档**：

| 文档说法 | 实现实际情况 |
|---|---|
| `preset.md` 全文 | **v1.3.2 已删除**（提交 `b6ce2a3`）。此处使用的是删除前最后一版 |
| README 示例 `{{ if pawn.memory }}` | **不安全**：`GetMemoryDirective` 返回 `Target?.GetImpressionOf(...) ?? string.Empty`，空串在 Scriban 中判真，实测泄漏 `Memory: []` |
| README 示例 `{{ if events }}` | 同一空串真值问题 |
| README:90 `recipient` "Same fields as `pawn`" | 字段确实同源，但 **null 时不守卫会抛异常**（实测 `EXC`） |
| README 变量表 | 只列了约 13 个，实际 `pawn.*` 有 40 个、`ctx.*` 有 15 组别名 |
| `preset.md` 的 `pawn.health.*` 等 | 标注 `(shadowed parent)` 属实，但**整个子树不可用**，不止"可能不可用" |

**结论：preset 优化应以本文件（源码抽取）为准，官方文档仅作线索。**
