> 来源: https://wiki.archlinux.org/title/Wayland
> 标题: Arch Wiki - Wayland
> 抓取: HTTP 200 | Content-Type: text/html; charset=UTF-8 | 原始字节: 120061

---

- Home

- Packages

- Forums

- Wiki

- GitLab

- Security

- AUR

- Download

Jump to content

ArchWiki

Search

- Create account

- Log in

Personal tools

-

Create account

-

Log in

# Wayland

7 languages

- Deutsch

- Español

- Magyar

- 日本語

- Português

- Русский

- 中文（简体）

From ArchWiki

Related articles

- Graphics processing unit

- KMS

- Xorg

- Screen capture#Wayland

Wayland is a display server protocol. It has been widely established as the successor of the X Window System [1] [2] [3] [4] . You can find a comparison between Wayland and Xorg on Wikipedia .

Display servers using the Wayland protocol are called compositors because they also act as compositing window managers . Below you can find a list of Wayland compositors .

For compatibility with native X11 applications to run them seamlessly, Xwayland can be used, which provides an X Server in Wayland.

## Requirements

This article or section needs expansion.

Reason: GNOME 51 should release around mid-September, this section should be reworked as EGLStreams won't be relevant any more: simply stating that for NVIDIA users if their hardware is not supported they have to pick between Wayland/nouveau or Xorg/nvidia. (Discuss in Talk:Wayland )

Wayland is just the protocol, unlike Xorg it does not have a common "display server" to install. To use it, you only need a compatible display driver (this section) and a compositor (next section) or desktop environment (e.g. GNOME or Plasma ) that implements the Wayland protocol. Most Wayland compositors only work on systems using Kernel mode setting .

For the GPU driver and Wayland compositor to be compatible they must support the same buffer API. There are two main APIs: GBM and EGLStreams .

| Buffer API
| GPU driver support
| Wayland compositor support

| GBM
| All except NVIDIA < 495*
| All

| EGLStreams
| NVIDIA
| GNOME < 51**

* NVIDIA ≥ 495 supports both EGLStreams and GBM. [5]
** GNOME 51 drops support for EGLStreams. [6]
Since NVIDIA introduced GBM support, many compositors (including Mutter and KWin) started using it by default for NVIDIA ≥ 495. GBM is generally considered better with wider support, and EGLStreams only had support because NVIDIA did not provide any alternative way to use their GPUs under Wayland with their proprietary drivers. Furthermore, KWin dropped support for EGLStreams after GBM was introduced into NVIDIA.

If you use a popular desktop environment/compositor and a GPU still supported by NVIDIA, you are most likely already using GBM backend. To check, run journalctl -b 0 --grep "renderer for" . To force GBM as a backend, set the following environment variables :

