# 本次调研交接摘要（A 方向 Proton / B 方向 Mono+GC）

> 归档目录：`D:\dqc\rimtalk\rimtalk\research\linux-perf\proton-and-mono\`
> 只收集，不做取舍判断。原文全部带 `> 来源:` 头；抓取过程见 `_FETCH-LOG.md`；索引见 `_SOURCES.md`。
> **未推荐任何"性能优化类 mod"。**

## 一、最相关的 3 个来源

1. **`steamcmd-info-294100.json` + `_NOTES-steam-launch-config.md`**（源 <https://api.steamcmd.net/v1/info/294100>）
   直接确认：Linux 启动项是 `start_RimWorld.sh`（原生），Windows 64 启动项是 `RimWorldWin64.exe`；
   两者是**两套可执行文件**。官方**唯一**启动参数是 `-disable-compute-shaders`（三平台一致），
   没有任何 GC 相关参数。同时确认存在 linux depot（294103/108/112/116）。

2. **`mono-manpage-manpage.me.md`**（源 <https://manpage.me/index.cgi?q=mono&sektion=1>，2300 行全文）
   `MONO_GC_PARAMS` 权威参数表：`max-heap-size` / `nursery-size`（默认 4 MB）/ `major`
   （`marksweep` | `marksweep-conc` | `marksweep-conc-par`，**默认是 `marksweep-conc`**）/
   `mode=balanced|throughput|pause[:max-pause]` / `soft-heap-limit` / `evacuation-threshold` /
   `(no-)lazy-sweep` / `(no-)concurrent-sweep` / `stack-mark=precise|conservative` /
   `save-target-ratio`（EXPERIMENTAL）/ `default-allowance-ratio`（EXPERIMENTAL）/ `minor` /
   `alloc-ratio` / `promotion-age` / `(no-)cementing` / `allow-synchronous-major`。
   另有 `MONO_GC_DEBUG` 全表与 `MONO_ENV_OPTIONS`。

3. **`proton-valve-readme-main.md`**（源 <https://github.com/ValveSoftware/Proton>，`proton_10.0` 分支）
   Proton 官方 README 原文：`PROTON_*` / `STEAM_COMPAT_*` 环境变量全表、DXVK / vkd3d-proton / wined3d
   关系、`PROTON_NO_FSYNC` / `PROTON_NO_NTSYNC`（esync 已在 Proton 11.0 废弃）等。

## 二、方向 A：可直接从已抓原文确认的事实

- **存在官方原生 Linux 版**：`store.steampowered.com/api/appdetails` 返回
  `platforms.linux = true`。故 Steam 默认走原生，Proton 必须手动"强制兼容性"。
- **Proton 下实际启动 `RimWorldWin64.exe`** → 读 `RimWorldWin64_Data/`；
  原生读 `RimWorldLinux_Data/`。**两套 Unity 数据目录**（用户历史 Player.log 的
  `RimWorldLinux_Data/Managed/` 与原生启动项一致）。
- **ProtonDB 聚合**（<https://www.protondb.com/api/v1/reports/summaries/294100.json>，原样）：
  `tier=platinum`、`score=0.91`、`total=221`、`confidence=strong`、`trendingTier=platinum`。
  **逐条报告文本抓不到**（纯前端 JS）。
- **RimSort + Linux/Proton 问题**已归档 14 个 issue 原文（正文 + 全部评论），
  其中 **#2026「Auto-detect Proton compatdata paths on Linux」仍为 open**，
  配套 PR #2102「dynamic path autodetection for all platforms」= `github-RimSort_RimSort-2102.md`。
  相关：#677（Allow Linux Users to Run With Proton）、#1442（PopOS 检测不到可执行文件）、
  #1786 / #1866 / #757（装好 mod 但游戏不加载）、#935（文件浏览器打不开）、
  #566（非标准配置路径告警）、#504（用 wine 启动 Windows 版的建议）。
- **社区帖**：`lemmy-insane-performance-increases-proton-em-10-0-37.md`（Proton-EM 性能报告原帖+评论）、
  `lemmy-looking-for-save-folder.md`（含 prefix / emulated windows paths 说明）、
  `lemmy-steam-not-working-properly-crashing.md`（含"切回原生"的建议）。

## 三、方向 B：可直接从已抓原文确认的事实

- `MONO_GC_PARAMS` / `MONO_GC_DEBUG` / `MONO_ENV_OPTIONS` 的完整语义，见上面第 2 条来源。
- **Unity 2022.3 独立播放器命令行参数全表**（`unity-2022.3-player-command-line-arguments.md`）中
  **不存在** `-gc-*` / `-force-gc-*` 一类参数。存在的只有 `-force-glcoreXY`、`-force-vulkan`、
  `-force-wayland`（Linux）、`-force-gfx-direct`、`-nolog` 等图形/日志类开关。
- Unity 官方 2022.3 与 6000.0 两张参数表已同时归档，可用于对照"某参数是否后来新增"。
- Unity Discussions 上确有开发者**为排查 OOM 而设置 `MONO_GC_PARAMS max-heap-size`** 的记录
  （`unity-discussions-mono_gc_params-max-heap-size.md`，完整楼层已抓）；
  另有 SGen nursery size 讨论（`unity-discussions-mono-gc-sgen-nursery-size.md`）。

## 四、未完成 / 未取到（不构成结论，仅记录）

- **未能确认 Unity 2022.3 Linux 播放器内嵌的 Mono 究竟是哪套 GC**（Boehm 还是 SGen）。
  已抓文档中**没有**一条直接说明这一点；`MONO_GC_PARAMS` 是否对该内嵌运行时生效，
  **没有直接证据**。要落实需在 Fedora 上看 `RimWorldLinux_Data/Mono/` 与 `Player.log` 的
  `Mono path` 行、以及链接的 `libmono*` 名称。
- **未能取到任何"Proton 明显快于 / 慢于原生"的定量对比**。Steam 社区、Reddit、ProtonDB 逐条报告
  全部抓取失败（见下）。现有材料只有定性社区发言。
- `sources.debian.org` 的 `sgen-gc.c` 源码返回 Varnish PoW 挑战页，**源码未取到**。

### 网络失败清单（均已重试 2 次）

| 站点 | 表现 |
|---|---|
| `steamcommunity.com`（全部帖子，含 "Running Rimworld with Proton. Where are the saves at?"） | 连接超时 WinError 10060 |
| `www.reddit.com` / `old.reddit.com` | 超时 / 连接重置 10054 |
| `steamdb.info`（app / config / depot 页） | 403 反爬 |
| `forums.linuxmint.com` | 403 |
| `r.jina.ai`（代理方案） | 超时 |
| `sources.debian.org` 源码 raw | 返回 PoW 挑战页 |
| `rimworld.gallery/api/v3/search` | 404（该实例未开放搜索 API） |
| `raw.githubusercontent.com` | 连接重置（本机已知不可达） |

### 成功清单

GitHub issue 原文 14 份 · GitHub 搜索 2 份 · Proton README 2 份 · Proton/GE-Proton 发行说明 2 份 ·
Lemmy 帖 7 份 · Mono manpage 3 份 · Unity 官方文档 8 份 · Unity Discussions 4 份 ·
SteamCMD 元数据 1 份 · SteamDB 替代来源（api.steamcmd.net）1 份。
`_raw/` 下保留全部原始 dump（55 个文件），`_tools/` 下保留可复现抓取脚本。

## 五、给接手的提示

- 上级目录 `research/linux-perf/` 在本轮之前**已存在**另一套更早的调研
  （含 `mono-sgen-garbage-collector.md`、`bdwgc-*`、`archwiki-*`、`slr-*`、`rimsort-steam-proton-issues.md` 等）。
  本目录**未修改其中任何文件**，只新增 `proton-and-mono/` 子目录内容。
- `github-bbradson_Performance-Fish-38.md` 是唯一涉及"优化类 mod"的文件，
  收录理由是该 issue 记录的是"Proton-GE 下游戏加载失败"的现场（A 方向第 5 问旁证）。
  上级目录的 `README.md` 曾把同类文件判为"超范围"，若要贯彻更严口径可直接删除该文件。
