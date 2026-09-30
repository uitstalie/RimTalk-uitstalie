> 来源: https://github.com/FeralInteractive/gamemode
> 标题: FeralInteractive/gamemode - Linux GameMode README
> 抓取: HTTP 200 | Content-Type: text/html; charset=utf-8 | 原始字节: 330044

---

Skip to content

## Navigation Menu

Sign in Appearance settings

Search /

Sign in
Sign up Appearance settings

You signed in with another tab or window. Reload to refresh your session.
You signed out in another tab or window. Reload to refresh your session.
You switched accounts on another tab or window. Reload to refresh your session.

Dismiss alert

{{ message }}

FeralInteractive

/

gamemode

Public

-
Notifications
You must be signed in to change notification settings

-
Fork
215

-

Star
6k

master

Branches Tags

Go to file

Code Open more actions menu

## Latest commit

## History
740 Commits
740 Commits

## Folders and files
| Name | Name | Last commit message
| Last commit date

| .github

| .github

|
|

| common

| common

|
|

| daemon

| daemon

|
|

| data

| data

|
|

| example

| example

|
|

| lib

| lib

|
|

| scripts

| scripts

|
|

| subprojects

| subprojects

|
|

| util

| util

|
|

| .clang-format

| .clang-format

|
|

| .gitignore

| .gitignore

|
|

| CHANGELOG.md

| CHANGELOG.md

|
|

| LICENSE.txt

| LICENSE.txt

|
|

| README.md

| README.md

|
|

| _config.yml

| _config.yml

|
|

| bootstrap.sh

| bootstrap.sh

|
|

| meson.build

| meson.build

|
|

| meson_options.txt

| meson_options.txt

|
|

| View all files

## Repository files navigation

# GameMode

GameMode is a daemon/lib combo for Linux that allows games to request a set of optimisations be temporarily applied to the host OS and/or a game process.

GameMode was designed primarily as a stop-gap solution to problems with the Intel and AMD CPU powersave or ondemand governors, but is now host to a range of optimisation features and configurations.

Currently GameMode includes support for optimisations including:

- CPU governor

- I/O priority

- Process niceness

- Kernel scheduler ( SCHED_ISO )

- Screensaver inhibiting

- GPU performance mode (NVIDIA and AMD), GPU overclocking (NVIDIA)

- CPU core pinning or parking

- Custom scripts

GameMode packages are available for Ubuntu, Debian, Solus, Arch, Gentoo, Fedora, OpenSUSE, Mageia and possibly more.

Issues with GameMode should be reported here in the issues section, and not reported to Feral directly.

## Requesting GameMode

For games/launchers which integrate GameMode support, simply running the game will automatically activate GameMode.

For others, you must manually request GameMode when running the game. This can be done by launching the game through gamemoderun :

```
gamemoderun ./game

Or edit the Steam launch options:

```
gamemoderun %command%

Note: for older versions of GameMode (before 1.3) use this string in place of gamemoderun :

