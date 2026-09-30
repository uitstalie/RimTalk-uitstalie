# _SOURCES.md - RimWorld Linux 原生（Steam Runtime / sniper）性能调优调研：来源清单

> 调研范围：**不依赖"优化类 mod"的系统层 / 运行时层 / 启动层手段**。
> 最后更新：本轮会话。
> 抓取方式与失败细节见同目录 `_FETCH-LOG.md`；正文全文见本目录各 `.md` 文件。
>
> **本文件只做分类与记录，不做取舍判断，不给"建议用哪个"。**

---

## 0. 本目录的三批内容

| 批次 | 说明 |
|---|---|
| **A. 上一轮已存在** | `README.md`、`rimsort-info.json`、`rimsort-steam-proton-issues.md`、`_get.js`、`proton-and-mono/` 子树（含 `_raw/` 原始 HTML dump 与 `_tools/`）。本文件不重复描述，详见 `README.md` |
| **B. 本轮新增并已落盘的正文** | 见 §1–§5 各表"已落盘"列 |
| **C. 本轮有链接但抓不到正文** | 见 §6，只记 URL + 标题 + 一句话说明 |

---

## 1. Mono / Unity 运行时调优

### 1.1 已抓取正文

| 文件 | 来源 | 内容指向 |
|---|---|---|
| `bdwgc-docs-environment.md` | github.com/bdwgc/bdwgc `docs/environment.md` | **Boehm GC 全部 `GC_*` 环境变量**（`GC_INITIAL_HEAP_SIZE`、`GC_MAXIMUM_HEAP_SIZE`、`GC_ENABLE_INCREMENTAL`、`GC_DISABLE_INCREMENTAL`、`GC_PAUSE_TIME_TARGET`、`GC_FREE_SPACE_DIVISOR`、`GC_FULL_FREQUENCY`、`GC_NPROCS`、`GC_MARKERS`、`GC_PRINT_STATS`、`GC_LOG_FILE`、`GC_DONT_GC`、`GC_USE_ENTIRE_HEAP` 等） |
| `bdwgc-gc.man.md` | 同上 `gc.man` | 同一批变量的 manpage 形态 |
| `bdwgc-docs-scale.md` | 同上 `docs/scale.md` | 堆增长/暂停时间/并行标记的调优维度 |
| `bdwgc-docs-gcdescr.md` | 同上 `docs/gcdescr.md` | 保守式标记清扫 GC 的内部机制（为何"保守"影响暂停） |
| `bdwgc-docs-debugging.md` | 同上 `docs/debugging.md` | GC 调试与统计输出手段 |
| `mono-1-manpage-debian.md` | manpages.debian.org `mono(1)` | **`MONO_ENV_OPTIONS`、`MONO_GC_PARAMS`、`MONO_GC_DEBUG`、`MONO_THREADS_SUSPEND`、`GC_DONT_GC` 等**；注意 `MONO_GC_PARAMS` 明确写的是 **SGen** 收集器的参数 |
| `mono-1-manpage-mankier.md` | mankier.com `mono(1)` | 同上，另一来源 |
| `manpage-me-mono-section1.md` | manpage.me `mono(1)` | 同上（转自上一轮 dump） |
| `mono-sgen-garbage-collector.md` | mono-project.com SGen 文档 | SGen 与 Boehm 的定位差异、SGen 参数含义 |
| `mono-runtime-docs-index.md` | mono-project.com 运行时文档索引 | Mono 运行时文档地图 |
| `stackoverflow-19362898-question.md` | api.stackexchange.com | "Mono GC max-heap-size isn't documented. Is it safe to use in production?"（提问正文） |
| `stackoverflow-19362898-answers.md` | 同上 | 该问答的回答正文 |
| `unity-discussions-mono_gc_params-max-heap-size.md` | discussions.unity.com/t/658229 | 用户报告 `MONO_GC_PARAMS max-heap-size` 在 Unity（编辑器）下**未生效** |
| `unity-discussions-control-memory-usage-while-building.md` | discussions.unity.com/t/909163 | Unity 内存占用控制讨论 |
| `unity-2022.3-player-command-line-arguments.md` | docs.unity3d.com 2022.3 | **Player 命令行参数全表**：`-force-gfx-direct`、`-force-glcore`/`-force-glcoreXY`、`-force-vulkan`、`-screen-fullscreen`、`-screen-width`、`-popupwindow`、`-logFile`、`-nolog`、`-single-instance`、`-disable-gpu-skinning`、GPU 设备选择等 |
| `unity-current-player-command-line-arguments.md` | docs.unity3d.com current | 同表的较新版本（用于版本差异比对） |
| `unity-cn-player-command-line-arguments-1.9.md` | docs.unity.cn 1.9 中文手册 | 早期版本参数表（转自上一轮 dump） |
| `unity-2022.3-performance-garbage-collector.md` | docs.unity3d.com 2022.3 | Unity GC 性能章节 |
| `unity-2022.3-managed-memory.md` | docs.unity3d.com 2022.3 | 托管内存与 GC 行为 |
| `unity-2022.3-incremental-garbage-collection.md` | docs.unity3d.com 2022.3 | 增量 GC（Player Setting，非命令行） |
| `unity-2022.3-scripting-backends-mono.md` | docs.unity3d.com 2022.3 `Mono.html` | Mono 脚本后端说明 |
| `unity-2022.3-linux-troubleshooting.md` | docs.unity3d.com 2022.3 | Unity 官方 Linux 排障 |
| `unity-cn-linux-editor-troubleshooting.md` | docs.unity.cn Linux 排障中文版 | 同上（转自上一轮 dump） |
| `gh-search-mono_gc_params.md` | api.github.com search/issues | 全 GitHub 上提及 `MONO_GC_PARAMS` 的 issue 抽样 30 条（看别人在什么场景下用它） |

