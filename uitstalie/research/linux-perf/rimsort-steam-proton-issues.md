# RimSort 与 Steam/Proton 环境问题调查

> 来源：RimSort 官方仓库 `RimSort/RimSort`（Python 写的 mod 管理器，1265 stars）
> 调查日期：本轮会话。所有结论均标注 issue/PR 编号，未做推测性推断。
> 场景：Linux + Steam，用户尝试用 GE-Proton 跑 RimWorld 但**因 RimSort 启动崩溃未跑通**

---

## 1. 关键结论（先说结果）

**在 Proton 环境下，RimSort 的 mod 配置会写到错误位置，导致 mod 不生效。**

RimSort issue **#2026**（**仍为 open**，创建 2026-05-30）原文：

> Multiple users on Linux running RimWorld via Proton have reported that mods appear to
> "not work" after saving and launching from RimSort. The root cause is that RimWorld's
> config directory under Proton lives inside the Proton prefix
> (e.g., `~/.steam/steam/steamapps/compatdata/294100/pfx/drive_c/users/steamuser/AppData/LocalLow/Ludeon Studios/RimWorld by Ludeon Studios/Config`),
> **not the native Linux path**. Users have to manually discover and set this path.

Proton 下的配置目录：

```
~/.steam/steam/steamapps/compatdata/294100/pfx/drive_c/users/steamuser/AppData/LocalLow/Ludeon Studios/RimWorld by Ludeon Studios/Config
```

而原生 Linux 下的配置目录是另一处。**两者不通用** —— 切换运行方式时必须重新配置 RimSort 的路径。

> `294100` 是 RimWorld 的 Steam AppID。

---

## 2. 相关 issue / PR 清单

| 编号 | 标题 | 状态 | 意义 |
|---|---|---|---|
| **#2026** | Auto-detect Proton compatdata paths on Linux | **open** | **根因**：Proton 下配置目录在 prefix 内，RimSort 不自动识别 |
| #677 | Allow Linux Users to Run With Proton | closed | Proton 支持的原始需求，11 条评论 |
| #1442 | Linux PopOS Cannot detect executable | closed | 报"不是有效 RimWorld 可执行文件" |
| #1786 | RimSort "works" but no mods enabled | closed | Ubuntu 24.04，保存排序后进游戏 0 mod |
| #1866 | rimsort not able to apply mods | closed | LMDE 7，RimSort 启游戏后 mod 未启用 |
| #1582 / #1583 | game executable override | closed | 允许覆盖可执行文件路径 |
| #64 | 动态 autodetect 路径 | — | #2026 属其子项 |

### 已合并的支持性 PR

| 编号 | 标题 | 合并时间 | 内容 |
|---|---|---|---|
| **#1586** | Steam style launch options | 2025-12-12 | 支持自定义可执行文件、环境变量、命令包装，如 `gamemoderun %command% -popupwindow` |
| **#1714** | Add Steam protocol launch option | 2026-01-14 | 用 `steam://rungameid/294100` URI 启动（走 Steam，从而经过 Proton） |

**最新 release：`v1.14.1`（2026-09-23）** —— 上述两项均已包含。

---

## 3. 用 Proton 跑的一个结构性矛盾（#1442 揭示）

Issue #1442 的评论原文：

> **LionelColaso**：You Are trying to run window installation on Linux, that's why you getting the popup
>
> **chartowal**：I did not know that **turning on the Proton compatibility tool meant downloading
> the windows version instead of the native linux version**. I am able to configure the file paths
> correctly when I stop forcing the compatibility tool.

**要点**：在 Steam 中启用 Proton 兼容工具，会让 Steam **下载 Windows 版而非原生 Linux 版**。
这意味着：

- 游戏目录从 `RimWorldLinux_Data` 变为 `RimWorldWin64_Data`
- 配置目录从原生 Linux 路径变为 prefix 内路径
- RimSort 的可执行文件校验、路径自动探测**都要跟着换**

即在两种运行方式间切换**不是改一个开关**，而是要重新配置整套路径。

---

## 4. 用户遇到的"启动崩溃"可能成因

以下为**基于 issue 的候选方向，未验证**，需在 Fedora 上实际排查：

1. **路径不匹配**（#2026 / #1442）
   RimSort 按原生 Linux 路径校验/写入，而 Proton 版在别处
2. **RimSort 启动方式与实际运行方式不符**
   - 直接执行二进制 → 不经过 Steam → 不会有 Steam Runtime / Proton 环境
   - 用 `steam://rungameid/294100`（#1714）→ 经 Steam → 行为取决于 Steam 侧的兼容性设置
   - RimWorld 需要 Steam Runtime 环境时，**直接执行二进制可能异常**
3. **启动选项传递**
   #1586 支持 Steam 风格启动选项；若在 RimSort 里写了选项而实际由 Steam 启动，可能重复或冲突
4. **RimSort 版本过旧**
   #677 的修复在 2026-01 才合并。若用户版本早于 `v1.14.x`，则不具备 Proton 启动能力

---

## 5. 待验证信息（需用户在 Fedora 上提供）

```bash
# 1. RimSort 版本（决定是否含 #1586/#1714 修复）
#    GUI 内查看，或看安装包版本

# 2. 游戏本体是哪个版本（决定路径）
ls ~/.local/share/Steam/steamapps/common/RimWorld/

# 3. 是否存在 Proton prefix（决定是否曾以 Proton 运行过）
ls -d ~/.steam/steam/steamapps/compatdata/294100 2>/dev/null \
  || ls -d ~/.local/share/Steam/steamapps/compatdata/294100 2>/dev/null

# 4. 原生配置目录
ls ~/.config/unity3d/Ludeon\ Studios/RimWorld\ by\ Ludeon\ Studios/

# 5. Proton 版配置目录（若存在）
ls ~/.steam/steam/steamapps/compatdata/294100/pfx/drive_c/users/steamuser/AppData/LocalLow/Ludeon\ Studios/RimWorld\ by\ Ludeon\ Studios/Config 2>/dev/null

# 6. Steam 侧的兼容性设置
#    RimWorld 属性 → 兼容性 → 是否勾选"强制使用特定 Steam Play 兼容工具"
```

**关键判据**：第 3 步的 prefix 与第 5 步的 Config 目录**是否存在** ——
若不存在，说明 Proton 从未成功运行过；若存在，则 RimSort 需指向那里。

---

## 6. 与本项目的关系

我们的项目交付物（preset + 增强 mod）在 Proton 与原生 Linux 下的差异：

| 项 | 原生 Linux | Proton |
|---|---|---|
| 游戏数据目录 | `RimWorldLinux_Data` | `RimWorldWin64_Data` |
| Mods 安装目录 | `~/.config/unity3d/.../Mods/` | prefix 内对应路径 |
| 程序集运行时 | Mono | Proton 内的 .NET |
| **我们的 preset** | 相同（JSON，与运行方式无关） | 相同 |
| **我们的增强 mod** | `net48` IL 程序集，Mono 可跑 | 同一 DLL 亦可跑 |

**好消息**：preset 是纯 JSON，**两种运行方式通用**；
`net48` IL 程序集两边都能加载。故运行方式切换**不影响我们的交付物本身**，
只影响**安装路径**与**游戏内验证环境**。

---

## 7. 未决

- 用户尚未提供第 5 节的验证信息，故"启动崩溃"的具体成因仍未定位
- #2026 至今 open，意味着 **Proton + RimSort 的路径问题官方尚未自动解决**，
  只能手动配置路径
