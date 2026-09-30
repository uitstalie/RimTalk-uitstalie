> 来源: https://github.com/RimSort/RimSort/issues/935
> 抓取方式: GitHub REST API (/repos/RimSort/RimSort/issues/935)

# Cannot open anything in file browser on linux

- 仓库: RimSort/RimSort
- 编号: #935 (Issue)
- 状态: closed  |  创建: 2025-06-18T14:21:48Z  |  更新: 2025-07-15T23:40:41Z  |  关闭: 2025-07-15T22:48:00Z
- 作者: jtljac
- 标签: bugs 🪲
- 评论数: 16
- URL: https://github.com/RimSort/RimSort/issues/935

## 正文

### Release Type

Compiled (Ubuntu 24.04)

### Version

1.0.19

### Operating System

Arch (KDE)

### Relevant logs

_No response_

### Describe the bug

When attempting to open any mod, or any directory, in the file browser from rimsort, it fails.

### Additional context

error in console:
```
qt.qpa.plugin: Could not find the Qt platform plugin "wayland" in ""
qt.qpa.plugin: Could not find the Qt platform plugin "xcb" in ""
This application failed to start because no Qt platform plugin could be initialized. Reinstalling the application may fix this problem.

/usr/bin/xdg-open: line 745: 21364 Aborted                 (core dumped) kde-open "$1"
```

It looks like a substitution has failed, given the `$1`.

### Code of Conduct

I agree to follow this project's Code of Conduct

### Duplicate Issue Check

I've checked for similar issues and didn't find anything

### Wiki/FAQ Check

I've checked the Wiki for a solution and didn't find a solution

## 评论 (16)

### @WolfSteele - 2025-06-18T15:46:40Z

Same problem. Just downloaded it on my Steam Deck, wanted to start the program, but nothing happens
Version 1.0.20

Getting this error when run in console:

  File "/home/deck/Downloads/RimSort/pygit2/__init__.py", line 244, in <module pygit2>
  File "/home/deck/Downloads/RimSort/pygit2/settings.py", line 56, in __init__
  File "/home/deck/Downloads/RimSort/pygit2/settings.py", line 62, in _initialize_tls_certificate_locations
  File "/home/deck/Downloads/RimSort/pygit2/settings.py", line 191, in set_ssl_cert_locations
_pygit2.GitError: OpenSSL error: failed to load certificates: error:00000000:lib(0)::reason(0)


Note: I am a complete Noob in Linux Stuff, so if the error is on my side just tell me XD

### @jtljac - 2025-06-18T15:50:08Z

> Can you test Latest v1.0.20 and report back

1.0.20 throws the same error

### @LionelColaso - 2025-06-18T16:47:05Z

solution over here https://github.com/RimSort/RimSort/issues/929

### @WolfSteele - 2025-06-18T17:56:25Z