### 1.2 已有原文但属"上一轮"的资料

| 文件 | 说明 |
|---|---|
| `proton-and-mono/_raw/ty.com_t_setting-mono_gc_params-max-heap-size-for-debugging-out-of-memory_658229.*` | 上一轮抓的 Unity 讨论帖原始 HTML（513 KB） |
| `proton-and-mono/_raw/discussions.unity.com_t_control-memory-usage-while-building_909163.*` | 同上（512 KB） |
| `proton-and-mono/_raw/manpage.me_index.cgi_q_mono_sektion_1.*` | mono(1) 原始 HTML（148 KB） |
| `proton-and-mono/_raw/manpages.debian.org_bullseye_mono-runtime-common_mono.1.en.html.*` | mono(1) 另一版本原始 HTML（134 KB） |

### 1.3 关键事实记录（不做判断，仅记录出处）

- Unity 2022.3 的 Linux Player 使用 `RimWorldLinux_Data/MonoBleedingEdge/`，见 `rimworld-playerlog-hugslib-gist.md`：
  `Mono path[0] = '[Rimworld_dir]/RimWorldLinux_Data/Managed'`、
  `Mono config path = '[Rimworld_dir]/RimWorldLinux_Data/MonoBleedingEdge/etc'`。
- `MONO_GC_PARAMS` 在 mono(1) 中被描述为 **SGen** 的参数（`mono-1-manpage-debian.md` 第 1265 行起）。
- Boehm GC（bdwgc）自身的 `GC_*` 变量在 `bdwgc-docs-environment.md` 中完整列出；其中有 `GC_IGNORE_ENV` 之外的开关，但**未在本轮资料中找到"Unity 是否读取这些变量"的官方说明**（记为空缺，不作推断）。
- Unity 官方 Player 参数表（2022.3）中**没有** GC 相关参数；GC 只有 Player Setting（增量 GC）。

---

## 2. Steam Runtime / sniper 容器

### 2.1 已抓取正文（主要来自 `gitlab.steamos.cloud/steamrt/steam-runtime-tools`，经 GitLab API v4）

