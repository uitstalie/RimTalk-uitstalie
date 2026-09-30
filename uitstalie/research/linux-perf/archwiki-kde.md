> 来源: https://wiki.archlinux.org/title/KDE
> 标题: Arch Wiki - KDE
> 抓取: HTTP 200 | Content-Type: text/html; charset=UTF-8 | 原始字节: 237602

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

# KDE

10 languages

- Deutsch

- Español

- Magyar

- Italiano

- 日本語

- Português

- Русский

- Türkçe

- Українська

- 中文（简体）

From ArchWiki

Related articles

- Desktop environment

- Display manager

- Window manager

- Qt

- SDDM

- Dolphin

- KDE Wallet

- KDevelop

- Trinity

- SonicDE

- Uniform look for Qt and GTK applications

- Official repositories#kde-unstable

KDE is a software project currently comprising a desktop environment ( KDE Plasma ), applications ( KDE Applications ), and Qt add-on libraries ( KDE Frameworks ).

## Installation

### Plasma

Install the plasma-meta meta-package or the plasma group. For differences between plasma-meta and plasma reference package group . Alternatively, for a more minimal Plasma installation, install the plasma-desktop package. Upstream KDE has package and setup recommendations to get a fully-featured Plasma session.

If you are an NVIDIA user, ensure the DRM kernel mode setting is enabled.

### Plasma Mobile

Install plasma-mobile and plasma-settings .

### Plasma Bigscreen

Install plasma-bigscreen .

### KDE applications

To install the full set of KDE applications, install the kde-applications-meta meta-package or the kde-applications group. If you only want KDE applications for a certain category, like gaming or education, install the relevant dependency of kde-applications-meta . Note that installing applications alone will not install any version of Plasma.

### Unstable releases

See Official repositories#kde-unstable for beta releases.

## Starting Plasma

Starting from Plasma 6.4, the Wayland session has matured enough to become the default and preferred one : the X11 session is only available separately with the plasma-x11-session package [1] . The Xorg session is still supported, but will be removed in Plasma 6.8 . See Wayland Known Significant Issues and X11 Known Significant Issues for more information.

Plasma can be started either using a display manager , or from the console.

### Using a display manager

Tip The preferred display manager is Plasma Login Manager .

- Select Plasma (Wayland) to launch a new session in Wayland .

- Select Plasma (X11) to launch a new session in Xorg .

- Select Plasma Mobile (Wayland) to launch a new Plasma Mobile session in Wayland .

- Select Plasma Bigscreen to launch a new Plasma Bigscreen session in Wayland .

### From the console

- To start a Plasma on Wayland session from a console, run /usr/lib/plasma-dbus-run-session-if-needed /usr/bin/startplasma-wayland [2] .

- To start Plasma with xinit/startx , append export DESKTOP_SESSION=plasma and exec startplasma-x11 to your .xinitrc file or run directly in the console startx /usr/bin/startplasma-x11 . If you want to start Xorg at login, please see Start X at login .

## Configuration

Most settings for KDE applications are stored in ~/.config/ . However, configuring KDE is primarily done through the System Settings application. It can be started from a terminal by executing systemsettings .

### Plasma desktop

#### Display configuration

For configuring multiple displays, use the KDE System settings display module or the kscreen tool.

Tip You can toggle display mirroring or extended mode using the Super+p shortcut. This opens the display mode menu even when the Display Settings UI does not show these options, useful if KDE gets stuck in mirror mode.

#### Themes

There are different types of KDE themes, varying by the scope of what they modify:

- Global themes , comprehensive packages that can include Plasma themes, application styles, colors, fonts, icons, cursors, splash screens, SDDM themes, and Konsole color schemes. Global themes can be applied with the lookandfeeltool command line tool.

- Plasma themes , modifying the look of Plasma panels and widgets. These often have a recommended accompanying Kvantum or Aurorae theme to complete the look.

- Application styles , modifying the look of programs.

- Application styles that use theme engines such as Kvantum , QtCurve [3] , QSvgStyle [4] , and Aurorae .

- Icon themes , providing icons for applications, files, and actions.

For easy system-wide installation and updating, some themes are available in both the official repositories and the AUR .

Global themes can also be installed through System Settings > Colors & Themes > Global Theme > Get New... .

Warning Global themes are commonly provided by end users and not monitored. You should use extreme caution when downloading and applying global themes. They can run arbitrary code, and loss of user data has occurred .

Tip

- For Qt5 applications, plasma5-integration and a compatible theme such as breeze5 (default Plasma theme) need to be installed in order for Qt5 applications such as VLC to be themed on Plasma.

- Install plasma-sdk to be able to easily edit Plasma Themes, explore Icons, and test Plasma widgets; check out also kde-development-environment-meta .

##### GTK application appearance

Tip For Qt and GTK theme consistency, see Uniform look for Qt and GTK applications .

The recommended theme for a pleasant appearance in GTK applications is breeze-gtk , a GTK theme designed to mimic the appearance of Plasma's Breeze theme. To configure it:

- Install the kde-gtk-config package (also part of the plasma group).

- Re-login into the user account or reboot.

- Go to System Settings > Colors & Themes > Application Style > Configure GNOME/GTK Application Style... .

- Select Breeze as the GTK theme.

Note Plasma automatically overwrites manual changes made to GTK configuration files (such as ~/.gtkrc-2.0 or ~/.config/gtk-3.0/settings.ini ) on every startup. There are multiple ways to avoid it:

- Uninstall the kde-gtk-config package when you are done configuring it.

- Make the files read-only (e.g., chmod -w ~/.config/gtk-3.0/settings.ini ).

- (Not recommended) Disable the GNOME/GTK Settings synchronization service . Despite the Background services KCM being hidden from the settings UI since Plasma 6.1.0 [5] , you can still access it via kcmshell6 kcm_kded .

#### Faces

This article or section is out of date.

Reason: Plasma Login Manager is now the preferred display manager. (Discuss in Talk:KDE )

Plasma and SDDM will both use images found at /var/lib/AccountsService/icons/ as users' avatars. To configure with a graphical interface, you can use System Settings > Users . The file corresponding to your username can be removed to restore the default avatar.

#### Widgets

Plasmoids are widgets for the Plasma desktop shell designed to enhance the functionality of the desktop; they can be found on the AUR .

Plasmoid scripts can also be installed by right-clicking onto a panel or the desktop and choosing Enter Edit Mode > Add Widgets... > Get New Widgets... > Download New Plasma Widgets . This will present a front-end for https://store.kde.org/ that allows you to install, uninstall, or update third-party Plasmoid scripts with just one click.

#### Sound applet in the system tray

Install plasma-pa or kmix (start Kmix from the Application Launcher). plasma-pa is now installed by default with plasma , no further configuration needed.

Note To adjust the step size of volume increments/decrements , add e.g. VolumePercentageStep=1 in the [Global] section of ~/.config/kmixrc .

#### Disable panel shadow

This article or section is out of date.

Reason: The Plasma Wayland session is now used by default. This section only works on X11. (Discuss in Talk:KDE )

As the Plasma panel is on top of other windows, its shadow is drawn over them. [6] To disable this behaviour without impacting other shadows, install xorg-xprop and run:

