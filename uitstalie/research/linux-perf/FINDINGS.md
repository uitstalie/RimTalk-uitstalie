# Linux 性能调研：结论与依据

> 本文件是 `research/linux-perf/` 下 80 份原始资料的**结论提炼**。
> 原始资料按 URL 归档，本文件只写"哪些能确定、哪些需实测"。
> 场景：Fedora KDE 44 · Steam Runtime Linux 1.0（sniper）· 原生 Linux · RTX 4070 SUPER

---

## 1. 最重要的否定结论：`MONO_GC_PARAMS` 对 RimWorld 无效

这是网上常被误传的方向。**三条证据链否定它**：

**证据一：`MONO_GC_PARAMS` 是 SGen 专有参数**

`mono(1)` manpage（本轮已抓，`mono-1-manpage-mankier.md:374`）原文：

> `MONO_GC_PARAMS` — **When using Mono with the SGen garbage collector**
> this variable controls several parameters of the collector.

**证据二：RimWorld 用的是 Boehm GC，不是 SGen**

真实 Linux 原生 Player.log 全文（`rimworld-playerlog-hugslib-gist.md`）：

```
Mono config path = '[Rimworld_dir]/RimWorldLinux_Data/MonoBleedingEdge/etc'
```

**`MonoBleedingEdge`** 即 Unity 内嵌的 Mono 发行目录名，配 **Boehm GC**。
SGen 是另一套，不在这个路径下。

**证据三：有人实测无效**

Unity 讨论帖（本轮已抓，`unity-discussions-mono_gc_params-max-heap-size.md`）：

> running "set MONO_GC_PARAMS max-heap-size=4G" then Unity from the commandline,
> **does not seem to work**

**结论**：不要花时间在 `MONO_GC_PARAMS` 上。

---

## 2. 与 Boehm GC 相关的变量（来自 bdwgc 官方，**但适用性待实测**）

RimWorld 用的是 Boehm GC，其变量表在 **bdwgc 官方**
（`bdwgc-docs-environment.md`，本轮已抓）。与性能相关的几项：

| 变量 | 作用（原文） |
|---|---|
| `GC_INITIAL_HEAP_SIZE=<bytes>` | 设初始堆大小。**May speed up process start-up** |
| `GC_MAXIMUM_HEAP_SIZE=<bytes>` | 设最大堆大小 |
| `GC_PRINT_STATS` | 打开收集器日志（诊断用） |
| `GC_LOG_FILE` | 指定 GC 日志文件（默认 stderr） |
| `GC_PRINT_VERBOSE_STATS` | 更详细日志 |
| `GC_COLLECT_AT_MALLOC=<n>` | 覆写默认值（**须该宏已定义，否则无效**） |

支持 `k` / `M` / `G` 后缀，如 `GC_INITIAL_HEAP_SIZE=1G`。

### ⚠️ 关键空缺：Unity 是否读取这些变量，**无官方说明**

本轮回调明确记录（见 `_SOURCES.md` §7）：

> 没找到 Unity 官方关于「Player 是否读取 `MONO_GC_PARAMS` / `GC_*`」的说明；
> 现有证据只有 bdwgc 侧变量表、mono(1) 把 `MONO_GC_PARAMS` 归给 SGen、
> 以及一条用户报告"在 Unity 下未生效"。

**故这是"可测方向"而非"确定方案"**。实测方法见 §5。

---

## 3. Steam Runtime（sniper）的运行时开关

sniper 官方文档本轮已通过 GitLab API v4 拿到（网页与 `/-/raw/` 被 Anubis 反爬挡住）。
与调试相关的环境变量：

| 变量 | 作用 |
|---|---|
| `STEAM_LINUX_RUNTIME_LOG=1` | 打开运行时日志 |
| `STEAM_LINUX_RUNTIME_VERBOSE=1` | 详细日志 |
| `PRESSURE_VESSEL_SHELL=instead` | 进入容器 shell（排查容器内环境） |

sniper 适用对象（`slr-runtime-sniper-README.md`）：**原生 Linux 游戏**与 Proton 8.0+。
即用户当前正是 sniper 的目标场景。

**空缺**：Valve 未提供 sniper 容器开销的量化数据（只有设计文档与已知问题表）。
issue #818（pressure-vessel 疑似内存泄漏）**已 closed**。

---

## 4. 已从真实日志确认的本机运行参数

来源：一份真实 Linux 原生 RimWorld 1.6 Player.log 全文（`rimworld-playerlog-hugslib-gist.md`）
—— 这是本轮唯一的第一手运行证据。

```
Initialize engine version: 2022.3.35f1 (011206c7a712)
Mono config path = '[Rimworld_dir]/RimWorldLinux_Data/MonoBleedingEdge/etc'
Command line arguments: -disable-compute-shaders
Default vsync count 1
[PhysX] Initialized MultithreadedTaskDispatcher with 16 workers
```

**值得注意**：该日志中**已经带了 `-disable-compute-shaders`**。
这可能是 Ludeon 官方的默认启动参数，也可能是玩家自己加的 —— 需与本机实际启动项核对。

`vsync count 1` 意味着垂直同步开启。若显示器为 144Hz 而游戏帧率受限，此项值得审视。

---

## 5. 实测方法（给 Fedora 上的操作）

### 5.1 测 `GC_*` 是否生效（**判据：日志有无 GC 输出**）

Boehm 的 `GC_PRINT_STATS` 若被读取，会往 stderr 输出 GC 统计。
Steam 启动选项填：

```
GC_PRINT_STATS=1 %command%
```

**判据**：
- 游戏日志（或终端）出现 GC 统计 → 变量**被读取**，可继续调 `GC_INITIAL_HEAP_SIZE`
- 无任何 GC 输出 → **Unity 未透传该变量**，此方向作废

> 这是**最小成本、最确定**的判据 —— 不需要先证明能提升性能，
> 只需先证明变量通道存在。

### 5.2 观察 sniper 容器内的实际环境

```
PRESSURE_VESSEL_SHELL=instead %command%
```

进入容器 shell 后可核对：
- 实际加载的库版本
- 环境变量是否被 Steam 透传进容器（**这是 §5.1 的关键前提**）
- Mono / GC 相关文件位置

### 5.3 打开运行时日志核对

```
STEAM_LINUX_RUNTIME_LOG=1 STEAM_LINUX_RUNTIME_VERBOSE=1 %command%
```

---

## 6. 本轮回调未拿到的资料（已如实记录，勿臆测内容）

被 Cloudflare 拦截（403）：

- **Ludeon 官方论坛**（含 topic 59118 "Linux and game performance"）
- **RimWorld Wiki**（含 `api.php`、`action=raw`）
- Stack Overflow、KDE Community Wiki

连接超时：`steamcommunity.com`、`reddit.com`、`archive.org`（无法用快照绕过 CF）

**后果**：RimWorld 官方与社区侧的 Linux 性能表述**本轮完全没拿到**。
若需这些内容，须另设手段（如换网络环境、用真实浏览器）。

---

## 7. 本文件的边界

- 本文件**只陈述可查证的事实**，不代替实际测试
- §2 的 `GC_*` 方向**尚无证据表明有效**，只说明"通道是否存在可测"
- **未涉及任何优化类 mod** —— 那类 mod 主要面向 Windows 测试，
  Linux 走 Mono 运行时，作者假设可能不成立
- Fedora KDE 44 的发行版特异性资料未拿到（RPM Fusion、KDE Community Wiki 均被反爬）
