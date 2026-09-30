> 来源: https://github.com/RimSort/RimSort/issues/2026
> 抓取方式: GitHub REST API (/repos/RimSort/RimSort/issues/2026)

# Auto-detect Proton compatdata paths on Linux

- 仓库: RimSort/RimSort
- 编号: #2026 (Issue)
- 状态: open  |  创建: 2026-05-30T20:36:40Z  |  更新: 2026-06-06T11:57:19Z  |  关闭: None
- 作者: cebarks
- 标签: feature/improvement 🆕, Linux🐧
- 评论数: 0
- URL: https://github.com/RimSort/RimSort/issues/2026

## 正文

### Origin of idea

Multiple users on Linux running RimWorld via Proton have reported that mods appear to "not work" after saving and launching from RimSort. The root cause is that RimWorld's config directory under Proton lives inside the Proton prefix (e.g., `~/.steam/steam/steamapps/compatdata/294100/pfx/drive_c/users/steamuser/AppData/LocalLow/Ludeon Studios/RimWorld by Ludeon Studios/Config`), not the native Linux path. Users have to manually discover and set this path.

Related reports: #1786, #1866 (closed), #677 (closed)
Part of the broader #64 (dynamic autodetect paths for all platforms).

### Suggestion/proposed solution

When running on Linux with Steam integration enabled, RimSort should:

1. Detect whether the user is running RimWorld via Proton (check for a `compatdata/294100` directory)
2. Auto-populate the config folder path to the Proton prefix location
3. Or at minimum, show a hint/warning when the config path looks like a native Linux path but Proton is detected

### Alternatives considered

- Document the Proton config path in the wiki/setup guide (low effort, helps but users still miss it)
- Add a "Proton mode" toggle in settings that switches path defaults

### Additional context

This is scoped specifically to Proton path auto-detection. The broader path autodetect work is tracked in #64.

### Code of Conduct

I agree to follow this project's Code of Conduct

### Duplicate Issue Check

I've checked for similar issues and didn't find anything

### Wiki/FAQ Check

I've checked the Wiki for a solution and didn't find a solution

## 评论 (0)
