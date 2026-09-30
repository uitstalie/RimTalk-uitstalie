# 接班说明（HANDOFF）

> **给下一个接手这个项目的 AI / 协作者。先读本文，再读 `TODO.md`。**
> 本文回答三个问题：现在到哪一步了、缺什么才能继续、具体怎么验证。
>
> 最后更新：本轮会话结束时。分支 `uitstalie-dev`。

---

## 0. 三分钟上手

| 想知道 | 去看 |
|---|---|
| 项目是什么、有什么铁律 | `AGENTS.md` |
| 待办与决策项 | `TODO.md` |
| **现在缺什么、怎么补** | **本文 §3、§4** |
| RimTalk 有哪些可用变量（权威） | `uitstalie/preset/design/variables-from-source.md` |
| 两个必须知道的源码陷阱 | `AGENTS.md` §3 / 本文 §2 |
| 我们模板 vs 社区模板 | `uitstalie/preset/design/template-comparison.md` |
| 增强怎么做、分几层 | `uitstalie/preset/design/source-enhancement-design.md` |
| Linux 环境与构建缺口 | `uitstalie/preset/design/addon-in-fork-design.md` §9 |
| RimSort/Proton 问题 | `uitstalie/preset/design/rimsort-steam-proton-issues.md` |

---

## 1. 项目现状（已完成的部分）

### 1.1 已交付

- **修复后的预设**：`uitstalie/preset/DeepSeek Chat_preset.v2.json`（9 条目，UTF-8 BOM）
- **构建与验证脚本**：`uitstalie/tools/build_preset.ps1`
  - 相对路径推导，换机可用
  - 断言全通过才写盘；生成物已验 SHA256 稳定
- **原始预设**（只读源）：`uitstalie/tools/upstream/DeepSeek Chat_preset.json`

修复内容（P0–P4）：
1. **33 处 Liquid `{% %}` → Scriban `{{ }}`** —— 修复前 `Pawn Profiles` 整条抛异常，
   模型收到的是 Scriban 源码而非角色档案
2. 逗号清理 + 修 `身份` 行逗号重复
3. 新增 `Recent Events`（Advanced 模式下必需）
4. `JSON Format` token 化，定制正文迁至「JSON 输出规范」
5. 全部可选字段改**双条件守卫**

### 1.2 环境（两台机器）

| 机器 | 系统 | 角色 |
|---|---|---|
| 开发机 | Windows + PowerShell 7.6.6 | 写代码、模板渲染实测、git |
| **游戏机** | **Fedora KDE 44** | **游戏内验证只能在它上面做** |

运行方式：**Steam Runtime Linux 1.0（sniper）原生 Linux，非 Proton**
（用户也在尝试 GE-Proton 但未跑通，见 §3.4）

---

## 2. 两条铁律（务必先记）

### 2.1 Scriban 把空字符串当真值

`Scriban.dll` 1.0.0.0 中 `{{ if x }}` 对 `""` **判真**。

| 写法 | `null` | `""` |
|---|---|---|
| `{{ if x }}` | 不输出 ✅ | **输出 ❌** |
| `{{ if x != "" }}` | **输出 ❌** | 不输出 ✅ |
| `{{ if x != null }}` | 不输出 ✅ | **输出 ❌** |
| `{{ if x != null && x != "" }}` | ✅ | ✅ |

**写任何可选字段守卫时必须用双条件**，否则会泄漏 `| 处境：` 这类标签字面量。
（官方 README 的示例同样踩了这个坑。）

### 2.2 别用 hashtable mock 去测成员解析

本工作区无 RimWorld 程序集，只能用 hashtable 模拟 Pawn。
但 **Scriban 对 hashtable 走内建反射，不调用 `TryGetMember`** ——
实测四次均显示 "TryGetMember 未被调用"，`MemberFilter` 开/关结果完全相同。

**故涉及 `TryGetMember` / `MemberFilter` / 遮蔽 的判断，只能游戏内实测，mock 结论一律不可信。**
（我为此撤回过一条错误结论，见 `TODO.md` 末尾「已撤回的错误结论」。）

---

## 3. 缺什么才能继续（§4 是验证方法）

### 3.1 【最优先】一行实测：遮蔽字段可不可达

**这一条决定一个增强候选归哪一层，5 分钟就能出结果。**

在游戏内用 RimTalk 调试窗口的 **Edit + Resend** 测：

```scriban
{{ pawn.healthTracker.State }}
```

| 输出 | 结论 | 后续 |
|---|---|---|
| 对象子字段（如 `Healthy`） | **可达** | 增强候选 6 归**第一层**（外部 API） |
| magic 格式化字符串 | **不可达** | 需第二层 |
| 报错 | **不可达** | 需第二层 |

背景：`NormalizePawnMember`（`ScribanParser.cs:408-420`）把
`healthtracker → health`（**别名反向指向被遮蔽名**），而 `TryGetMember` 里 magic 检查
先于真实属性。但 **Scriban 是先调 `TryGetMember` 还是先反射 CLR 属性，未定** ——
这个在无 RimWorld 程序集的环境里测不出来。

可同法测：`{{ pawn.skillTracker.PassionCount }}`、`{{ pawn.relationTracker.ChildrenCount }}`。

### 3.2 取一份完整真实 prompt

用于确认（目前**全是源码推断，无运行期数据**）：

- 哪些字段实际返回 `null`、哪些返回 `""` → **决定空串真值问题的取舍**
- 模板里哪些字段实际为空、哪些内容其实没被用上
- 两个已知冲突点的实际表现（§3.3）

