> 来源: https://github.com/RimSort/RimSort/issues/2102
> 抓取方式: GitHub REST API (/repos/RimSort/RimSort/issues/2102)

# feat: dynamic path autodetection for all platforms (#64 & #2026)

- 仓库: RimSort/RimSort
- 编号: #2102 (PR)
- 状态: closed  |  创建: 2026-06-06T11:39:40Z  |  更新: 2026-06-10T01:09:46Z  |  关闭: 2026-06-10T01:09:44Z
- 作者: cebarks
- 标签: bugs 🪲, help needed 🆘, macOS 🍏, Linux🐧, accessibility 👀 ℹ️🤓
- 评论数: 1
- URL: https://github.com/RimSort/RimSort/pull/2102

## 正文

## Summary

- **Fixes the double-path bug** in Linux autodetection where the fallback produced `~/.steam/steam/steamapps/common/RimWorld/steamapps/common/RimWorld`
- **Adds dynamic Steam root discovery** via `_find_steam_root()` that checks candidate paths for `steamapps/` or `config/libraryfolders.vdf` — supports Debian, native (`~/.steam/steam`, `~/.local/share/Steam`), Flatpak, and Snap Steam installations
- **Uses VDF parsing on Linux and macOS** (via existing `find_steam_rimworld()`) to find RimWorld in non-default Steam library folders, matching the approach Windows already uses
- **Detects Proton config prefix** on Linux — checks `compatdata/294100/pfx/...` before the native `~/.config/unity3d/...` path
- **Warns on Snap Steam** — advisory, non-blocking dialog recommending native or Flatpak installation
- **Hardens VDF parsing** — `find_steam_rimworld()` now catches malformed `libraryfolders.vdf` instead of crashing
- **Fixes Windows CI test failures** — VDF test content now properly escapes backslashes (matching real Steam VDF format), preventing the `vdf` library's `_unescape()` from corrupting paths containing `\r` or `\t` sequences

Closes #64 and #2026

## Changes

| File | What changed |
|------|-------------|
| `app/controllers/settings_controller.py` | New `_find_steam_root()` static method; `__get_debian_paths()` → `__get_linux_paths()` with 5 candidate paths + VDF + Proton; `__get_darwin_paths()` enhanced with VDF; Snap warning in caller |
| `app/utils/generic.py` | `find_steam_rimworld()` wrapped in try/except for malformed VDF |
| `tests/controllers/test_path_autodetection.py` | 27 new tests covering all platforms, VDF edge cases, Proton, Snap detection; VDF content uses proper backslash escaping for cross-platform correctness |

## Test plan

- [x] 27 new tests added (785 total, all passing)
- [x] All quality gates pass (ruff, ruff-format, mypy, pyright, jscpd, shfmt, markdownlint)
- [x] Windows CI — VDF backslash escaping fixed
- [ ] Manual testing on Linux with native Steam
- [ ] Manual testing on Linux with Flatpak Steam
- [x] Manual testing on macOS

🤖 Generated with [Claude Code](https://claude.com/claude-code)

## 评论 (1)

### @cebarks - 2026-06-07T12:28:27Z

need help with linux testing as I'm on macos only at the moment