```
$ xprop -remove _KDE_NET_WM_SHADOW

Then select the panel with the plus-sized cursor. [7] For automation, install xorg-xwininfo and create the following script:

```
/usr/local/bin/kde-no-shadow

```
#!/bin/bash
for WID in $(xwininfo -root -tree | sed '/"plasmashell": ("plasmashell" "plasmashell")/!d; s/^ *\([^ ]*\) .*/\1/g'); do
xprop -id $WID -remove _KDE_NET_WM_SHADOW
done

Make the script executable .

The factual accuracy of this article or section is disputed.

Reason: Autostarting does not work because the script starts too early (something like sleep 5 may help but is unreliable). (Discuss in Talk:KDE )

The script can be run on login with Add Login Script in Autostart :

```
$ kcmshell6 autostart

#### Display scaling / High DPI displays

See HiDPI#KDE Plasma .

### Plasma Mobile

The plasma-phone-settings repository contains several recommended settings that can be applied globally ( /etc/xdg ) and/or per user ( ~/.config ).

#### Lock screen

/etc/xdg/kscreenlockerrc (or ~/.config/kscreenlockerrc ) locks the screen immediately after login. [8] This is useful in combination with SDDM#Autologin .

```
/etc/xdg/kscreenlockerrc

```
[Daemon]
LockOnStart=true

### Virtual keyboard

To use a virtual keyboard in the Wayland session, install plasma-keyboard and enable it in System Settings > Keyboard > Virtual Keyboard .

If your device has a hardware keyboard, but you want to use the virtual keyboard, add the KWIN_IM_SHOW_ALWAYS=1 environment variable to your Wayland session.

To use a virtual keyboard in the X11 session, choose an appropriate one from List of applications/Utilities#On-screen keyboards and run it manually.

### Window decorations

Window decorations can be found in the AUR .

They can be changed in System Settings > Colors & Themes > Window Decorations . There you can also directly download and install more themes with one click.

#### Icon themes

Icon themes can be installed and changed on System Settings > Colors & Themes > Icons .

Note Although all modern Linux desktops share the same icon theme format, desktops like GNOME use fewer icons (esp. in menus and toolbars). Themes developed for such desktops usually lack icons required by Plasma and KDE applications. It is recommended to install Plasma-compatible icon themes instead.

Tip Since some icon themes do not inherit from the default icon theme, some icons may be missing.
To inherit from the Breeze, add breeze to the Inherits= array in /usr/share/icon/ theme-name /index.theme , for example: Inherits=breeze,hicolor . You need to reapply this patch after every update to the icon theme; consider using Pacman hooks to automate the process.

### Space efficiency

The Plasma Netbook shell has been dropped from Plasma 5; see the following KDE forum post . However, you can achieve something similar by editing the file ~/.config/kwinrc adding BorderlessMaximizedWindows=true in the [Windows] section.

### Thumbnail generation

To allow thumbnail generation for media or document files on the desktop and in Dolphin, install kdegraphics-thumbnailers and ffmpegthumbs .

Then enable the thumbnail categories for the desktop via right click on the desktop background > Configure Desktop and Wallpaper... > Icons > Configure Preview Plugins... .

In Dolphin , navigate to Configure > Configure Dolphin... > Interface > Previews .

### Night Light

Plasma provides a Redshift -like feature (working on both Xorg and Wayland ) called Night Light. It makes the colors on the screen warmer to reduce eye strain at the time of your choosing. It can be enabled in System Settings > Colors & Themes > Night Light .

### Printing

Tip Use the CUPS web interface for faster configuration. Printers configured in this way can be used in KDE applications.

You can also configure printers in System Settings > Printers . To use this method, you must first install the following packages: print-manager , cups , system-config-printer . See CUPS#Configuration .

### Samba/Windows support

This article or section is a candidate for moving to Dolphin .

Notes: This seems to be specific to dolphin and not about KDE in general. (Discuss in Talk:KDE )

The Dolphin share functionality requires the package kdenetwork-filesharing and usershares, which the stock smb.conf does not have enabled. Instructions to add them are in Samba#Enable Usershares , after which sharing in Dolphin should work out of the box after restarting Samba.

Accessing Windows shares from Dolphin works out of the box. Use the path smb:// servername / share to browse the files.

Tip Use * (asterisk) for both username and password when accessing a Windows share without authentication in Dolphin's prompt.

Unlike GTK file browsers, which utilize GVfs also for the launched program, opening files from Samba shares in Dolphin via KIO makes Plasma copy the whole file to the local system first with most programs (VLC is an exception).
To workaround this, you can use a GTK-based file browser like thunar with gvfs and gvfs-smb (and gnome-keyring for saving login credentials) to access SMB shares in a more able way.

Another possibility is to mount a Samba share via cifs-utils to make it look to Plasma like if the SMB share was just a normal local folder and thus can be accessed normally.
See Samba#Manual mounting and Samba#Automatic mounting .

A GUI solution is available with samba-mounter-git AUR , which offers basically the same functionality via an easy to use option located at System Settings > Network Drivers . However, it might break with new KDE Plasma versions.

### KDE Desktop activities

KDE Desktop Activities are special workspaces where you can select specific settings for each activity that apply only when you are using said activity.

### Power management

Install powerdevil for an integrated Plasma power managing service. This service offers additional power saving features, monitor brightness control (if supported) and battery reporting, including peripheral devices.

Tip Integration with power profiles requires the power-profiles-daemon optional dependency.

The factual accuracy of this article or section is disputed.

Reason: Regarding the note below, it might be that the problem is the logind setting LidSwitchIgnoreInhibited which defaults to yes . [9] (Discuss in Talk:KDE )

Note Power Devil may not inhibit all logind settings (such as the lid close action for laptops). In these cases, the logind setting itself will need to be changed - see Power management#ACPI events .

### Autostart

Plasma can autostart applications and run scripts on startup and shutdown. To autostart an application, navigate to System Settings > Autostart and add the program or shell script of your choice. For applications, a .desktop file will be created; for login scripts, a .desktop file launching the script will be created.

Note

- Programs can be autostarted on login only, whilst shell scripts can also be run on shutdown or even before Plasma itself starts.

- Shell scripts will only be run if they are marked executable .

- Shell scripts previously placed in ~/.config/autostart-scripts/ will get automatically migrated to .desktop files .

- Place desktop entries (i.e. .desktop files) in the appropriate XDG Autostart directory.

- Place or symlink shell scripts in one of the following directories:

- ~/.config/plasma-workspace/env/ : for executing scripts at login before launching Plasma.

- ~/.config/plasma-workspace/shutdown/ : for executing scripts when Plasma exits.

See official documentation .

### Phonon

From Wikipedia :

Phonon is the multimedia API provided by KDE and is the standard abstraction for handling multimedia streams within KDE software and also used by several Qt applications.
Phonon was originally created to allow KDE and Qt software to be independent of any single multimedia framework such as GStreamer or xine and to provide a stable API for a major version's lifetime.
Phonon is being widely used within KDE for both audio (e.g., the system notifications or KDE audio applications) and video (e.g., the Dolphin video thumbnails). It can use the following backends:

- VLC : phonon-qt6-vlc

- GStreamer : phonon-qt6-gstreamer-git AUR , see GStreamer#Installation for additional codec support