**取法**：游戏内 `Ctrl + 左键` 点右下角 RimTalk 开关 → 调试窗口 →
取任意一行 → API Log → **左栏就是发给 API 的完整 JSON**。

### 3.3 两个已知冲突点待实测

| 项 | 待验 |
|---|---|
| `pawn.memory` 同名冲突 | 原版魔法键 vs ExpandMemory 注册的 `pawn.memory`，实际取到哪个 |
| `ruaji.rimtalkpromptenhance` / `mjcg.RimtalkPatch` | 这两个已装 mod **无公开源码仓库**，注入了什么仍空白 |

### 3.4 Fedora 侧待提供的信息

```bash
# 编译工具链（决定能否在本机构建增强 mod）
dotnet --list-sdks
mono --version
msbuild -version

# 游戏与路径
ls ~/.local/share/Steam/steamapps/common/RimWorld/
ls ~/.config/unity3d/Ludeon\ Studios/RimWorld\ by\ Ludeon\ Studios/

# RimSort/Proton 场景（判断崩溃成因）
ls -d ~/.steam/steam/steamapps/compatdata/294100 2>/dev/null \
  || ls -d ~/.local/share/Steam/steamapps/compatdata/294100 2>/dev/null
```

### 3.5 游戏内验收现有交付物

`DeepSeek Chat_preset.v2.json` **尚未在游戏内验证过**：

- **先开 Advanced Prompt Mode**，否则 `World Background` 与 `Dialogue Generation Rules`
  会被**静默丢弃**（不报错）
- 检查角色档案应展开为真实姓名/特质，而非 `{{p.name}}` 原文
- prompt 中出现 `Colony Status`、`Memory & Knowledge Context` **属正常**（扩展 mod 注入）

---

## 4. 验证方法（可复现）

### 4.1 静态检查 + 模板渲染实测

```powershell
# 需 PowerShell 7（Windows 或 Linux 的 pwsh 均可）
& "<repo>\uitstalie\tools\build_preset.ps1"
```

脚本会：
1. 从 `uitstalie/tools/upstream/` 读原始预设
2. 用 mod 自带 `Libs/Scriban.dll` 按 `Template.Parse(text)` **单参数**渲染（与 mod 一致）
3. 跑 5 场景 × 2 种空值输入（`null` / 空串）= 10 组断言
4. **全部通过才写入** `uitstalie/preset/`

设 `RT_DEBUG=1` 可输出额外诊断。

### 4.2 判定渲染是否忠实于 mod

任何新写的模板判断，若涉及 `TryGetMember`/`MemberFilter`/遮蔽，
**不要用 §4.1 的脚本下结论**（见 §2.2）—— 必须进游戏用 Edit + Resend 测。

### 4.3 游戏内验证入口

| 目的 | 操作 |
|---|---|
| 看真实 prompt | `Ctrl + 左键` 点右下角 RimTalk 开关 → 调试窗口 → 任意行 → API Log |
| 改 prompt 实时测试 | 同上窗口的 **Edit + Resend**（不用重启游戏） |
| 排查渲染异常 | 搜日志中的 `Scriban Render Error` |

---

## 5. 增强路线（已决策：分层）

```
第一层  外部 API（独立程序集 RimTalk.Uitstalie.dll）
        用 RimTalkPromptAPI 注册新变量/条目/hook → 天然兼容上游，可先做
        候选 2 多行字段数组 / 3 schema 助手 / 4 结构化 profile / 5 recipient
第二层  进程内直调（改 RimTalk 行为）→ 破坏兼容，推迟并单独评估
        候选 1 空串真值规范化
```

`RimTalkPromptAPI` 共 31 个公开方法，其中 **`SetBuiltInEntryEnabled` 可让 mod 关掉内置条目**
（给「`Chat History` 内容是死配置」提供了 mod 层解法）。

**接手前先看** `uitstalie/preset/design/source-enhancement-design.md`。

---

## 6. 编译前置条件（尚未满足）

- ❌ 开发机（Windows）**无 .NET SDK / msbuild / csc / VS**，也无 RimWorld
- ⏳ 游戏机（Fedora）工具链**未核实**
- 项目 `net48` + x64。Linux 上需 Mono、`Microsoft.NETFramework.ReferenceAssemblies`、
  或 Windows 交叉编译（IL 程序集，Mono 可跑）
- **好消息**：`Krafs.Rimworld.Ref` 含 `1.6.4871`、`Lib.Harmony.Ref` 含 `2.4.2`，
  **不设环境变量 `RIMWORLD_DIR` 即可绕开上游的 Mac 路径问题**，无需游戏本体即可编译

---

## 7. 别做的事

| 不要 | 原因 |
|---|---|
| 手改 `uitstalie/preset/*.json` | 它是脚本生成物；改模板/脚本后重新生成 |
| 用 hashtable mock 判定遮蔽行为 | 见 §2.2，结论不可信 |
| 代修 Linux 构建缺口 | 用户明确表示自行研究（`TODO.md` D4） |
| 处理提交产物哈希漂移 | 用户表示暂不处理（`TODO.md` T6） |
| 依赖官方文档判断变量 | v1.3.2 已删除 `preset.md`，README 亦有与实现不符处；**以源码为准** |
| 相信 `rimtalk_knowledge.md` | 已删除（停留在 v1.0.6），见 `AGENTS.md` §9 |
