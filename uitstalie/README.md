# uitstalie/ — 本 fork 的自有部分

本目录是 `RimTalk-uitstalie` fork 的**自有内容区**，与上游 RimTalk 代码**完全隔离**。
上游文件（`About/`、`Defs/`、`Source/`、`RimTalk.csproj` 等）保持原样，便于同步上游更新。

> 状态：设计阶段，尚无 C# 代码。分支：`uitstalie-dev`

## ⚠️ 接手本项目请先读

**[`HANDOFF.md`](HANDOFF.md)** —— 接班说明：现在到哪一步、缺什么才能继续、具体怎么验证。
然后是 [`preset/design/`](preset/design/) 下的设计文档。

---

## 目录结构

```
uitstalie/
├── README.md              本文
├── HANDOFF.md             ★ 接班说明（先读这个）
├── preset/
│   ├── DeepSeek Chat_preset.v2.json   预设交付物
│   └── design/            设计文档（见下表）
├── research/
│   └── linux-perf/        Linux 性能/运行环境调研
├── tools/
│   ├── build_preset.ps1   构建 + 双重验证（断言全过才写盘）
│   └── upstream/          原始预设（只读源）
└── Source/                （待建）附加 mod 的 C# 代码
```

---

## 设计文档

| 文件 | 内容 |
|---|---|
| `HANDOFF.md` | **接班说明**：现状、缺口、验证方法、别做的事 |
| `preset/design/addon-in-fork-design.md` | **本目录的架构设计**：隔离方式、项目配置、packageId、部署、**Linux 构建缺口** |
| `preset/design/variables-from-source.md` | **权威变量表**，从 RimTalk v1.3.2 源码直接抽取（非转述官方文档） |
| `preset/design/template-comparison.md` | 我们的模板 vs 社区模板的优缺点对照 |
| `preset/design/source-enhancement-design.md` | 增强候选 6 条 + 兼容性谱系 + **分层路线** |
| `preset/design/rimsort-steam-proton-issues.md` | RimSort + Steam/Proton 问题调查 |
| `preset/design/collected-suggestions.md` | 社区资料汇总（3 个 preset + 教程 + 讨论） |

---

## 两条必须知道的源码级事实

写作预设或增强代码前**务必先读** `variables-from-source.md`，其中两个陷阱会直接导致缺陷：

**1. Scriban 把空字符串当真值。**
`{{ if x }}` 对 `""` 判真，而 `GetMagicPawnValue` 对部分字段做了 `?? ""`。
故单条件写法必然泄漏标签字面量，必须写 `{{ if x != null && x != "" }}`。

**2. 字段遮蔽导致整棵子树不可用。**
`MemberFilter` 屏蔽了 Pawn 上 7 个真实属性
（`skills`/`health`/`equipment`/`genes`/`surroundings`/`social`/`relations`），
对这些名字的深挖访问（如 `pawn.health.State`）**会抛异常**。
其余嵌套属性（`needs`/`story`/`mindState`/`ageTracker`/`guest`/`ideo`/`inventory`）正常可用。

---

## 构建注意（尚未验证）

- 上游 `RimTalk.csproj` 是 **SDK 风格 + 默认 glob**（仅 `Compile Remove="Tests/**"`），
  因此 **`uitstalie/**` 下的 `.cs` 会被自动编入主 mod**。
  解决方案见 `preset/design/addon-in-fork-design.md` §3
- 上游 `.gitignore` 已含 `AGENTS.md` / `CLAUDE.md` / `Docs/*` / `obj/` / `bin/`
- 本项目为 `net48`，依赖 `Krafs.Rimworld.Ref` 与 `Lib.Harmony.Ref`
- **本目录的 `Source/` 尚未建立**；建立时需同步处理 glob 隔离问题

---

## 上游同步

```bash
git fetch upstream
git merge upstream/main        # 或在 GitHub 上同步 fork 后 pull
```

因自有内容全在 `uitstalie/` 内，冲突面应仅限于
`RimTalk.csproj` 中新增的 `Compile Remove` 两行（若采用该方案）。