| 文件 | 路径 | 内容指向 |
|---|---|---|
| `slr-steam-linux-runtime.md` | `docs/steam-linux-runtime.md` | 该文档为占位（247 字节），指向别处 |
| `slr-for-game-developers.md` | `docs/slr-for-game-developers.md` | **面向游戏开发者的 SLR 说明**：`PRESSURE_VESSEL_SHELL=instead %command%`、`PRESSURE_VESSEL_TERMINAL=tty`、`PRESSURE_VESSEL_DEVEL=1`、`PRESSURE_VESSEL_FILESYSTEMS_RO/RW`、容器内 shell、启动选项写法 |
| `slr-pressure-vessel.md` | `docs/pressure-vessel.md` | pressure-vessel 总体设计 |
| `slr-pressure-vessel-README.md` | `pressure-vessel/README.md` | 同上（短） |
| `slr-container-runtime.md` | `docs/container-runtime.md` | 容器运行时（`SteamLinuxRuntime_*`）说明 |
| `slr-container-runtime-README.md` | `subprojects/container-runtime/README.md` | 同上 |
| `slr-entry-script.md` | `subprojects/container-runtime/SteamLinuxRuntime_whatever.sh.in` | 入口脚本：`--verb`、`--` 传参、`STEAM_COMPAT_*` 的读取位置 |
| `slr-v2-entry-point.md` | `subprojects/container-runtime/common/_v2-entry-point` | v2 入口点脚本（`--verb=waitforexitandrun` 等） |
| `slr-launch-client.md` | `bin/launch-client.md` | **`steam-runtime-launch-client` 全部环境变量**：`PRESSURE_VESSEL_LOG_INFO`、`PRESSURE_VESSEL_LOG_WITH_TIMESTAMP` 等 |
| `slr-launch-options.md` | `bin/launch-options.md` | 启动选项解析 |
| `slr-run-outside-ldlp.md` | `bin/run-outside-ldlp.md` | 绕过 LD_LIBRARY_PATH 运行宿主程序 |
| `slr-ld-library-path-runtime.md` | `docs/ld-library-path-runtime.md` | 运行时与 `LD_LIBRARY_PATH` 的关系 |
| `slr-check-requirements.md` | `bin/check-requirements.md` | 依赖检查 |
| `slr-system-info.md` | `bin/system-info.md` | **`steam-runtime-system-info` 完整输出字段**（诊断容器/驱动/库来源，含 GRAPHICS 段） |
| `slr-graphics-provider-json.md` | `docs/steam-runtime-graphics-provider.json.5.md` | **图形驱动如何从宿主注入容器**（NVIDIA 专有驱动在此路径上） |
| `slr-emulator-json.md` | `docs/steam-runtime-emulator.json.5.md` | runtime emulator 配置 |
| `slr-steam-compat-tool-interface.md` | `docs/steam-compat-tool-interface.md` | **`STEAM_COMPAT_*` 环境变量接口**（面向兼容工具/Proton 的契约） |
| `slr-shared-paths.md` | `docs/shared-paths.md` | 宿主目录如何共享进容器，`PRESSURE_VESSEL_FILESYSTEMS_*`、`STEAM_COMPAT_MOUNTS` |
| `slr-distro-assumptions.md` | `docs/distro-assumptions.md` | 对宿主发行版的假设（库、locale、驱动） |
| `slr-can-i-use.md` | `docs/can-i-use.md` | 何谓支持的使用方式 |
| `slr-legacy-steam-runtime.md` | `docs/legacy-steam-runtime.md` | 旧 scout 时代运行时 |
| `slr-manifest-v2.md` | `subprojects/container-runtime/docs/manifest-v2.md` | `toolmanifest.vdf` 格式 |
| `slr-runtime-sniper-README.md` | `subprojects/container-runtime/runtimes/sniper/README.md` | **sniper 运行时本身** |
| `slr-runtime-soldier-README.md` | `.../runtimes/soldier/README.md` | soldier 运行时 |
| `slr-runtime-scout-README.md` | `.../runtimes/scout/README.md` | scout 运行时 |
| `slr-steamrt-README.md` | `steamrt/steamrt` README（分支 `steamrt/sniper`） | sniper 分支的元包说明 |
| `slr-sniper-platform-README.md` | `steamrt/sniper/platform` README | **sniper platform 镜像（容器里的运行库集合）** |
| `slr-sniper-sdk-README.md` | `steamrt/sniper/sdk` README | sniper SDK 镜像 |
| `slr-sniper-release-notes.md` | Wiki `Sniper-release-notes` | **sniper 发布说明总索引** |
| `slr-sniper-release-notes-2024.md` | Wiki `Sniper-release-notes/2024` | 2024 年逐次更新记录 |
| `slr-sniper-release-notes-2025.md` | Wiki `Sniper-release-notes/2025` | 2025 年逐次更新记录 |
| `slr-steamrt4-release-notes.md` | Wiki `steamrt4-release-notes` | SteamRT 4 的发布说明（后继运行时） |
| `steamlinuxruntime-reporting-bugs.md` | github.com/ValveSoftware/steam-runtime `doc/reporting-steamlinuxruntime-bugs.md` | 报告 SLR 问题所需的信息采集步骤（含 `steam-runtime-system-info`） |
| `steamlinuxruntime-known-issues.md` | github.com/ValveSoftware/steam-runtime `doc/steamlinuxruntime-known-issues.md` | **SLR 已知问题与 workaround**，含 `PRESSURE_VESSEL_FILESYSTEMS_RO/RW` 用法 |
| `steam-runtime-README.md` | 同上 `README.md` | Steam Runtime 总述 |
| `steam-runtime-repo-readme.md` | 同上仓库首页 | 仓库首页文本 |
| `steam-runtime-possible-designs.md` | 同上 `doc/possible-designs.md` | 设计取舍文档，含 `PRESSURE_VESSEL_WRAP_GUI` 等 |
| `triple-aye-steam-runtime-fun.md` | triple-aye.com | 第三方对 Steam Runtime 行为的实测笔记 |
| `steam-for-linux-issue-13536.md` | github.com/ValveSoftware/steam-for-linux | **原生 Linux 游戏关闭时 Steam 侧内存泄漏** |
| `gh-search-steamruntime-sniper-performance.md` | api.github.com search/issues | `steam-runtime` 仓库中 sniper + performance 的 issue；命中 **#818 pressure-vessel 疑似导致内存泄漏**（已 closed） |

