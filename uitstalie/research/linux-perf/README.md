# linux-perf 资料说明

> RimWorld 在 Linux 上的**性能与运行环境**调研归档。
> 只收集系统层、运行时层、启动层手段 —— **不涉及"优化类 mod"**
> （那类 mod 主要面向 Windows 测试，Linux 走 Mono 运行时，作者假设可能不成立）。

---

## 先看这个

| 文件 | 内容 |
|---|---|
| **`FINDINGS.md`** | **结论提炼**：哪些能确定、哪些需实测、怎么测 |
| `_SOURCES.md` | 全部来源索引 + 抓不到正文的有价值页面清单 |
| `README.md` | 本文 |

**`FINDINGS.md` 的核心是两条**：

1. **`MONO_GC_PARAMS` 对 RimWorld 无效**（三条证据链，见该文件 §1）—— 否定一个常被误传的方向
2. **`GC_*`（Boehm）变量是否被 Unity 读取，无官方说明** —— 是"可测方向"而非"确定方案"，
   实测判据见该文件 §5.1

---

## 本目录收录内容

按"是否有决策价值"精选。**完整 86 份正文在工作区**（见下节）。

### 运行时 / GC

| 文件 | 价值 |
|---|---|
| `bdwgc-docs-environment.md` | **Boehm `GC_*` 变量权威全表**（RimWorld 用的就是 Boehm） |
| `bdwgc-docs-gcdescr.md` / `bdwgc-docs-scale.md` / `bdwgc-docs-debugging.md` / `bdwgc-gc.man.md` | Boehm GC 设计、伸缩、调试 |
| `mono-1-manpage-mankier.md` / `mono-1-manpage-debian.md` | mono(1) —— **`MONO_GC_PARAMS` 归 SGen 的出处** |
| `mono-sgen-garbage-collector.md` | SGen 文档（用于对照，非 RimWorld 所用） |
| `mono-runtime-docs-index.md` | Mono 运行时文档索引 |

### Unity

| 文件 | 价值 |
|---|---|
| `unity-2022.3-performance-garbage-collector.md` | Unity 2022.3 GC 性能 |
| `unity-2022.3-managed-memory.md` | 托管内存 |
| `unity-2022.3-player-command-line-arguments.md` | 播放器命令行参数 |
| `unity-current-player-command-line-arguments.md` / `unity-command-line-arguments.md` | 同上，其他来源 |
| `unity-discussions-mono_gc_params-max-heap-size.md` | **"MONO_GC_PARAMS 未生效"的实测报告** |

### Steam Runtime（sniper）

通过 GitLab API v4 取得（网页与 `/-/raw/` 被 Anubis 反爬挡住）：

| 文件 | 价值 |
|---|---|
| `slr-runtime-sniper-README.md` | sniper 适用范围：**原生 Linux 游戏**与 Proton 8.0+ |
| `slr-sniper-release-notes.md` / `slr-sniper-release-notes-2025.md` | 逐次发布说明 |
| `slr-steamrt-README.md` | steamrt 总览 |
| `steam-runtime-repo-readme.md` | Valve 仓库说明 |
| `triple-aye-steam-runtime-fun.md` | 实践讨论 |

### 运行证据（第一手）

| 文件 | 价值 |
|---|---|
| **`rimworld-playerlog-hugslib-gist.md`** | **真实 Linux 原生 RimWorld 1.6 Player.log 全文** —— 证实 Unity `2022.3.35f1`、`MonoBleedingEdge` 路径、`-disable-compute-shaders`、`vsync count 1` |

### 系统层

`archwiki-improving-performance.md` · `archwiki-cpu-frequency-scaling.md` ·
`archwiki-nvidia.md` · `archwiki-wayland.md` · `archwiki-kde.md` ·
`archwiki-steam.md` · `archwiki-steam-troubleshooting.md` ·
`nvidia-580.126.18-opengl-env-variables.md`（与用户驱动版本一致） ·
`nvidia-tweaks-environment-variables.md` · `feral-gamemode-readme.md`

### 本项目自产

`rimsort-steam-proton-issues.md` —— RimSort + Steam/Proton 问题调查
（用户崩溃成因：RimSort #2026，Proton 下配置目录在 prefix 内）

### `proton-and-mono/` 子目录

第二路调研（Proton 路线 + Mono 调优）。**关键项**：

| 文件 | 价值 |
|---|---|
| **`_NOTES-steam-launch-config.md`** + `steamcmd-info-294100.json` | **官方启动参数**（SteamCMD 元数据）：Linux `start_RimWorld.sh`、Windows `RimWorldWin64.exe`，**唯一参数 `-disable-compute-shaders`，无任何 GC 参数** |
| `unity-2022.3-incremental-garbage-collection.md` | **Unity 官方明说用 Boehm GC** —— 否定 `MONO_GC_PARAMS` 的关键证据 |
| `proton-valve-readme-main.md` | Proton 官方 README（`PROTON_*` / `STEAM_COMPAT_*` 全表） |
| `mono-manpage-manpage.me.md` | mono(1) 全文（`MONO_GC_PARAMS` 参数表另一来源） |
| `unity-2022.3/6000.0-player-command-line-arguments.md` | 证实**不存在 `-gc-*` / `-force-gc-*` 参数** |
| `github-RimSort_RimSort-2026.md` / `-2102.md` | 根因 issue（open）与其配套 PR |
| `_HANDOFF.md` | 该子目录的交接说明（含两处未完成项） |

**该子目录未收录**：`_raw/`（55 个原始 dump）、`_tools/`（抓取脚本）、
大量 Lemmy 帖与搜索 JSON dump、`github-bbradson_Performance-Fish-38.md`
（超范围：Performance-Fish 是优化 mod）。**这些仍完整保留在工作区。**

---

## 未纳入仓库的内容

**完整 86 份正文在工作区** `research/linux-perf/`（未收录 51 份，约 888 KB），
多为同名主题的其他来源副本。用户会另行打包整个工作区，故不会丢失。

未纳入的主要原因：内容与已收录项重复，或属发行版特异性资料且未在本项目场景中用到。

---

## 本轮明确没拿到的资料（勿臆测内容）

被 Cloudflare 拦截（403）：

- **Ludeon 官方论坛**（含 topic 59118 "Linux and game performance"）
- **RimWorld Wiki**（含 `api.php`、`action=raw`）
- Stack Overflow、KDE Community Wiki

连接超时：`steamcommunity.com`、`reddit.com`、`archive.org`（无法用快照绕 CF）

**后果**：RimWorld 官方与社区侧的 Linux 性能表述**本轮完全没拿到**，
URL 已记入 `_SOURCES.md`。若需这些内容须另设手段。

Fedora KDE 44 的发行版特异性资料同样未拿到（RPM Fusion、KDE Community Wiki 均被反爬）。