```
GBM_BACKEND=nvidia-drm
__GLX_VENDOR_LIBRARY_NAME=nvidia

## Compositors

See Window manager#Types for the difference between Stacking , Tiling and Dynamic .

### Stacking

- COSMIC Compositor — Compositor for the COSMIC desktop environment with optional tiling function.

https://github.com/pop-os/cosmic-comp || cosmic-comp

- hikari — wlroots-based compositor inspired by cwm which is actively developed on FreeBSD but also supports Linux.

https://codeberg.org/thomasadam/hikari || hikari AUR

- KDE KWin — See KDE#Starting Plasma .

https://userbase.kde.org/KWin || kwin

- labwc — wlroots-based compositor inspired by Openbox.

https://github.com/labwc/labwc || labwc

- Mutter — See GNOME#Starting .

https://gitlab.gnome.org/GNOME/mutter || mutter

- waybox — a *box-style (minimalist) Wayland compositor modeled largely on Openbox

https://github.com/wizbright/waybox || waybox AUR

- wayfire — 3D compositor inspired by Compiz and based on wlroots.

https://wayfire.org/ || wayfire

- Weston — Wayland compositor designed for correctness, reliability, predictability, and performance.

https://gitlab.freedesktop.org/wayland/weston || weston

- wio — wlroots-based compositor that aims to replicate the look and feel of Plan 9's Rio desktop.

https://gitlab.com/Rubo/wio || wio-wl AUR

- wlmaker — wlroots-based compositor that's inspired by Window Maker .

https://phkaeser.github.io/wlmaker/ || wlmaker AUR

- woodland — a minimal lightweight wlroots-based window-stacking compositor for Wayland, inspired by Wayfire and TinyWl.

https://github.com/DiogenesN/woodland || woodland AUR

### Tiling

- Cagebreak — Based on cage, inspired by ratpoison .

https://github.com/project-repo/cagebreak || cagebreak AUR

- jay — A Wayland compositor, written in Rust. Appearance is based on the default i3 look and feel. Jay can be configured via a declarative TOML file or a shared library that gets injected into the compositor.

https://github.com/mahkoh/jay || jay AUR

- IonWL — Manual tiling compositor. Follows Ion3's design with a comprehensive Python API.

https://codeberg.org/ideasman42/IonWL || ionwl-git AUR

- miracle-wm — A Wayland compositor based on Mir in the style of i3 and sway with the intention to be flashier and more feature-rich than either, like swayfx.

https://github.com/miracle-wm-org/miracle-wm || miracle-wm AUR

- niri — A scrollable-tiling Wayland compositor.

https://github.com/niri-wm/niri || niri

- Qtile — A full-featured, hackable tiling window manager and Wayland compositor written and configured in Python.

https://github.com/qtile/qtile || qtile

- Sway — i3 -compatible Wayland compositor based on wlroots.

https://github.com/swaywm/sway || sway

- SwayFx — Sway , but with eye candy!

https://github.com/WillPower3309/swayfx || swayfx AUR

- Velox — Simple window manager based on swc, inspired by dwm and xmonad .

https://github.com/michaelforney/velox || velox-git AUR

### Dynamic

- cwc — awesome -like Wayland compositor based on wlroots.

https://cudiph.github.io/cwc/apidoc/ || cwc AUR

- dwl — dwm -like Wayland compositor based on wlroots.

https://codeberg.org/dwl/dwl || dwl AUR

- Hyprland — A dynamic tiling Wayland compositor that does not sacrifice on its looks.

https://hypr.land || hyprland

- japokwm — Dynamic Wayland tiling compositor based around creating layouts, based on wlroots.

https://github.com/werererer/japokwm || japokwm-git AUR

- MangoWM — A dwl -based compositor with a standard configuration file, an optional scrolling layout and support for eye candy.

https://github.com/mangowm/mango || mangowm AUR

- pinnacle-comp — A Smithay-based Wayland compositor, inspired by AwesomeWM and configured in Lua or Rust

https://github.com/pinnacle-comp/pinnacle || pinnacle-comp AUR

- river-classic — Dynamic tiling Wayland compositor inspired by dwm and bspwm .

https://codeberg.org/river/river-classic || river-classic

### Other

- Cage — Displays a single fullscreen application like a kiosk.

https://www.hjdskes.nl/projects/cage/ || cage

- GNOME Kiosk — Mutter based compositor that provides an environment suitable for fixed purpose, or single application deployments like wall displays and point-of-sale systems.

https://gitlab.gnome.org/GNOME/gnome-kiosk || gnome-kiosk AUR

- phoc — A tiny wlroots-based compositor for mobile devices.

https://gitlab.gnome.org/World/Phosh/phoc || phoc

- Wayback — X11 compatibility layer which allows for running full X11 desktop environments using Wayland components. It is experimental, in the early stage of development.

https://wayback.freedesktop.org/ || wayback-x11 AUR

- River — A non-monolithic Wayland compositor. Unlike other Wayland compositors, it does not combine the compositor and window manager into one program. Instead, users can choose any window manager implementing the river-window-management-v1 protocol.

https://isaacfreund.com/software/river/ || river
Some of the above may support display managers . Check /usr/share/wayland-sessions/ compositor .desktop to see how they are started.

## Display managers

Display managers listed below support launching Wayland compositors.

| Name

| Runs on

| Description

| atrium AUR

| Wayland

| Display manager with first-class multiseat support.

| emptty

| tty

| Simple CLI Display Manager on TTY.

| GDM

| Wayland

| GNOME display manager.

| greetd

| Wayland/Xorg/tty
See Greetd#Greeters .

| Minimal and flexible login daemon.

| lemurs

| tty

| TUI display manager written in Rust.

| lidm AUR

| tty

| A fully colorful customizable TUI display manager made in C.

| LightDM

|
Xorg [7]

| Cross-desktop display manager.

| ly

| tty

| TUI display manager written in Zig

| Plasma Login Manager

| Wayland

| KDE display manager.

| SDDM

| Wayland/Xorg

| QML-based display manager.

| tbsm AUR

| tty

| Simple CLI session launcher written in pure bash.

| uwsm

| tty

| Session and XDG autostart manager for standalone compositors.
Provides a TUI menu, but can also be used with other display managers.

## Xwayland

Xwayland(1) is an X server that runs under Wayland and provides compatibility for native X11 applications that are yet to provide Wayland support. To use it, install the xorg-xwayland package.

Xwayland is started via a compositor, so you should check the documentation for your chosen compositor for Xwayland compatibility and instructions on how to start Xwayland.

By default, Xwayland runs its X server in rootless mode.

Note

- Security: Xwayland is an X server, so it does not have the security features of Wayland.

- Performance: Xwayland has a nearly identical performance to that of X11, in most cases.

- Compatibility: Xwayland is not fully backward compatible with X11. Some applications may not work properly under Xwayland.

### Wayback

Wayback ( wayback-x11 AUR , wayback-x11-git AUR ), is an X11 compatibility layer which allows for running full X11 desktop environments using Wayland components. It is intended to eventually replace the classic X.Org server, thus reducing maintenance burden of X11 applications.

### NVIDIA driver

Note NVIDIA drivers prior to version 470 (e.g. nvidia-390xx-dkms AUR ) do not support hardware accelerated Xwayland, causing non-Wayland-native applications to suffer from poor performance in Wayland sessions.

Enabling DRM KMS is required. There may be additional information in the official documentation regarding your display manager (e.g. GDM ).

### Detect Xwayland applications

To determine whether an application is running via Xwayland, you can use xeyes from xorg-xeyes : the eyes are moving, when moving the mouse pointer over an application window.

Another option is to run xwininfo (from xorg-xwininfo ) in a terminal window: when hovering over an Xwayland window the mouse pointer will turn into a + sign. If you click the window it will display some information and end, but it will not do anything with native Wayland windows.You can use Ctrl+C to end it.

You can also use xlsclients (from the xorg-xlsclients package). To list all applications running via Xwayland, run xlsclients -l .

Alternatively, you can start extramaus AUR and move your mouse pointer over the window of an application. If the red mouse moves, the application is running via Xwayland.

Tip For KDE Plasma, you can also inspect windows with KDE#KWin debug console .

## GUI libraries

### EFL

Enlightenment has Wayland support . To run an EFL-based application on Wayland, set the environment variable ELM_DISPLAY=wl .

### Electron

Since Electron 38.2, Wayland is used by default. [8] For earlier versions, Wayland support can be activated using the --ozone-platform=auto or --ozone-platform=wayland command line flags, or by setting the environment variable ELECTRON_OZONE_PLATFORM_HINT to auto or wayland .

### FLTK

Wayland is supported since fltk 1.4, and it uses the Wayland backend by default. It is possible to override it to use Xwayland in a Wayland session by modifying an environment variable: FLTK_BACKEND=x11 . [9] .

### GLFW

The glfw package has support for Wayland, and uses the Wayland backend if the environment variable XDG_SESSION_TYPE is set to wayland and the application developer has not set a specific desired backend.

See the source code for more information.

### GTK

The gtk3 and gtk4 packages have the Wayland backend enabled. GTK will default to the Wayland backend, but it is possible to override it to use Xwayland in a Wayland session by modifying an environment variable: GDK_BACKEND=x11 .

For theming issues, see GTK#Wayland backend .

### Java

The open source implementation of the Java platform OpenJDK does not yet have native support for Wayland. The Wakefield project is working on a component named WLToolkit to add Wayland support to OpenJDK.

It is possible to use Wakefield’s jdk25-wayland [10] work-in-progress branch. Some programs such as the JetBrains IDEs do just that so they support Wayland out of the box. For other Java programs, you need you bring your own Wakefield build, e.g. jdk-openjdk-wakefield AUR . To use it, point JAVA_HOME to /usr/lib/jvm/java-25-openjdk-wakefield and run your program with the -Dawt.toolkit.name=WLToolkit option.

### Qt

Qt 6 supports Wayland and uses it by default in a Wayland session.

To enable Wayland support in Qt 5, install the qt5-wayland package, and use -platform wayland command line parameter or QT_QPA_PLATFORM=wayland environment variable . [11] . QT_QPA_PLATFORM="wayland;xcb" allows Qt to use the xcb (X11) plugin instead if Wayland is not available.

To force the usage of Xwayland in a Wayland session, use -platform xcb command line parameter or QT_QPA_PLATFORM=xcb .

### SDL

In SDL3 , Wayland is used by default if the compositor supports the fifo-v1 protocol . [12] Otherwise, X11 and Wayland are tried in order. Either can be forced either using the SDL_VIDEO_DRIVER=x11 or SDL_VIDEO_DRIVER=wayland environment variables respectively (or, with a lower precedence, the SDL2 environment variable below). [13]

sdl2-compat follows the SDL3 rules above, barring application-specific exceptions . As for SDL2 proper (e.g. sdl2 AUR ), set SDL_VIDEODRIVER=wayland .
SDL_VIDEODRIVER="wayland,x11" allows SDL2 to use the x11 video driver instead if Wayland is not available. [14]

You may also want to install libdecor to enable client-side window decorations (for example, on GNOME).

Refer to the official documentation for more details.

### winit

Winit is a window handling library in Rust. It will default to the Wayland backend, but it is possible to override it to use Xwayland by modifying environment variables:

- Prior to version 0.29.2, set WINIT_UNIX_BACKEND=x11

- For version 0.29.2 and higher, unset WAYLAND_DISPLAY , which forces a fallback to X using the DISPLAY variable. [15]

## Tips and tricks

### Automation

- ydotool(1) — Generic command-line automation tool (not limited to Wayland). Enable/start the ydotool.service user unit .

https://github.com/ReimuNotMoe/ydotool || ydotool

- wtype(1) — xdotool type for Wayland.

https://github.com/atx/wtype || wtype

- keyboard — Python library to hook and simulate keyboard events.

https://github.com/boppreh/keyboard || python-keyboard AUR

- mouse — Python library to hook and simulate mouse events.

https://github.com/boppreh/mouse || python-mouse AUR

- wlrctl — A command line utility for miscellaneous wlroots extensions (supports the foreign-toplevel-management, virtual-keyboard, virtual-pointer).

https://git.sr.ht/~brocellous/wlrctl || wlrctl AUR

- CrossMacro — Cross-platform desktop automation app with macro recording, playback, scheduling, text expansion, CLI tools, and Wayland/X11-aware Linux support.

https://github.com/alper-han/CrossMacro || crossmacro AUR

### Remap keyboard or mouse keys

See Input remap utilities .

### Screencast

See Screen capture#Screencasting and Screen capture#Screencast Wayland windows with X11 applications .

### Persist clipboard after app close

This article or section is a candidate for merging with Clipboard .

Notes: This is a standard behavior even on Xorg. There are many other clipboard managers. (Discuss in Talk:Wayland )

Due to Wayland's design philosophy, clipboard data is stored in the memory of the source client. When the client closes, the clipboard data is lost. You can solve this using wl-clip-persist , which runs in the background to reads the clipboard data and stores it in its own memory, separate from the source client.

### Autostart wayland compositor as systemd service

Note Universal Wayland Session Manager automatically generates systemd units for your compositors, moreover it helps you to integrate graphical applications with systemd .

If you do not want to use a display manager or a shell, you can autostart your Wayland compositor with a systemd service. Adjust the ExecStart line with the compositor you want to use. Here is an example for KDE Plasma :

```
/etc/systemd/system/wayland-compositor.service