### 2.2 关键事实记录

- `STEAM_COMPAT_*` 出现在 `docs/steam-compat-tool-interface.md` 与入口脚本中，定义为**兼容工具（Proton 类）与 Steam 之间的接口**；SLR 入口脚本会读取部分 `STEAM_COMPAT_*` 变量。
- `PRESSURE_VESSEL_*` 是 pressure-vessel（SLR 的容器管理器）自己的变量族，见 `slr-for-game-developers.md` / `slr-launch-client.md` / `slr-shared-paths.md` / `steam-runtime-possible-designs.md`。
- sniper 与 soldier/scout 的差异写在各自 `runtimes/*/README.md` 中。

---

## 3. Linux 桌面 / 合成器 / 驱动 / 调度

### 3.1 已抓取正文

| 文件 | 来源 | 内容指向 |
|---|---|---|
| `archwiki-nvidia.md` | Arch Wiki NVIDIA | 专有驱动安装、`nvidia-drm.modeset`、Wayland 相关、已知问题 |
| `archwiki-nvidia-tips-and-tricks.md` | Arch Wiki NVIDIA/Tips and tricks | 更多驱动侧开关与调试 |
| `nvidia-580.126.18-opengl-env-variables.md` | NVIDIA 官方驱动 580.126.18 README | **与该机驱动版本完全一致的 OpenGL 环境变量章节**（`__GL_*` 全表） |
| `nvidia-tweaks-environment-variables.md` | deepwiki ventureoo/nvidia-tweaks | 社区整理的 NVIDIA 环境变量 |
| `archwiki-kde.md` | Arch Wiki KDE | KDE 安装/合成器/相关 |
| `archwiki-wayland.md` | Arch Wiki Wayland | Wayland 总体、XWayland |
| `kde-discuss-wayland-vs-x-benchmarks.md` | discuss.kde.org/t/19348 | **KDE 官方论坛的 Wayland vs X11 实测对比帖（20 帖）** |
| `unity-discussions-wayland-support-linux.md` | discussions.unity.com/t/1696530 | **Unity 在 Linux/Wayland 下的支持现状与 NVIDIA+Vulkan 讨论（11 帖）** |
| `archwiki-improving-performance.md` | Arch Wiki Improving performance | CPU governor、调度器、I/O、内核参数总纲 |
| `archwiki-cpu-frequency-scaling.md` | Arch Wiki CPU frequency scaling | governor 选择与持久化 |
| `archwiki-gamemode.md` | Arch Wiki GameMode | GameMode 用法与可调项 |
| `feral-gamemode-readme.md` | github.com/FeralInteractive/gamemode | GameMode 官方 README（含 `gamemoderun %command%`） |
| `archwiki-environment-variables.md` | Arch Wiki Environment variables | 环境变量如何定义与会话级生效 |
| `archwiki-steam.md` | Arch Wiki Steam | Steam 安装、运行时选择、启动选项 |
| `archwiki-steam-troubleshooting.md` | Arch Wiki Steam/Troubleshooting | Steam 排障总表（含库路径、原生 vs runtime） |
| `archwiki-steam-game-specific-troubleshooting.md` | Arch Wiki Steam/Game-specific troubleshooting | **按游戏列的已知问题与启动选项**（108 KB） |

