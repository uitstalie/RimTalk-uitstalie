> 来源: https://api.steamcmd.net/v1/info/294100
> 抓取方式: SteamCMD API 原始 JSON 已存为 `steamcmd-info-294100.json`；本文件是其中与"用哪种方式运行"直接相关的字段的**逐字摘录**（不加工、不删改）。

# RimWorld (appid 294100) Steam 元数据摘录

## 1. 平台支持（来自 `store.steampowered.com/api/appdetails`）

```json
{
  "name": "RimWorld",
  "platforms": { "windows": true, "mac": true, "linux": true },
  "type": "game"
}
```

即：**RimWorld 有官方原生 Linux 版**，Steam 默认会启动原生版；
要走 Proton 必须在库属性里显式开启"强制使用 Steam Play 兼容性工具"。

## 2. 安装目录

```json
"contenttype": "3",
"installdir": "RimWorld"
```

## 3. 分平台 depot（`data.294100.depots`）

| depot | oslist | osarch | 说明 |
|---|---|---|---|
| 1149641 | windows | 32 | |
| 1149642 | macos | - | |
| **1149643** | **linux** | - | |
| 1149644 | windows | 64 | |
| 294101 | windows | 32 | |
| 294102 | macos | - | |
| **294103** | **linux** | - | |
| 294104 | windows | 64 | |
| 294105 | windows | 32 | |
| 294106 | windows | 64 | |
| 294107 | macos | - | |
| **294108** | **linux** | - | |
| 294109 | windows | 32 | |
| 294110 | windows | 64 | |
| 294111 | macos | - | |
| **294112** | **linux** | - | |
| 294113 | windows | 32 | |
| 294114 | windows | 64 | |
| 294115 | macos | - | |
| **294116** | **linux** | - | |
| 367683 | windows | 32 | |
| 367684 | windows | 64 | |
| 367685 | macos | - | |
| 367686 | linux | - | |

其他 depot 键：`baselanguages`、`branches`、`hasdepotsindlc`、`overridescddb`、`privatebranches`、`workshopdepot`。

## 4. 各平台启动项（`data.294100.config.launch` 全量）

| key | oslist / osarch | executable | arguments | 说明 |
|---|---|---|---|---|
| 0 | windows / 32 | `RimWorldWin.exe` | `-disable-compute-shaders` | Launch |
| 1 | macos / - | `RimWorldMac.app` | `-disable-compute-shaders` | Launch |
| **2** | **linux / -** | **`start_RimWorld.sh`** | `-disable-compute-shaders` | **Launch（原生 Linux 入口，是个 shell 包装脚本，不是 ELF 本体）** |
| **3** | **windows / 64** | **`RimWorldWin64.exe`** | `-disable-compute-shaders` | **Proton 路线实际启动的就是这个** |
| 10 | windows / 64, betakey=alpha4 | `RimWorldWin.exe` | - | type: none |
| 11 | windows / 64, betakey=phoenix | `RimWorld.exe` | - | Launch - Phoenix |
| 12 | linux / 64, betakey=phoenix | `RimWorld` | - | Launch - Phoenix |
| 13 | macos, betakey=phoenix | `RimWorld.app` | - | Launch - Phoenix |
| 4 | windows / 64, betakey=beta18 | `RimWorldWin.exe` | - | type: none |
| 5 | windows / 64, betakey=alpha17 | `RimWorldWin.exe` | - | type: none |
| 6 | windows / 64, betakey=alpha16 | `RimWorldWin.exe` | - | type: none |
| 7 | windows / 64, betakey=alpha15 | `RimWorldWin.exe` | - | type: none |
| 8 | windows / 64, betakey=alpha14 | `RimWorldWin.exe` | - | type: none |
| 9 | windows / 64, betakey=alpha13 | `RimWorldWin.exe` | - | type: none |

## 5. 由本摘录可直接确认的事实

- 官方为三个平台各出了一套启动项，**Linux 与 Windows 是两套不同的可执行文件**，
  因此 Proton 路线启动的 `RimWorldWin64.exe` 读的是 `RimWorldWin64_Data/`，与原生版的
  `RimWorldLinux_Data/` 是**两套不同的 Unity 数据目录**。
- 官方的默认启动参数只有 `-disable-compute-shaders` 一项（三个平台一致），
  **没有**与 GC 相关的参数。
- 用户日志中出现的 `RimWorldLinux_Data/Managed/` 与这里的 depot 3（原生 Linux 启动项）一致。