- mpv : phonon-qt6-mpv AUR

KDE recommends only the VLC backend , as the GStreamer backend is unmaintained .

Note

- Multiple backends can be installed at once and prioritized via the phononsettings application.

- According to the KDE forums , the VLC backend lacks support for ReplayGain .

- If using the VLC backend, you may experience crashes every time Plasma wants to send you an audible warning and in quite a number of other cases as well [10] . A possible fix is to rebuild the VLC plugins cache:

```
# /usr/lib/vlc/vlc-cache-gen /usr/lib/vlc/plugins

### Backup and restore

Plasma stores personalized desktop settings as configuration files in the XDG_CONFIG_HOME folder. Use the detail of configuration files to select and choose a method of backup and restore .

### systemd startup

Plasma uses a systemd user instance to launch and manage all the Plasma services. This is the default startup method since Plasma 5.25, but can be disabled to use boot scripts instead with the following command (however this may stop working in a future release):

```
$ kwriteconfig6 --file startkderc --group General --key systemdBoot false

More details about the implementation can be read in Edmundson's blog: Plasma and the systemd startup .

### Spell checking

KDE applications use sonnet for spell checking. See its optional dependencies for the supported spell checkers .

Configure it in System Settings > Spell Check .

### Running KWin Wayland on NVIDIA

See https://community.kde.org/Plasma/Wayland/Nvidia .

## Applications

The KDE project provides a suite of applications that integrate with the Plasma desktop. See the kde-applications group for a full listing of the available applications. Also see Category:KDE for related KDE application pages.

Aside from the programs provided in KDE Applications, there are many other applications available that can complement the Plasma desktop. Some of these are discussed below.

### System administration

#### Terminate Xorg server through KDE System Settings

Navigate to the submenu System Settings > Keyboard > Advanced (tab) > Key sequence to kill the X server and ensure that the checkbox is ticked.

#### KCM

KCM stands for KC onfig M odule. KCMs can help you configure your system by providing interfaces in System Settings, or through the command line with kcmshell6 . Some applications bundle their configuration modules, while others need to be installed separately:

- sddm-kcm — KDE Configuration Module for SDDM .

https://invent.kde.org/plasma/sddm-kcm || sddm-kcm

- kde-gtk-config — GTK2 and GTK3 Configurator for KDE.

https://invent.kde.org/plasma/kde-gtk-config || kde-gtk-config

- wacom tablet — KDE GUI for the Wacom Linux Drivers.

https://www.linux-apps.com/p/1127862/ || wacomtablet
More KCMs can be found at linux-apps.com .

### Desktop search

KDE implements desktop search with software called Baloo , a file indexing and searching solution.

### Web browsers

The following web browsers can integrate with Plasma:

- Konqueror — Part of the KDE project, supports two rendering engines – KHTML and the Chromium -based Qt WebEngine.

https://konqueror.org/ || konqueror

- Falkon — A Qt web browser with Plasma integration features, previously known as Qupzilla. It uses Qt WebEngine.

https://userbase.kde.org/Falkon/ || falkon

- Chromium — Chromium and Chrome can be configured to better integrate with Plasma; see Chromium#KDE integration .

https://www.chromium.org/ || chromium

- Firefox — Firefox can be configured to better integrate with Plasma; see Firefox#KDE integration .

https://mozilla.org/firefox || firefox
Tip Starting from Plasma 5.13, there is an official browser extension for Firefox , Chromium , Edge and Vivaldi to integrate with Plasma. It provides media playback control from the Plasma tray, download notifications, and the find open tabs feature in KRunner. Install plasma-browser-integration and the corresponding browser extension. See details on Plasma wiki .

Note Regardless of installation status, Plasma Browser Integration uses a background service called “Plasma Browser Integration Flatpak Integration” to create data for flatpak browsers in ~/.var/app that repopulates even after removal through flatpak and directory commands. This service can be disabled through “Background Services” in KRunner. See details on the KDE thread.

### PIM

KDE offers its own stack for personal information management (PIM). This includes emails, contacts, calendars, etc. To install all the PIM packages, you could use the kde-pim package group or the kde-pim-meta meta package.

#### Akonadi

Akonadi is a system meant to act as a local cache for PIM data, regardless of its origin, which can be then used by other applications. This includes the user's emails, contacts, calendars, events, journals, alarms, notes, and so on. Akonadi does not store any data by itself: the storage format depends on the nature of the data (for example, contacts may be stored in vCard format).

Install akonadi . For additional addons, install kdepim-addons .

##### SQLite

By default Akonadi will use SQLite and store the database in ~/.local/share/akonadi/akonadi.db . To configure Akonadi to use SQLite explicitly, edit the Akonadi configuration file to match the configuration below:

```
~/.config/akonadi/akonadiserverrc

```
[%General]
Driver=QSQLITE

Note When Akonadi starts, it will create the [QSQLITE] section and set the appropriate variables in it.

##### PostgreSQL

Akonadi supports either using the existing system-wide PostgreSQL instance, i.e. postgresql.service , or running a PostgreSQL instance with user privileges and the database in ~/.local/share/akonadi/db_data/ .

###### Per-user PostgreSQL instance

Install postgresql and postgresql-old-upgrade .

Edit the Akonadi configuration file so that it has the following contents:

```
~/.config/akonadi/akonadiserverrc

```
[%General]
Driver=QPSQL

Note

- When Akonadi starts, it will create the [QPSQL] section and set the appropriate variables in it.

- The database will be stored in ~/.local/share/akonadi/db_data/ .

Start Akonadi with akonadictl start , and check its status: akonadictl status .

Note

- Starting with akonadi 19.08.0-1, the PostgreSQL database cluster in ~/.local/share/akonadi/db_data/ will get automatically upgraded when a major PostgreSQL version upgrade is detected.

- For previous akonadi versions, major PostgreSQL version upgrades will require a manual database upgrade. Follow the update instructions on KDE UserBase Wiki . Make sure to adjust the paths to PostgreSQL binaries to those used by postgresql and postgresql-old-upgrade , see PostgreSQL#Upgrading PostgreSQL .

###### System-wide PostgreSQL instance

This requires an already configured and running PostgreSQL .

Create a PostgreSQL user account for your user:

```
[postgres]$ createuser username

Create a database for Akonadi:

```
[postgres]$ createdb -O username -E UTF8 --locale=C -T template0 akonadi- username

Edit the Akonadi configuration file to match the configuration below:

```
~/.config/akonadi/akonadiserverrc

```
[%General]
Driver=QPSQL

[QPSQL]
Host=/run/postgresql
Name=akonadi- username
StartServer=false

Note Custom port, username and password can be specified with options Port= , User= , Password= in the [QPSQL] section.

Start Akonadi with akonadictl start , and check its status: akonadictl status .

##### MySQL

For Akonadi to run a managed MariaDB instance (see MySQL for alternative providers) with the database stored in ~/.local/share/akonadi/db_data/ , edit the Akonadi configuration file to match the configuration below:

```
~/.config/akonadi/akonadiserverrc

```
[%General]
Driver=QMYSQL

Note If Akonadi cannot find /usr/bin/mysqld upon first start, it will fall back to using SQLite.