---

## 4. RimWorld 自身的 Linux 表现 / 已知问题

### 4.1 已抓取正文

| 文件 | 来源 | 内容指向 |
|---|---|---|
| `rimworld-playerlog-hugslib-gist.md` | gist.github.com/HugsLibRecordKeeper/6f546cdb… | **一份真实的 Linux 原生 RimWorld Player.log 全文（418 KB）**。含：`Initialize engine version: 2022.3.35f1 (011206c7a712)`、`Mono config path = .../RimWorldLinux_Data/MonoBleedingEdge/etc`、`Command line arguments: -disable-compute-shaders`、`[PhysX] Initialized MultithreadedTaskDispatcher with 16 workers.`、`Default vsync count 1`、`RimWorld 1.6.4871 rev600`、Steam API 从 `~/.local/share/Steam/linux64/steamclient.so` 加载 |
| `rimsort-steam-proton-issues.md` | 上一轮自产（RimSort 官方 issue 汇总） | Linux + Steam 下 mod 管理器路径问题；含原生 Linux 与 Proton 的目录差异对照 |
| `gh-search-steamruntime-sniper-performance.md` | api.github.com | 见 §2.1 |

### 4.2 检索到但**没有命中**的方向（空结果也是记录）

- GitHub issue 搜索 `RimWorld linux performance in:title` → `total_count = 0`。
- GitHub issue 搜索 `RimWorld in:title,body repo:ValveSoftware/steam-runtime` → 1 条，且内容为 `XDG_CONFIG_HOME` 问题，**与性能无关**。
- 本轮抓取到的 Valve 官方 SLR 文档中**未出现 RimWorld 字样**。
- `rimworldwiki.com/wiki/Performance` 存在但被 Cloudflare 拦截（见 §6）。
- Ludeon 官方论坛主题 `topic=59118` 标题即 "Linux and game performance"，但被 Cloudflare 拦截（见 §6）。

---

## 5. 与本项目交付物的关系

- 交付物（preset JSON + 增强 mod）与运行方式无关，详见 `README.md` §"与项目的关系"。
- 本目录资料用于**游戏内验证环境**与**构建环境**的准备，不改变交付物本身。

---

## 6. 有价值但**本轮抓不到正文**的页面