> solution over here [#929](https://github.com/RimSort/RimSort/issues/929)

This worked. Thank you.

### @jtljac - 2025-06-19T00:20:36Z

@LionelColaso This issue isn't solved by #929, that was an unrelated comment, this issue is about the file browser failing to open

### @LionelColaso - 2025-06-19T00:25:57Z

> ### Operating System
> 
> Arch (KDE)
> 
> ```
> qt.qpa.plugin: Could not find the Qt platform plugin "wayland" in ""
> qt.qpa.plugin: Could not find the Qt platform plugin "xcb" in ""
> This application failed to start because no Qt platform plugin could be initialized. Reinstalling the application may fix this problem.
> 
> /usr/bin/xdg-open: line 745: 21364 Aborted                 (core dumped) kde-open "$1"
> ```
> 
> It looks like a substitution has failed, given the `$1`.

sudo pacman -Syu qt6-base qt6-wayland xcb-util xcb-util-wm xcb-util-image libxcb libxkbcommon


### @jtljac - 2025-06-19T00:32:44Z

They were all already installed. 
Reinstalling anyway hasn't made a difference

### @LionelColaso - 2025-06-19T00:35:32Z

If the plugins are installed but still not found, try manually setting the environment variable before launching the app:

`export QT_QPA_PLATFORM_PLUGIN_PATH=/path/to/qt/plugins/platforms`

You can find this path by searching:

`find /usr -type d -name platforms 2>/dev/null`



### @LionelColaso - 2025-06-19T00:36:22Z

forcing xcb or wayland can help:

`export QT_QPA_PLATFORM=xcb`
# or
`export QT_QPA_PLATFORM=wayland`

Then launch the application again in the same terminal.


### @doublevoid - 2025-07-11T22:33:57Z

Doesn't work on my end either, the error when `QT_QPA_PLATFORM` is set to `wayland` is _very_ weird though.
```
qt.qpa.wayland: No shell integration named "xdg-shell" found
qt.qpa.wayland: No shell integration named "wl-shell" found
qt.qpa.wayland: No shell integration named "ivi-shell" found
qt.qpa.wayland: No shell integration named "qt-shell" found
qt.qpa.wayland: Loading shell integration failed.
qt.qpa.wayland: Attempted to load the following shells QList("xdg-shell", "wl-shell", "ivi-shell", "qt-shell")
qt.qpa.plugin: Could not load the Qt platform plugin "wayland" in "/usr/lib/qt6/plugins/platforms" even though it was found.
This application failed to start because no Qt platform plugin could be initialized. Reinstalling the application may fix this problem.

Available platform plugins are: offscreen, xcb, minimal, wayland, minimalegl, wayland-egl, eglfs, vnc, linuxfb, vkkhrdisplay.

/usr/bin/xdg-open: line 745: 21856 Aborted                 (core dumped) kde-open "$1"
```
When `QT_QPA_PLATFORM` is set to `xcb` it doesn't open a directory either, it logs:
```
Could not read file file:///home/user/.steam/steam/steamapps/workshop/content/294100/MOD_ID.
```
This is on `1.0.24`

### @LionelColaso - 2025-07-12T02:06:56Z

> Doesn't work on my end either, the error when `QT_QPA_PLATFORM` is set to `wayland` is _very_ weird though.
> 
> ```
> qt.qpa.wayland: No shell integration named "xdg-shell" found
> qt.qpa.wayland: No shell integration named "wl-shell" found
> qt.qpa.wayland: No shell integration named "ivi-shell" found
> qt.qpa.wayland: No shell integration named "qt-shell" found
> qt.qpa.wayland: Loading shell integration failed.
> qt.qpa.wayland: Attempted to load the following shells QList("xdg-shell", "wl-shell", "ivi-shell", "qt-shell")
> qt.qpa.plugin: Could not load the Qt platform plugin "wayland" in "/usr/lib/qt6/plugins/platforms" even though it was found.
> This application failed to start because no Qt platform plugin could be initialized. Reinstalling the application may fix this problem.
> 
> Available platform plugins are: offscreen, xcb, minimal, wayland, minimalegl, wayland-egl, eglfs, vnc, linuxfb, vkkhrdisplay.
> 
> /usr/bin/xdg-open: line 745: 21856 Aborted                 (core dumped) kde-open "$1"
> ```
> 
> When `QT_QPA_PLATFORM` is set to `xcb` it doesn't open a directory either, it logs:
> 
> ```
> Could not read file file:///home/user/.steam/steam/steamapps/workshop/content/294100/MOD_ID.
> ```
> 
> This is on `1.0.24`

Which OS

### @doublevoid - 2025-07-12T16:54:36Z

@LionelColaso arch

edit:
As mentioned before by other users, running through the python interpreter makes every related issue go away, maybe the issue is related to the linking step at the building stage?

### @Damglador - 2025-07-15T12:27:56Z

I found something weird. When I launch RimSort from my application launcher it coredumps kde-open, but when I launch it from my terminal, it works and opens folders it should open.

Also this issues extends to opening any URI, it can't even open mod page in Steam or browser

### @Damglador - 2025-07-15T12:34:28Z

Oh hey, I know what causes it, partially. The .desktop file provided with the Arch package sets the working directory to /opt/rimsort and when it's /opt/rimsort, xdg-open doesn't work. If I cd into /opt/rimsort and launch rimsort it also will break. Removing working directory from desktop file fixes it.

This is an issue with both rimsort-bin and rimsort-git

### @jtljac - 2025-07-15T22:48:00Z

> Oh hey, I know what causes it, partially. The .desktop file provided with the Arch package sets the working directory to /opt/rimsort and when it's /opt/rimsort, xdg-open doesn't work. If I cd into /opt/rimsort and launch rimsort it also will break. Removing working directory from desktop file fixes it.
> 
> This is an issue with both rimsort-bin and rimsort-git

This has solved it.
I maintain the rimsort-bin package, I've added this fix with the v1.0.26 version update. I've also commented on the git version to prompt them to implement the same fix.

### @Damglador - 2025-07-15T23:40:41Z

Awesome
