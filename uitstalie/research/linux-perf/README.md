# linux-perf 资料说明

> 本目录是 **RimWorld 在 Linux 上的性能/运行环境调研**归档。
> 目标：不依赖"优化类 mod"（那些主要面向 Windows 测试），只收集系统层、运行时层、启动层手段。

---

## 目录内容

| 文件 | 内容 |
|---|---|
| `archwiki-improving-performance.md` | Arch Wiki 性能总纲（CPU governor、调度器等） |
| `archwiki-cpu-frequency-scaling.md` | CPU 频率调节 |
| `archwiki-nvidia.md` | NVIDIA 专有驱动相关 |
| `archwiki-kde.md` | KDE 相关 |
| `archwiki-wayland.md` | Wayland 相关 |
| `archwiki-steam.md` | Steam 客户端 |
| `archwiki-steam-troubleshooting.md` | Steam 排障 |
| `nvidia-580.126.18-opengl-env-variables.md` | 与用户驱动版本一致的 OpenGL 环境变量 |
| `nvidia-tweaks-environment-variables.md` | NVIDIA 调优环境变量 |
| `feral-gamemode-readme.md` | Feral GameMode（`gamemoderun`） |
| `mono-1-manpage-debian.md` / `mono-1-manpage-mankier.md` | Mono 运行时 manpage |
| `mono-sgen-garbage-collector.md` | **SGen GC 文档** —— Mono GC 调优核心依据 |
| `mono-runtime-docs-index.md` | Mono 运行时文档索引 |
| `unity-2022.3-managed-memory.md` | Unity 托管内存 |
| `unity-2022.3-performance-garbage-collector.md` | **Unity GC 性能** |
| `unity-2022.3-player-command-line-arguments.md` | Unity 播放器命令行参数 |
| `unity-current-player-command-line-arguments.md` / `unity-command-line-arguments.md` | 同上，其他来源 |
| `steam-runtime-repo-readme.md` | Valve Steam Runtime 仓库说明 |
| `triple-aye-steam-runtime-fun.md` | Steam Runtime 相关讨论 |
| `kde-discuss-wayland-vs-x-benchmarks.md` | Wayland vs X11 基准（仅 368 字节，内容少） |
| **`rimsort-steam-proton-issues.md`** | **RimSort + Steam/Proton 问题调查**（本项目自产，含用户崩溃成因定位） |
| `proton-and-mono/` | Proton 与 Mono 调优的第二路调研（**进行中**） |

---

## 未提交的内容与原因

为控制仓库体积，以下**未纳入仓库**（仅在原始工作区存在）：

| 内容 | 体积 | 排除原因 |
|---|---|---|
| `proton-and-mono/_raw/` 下的网页 dump | ~2.2 MB | 抓取原始 HTML/JSON，非提炼产物；需要时可按 `_SOURCES` 重新抓取 |
| `-upcoming-game-WARDOGS-…` 网页 dump | 79 KB | **与 RimWorld 无关**，抓取跑偏 |
| `github-bbradson_Performance-Fish-38.md` | 4.3 KB | **超范围**：Performance-Fish 是"优化类 mod"，已明确指示不调研此类 |
| `github.com_MrXploisLite_RimModManager…` | 415 KB | 是 **RimModManager**（另一款 mod 管理器），非 RimSort |

> 若后续需要这些原始件，可在开发机上从原工作区取；切勿误以为它们不存在。

---

## 待补

第二路调研（Proton 与 Mono，`proton-and-mono/`）在本目录提交时**尚未完成**，
其结构化总结（`_SOURCES.md` / `_FETCH-LOG.md`）缺失。接手者若需要，可：
1. 在开发机上查看原工作区 `research/linux-perf/proton-and-mono/`
2. 或按 `_raw/` 中的 URL 记录重新抓取

---

## 与项目的关系

本项目交付物（预设 JSON + 增强 mod）**不受运行方式切换影响**：

- 预设是纯 JSON，原生 Linux 与 Proton 通用
- 增强 mod 是 `net48` IL 程序集，Mono 与 Proton 均可加载

故本目录的调研主要用于**游戏内验证环境**与**构建环境**的准备，
而非改变交付物本身。相关约束见 `../../preset/design/addon-in-fork-design.md` §9。
