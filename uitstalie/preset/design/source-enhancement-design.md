# 源码级增强设计

> 状态：**路线已定（分层），未实施**
> 用户决策：**分层处理** —— 能用外部 API 的走外部，有兼容代价的推迟/单独评估
> 用户约束：保持对上游兼容
> 关联：`../TODO.md` D1/D2 · `addon-in-fork-design.md`（仓库内附加 mod 结构）

---

## 1. 分层路线（已决策）

```
第一层  外部 API（独立程序集 RimTalk.Uitstalie.dll）
        用 RimTalkPromptAPI 注册新变量/条目/hook
        → 天然兼容上游，无同步冲突，可先做
              │
              ├─ 覆盖：候选 2、3、4、5、6（见 §3）
              │
第二层  （仅在有真实运行数据且确有必要时评估）
        进程内直调，改 RimTalk 行为
        → 破坏兼容，部署变为整包替换，须单独决策
              │
              └─ 覆盖：候选 1（空串真值规范化）
```

**原则**：先用外部 API 拿大部分收益；有兼容代价的推迟到有依据时再说。

---

## 2. 外部 API 能力边界（已从源码核实）

`Source/API/RimTalkPromptAPI.cs` 的公开方法（共 31 个）：

| 类别 | 方法 |
|---|---|
| **注册变量** | `RegisterPawnVariable`、`RegisterEnvironmentVariable`、`RegisterContextVariable` |
| **查询** | `GetRegisteredCustomVariables`、`FindEntryIdByName`、`GetVariableStore`、`GetActivePreset`、`GetAllPresets` |
| **全局变量** | `SetGlobalVariable`、`GetGlobalVariable` |
| **条目管理** | `CreatePromptEntry`、`AddPromptEntry`、`InsertPromptEntry`（含 `After`/`Before` 及按名变体）、`RemovePromptEntry`、`RemovePromptEntriesByModId`、`RegisterModDefaultEntry`、`ApplyRegisteredModDefaults` |
| **改内置条目** | `SetBuiltInEntryEnabled(modId, targetIdOrName, enabled)` |
| **Hook / 注入** | `RegisterPawnHook`、`RegisterEnvironmentHook`、`InjectPawnSection`、`InjectEnvironmentSection`、`UnregisterAllHooks`、`HasAnyHooks` |

**重要推论**：`SetBuiltInEntryEnabled` 让外部 mod 能**直接关掉内置条目** ——
这给 `TODO.md` M1（`Chat History` 内容是死配置）提供了 mod 层解法。

---

## 3. 候选清单与分层归属

| 序 | 候选 | 兼容档 | 归属层 | 状态 |
|---|---|---|---|---|
| 1 | 空串真值规范化（`?? ""` → `?? null`） | **B/D** | **第二层** | **被 §4 的未知项阻塞** |
| 2 | 多行字段返回数组 | A | 第一层 | 待设计 |
| 3 | JSON schema 助手（动态 enum） | A | 第一层 | 待设计 |
| 4 | 结构化 profile | A | 第一层 | 待设计，工作量中等 |
| 5 | `recipient` 非空保证 | A | 第一层 | 可选，价值低 |
| 6 | 遮蔽字段访问 | ？ | **未知（见 §4）** | **需先实测** |

> 兼容档：A=纯增量（完全兼容）· B=补齐取值（边界变化）· C=并存表示 · D=改既有语义

---

## 4. 未解决的未知项：遮蔽字段到底可不可达

### 4.1 已从源码确认的三件事

`ScribanParser.cs`：

1. `NormalizePawnMember`（`:408-420`）把别名**映射回被遮蔽的名字**：

   ```csharp
   "skilltracker" => "skills",
   "healthtracker" => "health",      // ← 别名反而指向遮蔽名
   "equipmenttracker" => "equipment",
   "genetracker" => "genes",
   "surroundingstracker" => "surroundings",
   ```

2. `GetMagicPawnValue`（`:282-328`）对 `health`/`skills`/`relations` 等返回**格式化字符串**

3. `TryGetMember`（`:177-193`）中 **magic 检查在真实属性之前**：

   ```csharp
   var raw = GetMagicPawnValue(p, normalized, context);
   if (raw != null) { value = raw; return true; }   // 先命中
   ```

### 4.2 但实际效果未定

关键未知：**Scriban 是先调用 `TryGetMember`，还是先反射解析 CLR 属性？**

- 若先调 `TryGetMember` → magic 字符串胜出 → `pawn.healthTracker.State` 会失败
- 若先反射真实属性 → `pawn.healthTracker`（真名不含遮蔽词）可绕过 → 子字段可达

### 4.3 为什么在开发机上测不了

本工作区用 hashtable 模拟 Pawn，**Scriban 对 hashtable 走内建反射，不调用我设的 `TryGetMember`**。
实测证据（四次尝试，结论一致）：

```
TryGetMember 命中: (未被调用)      ← 全部用例
MemberFilter 开/关：结果完全相同     ← 说明过滤器也未参与
```

**故在此环境下无法判定。** 之前基于 mock 得出的"遮蔽不可绕开"结论**不可靠，已撤回**。

### 4.4 判定方法（一行模板）

在游戏内用调试窗口的 **Edit + Resend** 测试：

```scriban
{{ pawn.healthTracker.State }}
```

- 输出对象子字段（如 `Healthy`）→ **可达**，候选 6 走第一层即可
- 输出 magic 字符串或报错 → **不可达**，需第二层

同理可测 `{{ pawn.skillTracker.PassionCount }}`、`{{ pawn.relationTracker.ChildrenCount }}`。

> 注意：`pawn.health.State`（真名）**必然**不可用，因为 `health` 正是被遮蔽的名字。
> 要测的是**别名形式**。

---

## 5. 第一层的实施顺序（建议）

按"收益/风险比"，且都可用外部 API：

| 序 | 候选 | 理由 |
|---|---|---|
| 1 | 候选 2（多行字段数组） | 消除社区 `capture nl` 那类别扭技巧，纯加法 |
| 2 | 候选 3（schema 助手） | 消除幻觉角色名/目标名，纯加法 |
| 3 | 候选 4（结构化 profile） | 收益大，但工作量中等 |
| 4 | 候选 5（`recipient`） | 小改善，可选 |
| 5 | 候选 6（遮蔽访问） | **先按 §4.4 实测再定层** |
| — | 候选 1（空串真值） | **第二层，且需先有真实数据** |

---

## 6. 动手前的未决问题

1. **§4.4 的实测**：`{{ pawn.healthTracker.State }}` 在游戏内输出什么
2. **真实取值分布**：需实测确认哪些 `pawn.*` 返回 null、哪些返回 `""`
   （目前只有源码推断，无运行期数据）—— 这决定候选 1 的取舍
3. **候选 1 的取舍**：接受不兼容换模板简化，还是维持双条件写法
4. **编译方案**：见 `addon-in-fork-design.md` §9 与 `../TODO.md` D3