```
[Unit]
After=graphical.target systemd-user-sessions.service modprobe@drm.service
Conflicts=getty@tty1.service

[Service]
User= username
WorkingDirectory=~

PAMName=login
TTYPath=/dev/tty1
UnsetEnvironment=TERM

StandardOutput=journal
ExecStart=/usr/lib/plasma-dbus-run-session-if-needed /usr/bin/startplasma-wayland

[Install]
WantedBy=graphical.target

### Use another renderer for wlroots based compositor

You can use another wlroots renderer such as Vulkan by specifying the WLR_RENDERER environment variable for wlroots based compositor. The list of available ones is on the wlroots documentation .

### Specifying the primary graphics cards on wlroot based compositor

If your device has Hybrid graphics , then you can use WLR_DRM_DEVICES environment variable to specifies primary graphics cards according to the wlroots documentation

Example:

```
WLR_DRM_DEVICES='/dev/dri/card1:/dev/dri/card2:/dev/dri/card0'

### Remote display

- wlroots0.18 AUR and wlroots0.19 AUR (used by sway ) offers a VNC backend via wayvnc since version 0.10. RDP backend has been removed [16] .

- mutter has now remote desktop enabled at compile time, see [17] and gnome-remote-desktop for details.

- krfb offers a VNC server for kwin . krfb-virtualmonitor can be used to set up another device as an extra monitor.