###### System-wide MySQL instance

Akonadi supports using the system-wide MySQL for its database. [11]

This article or section needs expansion.

Reason: Add instructions. (Discuss in Talk:KDE )

```
~/.config/akonadi/akonadiserverrc

```
[%General]
Driver=QMYSQL

[QMYSQL]
Host=
Name=akonadi_ username
Options="UNIX_SOCKET=/run/mysqld/mysqld.sock"
StartServer=false

##### Disabling Akonadi

Users who want to disable Akonadi would need to not start any KDE applications that rely on it. See this section in the KDE userbase for more information.

### KDE Connect

KDE Connect provides several features to connect your Android or iOS phone with your Linux desktop:

- Share files and URLs to/from KDE from/to any app, without wires.

- Touchpad emulation: Use your phone screen as your computer's touchpad.

- Notifications sync (4.3+): Read your Android notifications from the desktop.

- Shared clipboard: copy and paste between your phone and your computer.

- Multimedia remote control: Use your phone as a remote for Linux media players.

- Wi-Fi connection: no USB or Bluetooth needed.

- RSA Encryption: Your information is safe.

You will need to install KDE Connect both on your computer and on your phone. For PC, install the kdeconnect package. For Android, install KDE Connect from Google Play or from F-Droid . If you want to browse your phone's filesystem, you need to install sshfs as well and configure filesystem exposes in your Android app. For iOS, install KDE Connect from the App Store . Not all features from the Android version are available on the iOS version.

To use remote input functionality on a Plasma Wayland session, the xdg-desktop-portal package is required.

It is possible to use KDE Connect even if you do not use the Plasma desktop. For GNOME users, better integration can be achieved by installing gnome-shell-extension-gsconnect AUR instead of kdeconnect . To start the KDE Connect daemon manually, execute /usr/bin/kdeconnectd .

If you use a firewall , you need to open UDP and TCP ports 1714 through 1764 .

Sometimes, KDE Connect will not detect a phone. You can restart the services by running killall kdeconnectd and then opening kdeconnect in system settings or running kdeconnect-cli --refresh followed by kdeconnect-cli -l . You can also use Pair new device > Add devices by IP on KDE Connect for Android.

## Tips and tricks

### Use a different window manager

It is possible to use a window manager other than KWin with Plasma. This allows you to combine the functionality of the KDE desktop with the utility of a tiling window manager , which may be more fleshed out than KWin tiling scripts.

The component chooser settings in Plasma no longer allows changing the window manager , but you are still able to swap KWin via other methods.

Note When replacing Kwin with a window manager that does not provide a compositor (such as Openbox), any desktop compositing effects, e.g., transparency, will be lost. In this case, install and run a separate Composite manager to provide the effects, such as Xcompmgr or picom .

#### Replacing KWin service

Since KDE 5.25, Plasma's systemd-based startup is enabled by default.

To replace KWin in this startup, you must first mask the plasma-kwin_x11.service for the current user to prevent it from starting.

Then, create a new systemd user unit to start your preferred WM [12] :

```
~/.config/systemd/user/plasma-custom-wm.service

```
[Install]
WantedBy=plasma-workspace.target

[Unit]
Description=Plasma Custom Window Manager
Before=plasma-workspace.target

[Service]
ExecStart= /path/to/other/wm
Slice=session.slice
Restart=on-failure

To use it, do (as user units ) a daemon-reload , make sure you have masked plasma-kwin_x11.service then enable the newly created plasma-custom-wm.service .

Note When using the i3 window manager with Plasma, it may be necessary to manually set dialogs to open in floating mode in order for them to correctly appear. For more information, see i3#Correct handling of floating dialogs .

#### Using script-based boot and KDEWM

Plasma's script-based boot is used by disabling #systemd startup . If you have done so, you can change the window manager by setting the KDEWM environment variable before Plasma is invoked.

##### System-wide

This article or section is a candidate for merging with Environment variables#Globally .

Notes: This technique should be moved into a new section there (2.1.3: Using Xsession), and then this section merged with the previous one. (Discuss in Talk:KDE )

If you have root access, you can also add an XSession that will be available to all users as an option on the login screen.

First, create a script with execution permissions as follows:

```
/usr/local/bin/plasma-i3.sh

```
#!/bin/sh
export KDEWM=/usr/bin/i3
/usr/bin/startplasma-x11

Replace /usr/bin/i3 with the path to your preferred WM. Ensure the path is correctly set. If KDE is unable to start the window manager, the session will fail and the user will be returned to the login screen.

Then, to add an XSession, add a file in /usr/share/xsessions/ with the following content:

```
/usr/share/xsessions/plasma-i3.desktop

```
[Desktop Entry]
Type=XSession
Exec=/usr/local/bin/plasma-i3.sh
DesktopNames=KDE
Name=Plasma (i3)
Comment=KDE Plasma with i3 as the WM

### KWin tiling window scripts

A list of KWin extensions that can be used to make KDE behave more like a tiling window manager .

- Kröhnkite — A dynamic tiling extension inspired by dwm.

https://codeberg.org/anametologin/Krohnkite || kwin-scripts-krohnkite AUR

- KZones — A script that mimics the behavior of Microsoft PowerToys and Windows 11 snap layouts.

https://github.com/gerritdevriese/kzones || kwin-scripts-kzones AUR

- PlasmaZones — Zone-based window tiling for KDE Plasma built on the Phosphor library suite

https://github.com/fuddlesworth/PlasmaZones || plasmazones-bin AUR

- Polonium — Auto-tile manager inspired by Bismuth

https://github.com/zeroxoneafour/polonium || kwin-polonium AUR

### KWin debug console

KWin has a built-in debug console for inspecting runtime properties such as surfaces, input events, and clipboard contents. It can be started from KRunner ( Open KWin debug console ) or from your terminal by running:

```
$ qdbus6 org.kde.KWin /KWin org.kde.KWin.showDebugConsole

### Configuring monitor resolution / multiple monitors

To enable display resolution management and multiple monitors in Plasma, install kscreen . This provides additional options to System Settings > Display & Monitor .

### Configuring ICC profiles

On X11, ICC profiles are handled by colord . To configure them in Plasma, install colord-kde . This provides additional options in System Settings > Color Management . ICC profiles can be imported using Import Profile .

For Wayland sessions, color management is handled by the compositor, i.e. KWin for Plasma. In this case, no additional package is required. The color profile can be configured per monitor in System Settings > Display & Monitor > Color Profile .

### HDR

HDR support only works in a Wayland session. System Settings > Display & Monitor > High Dynamic Range > Enable HDR .

For more information on displaying HDR content, see HDR monitor support . Development details about HDR in Plasma can be found on Xaver Hugl's blog posts .

When enabling HDR mode in KDE Plasma, SDR content can appear extremely dark, sometimes making the screen nearly unreadable . To address this, KDE provides two key sliders in display settings: Maximum SDR Brightness , which adjusts the brightness mapping for SDR content in HDR mode, and Brightness which controls the overall display backlight or luminance .

### Disable opening application launcher with Super key (Windows key)

To disable this feature, you currently have to edit the kwinrc config file and set the Meta key under ModifierOnlyShortcuts to an empty string:

```
$XDG_CONFIG_HOME/kwinrc