```
LD_PRELOAD="$LD_PRELOAD:/usr/\$LIB/libgamemodeauto.so.0"

Please note the backslash here in \$LIB is required.

## Configuration

The daemon is configured with a gamemode.ini file. example/gamemode.ini is an example of what this file would look like, with explanations for all the variables.

Configuration files are loaded and merged from the following directories, from highest to lowest priority:

- $PWD ("unsafe" - [gpu] settings take no effect in this file )

- $XDG_CONFIG_HOME or $HOME/.config/ ("unsafe" - [gpu] settings take no effect in this file )

- /etc/

- /usr/share/gamemode/

## Note for Hybrid GPU users

It's not possible to integrate commands like optirun automatically inside GameMode, since the GameMode request is made once the game has already started. However it is possible to use a hybrid GPU wrapper like optirun by starting the game with gamemoderun .

You can do this by setting the environment variable GAMEMODERUNEXEC to your wrapper's launch command, so for example GAMEMODERUNEXEC=optirun , GAMEMODERUNEXEC="env DRI_PRIME=1" , or GAMEMODERUNEXEC="env __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia __VK_LAYER_NV_optimus=NVIDIA_only" . This environment variable can be set globally (e.g. in /etc/environment), so that the same prefix command does not have to be duplicated everywhere you want to use gamemoderun .

GameMode will not be injected to the wrapper.

## Development

The design of GameMode has a clear-cut abstraction between the host daemon and library ( gamemoded and libgamemode ), and the client loaders ( libgamemodeauto and gamemode_client.h ) that allows for safe use without worrying about whether the daemon is installed or running. This design also means that while the host library currently relies on systemd for exchanging messages with the daemon, it's entirely possible to implement other internals that still work with the same clients.

See repository subdirectories for information on each component.

### Install Dependencies

GameMode depends on meson for building and systemd for internal communication. This repo contains a bootstrap.sh script to allow for quick install to the user bus, but check meson_options.txt for custom settings. These instructions all assume that you
already have a C development environment (gcc or clang, libc-devel, etc) installed.

#### Ubuntu/Debian

Note: Debian 13 and Ubuntu 25.04 (and later) need to install systemd-dev and libsystemd-dev in addition to the dependencies below.

```
apt update && apt install meson libsystemd-dev pkg-config ninja-build git dbus-user-session libdbus-1-dev libinih-dev build-essential

On Debian 12 and Ubuntu 22 (and earlier), you'll need to install python3 and python3-venv packages to install the latest meson version from pip .

```
python3 -m venv .venv
source .venv/bin/activate
pip install meson

Later you can deactivate the virtual environment and remove it.

```
deactivate
rm -rf .venv

#### Arch

```
pacman -S meson systemd git dbus libinih gcc pkgconf

#### RHEL 10 and variants

Note: Older versions of RHEL (and variants) cannot build gamemode due to not exposing libdbus-1 to pkg-config.
(also - don't try and play games on RHEL, come on)

You must have EPEL enabled to install all dependencies.

```
dnf install meson systemd-devel pkg-config git dbus-devel inih-devel

#### Fedora

```
dnf install meson systemd-devel pkg-config git dbus-devel inih-devel

#### OpenSUSE Leap/Tumbleweed

```
zypper install meson systemd-devel git dbus-1-devel libgcc_s1 libstdc++-devel libinih-devel

#### Gentoo

Gentoo has an ebuild which builds a stable release from sources. It will also pull in all the dependencies so you can work on the source code.

```
emerge --ask games-util/gamemode

You can also install using the latest sources from git:

```
ACCEPT_KEYWORDS= " ** " emerge --ask ~ games-util/gamemode-9999

#### Nix

Similar to Gentoo, nixOS already has a package for gamemode, so we can use that to setup an environment:

```
nix-shell -p pkgs.gamemode.buildInputs pkgs.gamemode.nativeBuildInputs

### Build and Install GameMode

Then clone, build and install a release version of GameMode at 1.8.2:

```
git clone https://github.com/FeralInteractive/gamemode.git
cd gamemode
git checkout 1.8.2 # omit to build the master branch
./bootstrap.sh

To test GameMode installed and will run correctly:

```
gamemoded -t

To uninstall:

```
systemctl --user stop gamemoded.service
ninja uninstall -C builddir

### Pull Requests

Pull requests must match with the coding style found in the .clang-format file, please run this before committing:

```
clang-format -i $(find . -name '*.[ch]' -not -path "*subprojects/*")

### Maintained by

Feral Interactive

See the contributors section for an extended list of contributors.

## License

Copyright © 2017-2025 Feral Interactive and the GameMode contributors

GameMode is available under the terms of the BSD 3-Clause License (Revised)

The "inih" library is distributed under the New BSD license

## About
Optimise Linux system performance on demand

### Topics
linux videogames

### Resources
Readme
BSD-3-Clause license
Activity
Custom properties

### Stars
6.0k stars

### Watchers
89 watching

### Forks
215 forks
Report repository

## Releases

## Packages

## Used by

## Contributors

## Languages

You can’t perform that action at this time.