- There was a merge of FreeRDP into Weston in 2013, enabled via a compile flag. The weston package has it enabled since version 6.0.0.

- waypipe is a transparent proxy for Wayland applications, with a wrapper command to run over SSH

- Here is an example for launching a remote KDE kcalc under Plasma:

```
$ waypipe ssh example.local env QT_QPA_PLATFORM=wayland QT_QPA_PLATFORMTHEME=KDE dbus-launch kcalc

## Troubleshooting

First, make sure that your current session is running under Wayland instead of X11 (many compositors support both).
This can be done by examining the WAYLAND_DISPLAY environment variable (it should begin with wayland- ), and/or checking that XDG_SESSION_TYPE is wayland .

For (possibly) application-related issues, consider also checking whether the application is running under XWayland .

### Useful tools

- wayland-info from wayland-utils : displays information about the current compositor.

- wev : for debugging Wayland events on a Wayland window, analagous to the X11 tool xev .

- wlopm : Wayland output power management for compositors that support the wlr output power management protocol .

- wlr-randr : Manages outputs of Wayland compositors that support the wlr output management protocol .

### Color correction

See Backlight#Color correction .

### GNOME: Slow motion, graphical glitches, and crashes

Gnome-shell users may experience display issues when they switch to Wayland from X. One of the root cause might be the CLUTTER_PAINT=disable-clipped-redraws:disable-culling set by yourself for Xorg-based gnome-shell. Just try to remove it from /etc/environment or other rc files to see if everything goes back to normal.

### Input grabbing in games, remote desktop and virtual machine windows

In contrast to Xorg, Wayland does not allow exclusive input device grabbing, also known as active or explicit grab (e.g. keyboard , mouse ), instead, it depends on the Wayland compositor to pass keyboard shortcuts and confine the pointer device to the application window.

This change in input grabbing breaks current applications' behavior, meaning:

- Hotkey combinations and modifiers will be caught by the compositor and will not be sent to remote desktop and virtual machine windows.

- The mouse pointer will not be restricted to the application's window which might cause a parallax effect where the location of the mouse pointer inside the window of the virtual machine or remote desktop is displaced from the host's mouse pointer.

Wayland solves this by adding protocol extensions for Wayland and Xwayland. Support for these extensions is needed to be added to the Wayland compositors. In the case of native Wayland clients, the used widget toolkits (e.g GTK, Qt) needs to support these extensions or the applications themselves if no widget toolkit is being used. In the case of Xorg applications, no changes in the applications or widget toolkits are needed as the Xwayland support is enough.

These extensions are already included in wayland-protocols , and supported by xorg-xwayland .

The related extensions are:

- Xwayland keyboard grabbing protocol

- Compositor shortcuts inhibit protocol

- Relative pointer protocol

- Pointer constraints protocol

Supporting Wayland compositors:

- Mutter, GNOME 's compositor since release 3.28

- wlroots supports relative-pointer and pointer-constraints

- Kwin

- KDE#X11 shortcuts conflict on Wayland

- Keyboard shortcuts inhibit

Supporting widget toolkits:

- GTK since release 3.22.18.

### GTK themes not working

See https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland .

### Avoid loading NVIDIA modules

Add __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json as environment variable before launching a Wayland compositor like sway .

### Magnifying/surface scaling

Screen magnifying is not solved yet, a pull request was merged mid-2022 providing the protocol wp-surface-scale .

### Wayland lag/stuttering since kernel 6.11.2 (AMD)

Until this issue is patched in future kernel releases, a workaround is to add amdgpu.dcdebugmask=0x400 to the cmdline.

See: https://community.frame.work/t/wayland-lag-stuttering-since-kernel-6-11-2/59422

### Games / applications suspended when changing a virtual desktop

This article or section needs expansion.

Reason: Add more information and reference to upstream documentation here if found: the feature is elusive and seems poorly documented. (Discuss in Talk:Wayland )

When changing workspace or using Alt+Tab , games (and possibly other graphical applications) are suspended, put in some weird state, and they (partially) stop. This includes VRR applications and applications with VSync turned on but is not limited to them only. Symptoms include things like audio dropping (partially) out, game not progressing, ping times rising high or network dropping out, but only if the game window is not in focus. This may only affect applications with VSync on.

It is possible some games can work around this issue by changing to a window, but some do not. This is extremely annoying in more complex games which require heavy usage of web browsing, documentation and 3rd party tools or if the gameplay is interrupted for some reason.

Possible workaround include setting environment variables MESA_VK_WSI_PRESENT_MODE=immediate and/or vk_xwayland_wait_ready=false , but setting these will break any VSync or VRR implementations.

## See also

- Wayland documentation online

- Official repository

- Fedora:How to debug Wayland problems

- We are Wayland now! - An updated version of "Are we Wayland yet?"

- Awesome Wayland projects

- Cursor themes

- Arch Linux forum discussion

- i3 Migration Guide - Common X11 apps used on i3 with Wayland alternatives

- Wayland Explorer - A better way to read Wayland documentation

- How can I tell if an application is using XWayland

Retrieved from " https://wiki.archlinux.org/index.php?title=Wayland&oldid=886332 "

Category :
- Wayland

Hidden categories:
- Pages or sections flagged with Template:Expansion

- Pages or sections flagged with Template:Merge

Search

Wayland

Add topic
