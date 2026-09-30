# uitstalie/ - 已迁出（指针）

> **2026-09-30 起，本目录的内容已迁至工作区 `common/rimtalk/`（独立 git 仓库）。**
> 本目录现在只剩这一个说明文件。

原内容（预设交付物、设计文档、Linux 调研、构建脚本）以及对应的历史提交，
仍然留在本仓库的 git 历史里（`git log -- uitstalie/` 可查），但**不要再在这里新增或修改内容**。

## 新位置

| 原路径（本仓库） | 新路径（工作区 `common/rimtalk/`） |
|---|---|
| `uitstalie/HANDOFF.md` | `HANDOFF.md` |
| `uitstalie/preset/DeepSeek Chat_preset.v2.json` | `output/DeepSeek Chat_preset.v2.json` |
| `uitstalie/preset/design/*.md` | `research/*.md` |
| `uitstalie/research/linux-perf/` | `research/linux-perf/` |
| `uitstalie/tools/build_preset.ps1` | `tools/build_preset.ps1` |
| `uitstalie/tools/upstream/` | `tools/upstream/` |
| `uitstalie/.gitattributes` | `rimtalk/.gitattributes`（已修正 pattern 基准） |

## 为什么迁出

这些内容与 mod 源码混在同一个仓库里：同步上游时冲突面变大，而它们与 `Source/`
没有编译关系（`.cs` 有无、怎么编译都不受影响）。迁出后本仓库收敛为
「上游 RimTalk + 计划中的附加 mod 源码」，内容侧由 `common/` 单独管控。

## 本仓库仍然负责什么

- 上游 RimTalk 的同步（`git fetch upstream && git merge upstream/main`）
- 分支 `uitstalie-dev` 与 fork `uitstalie/RimTalk-uitstalie`
- **计划中的附加 mod 源码** —— 位置需重新确认（原计划放 `uitstalie/Source/`）；
  技术论证见迁出后的 `common/rimtalk/research/addon-in-fork-design.md`，其开头有位置变更说明