> 这些页面在检索结果中出现且与本调研主题直接相关，但本环境被 Cloudflare / Anubis / 连接超时拦下。
> 记录 URL + 标题 + 一句话说明；**未获取正文，故不对其内容作任何断言**。

### 6.1 RimWorld 本体与社区

| URL | 标题 | 说明 |
|---|---|---|
| https://ludeon.com/forums/index.php?topic=59118.0 | Linux and game performance（Ludeon 官方论坛） | 标题即指向 Linux 与游戏性能；Cloudflare 403 |
| https://ludeon.com/forums/index.php?topic=4805.0 | If the game won't start properly（Ludeon 官方论坛） | 多页的启动问题总帖，含 Linux 启动参数讨论；Cloudflare 403 |
| https://rimworldwiki.com/wiki/Performance | Performance - RimWorld Wiki | Wiki 的性能条目；Cloudflare 403（`api.php`、`action=raw` 同样 403） |
| https://steamcommunity.com/app/294100/discussions/0/4357870314539217795/ | performance is still sh**（Steam 社区） | RimWorld 性能长帖；连接超时 |
| https://steamcommunity.com/app/294100/discussions/0/3440124725200767032/ | Update the game so it utilises more than one core（Steam 社区） | 多核利用相关；连接超时 |
| https://steamcommunity.com/app/294100/discussions/0/521962714990436285/ | Question about increasing performance in Rimworld（Steam 社区） | 性能提升讨论；连接超时 |
| https://steamcommunity.com/app/294100/discussions/0/3279195573101791252 | Steam Deck defaults to Proton（Steam 社区） | 原生 Linux 与 Proton 的取舍讨论；连接超时 |
| https://steamcommunity.com/app/294100/discussions/0/3388420307320653157 | （标题未取到） | 上一轮抓取仅得 157 字节，判定为失败 |
| https://rimworld.2game.info/tag/Linux/ | RimWorld 2game.info - Linux 标签 | 日文 RimWorld 资料站的 Linux 分类页；403 |
| https://rimworld.2game.info/detail.php?id=2986170057 | Mouse Drag Lag Fix (Linux) 1.6 | **记录的是一个 Linux 侧现象**（鼠标拖拽时卡顿）；页面本身是 mod 条目，403 |
| https://rimworld.gallery/m/linux_gaming@lemmy.world/t/20498/How-would-you-optimize-4GB-VRAM | How would you optimize 4GB VRAM（rimworld.gallery / linux_gaming） | 低显存下的取舍讨论。该页本轮**探测时可访问**（HTTP 200 / 166 KB），但内容与 RimWorld Linux 原生调优关系较弱，未落盘 |

### 6.2 Mono / Unity

| URL | 标题 | 说明 |
|---|---|---|
| https://man.m.sourcentral.org/ubuntu2404/1+mono | mono(1) man page (Ubuntu 24.04) | Anubis Proof-of-Work 拦截；已用 Debian manpage 替代 |
| https://stackoverflow.com/questions/15860481/how-can-i-limit-the-memory-size-for-.net-mono-process | How can I limit the memory size for .NET / Mono process | 被 Unity 讨论帖引用；SO 站全站 Cloudflare 403 |
| https://stackoverflow.com/questions/19362898/mono-gc-max-heap-size-isnt-documented-is-it-safe-to-use-in-production | Mono GC max-heap-size isn't documented | 页面 403，已改用 api.stackexchange.com 取得正文 |
| https://docs.unity3d.com/2022.3/Documentation/Manual/UnderstandingAutomaticMemoryManagement.html | （404） | 2022.3 手册无此页 |
| https://docs.unity3d.com/2022.3/Documentation/Manual/dotnet-garbage-collection.html | （404） | 2022.3 手册无此页（该页名属 Unity 6 系列） |
| https://docs.unity3d.com/6000.1/Documentation/Manual/dotnet-garbage-collection.html | Garbage collection（Unity 6.1） | 正文为 JS 渲染，HTML 中不含内容；仅作版本差异参考 |
| https://docs.unity.cn/cn/current/Manual/linux-editor-troubleshooting.html | Linux 编辑器疑难解答（Unity 中文手册） | 已转写落盘（编辑器而非 Player） |