```
[ModifierOnlyShortcuts]
Meta=

Alternatively, you can also run the following command:

```
$ kwriteconfig6 --file kwinrc --group ModifierOnlyShortcuts --key Meta ""

### Disable bookmarks showing in application menu

With the Plasma Browser integration installed, KDE will show bookmarks in the application launcher.

To disable this feature, go to System Settings > Search > Plasma Search and uncheck Bookmarks .

### IBus Integration

IBus is an input method framework and can be integrated into KDE. See IBus#Integration for details.

Using IBus may be required when using KDE on Wayland to offer accented characters and dead keys support [13] .

### Enable hotspot in plasma-nm

See NetworkManager#Sharing internet connection over Wi-Fi .

### Restore previous saved session

If you have System Settings > Session > Desktop Session > Session Restore > On login, launch apps that were open: On last logout (default) selected, ksmserver (KDE's session manager) will automatically save/load all open applications to/from ~/.config/ksmserverrc on logout/login.

Note Currently, native Wayland windows cannot be restored. See Wayland Showstoppers for the current state of development.

### Receive local mail in KMail

If you have set up local mail delivery with a mail server that uses the Maildir format, you may want to receive this mail in KMail. To do so, you can reuse KMail's default receiving account, "Local Folders" that stores mail in ~/.local/share/local-mail/ .

Symlink the ~/Maildir directory (where Maildir format mail is commonly delivered) to the Local Folders' inbox:

```
$ ln -s .local/share/local-mail/inbox ~/Maildir

Alternatively, add a new receiving account with the type Maildir and set ~/Maildir as its directory.

### Configure Plasma for all users

Edit config/main.xml files in the /usr/share/plasma . For example, to configure the Application Launcher for all users, edit /usr/share/plasma/plasmoids/org.kde.plasma.kickoff/contents/config/main.xml . To prevent the files from being overwritten with package updates, add the files to Pacman's NoUpgrade

### Disable sleep completely

See Power management/Suspend and hibernate#Disable sleep completely .

### Using window rules

Kwin has the ability to specify rules for specific windows/applications. For example, you can force enable the window titlebar even if the application developer decided that there should not be one. You can set such rules as specific starting positions, sizes, minimizing states, keeping above/below others and so on.

To create a rule, you can press Alt+F3 when the window of interest is in focus. Then, in More Actions > Configure special application/window settings , you can set the desired property. A list of created rules is available from System Settings > Window Management > Window Rules .

### Mount network shares in fixed location

By default KDE mount manager ( kio-fuse ) will mount network shares to ${XDG_RUNTIME_DIR}/kio-fuse- 6-char-random-string .

Create a directory, e.g. mnt_kio in your home directory:

```
$ mkdir ~/mnt_kio

Override default kio-fuse.service using a drop-in file :

```
~/.config/systemd/user/kio-fuse.service.d/mountpoint.conf

```
[Service]
ExecStart=
ExecStart=/usr/lib/kio-fuse -f %h/mnt_kio

Now if you mount your network shares via dbus or by opening some file from a remote share in Dolphin:

```
$ dbus-send --session --print-reply --type=method_call \
--dest=org.kde.KIOFuse \
/org/kde/KIOFuse \
org.kde.KIOFuse.VFS.mountUrl "smb://etcetc"

They will be mounted to ~/mnt_kio .

### Locally Integrated Menu

To have the menu bar integrated with the title bar, install material-kwin-decoration-git AUR from the AUR, then in System Settings > Window Decorations, select 'Material' and add the Application Menu button to the title bar (preferably as second from the left).

### Pre-authorize remote control on Wayland

Xdg-desktop-portal-kde has support for remote input from a remote desktop session, a virtual KVM switch, kde-connect, emulated devices like a controller using Steam Input, etc. This authorization is lost after the application or the desktop portal is restarted, which causes the "Remote control requested" window to pop up every time and makes unattended access impossible.

As of plasma version 6.3, a permission system was implemented , which allows to pre-authorize applications. Currently, the permission API is only available through the flatpak CLI, although applications do not need to run as a flatpak to be able to get pre-authorized.

As per the upstream docs and flatpak-permission-set man pages, you need to figure out if the application you want to authorize sets an application ID or not. If started through a runner like KRunner , it gets set by plasma and is usually the filename of the .desktop -file under /usr/share/applications .

For example, to pre-authorize a virtual KVM switch like lan-mouse , you would do:

```
$ flatpak permission-set kde-authorized remote-desktop de.feschbar.LanMouse yes

If you start it as a daemon in a systemd user-unit , you should use the name of that unit instead:

```
$ flatpak permission-set kde-authorized remote-desktop lan-mouse yes

If you application does not set an ID, you can leave that field empty:

```
$ flatpak permission-set kde-authorized remote-desktop "" yes

### Ambient Light Sensor

Starting with Plasma 6.6.0 , the screen brightness can be controlled automatically by an Ambient Light Sensor if your device is equipped with one.

To enable this feature, iio-sensor-proxy needs to be installed, which is an optional dependency of qt6-sensors and hence not installed by default. This enables the iio-sensor-proxy.service and after restarting the Plasma session, the option "Automatically adapt to environment" will show up in Plasma Display Configuration.

Internally, this feature uses a brightness curve, which is adapted automatically according to brightness settings by the user.

The current implementation of automatic brightness does not support X11 but not due to technical limitations [14] . For X11 support, check out illuminanced .

## Troubleshooting

### KDE applications fail to start in GNOME after upgrade to KDE 6

Wayland is used by default for KDE 6 applications, and the KDE applications fail to work under GNOME Wayland (and potentially other DEs/WMs) in this scenario. This can be fixed by setting the QT_QPA_PLATFORM=xcb environment variable .

This is a workaround for KDE bugs and not a problem with Wayland itself.

### KDE icons missing after upgrade to KDE 6

After the last upgrade to KDE 6, you may notice issues with all of the KDE icons not displaying. Newly created accounts showed them just fine.

The issue for this is that the theme got lost while upgrading and had to be reassigned manually. For this, go to System Settings > Colors & Themes > Icons and select the theme you would like to use for the icons again.

### qt5ct and kvantum bugs after upgrade

This article or section is out of date.

Reason: This was added 2021-02-15: the "latest update" is one year old. Is this fixed? (Discuss in Talk:KDE )

The latest update might cause incompatibility. HiDPI scaling that made some interfaces too big for your screen, some icons missing or not able to be displayed, and missing panels or widgets.

Try to remove qt5ct and kvantum related packages, then apply the default global Plasma theme. If the problem persists, try clearing all your KDE configuration and reinstalling plasma to overwrite the configuration. Be sure to check HiDPI scaling in KDE system settings as well.

### Fonts are huge or seem disproportionate

Try to force font DPI to 96 in System Settings > Text & Fonts > Fonts .

If that does not work, try setting the DPI directly in your Xorg configuration as documented in Xorg#Setting DPI manually .

### Configuration related

Many problems in KDE are related to its configuration.

#### Plasma desktop behaves strangely

Plasma problems are usually caused by unstable Plasma widgets (colloquially called plasmoids ) or Plasma themes . First, find which was the last widget or theme you had installed and disable or uninstall it.

So, if your desktop suddenly exhibits "locking up", this is likely caused by a faulty installed widget. If you cannot remember which widget you installed before the problem began (sometimes it can be an irregular problem), try to track it down by removing each widget until the problem ceases. Then you can uninstall the widget and file a bug report on the KDE bug tracker only if it is an official widget . If it is not, it is recommended to find the entry on the KDE Store and inform the developer of that widget about the problem (detailing steps to reproduce, etc.).

If you cannot find the problem, but you do not want all the settings to be lost, navigate to ~/.config/ and run the following command:

```
$ for j in plasma*; do mv -- "$j" "${j%}.bak"; done

This command will rename all Plasma-related configuration files to *.bak (e.g. plasmarc.bak ) of your user and when you log in again to Plasma, you will have the default settings back. To undo that action, remove the .bak file extension. If you already have *.bak files, rename, move, or delete them first. It is highly recommended that you create regular backups anyway. See Synchronization and backup programs for a list of possible solutions.

#### Clean cache to resolve upgrade problems

The problem may be caused by an old cache. Sometimes, after an upgrade, the old cache might introduce strange, hard-to-debug behaviour such as unkillable shells, hangs when changing various settings, Ark being unable to extract archives, or Amarok not recognizing any of your music. This solution can also resolve problems with KDE and Qt applications looking bad after an update.

Rebuild the cache using the following commands:

```
$ rm ~/.config/Trolltech.conf
$ kbuildsycoca6 --noincremental

Optionally, empty the ~/.cache/ folder contents; however, this will also clear the cache of other applications:

```
$ rm -rf ~/.cache/*

Sometimes, empty the ~/.cache/ folder does not work; for example, if you encountered the following error:

```
kf.service.sycoca: The menu spec file ( "" ) contains a Layout or DefaultLayout tag without the mandatory Merge tag inside. Please fix it.

It might be something related to outdated configuration files. In the above case, moving ~/.config/menus/ folder away may fix the issue. In other cases, trying to move each file out of ~/.config/menus/ folder could be a good way to check what triggers the error.

#### Plasma desktop does not respect locale/language settings

Plasma desktop may use different settings than you set at KDE System Settings panel, or in locale.conf (per Locale#Variables ). The first thing to do is log out and log in after removing ~/.config/plasma-localerc , if this does not fix the issue, try to edit the file manually. For example, to set LANG variable to es_ES.UTF-8 and the LC_MESSAGES variable to en_US.UTF-8 :

```
~/.config/plasma-localerc

```
[Formats]
LANG=es_ES.UTF-8

[Translations]
LANGUAGE=en_US

#### Cannot change theme, icons, fonts, or colors in system settings; most icons are not displayed

Make sure that QT_QPA_PLATFORMTHEME environment variable is unset; the command printenv QT_QPA_PLATFORMTHEME should show empty output. Otherwise, if you had an environment set (most likely qt5ct or qt6ct) the variable will force qt5ct/qt6ct settings upon Qt applications; the command export QT_QPA_PLATFORMTHEME= should unset the environment.

An easier (and more reliable) solution can be to uninstall completely qt5ct and qt6ct.

#### Volume control, notifications, or multimedia keys do not work

Hiding certain items in the System Tray settings (e.g. Audio Volume, Media Player or Notifications) also disables related features. Hiding the Audio Volume disables volume control keys, Media Player disables multimedia keys (rewind, stop, pause) and hiding Notifications disables showing notifications.

#### Login Screen KCM does not sync cursor settings to SDDM

The Login Screen KCM reads your cursor settings from ~/.config/kcminputrc , without this file, no settings are synced. The easiest way to generate this file is to change your cursor theme in System Settings > Colors & Themes > Cursors , then change it back to your preferred cursor theme.

#### Missing panels/widgets

A crash or hardware change can modify the screen numbers, even on a single monitor setup. The panels/widgets can be missing after such an event; this can be fixed in the ~/.config/plasma-org.kde.plasma.desktop-appletsrc file by changing the lastScreen values.

### Graphical problems

Make sure you have the proper driver for your GPU installed. See Graphics processing unit#Installation to identify your hardware and choose the driver for it. If you have an older card, it might help to #Disable desktop effects manually or automatically for defined applications or #Disable compositing .

#### Forcing dGPU usage on hybrid graphics systems

Hybrid graphics is a power management strategy commonly used in laptops that keeps the dedicated graphics processor (dGPU) inactive when not needed, defaulting to the integrated graphics processor (iGPU) for basic desktop rendering to conserve battery life.

While this approach saves power, it can result in suboptimal desktop performance, including low frame rates in animations and potential graphical artifacts, even on systems with capable dGPUs.

Forcing KDE Plasma to utilize the discrete GPU can significantly improve desktop responsiveness and visual quality.

##### Method 1: DRI_PRIME (Open-source drivers)

For systems using open-source graphics drivers (Intel + AMDGPU, Intel + Nouveau), you can globally set the DRI_PRIME environment variable to specify the dGPU:

```
DRI_PRIME=1

The index value (0 or 1) depends on your system configuration. Verify which index corresponds to your dGPU by running:

```
DRI_PRIME=1 glxinfo

Note This method does not work with NVIDIA proprietary drivers. For NVIDIA systems, use PRIME render offload or the KWin method below.

##### Method 2: KWIN_DRM_DEVICES (KWin-specific)

For direct control over KWin's GPU selection, create a startup script that sets the DRM device priority:

```
~/.config/plasma-workspace/env/gpu.sh

```
#!/bin/bash
export KWIN_DRM_DEVICES=/dev/dri/card1:/dev/dri/card0

To identify your DRM cards and their corresponding GPUs:

```
for i in /sys/class/drm/card*/device; do
echo "Card: $(basename $(dirname $i))"
if [ -f "$i/vendor" ] && [ -f "$i/device" ]; then
echo "GPU: $(cat $i/vendor) $(cat $i/device)"
fi
echo "---"
done

List the dGPU first in the KWIN_DRM_DEVICES variable to prioritize it for rendering.

#### Getting the current state of KWin for support and debug purposes

This command prints out a summary of the current state of KWin, including used options, used compositing backend, and relevant OpenGL driver capabilities. See more on Martin's blog .

```
$ qdbus6 org.kde.KWin /KWin org.kde.KWin.supportInformation

#### Disable desktop effects manually or automatically for defined applications

Plasma has desktop effects enabled by default and e.g., not every game will disable them automatically. You can disable desktop effects in System Settings > Window Management > Desktop Effects and you can toggle desktop effects with Alt+Shift+F12 .

Additionally, you can create custom KWin rules to automatically disable/enable compositing when a certain application/window starts under System Settings > Window Management > Window Rules .

#### Enable transparency

If you use a transparent background without enabling the compositor, you will get the message:

```
This color scheme uses a transparent background which does not appear to be supported on your desktop

In System Settings > Display & Monitor > Compositor , check Compositing: Enable on startup and restart Plasma.

#### Disable compositing

This article or section is being considered for removal.

Reason: this setting doesn't exist anymore. At least on a Wayland session. This can be removed after plasma 6.8 released which will be planned as Wayland only.
Note that we should also edit and remove the "compositing" mentioned parts on the whole page. (Discuss in Talk:KDE )

In System Settings > Display & Monitor > Compositor , uncheck Compositing: Enable on startup and restart Plasma.

#### Flickering in fullscreen when compositing is enabled

In System Settings > Display & Monitor > Compositor , uncheck Compositing: Allow applications to block compositing . This may harm performance.

#### Effects such as Expose, Overview and Desktop Grid are jerky

Setting the environment variable QSG_USE_SIMPLE_ANIMATION_DRIVER for KWIN reduces jerking in some Quick Scene Graphics-based effects. For this purpose, it is sufficient to create a drop-in for the service running KWIN:

```
/etc/systemd/user/plasma-kwin_x11.service.d/10-kwin_QSG_SAD.conf

```
[Service]
Environment="QSG_USE_SIMPLE_ANIMATION_DRIVER=1"

(in the case of Wayland session, use plasma-kwin_wayland.service.d as directory name)

Then restart the session.

Another try is to set QSG_NO_VSYNC instead of QSG_USE_SIMPLE_ANIMATION_DRIVER .

#### Plasma cursor sometimes shown incorrectly

Create the directory ~/.local/share/icons/default/ (alternatively, ~/.icons/default ), then, inside it, create a file named index.theme , then add to it the following contents:

```
~/.local/share/icons/default/index.theme

```
[Icon Theme]
Inherits=breeze_cursors

If applicable, replace breeze_cursors with the cursor theme you use (cursor themes can be found in /usr/share/icons/ , e.g., Breeze_Light ).

Note You must relog in for these changes to take effect.

On Wayland, it is necessary for xdg-desktop-portal-gtk to be installed for GTK/GNOME applications to correctly apply cursor themes.

##### Firefox and Thunderbird ignore cursor theme

Firefox and Thunderbird running under Wayland will refer to GSettings to determine which cursor to display.

To sync KDE settings to GTK applications, install kde-gtk-config .

If you do not want to install an extra package, you can set the cursor theme manually:

```
$ gsettings set org.gnome.desktop.interface cursor-theme cursor-theme-name

#### Cursor jerking/flicking when changing roles (e.g., when mousing over hyperlinks)

Try installing the appropriate 2D acceleration driver for your system and window manager.

#### Unusable screen resolution set

Your local configuration settings for kscreen can override those set in xorg.conf . Look for kscreen configuration files in ~/.local/share/kscreen/ and check if mode is being set to a resolution that is not supported by your monitor.

#### Blurry icons in system tray

In order to add icons to tray, applications often make use of the library appindicator. If your icons are blurry, check which version of libappindicator you have installed. If you only have libappindicator-gtk2 AUR installed, you can install libappindicator as an attempt to get clear icons.

#### Cannot change screen resolution when running in a virtual machine

When running Plasma in a VMware , VirtualBox or QEMU virtual machine, kscreen may not allow changing the guest's screen resolution to a resolution higher than 800×600.

The workaround is to set the PreferredMode option in xorg.conf.d(5) . Alternatively, try using a different graphics adapter in the virtual machine, e.g., VBoxSVGA instead of VMSVGA for VirtualBox and Virtio instead of QXL for QEMU. See KDE Bug 407058 for details.

#### Dolphin, Kate, etc. stuck long time when opening

Check whether your user directories ( Documents , Downloads , etc.) are read-only.

#### Spectacle screenshot uses old screen state

In System Settings > Display & Monitor > Compositor , change Keep window thumbnails from Only from Shown windows to Never . If you are using Intel graphics, ensure that xf86-video-intel is not installed .

#### Poor font rendering in GTK applications

See XDG Desktop Portal#Poor font rendering in GTK applications on KDE Plasma .

#### Improper window resizing

You may observe that windows of some applications do not resize properly, but rather, the resized portion is transparent and mouse clicks are sent to the underlying window. To correct this behavior, change KDE's GTK3 theme to something other than oxygen-gtk.

#### Random lockups while using modesetting or the Nouveau driver for old Nvidia cards

See Nouveau#Random lockups with kernel error messages .

### Sound problems

Note First make sure you have alsa-utils installed.

#### No sound after suspend

If there is no sound after suspending and KMix does not show audio devices that should be there, restarting plasmashell and pulseaudio may help:

```
$ killall plasmashell
$ systemctl --user restart pulseaudio.service
$ plasmashell

Some applications may also need to be restarted in order for sound to play from them again.

#### MP3 files cannot be played when using the GStreamer Phonon backend

This can be solved by installing the GStreamer libav plugin (package gst-libav ). If you still encounter problems, you can try changing the Phonon backend used by installing another, such as phonon-qt6-vlc .

Then, make sure the backend is preferred via phononsettings .

#### No volume control icon in tray and cannot adjust sound by function key

Check if you have plasma-pa installed.

#### No sound after a short time

If journalctl -p4 -t pulseaudio contains entries saying Failed to create sink input: sink is suspended , try commenting the following line in /etc/pulse/default.pa :

```
#load-module module-suspend-on-idle

If the issue persists, plasma-meta or plasma may have installed pulseaudio alongside wireplumber . To fix the issue, replace pulseaudio with pipewire-pulse . If pulseaudio is preferred, replace wireplumber with pipewire-media-session . See PipeWire#PulseAudio clients and this forum thread for more details.

### Power management

#### No Suspend/Hibernate Options

If your system is able to suspend or hibernate using systemd but do not have these options shown in KDE, make sure powerdevil is installed.

#### No power profile options

Make sure you installed powerdevil and power-profiles-daemon .
Run powerprofilesctl and check the driver. If it is intel_pstate or amd_pstate , you are done, otherwise see CPU frequency scaling#Scaling drivers for more information on enabling them.

### KMail

#### Clean Akonadi configuration to fix KMail

See [15] for details.

If you want a backup, copy the following configuration directories:

```
$ cp -a ~/.local/share/akonadi ~/.local/share/akonadi-old
$ cp -a ~/.config/akonadi ~/.config/akonadi-old

#### Empty IMAP inbox in KMail

For some IMAP accounts KMail will show the inbox as a top-level container (so it will not be possible to read messages there) with all other folders of this account inside. [16] . To solve this problem, simply disable the server-side subscriptions in the KMail account settings.

#### Authorization error for EWS account in KMail

While setting up an EWS account in KMail, you may keep getting errors about failed authorization even for valid and fully working credentials. This is likely caused by broken communication between KWallet and KMail. To workaround the issue, set a password via qdbus:

```
$ qdbus6 org.freedesktop.Akonadi.Resource.akonadi_ews_resource_0 /Settings org.kde.Akonadi.Ews.Wallet.setPassword "XXX"

### Aggressive QXcbConnection / kscreen.xcb.helper journal logging

See Qt#Disable/Change Qt journal logging behaviour .

### KF5/Qt 5 applications do not display icons in i3/FVWM/awesome

See Qt#Configuration of Qt 5/6 applications under environments other than KDE Plasma .

### Problems with saving credentials and persistently occurring KWallet dialogs

It is not recommended to turn off the KWallet password saving system in the user settings, as it is required to save encrypted credentials like Wi-Fi passphrases for each user. Persistently occurring KWallet dialogs can be the consequence of turning it off.

In case you find the dialogs to unlock the wallet annoying when applications want to access it, you can let the display managers Plasma Login Manager , SDDM and LightDM unlock the wallet at login automatically and see KDE Wallet#Unlock KDE Wallet automatically on login . The first wallet needs to be generated by KWallet (and not user-generated) in order to be usable for system program credentials.

In case you want the wallet credentials not to be opened in memory for every application, you can restrict applications from accessing it with kwalletmanager in the KWallet settings.

If you do not care for credential encryption at all, you can simply leave the password forms blank when KWallet asks for the password while creating a wallet. In this case, applications can access passwords without having to unlock the wallet first.

### Discover does not show any applications

This can be solved by installing packagekit-qt6 .

Warning As explained in a GitHub comment by a Package Maintainer, "Handling system packages via packagekit is just fundamentally incompatible with our high-maintenance rolling release distro, where any update might leave the system in an unbootable or otherwise unusable state if the user does not take care reading pacman's logs or merging pacnew files before rebooting."

### Discover stops showing updates from Arch repositories

Discover sometimes will not remove its PackageKit alpm lock. To release it, remove /var/lib/PackageKit/alpm/db.lck . Use "Refresh" in Discover and updates should appear (if there are any updates pending).

### High CPU usage of kscreenlocker_greet with NVIDIA drivers

As described in KDE Bug 347772 NVIDIA OpenGL drivers and QML may not play well together with Qt 5. This may lead kscreenlocker_greet to high CPU usage after unlocking the session. To work around this issue, set the QSG_RENDER_LOOP environment variable to basic .

Then kill previous instances of the greeter with killall kscreenlocker_greet .

### OS error 22 when running Akonadi on ZFS

If your home directory is on a ZFS pool, create a ~/.config/akonadi/mysql-local.conf file with the following contents:

```
[mysqld]
innodb_use_native_aio = 0

See MariaDB#OS error 22 when running on ZFS .

### Some programs are unable to scroll when their windows are inactive

This is caused by the problematic way of GTK3 handling mouse scroll events. A workaround for this is to set environment variable GDK_CORE_DEVICE_EVENTS=1 . However, this workaround also breaks touchpad smooth scrolling and touchscreen scrolling.

### TeamViewer behaves slowly

When using TeamViewer, it may behave slowly if you use smooth animations (such as windows minimizing). See #Disable compositing as a workaround.

### Kmail, Kontact and Wayland

Kmail may become unresponsive or show a black message viewer or similar, often after having been minimized and restored. A workaround may be to set environment variable QT_QPA_PLATFORM="xcb;wayland" . See KDE Bug 397825 .

### Unlock widgets (Plasma ≥ 5.18)

If you previously locked your widgets, you will probably find yourself unable to unlock them again.
You just have to run this command to do so:

```
$ qdbus6 org.kde.plasmashell /PlasmaShell evaluateScript "lockCorona(false)"

The new Customize Layout does not require locking them back up but if you want to do that:

```
$ qdbus6 org.kde.plasmashell /PlasmaShell evaluateScript "lockCorona(true)"

### KIO opens URLs with the wrong program

Check file associations regarding HTML, PHP, etc... and change it to a browser. KIO's cache files are located in $HOME/.cache/kioexec . See also xdg-utils#URL scheme handlers .

### Lock the screen before suspending and hibernating

In the System Settings application, KDE offers a setting to automatically lock the screen after waking up from sleep. Upon resuming, some users report that the screen is briefly shown before locking. To prevent this behavior and have KDE lock the screen before suspending, create a hook in systemd(1) by creating the following file as the root user:

```
/usr/lib/systemd/system-sleep/lock_before_suspend.sh

```
#!/bin/bash

case $1/$2 in
pre/*)
case $2 in
suspend|hibernate)
loginctl lock-session
sleep 1
;;
esac
;;
esac

The use of sleep is necessary in order for the loginctl lock-session command to complete before the device is suspended. Using a lower timeout may not allow for this to complete.

After creating the file, make it executable .

Finally, make sure that the KDE setting is enabled by going to System Settings > Screen Locking and checking the Lock screen automatically: After waking from sleep checkbox.

### X11 shortcuts conflict on Wayland

Some X11 software like freerdp can grab keyboard input since KDE 5.27. Others like VMware cannot grab correctly. [17]

It is inappropriate to force grab in Xserver or in compositors. [18] You can solve it in an elegant way as follows:

- Right click the window titlebar (e.g. VMware or Citrix);

- More Actions > Configure Special Window Settings...

- Click Add Property... and select Ignore global shortcuts .

- Select force and yes . Apply it.

### System settings not applying when changed

This can be caused because system settings cannot access/modify the .config folder in your home directory.

To fix this, you need to change the owner of the folder:

```
# chown user : user /home/ user /.config

user refers to the name of the user that you are logged into in KDE Plasma. If the name of your home directory is not the same as the user you are logged in as, you can change it accordingly.

If this does not work, you might need to change the permissions of the folder:

```
# chmod 755 /home/ user /.config

### Plasma 6 Global Menu not working with some applications

There are issues with the Widget "Global Menu" not working with some applications even after installing appmenu-gtk-module and libdbusmenu-glib . The fix is to install the plasma5-integration and to restart your Session.

#### Firefox, Thunderbird and their forks

This article or section is a candidate for moving to GTK .

Notes: This seems GTK specific. (Discuss in Talk:KDE )

The following flags must be enabled in the about:config section when running under wayland natively.

- widget.gtk.global-menu.enabled

- widget.gtk.global-menu.wayland.enabled

### Automatic mounting of internal drives not working

The factual accuracy of this article or section is disputed.

Reason: Doubtful advice from a security standpoint. Why not use fstab user options instead? (Discuss in Talk:KDE )

It is necessary to add a Polkit rule allowing mounting of internal drives without elevated privileges:

```
/etc/polkit-1/rules.d/10-udisks2.rules

```
polkit.addRule(function(action, subject) {
if (action.id == "org.freedesktop.udisks2.filesystem-mount-system") {
return polkit.Result.YES;
}
});

### Various screen problems

KDE's powerdevil uses ddcutil by default, but may not be compatible with certain screen types (especially laptop screens) and lead to various screen problems such as frozen images, black screens after logging in, flickering, etc. To mitigate the problem, you can try to disable it.

Powerdevil can be configured with a drop-in file for the user unit :

```
/etc/systemd/user/plasma-powerdevil.service.d/disable-ddcutil.conf

```
[Service]
Environment="POWERDEVIL_NO_DDCUTIL=1"

Finally, restart the plasma-powerdevil.service user unit .

## See also

- KDE homepage

- KDE Blogs

- This Week in Plasma

- This Week in KDE Apps

- KDE Forums

- KDE Wikis

- KDE bug tracker and reporter

- KDE Matrix Rooms

Retrieved from " https://wiki.archlinux.org/index.php?title=KDE&oldid=886485 "

Category :
- KDE

Hidden categories:
- Pages or sections flagged with Template:Out of date

- Pages or sections flagged with Template:Accuracy

- Pages or sections flagged with Template:Move

- Pages or sections flagged with Template:Expansion

- Pages or sections flagged with Template:Merge

- Sections flagged with Template:Remove

Search

KDE

Add topic