### 6.3 Steam Runtime / sniper

| URL | 标题 | 说明 |
|---|---|---|
| https://steamdb.info/patchnotes/22604250/ | Steam Linux Runtime 3.0 (sniper) update for 1 April 2026 | sniper 更新日志；SteamDB 读取超时 |
| https://steamdb.info/patchnotes/18646220/ | Steam Linux Runtime 3.0 (sniper) update for 30 June 2025 | 同上 |
| https://steamcommunity.com/app/221410/discussions/0/3164316851907641576 | Difference between Steam Runtime and Steam Native | Steam 客户端社区对两种运行方式的说明；连接超时 |
| https://github.com/ValveSoftware/steam-runtime/issues/765 | OpenXR API layer awareness | steam-runtime 仓库 issue；与本主题相关性弱 |
| https://lists.archlinux.org/archives/list/arch-general@lists.archlinux.org/thread/3CAGMNOYEPTZ2I2WIJ6HAIPUZBZ7OV4I/ | Are Steam games kind of sandboxed?（arch-general 邮件列表） | 关于 Steam 容器隔离的讨论 |
| https://fosdem.org/2020/schedule/event/containers_steam/ | Containers and Steam（FOSDEM 2020 演讲） | Valve 工程师讲 Steam Runtime 容器的幻灯片 |
| https://geek-blogs.com/blog/steam-linux-runtime/ | Steam Linux Runtime：打造稳定一致的 Linux 游戏运行环境 | 中文综述文章 |
| https://discuss.cachyos.org/t/may-be-worth-a-heads-on-orphaned-packages-and-updates/21527 | May be worth a heads on Orphaned packages and updates | 发行版包与 Steam Runtime 交互的社区帖 |

### 6.4 Fedora / KDE / 驱动

| URL | 标题 | 说明 |
|---|---|---|
| https://rpmfusion.org/Howto/NVIDIA | RPM Fusion - Howto/NVIDIA | Fedora 下 NVIDIA 驱动安装；Anubis Proof-of-Work 拦截 |
| https://community.kde.org/Plasma/Wayland_Showstoppers | Plasma/Wayland Showstoppers | KDE 官方整理的 Wayland 阻碍项；403 |
| https://docs.pagure.org/fedora-kiwi-descriptions/issue/229/ | FEX RootFS: Slow Steam/Game startup due to missing locales | Fedora 侧 Steam 启动慢的一个成因（locale）；与 RimWorld 无直接关系 |
| https://discuss.cachyos.org/t/proton-memory-leak-runaway/36313 | Proton Memory Leak - Runaway | 与 `steam-for-linux#13536` 同类现象的社区帖 |

---

## 7. 未解决的空缺（明确记录，便于接手）

1. **没有找到 Unity 官方关于「Player 是否读取 `MONO_GC_PARAMS` / `GC_*`」的说明。**
   本轮只拿到：bdwgc 侧变量全表、mono(1) 把 `MONO_GC_PARAMS` 归给 SGen、以及一条用户报告"在 Unity 下设置未生效"。
2. **没有找到 Valve 官方关于「sniper 容器带来多少性能开销」的量化数据。**
   只有设计文档、已知问题列表与一条 pressure-vessel 内存泄漏 issue（#818，已 closed）。
3. **RimWorld 官方（Ludeon）侧的 Linux 性能表述本轮完全没拿到** —— Ludeon 论坛与 RimWorld Wiki 均被 Cloudflare 拦截，Internet Archive 也不可达。
4. **Fedora KDE 44 + NVIDIA 580 的发行版特异性资料没拿到** —— RPM Fusion 与 KDE Community Wiki 均被反爬拦截。
5. 本目录的 `proton-and-mono/` 子树（上一轮）缺 `_SOURCES.md` / `_FETCH-LOG.md`；其 `_raw/` 内的 URL 清单需从文件名反推，见 `README.md` §"待补"。
