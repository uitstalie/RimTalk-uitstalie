> 来源: https://gitlab.steamos.cloud/steamrt/steamrt/-/wikis/Sniper-release-notes
> 标题: Steam Linux Runtime 3.0 (sniper) release notes (index)
> 抓取: HTTP 200 (GitLab API v4 /wikis, 原始 Markdown)

---

Look in `SteamLinuxRuntime_sniper/VERSIONS.txt` to check which build you have. Usually the newest version listed here is the `client_beta` branch, and the second-oldest is the public branch (but this can vary if a version was held back).

## Useful links

[README](https://gitlab.steamos.cloud/steamrt/steamrt/-/blob/steamrt/soldier/README.md)
| [SLR 3.0 history](https://steamdb.info/app/1628350/history/)
| [container images](https://repo.steampowered.com/steamrt3/images/)
| [SDK](https://gitlab.steamos.cloud/steamrt/sniper/sdk)

## Steam Linux Runtime 3.0 (sniper) depot 3.0.20260928.262393

*contains
[steam-runtime-tools 0.20260925.0](https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/tags/v0.20260925.0),
built using
[flatdeb-steam 0.20260909.0](https://gitlab.steamos.cloud/steamrt/flatdeb-steam/-/tags/v0.20260909.0);
steamrt/tasks#1138*

[Steam Linux Runtime 3.0 (sniper)](https://steamdb.info/app/1628350)
Steampipe build ID 25607578, released as beta 2026-09-29

This runtime environment is based on Debian 11 LTS,
which reached end-of-life on 2026-08-31.
For new/maintained games,
game developers should consider
[upgrading to Steam Runtime 4](https://gitlab.steamos.cloud/steamrt/steamrt4/sdk#upgrading-from-steam-linux-runtime-30-sniper).

### Container runtime

* Fix VA-API on Gentoo (steamrt/tasks#1143, [steam-for-linux#13554](https://github.com/ValveSoftware/steam-for-linux/issues/13554))
* Capture more NGX libraries for the Nvidia proprietary driver (steamrt/tasks#1136)
* Fix a regression in the previous beta where the container would not start for users of `pam_tmpdir` or `pam_mktemp` (steamrt/tasks#1144, [steam-runtime#855](https://github.com/ValveSoftware/steam-runtime/issues/855))
* Improve startup speed and robustness on systems with a non-working automount point, for example an unavailable network drive or missing removable drive (steamrt/tasks#1006, [steam-for-linux#10571](https://github.com/ValveSoftware/steam-for-linux/issues/10571), [steam-runtime#766](https://github.com/ValveSoftware/steam-runtime/issues/766), [steam-runtime#847](https://github.com/ValveSoftware/steam-runtime/issues/847))
* Improve startup speed on systems with a very large number of mount points (steamrt/tasks#1006)

### Diagnostic tools

* Fix detection of VA-API drivers on Gentoo (steamrt/tasks#1143, [steam-for-linux#13554](https://github.com/ValveSoftware/steam-for-linux/issues/13554))
* `s-r-check-requirements` now has a mode to simulate failures for testing purposes (steamrt/tasks#1016)

## sniper build 3.0.20260914.260626

*contains
[steam-runtime-tools 0.20260914.0](https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/tags/v0.20260914.0),
built using
[flatdeb-steam 0.20260909.0](https://gitlab.steamos.cloud/steamrt/flatdeb-steam/-/tags/v0.20260909.0);
steamrt/tasks#1114*

[Steam Linux Runtime 3.0 (sniper)](https://steamdb.info/app/1628350) Steampipe build ID 25378315, released as beta 2026-09-18

This runtime environment is based on Debian 11 LTS, which reached end-of-life on 2026-08-31. For new/maintained games, game developers should consider [upgrading to Steam Runtime 4](https://gitlab.steamos.cloud/steamrt/steamrt4/sdk#upgrading-from-steam-linux-runtime-30-sniper).

### Platform libraries

* Update SDL3 to 3.4.16 (steamrt/tasks#1128)
* Update sdl2-compat to 2.32.72 (steamrt/tasks#1128)
* Update SDL3_image to 3.4.6 (steamrt/tasks#1128)
* Update vkd3d for native Linux games to 2.1 (#1127)
    * Note that this is unrelated to the version of vkd3d-proton that is part of Proton
* Update Pipewire client library to 1.4.2 (backported from Debian 13), fixing a crash or deadlock on Bluetooth profile-switching and hopefully improving robustness with native Pipewire protocol in general (steamrt/tasks#1135, [steam-runtime#853](https://github.com/ValveSoftware/steam-runtime/issues/853))
* `s-r-supervisor`, `s-r-launch-client`, `s-r-launcher-service`: Add the ability to prepend or append to environment variables (steamrt/tasks#1093)
* `s-r-launch-client` can set environment variables with non-UTF-8 names or values (steamrt/tasks#1007)
* Update packages from Debian 11 LTS:
    * `ca-certificates_20250419~deb12u1~deb11u1`
    * `nss_2:3.61-1+deb11u7` (CVE-2026-16389)
    * `nvidia-settings_535.309.01-0+deb11u1` (`libxnvctrl0`)

### Container runtime

* When run from an environment that is not the `LD_LIBRARY_PATH`-based Steam Runtime, don't reset the `PATH` (steamrt/tasks#1053)
* Fix an assertion failure when two containers are launched concurrently (steamrt/tasks#1137)
* Update `srt-bwrap` to bubblewrap 0.12.0
* Update Flatpak-derived code to Flatpak 1.18.2

### Diagnostic tools

* Command-line tools from steam-runtime-tools more consistently show `--help`, `--version` on standard output (steamrt/tasks#1079)
* Most command-line tools from steam-runtime-tools enable informational messages with `--verbose`/`-v`, and debug messages if that option is used twice (steamrt/tasks#1079)

### SDK

* Temporarily use `snapshot.debian.org` to provide `bullseye-security` until it's set up on `archive.debian.org` (steamrt/tasks#1132, [Debian#1147093](https://bugs.debian.org/1147093), [Debian#1147150](https://bugs.debian.org/1147150))
* Configure `bullseye-security` apt source to ignore `Valid-Until` now that Debian 11 LTS has reached end-of-life ([Debian#1147150](https://bugs.debian.org/1147150))
* Update packages from Debian 11 LTS:
    * `libarchive_3.4.3-2+deb11u5` (CVE-2026-14164, CVE-2026-15028, CVE-2026-16517)
    * `unzip_6.0-26+deb11u2` (CAN-2026-2034440, CAN-2026-2034443, CAN-2026-2034442)
    * `xorg-server_2:1.20.11-1+deb11u18` (CVE-2022-49737, CVE-2026-33999, CVE-2026-34000, CVE-2026-34001, CVE-2026-34002, CVE-2026-34003, CVE-2026-50257, CVE-2026-50260, CVE-2026-50261, CVE-2026-50258, CVE-2026-50259, CVE-2026-50262, CVE-2026-50263, CVE-2026-50256, CVE-2026-50264)

## sniper build 3.0.20260805.254768

* steamrt/tasks#1083
* Contains
[steam-runtime-tools 0.20260805.0](https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/tags/v0.20260805.0),
built using
[flatdeb-steam 0.20260721.0](https://gitlab.steamos.cloud/steamrt/flatdeb-steam/-/tags/v0.20260721.0)
* [Steam Linux Runtime 3.0 (sniper)](https://steamdb.info/app/1628350): Steampipe build ID 24599756, released as beta 2026-08-06, promoted to stable 2026-08-11

### Platform libraries

* Update SDL to 3.4.14 (steamrt/tasks#1108)
* Backport Vulkan-Loader and Vulkan-Tools from Debian 13, corresponding to Vulkan SDK 1.4.309.0. In practice this will mostly only affect older LTS distributions like Ubuntu 24.04 and 22.04. (steamrt/tasks#316)
* Backport upstream bug fixes into `at-spi2-atk` to avoid GTK 3 app crashes when inspected by some accessibility or debugging tools (steamrt/tasks#1105)
* Resync sdl2-compat packaging with Debian, removing unnecessary transitional packages (steamrt/tasks#774)
* Resync vkd3d packaging with Debian (steamrt/tasks#1084)
* Update packages from Debian 11 LTS:
    * `nss_2:3.61-1+deb11u6` (CVE-2026-6766, CVE-2026-6767, CVE-2026-6772, CVE-2026-12318)
    * `xz-utils_5.2.5-2.1~deb11u2` (CVE-2026-34743)

### Container runtime

* When running under x86 emulation on arm64, fix failure to launch native Linux titles that have command-line arguments starting with `-`, such as Team Fortress 2 (steamrt/tasks#1109)

### Diagnostic tools

* `steam-runtime-launch-client --list` lists all (potentially multiple) instances of `steam-runtime-launcher-service --alongside-steam` (steamrt/tasks#1095)
* Avoid some unnecessary log messages when debugging is enabled

### SDK

* Backport Vulkan headers from Debian 13, corresponding to Vulkan SDK 1.4.309.0 (steamrt/tasks#316)
* Backport `glslang`, `spirv-headers` and `spirv-tools` from Debian 13, corresponding to Vulkan SDK 1.4.309.0 (steamrt/tasks#1087)
* Fix intermittent crash in `testaudiodecoder` SDL3_mixer example
* A backport of `vulkan-volk` from Debian 13 is available in the apt repository, but not currently preinstalled in the SDK (steamrt/tasks#316)
* Update packages from Debian 11 LTS:
    * `linux_5.10.262-1`

### Internal changes

* steamrt/steam-runtime-tools> build system refactoring

## Steam Linux Runtime 3.0 (sniper) depot 3.0.20260714.251853 (Steampipe build ID 24221982)

* steamrt/tasks#1052
* Contains [steam-runtime-tools 0.20260714.0](https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/tags/v0.20260714.0),
built using [flatdeb-steam 0.20260601.0](https://gitlab.steamos.cloud/steamrt/flatdeb-steam/-/tags/v0.20260601.0)
* [Steam Linux Runtime 3.0 (sniper)](https://steamdb.info/app/1628350): Steampipe build ID 24221982, released as beta 2026-07-15, promoted to stable 2026-08-06

### Platform libraries

* Update libsdl3 to 3.4.12 (steamrt/tasks#1067)
* Update vkd3d for native Linux games to 2.0 (steamrt/tasks#1042)
    * Note that this is unrelated to the version of vkd3d-proton that is part of Proton
* `steam-runtime-launch-client`:
    * Improve error message if `steam-runtime-launch-service` isn't running (steamrt/steam-runtime-tools!989)
    * Improve exit status if a command isn't found or can't be run
    * Add `--if-exists` option to silence the error message if a command isn't found (steamrt/tasks#980, [steam-for-linux#13030](https://github.com/ValveSoftware/steam-for-linux/issues/13030))
* Update packages from Debian 11 LTS:
    * `dpkg_1.20.14` (CVE-2025-6297)
    * `libinput_1.16.4-3+deb11u1` (CVE-2022-1215, CVE-2026-50292)
    * `openssl_1.1.1w-0+deb11u8` (CVE-2026-7383, CVE-2026-9076, CVE-2026-34180, CVE-2026-42766, CVE-2026-45447, CVE-2026-28387, CVE-2026-28388, CVE-2026-28389, CVE-2026-28390)
* Merge modified packages from Debian 11 LTS:
    * `mesa_20.3.5-1+deb11u1` (CVE-2026-40393)

### Container runtime

* Improve robustness of pressure-vessel if the root directory contains
    automount points for unreachable networked filesystems or detached
    external drives. It will still be very slow to start Steam or games,
    but they will start eventually in some situations where they would
    previously have failed.

    The `PRESSURE_VESSEL_WORKAROUNDS=limit-shared-dirs` workaround option
    can still be used to work around this if necessary. It is best used in conjunction with
    `PRESSURE_VESSEL_FILESYSTEMS_RW` to share any directories that _are_ necessary.
    For example, if Steam games are installed in non-default directories `/games`
    and `/mnt/local-drive` in addition to the default `~/.local/share/Steam`, then
    Steam could be run as:

    ```
    env PRESSURE_VESSEL_WORKAROUNDS=limit-shared-dirs \
        PRESSURE_VESSEL_FILESYSTEMS_RW=/games:/mnt/local-drive \
        steam
    ```

    (steamrt/tasks#535, [bubblewrap#653](https://github.com/containers/bubblewrap/issues/653), [bubblewrap#650](https://github.com/containers/bubblewrap/issues/650), [bubblewrap#541](https://github.com/containers/bubblewrap/issues/541),
      [steam-runtime#766](https://github.com/ValveSoftware/steam-runtime/issues/766), [steam-for-linux#10571](https://github.com/ValveSoftware/steam-for-linux/issues/10571))
 
### Diagnostic tools

* Improve validity checks for runtime version numbers (steamrt/tasks#945)
* Improve debug logging in `steam-runtime-supervisor` (steamrt/tasks#1078, steamrt/tasks#1080)
* Update lists of symbols required in SDL_image, SDL_net (steamrt/tasks#899, steamrt/tasks#773)

### SDK

* Update packages from Debian 11 LTS:
    * `libhtml-parser-perl_3.75-1+deb11u1` (CVE-2026-8829)
    * `libxfont_1:2.0.4-1+deb11u1` (CVE-2026-56001, CVE-2026-56002, CVE-2026-56003)
    * `linux_5.10.259-1`
    * `python-urllib3_1.26.5-1~exp1+deb11u4` (CVE-2026-44431)

### Internal changes

* Update Flatpak-derived code from Flatpak 1.18.0 (steamrt/tasks#838)
* Update libglnx to 2026-06-17

## Steam Linux Runtime 3.0 (sniper) depot 3.0.20260608.242788 (Steampipe build ID 23629198)

*contains
[steam-runtime-tools 0.20260601.0](https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/tags/v0.20260601.0),
built using
[flatdeb-steam 0.20260601.0](https://gitlab.steamos.cloud/steamrt/flatdeb-steam/-/tags/v0.20260601.0);
steamrt/tasks#1044; released as beta 2026-06-08, promoted to stable 2026-06-09*

### Platform libraries

* Update sdl2-compat to 2.32.70, fixing a regression in 2.32.68 where the SteamOS on-screen keyboard would pop up when starting native sniper games that use SDL2 (steamrt/tasks#1051)
* Update SDL3_mixer to 3.2.4 (steamrt/tasks#1045)
* Update packages from Debian 11 LTS:
    * `glibc_2.31-13+deb11u14` (CVE-2026-0861, CVE-2025-15281, CVE-2025-8058, CVE-2026-0915, CVE-2026-4046)
    * `libxml2_2.9.10+dfsg-6.7+deb11u10` (CVE-2026-0989, CVE-2026-0990, CVE-2026-0992, CVE-2025-8732, CVE-2026-1757)
    * `sudo_1.9.5p2-3+deb11u4` (CVE-2026-35535)
* The experimental arm64 container images (`SteamLinuxRuntime_sniper-arm64.tar.xz`, `*arm64*-runtime.tar.gz`, `*arm64*-sysroot.tar.gz`) and the `.../arm64` version of steamrt/sniper/platform> are no longer generated. Games that want to run natively on arm64 should target the newer [Steam Linux Runtime 4.0](https://gitlab.steamos.cloud/steamrt/steamrt4/sdk) instead (steamrt/tasks#1032)

### SDK

* The experimental arm64 sysroot (`*arm64*-sysroot.tar.gz`) and the `.../arm64` and `.../arm64-on-amd64` versions of steamrt/sniper/sdk> are no longer generated. Games that want to run natively on arm64 should target the newer [Steam Linux Runtime 4.0](https://gitlab.steamos.cloud/steamrt/steamrt4/sdk) instead (steamrt/tasks#1032)

## Steam Linux Runtime 3.0 (sniper) depot 3.0.20260602.240810 (Steampipe build ID 23547206)

*contains
[steam-runtime-tools 0.20260601.0](https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/tags/v0.20260601.0),
built using
[flatdeb-steam 0.20260601.0](https://gitlab.steamos.cloud/steamrt/flatdeb-steam/-/tags/v0.20260601.0);
steamrt/tasks#1030; released as beta 2026-06-03, superseded 2026-06-08*

### Platform libraries

* Add SDL3_net (steamrt/tasks#773)
* Update SDL3 to 3.4.10 (steamrt/tasks#1038, steamrt/tasks#1040, [Source-1-Games#8018](https://github.com/ValveSoftware/Source-1-Games/issues/8018))
* Update SDL2_mixer to 2.8.2 (steamrt/tasks#1034)
* Update SDL3_mixer to 3.2.2 (steamrt/tasks#1034)
* Update packages from Debian 11 LTS:
    * `gnutls28_3.7.1-5+deb11u10` (CVE-2026-3833, CVE-2026-5260, CVE-2026-33845, CVE-2026-33846, CVE-2026-42009, CVE-2026-42010, CVE-2026-42011, CVE-2026-42012, CVE-2026-42013, CVE-2026-42014, CVE-2026-42015)
    * `krb5_1.18.3-6+deb11u8` (CVE-2026-40355, CVE-2026-40356)
    * `lcms2_2.12~rc1-2+deb11u1` (CVE-2026-41254)
    * `libpng1.6_1.6.37-3+deb11u4` (CVE-2026-34757)
    * `nghttp2_1.43.0-1+deb11u3` (CVE-2026-27135)
    * `python3.9_3.9.2-1+deb11u7` (CVE-2025-13462, CVE-2026-2297, CVE-2026-3644, CVE-2026-4224, CVE-2026-4519)

### Container runtime

* Don't treat `libnvidia-pkcs*.so.*` as a graphics library, to avoid pulling in the host system's OpenSSL `libcrypto.so.*` on Nvidia systems (steamrt/tasks#1035, [steam-runtime#825](https://github.com/ValveSoftware/steam-runtime/issues/825))
* New `PRESSURE_VESSEL_WORKAROUNDS=limit-shared-dirs` workaround option can be used to work around automount points for unreachable network services or detached external drives. Best used in conjunction with `PRESSURE_VESSEL_FILESYSTEMS_RW` to share any directories that *are* necessary, for example
    ```
    env PRESSURE_VESSEL_WORKAROUNDS=limit-shared-dirs \
        PRESSURE_VESSEL_FILESYSTEMS_RW=/games:/mnt/local-drive \
          steam
    ```
    (steamrt/tasks#959, [steam-for-linux#10571](https://github.com/ValveSoftware/steam-for-linux/issues/10571))

### SDK

* Update packages from Debian 11 LTS:
    * `linux_5.10.251-5`
    * `rsync_3.2.3-4+deb11u4` (CVE-2026-29518, CVE-2026-43617, CVE-2026-43618, CVE-2026-43619, CVE-2026-43620)
* `com.valvesoftware.SteamRuntime.Sdk-*-debug.tar.gz` is no longer generated. Please use [debuginfod](https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/blob/main/docs/slr-for-game-developers.md#getting-debug-symbols) or the `images/*/dbgsym/` directories instead. (steamrt/tasks#891)
* `com.valvesoftware.SteamRuntime.Sdk-*-runtime.tar.gz` is no longer generated. Please use the steamrt/sniper/sdk> OCI images or `com.valvesoftware.SteamRuntime.Sdk-*-sysroot.tar.gz` instead. (steamrt/tasks#892)

## Steam Linux Runtime 3.0 (sniper) depot 3.0.20260507.232682 (Steampipe build ID  23181402)

*contains
[steam-runtime-tools 0.20260505.0](https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/tags/v0.20260505.0),
built using
[flatdeb-steam 0.20260310.0](https://gitlab.steamos.cloud/steamrt/flatdeb-steam/-/tags/v0.20260310.0);
steamrt/tasks#997; released as beta 2026-05-11, promoted to stable 2026-06-03*

### Platform libraries

* Update SDL to 3.4.8 (steamrt/tasks#1024)
* Update sdl2-compat to 2.32.68 (steamrt/tasks#1024)
* Update SDL3_image to 3.4.4 (steamrt/tasks#1024, CVE-2026-35444)
* Update SDL2_image to 2.8.12 (steamrt/tasks#1024, CVE-2026-35444)
* Update packages from Debian 11 LTS:
    * `libexif_0.6.22-3+deb11u1` (CVE-2026-40386, CVE-2026-40385, CVE-2026-32775)
    * `perl_5.32.1-4+deb11u5` (CVE-2025-40909)
    * `tzdata_2026b-0+deb11u1` (time zone updates for Moldova, British Columbia)
* Merge modified packages from Debian 11 LTS:
    * `tiff_4.2.0-1+deb11u8` (CVE-2026-4775)

### Container runtime

* Terminate all container processes when `srt-bwrap` exits, fixing the Stop button in the experimental steamrt3c Steam client (steamrt/tasks#961, steamrt/tasks#991)
* Add `pressure-vessel-arm64/`, making the x86 compatibility tool `SteamLinuxRuntime_sniper` more efficient and robust when running under x86 emulation on arm64 (steamrt/tasks#845)
* Improve forwarding of signals to child processes (steamrt/tasks#991)
* Update `srt-bwrap` to bubblewrap 0.11.2

### Diagnostic tools

* When using `STEAM_COMPAT_LAUNCHER_SERVICE`, try harder to find a `steam-runtime-launcher-service` of a matching architecture (steamrt/tasks#998)

### SDK

* Update packages from Debian 11 LTS:
    * `libarchive_3.4.3-2+deb11u4` (CVE-2026-4111, CVE-2026-4424, CVE-2026-4426, CVE-2026-5121)
    * `linux_5.10.251-3`

## Steam Linux Runtime 3.0 (sniper) depot 3.0.20260415.224995 (Steampipe build ID 22818263)

*contains
[steam-runtime-tools 0.20260414.0](https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/tags/v0.20260414.0),
built using
[flatdeb-steam 0.20260310.0](https://gitlab.steamos.cloud/steamrt/flatdeb-steam/-/tags/v0.20260310.0);
steamrt/tasks#979; released as beta 2026-04-16, promoted to stable 2026-05-11*

### Platform libraries

* Update SDL to 3.4.4 (steamrt/tasks#975)
* Update sdl2-compat to 2.32.66 (steamrt/tasks#975)
* Make SDL prefer X11 over Wayland, for compatibility with the Steam Overlay (steamrt/tasks#984) and games that require/assume X11 or GLX (steamrt/tasks#983, [steam-runtime#812](https://github.com/ValveSoftware/steam-runtime/issues/812), [Source-1-Games#7934](https://github.com/ValveSoftware/Source-1-Games/issues/7934))
* Update packages from Debian 11 LTS:
    * `gdk-pixbuf_2.42.2+dfsg-1+deb11u5` (CVE-2026-5201)
    * `libpng1.6_1.6.37-3+deb11u3` (CVE-2026-33416, CVE-2026-33636)
    * `python3.9_3.9.2-1+deb11u6` (CVE-2026-6100)
    * `systemd_247.3-7+deb11u8` (CVE-2026-4105, CVE-2026-29111, CVE-2026-40225, CVE-2026-40226)

### Diagnostic tools

* Improve clarity of steam-runtime-system-info output when there are no issues to report (steamrt/tasks#837)

## Steam Linux Runtime 3.0 (sniper) depot 3.0.20260331.220801 (Steampipe build ID 22604250)

*contains
[steam-runtime-tools 0.20260327.0](https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/tags/v0.20260327.0),
built using
[flatdeb-steam 0.20260310.0](https://gitlab.steamos.cloud/steamrt/flatdeb-steam/-/tags/v0.20260310.0);
steamrt/tasks#951; released as beta 2026-04-01*

### Platform libraries

* Update packages from Debian 11 LTS:
    * `nss_2:3.61-1+deb11u5` (CVE-2026-2781)

### Container runtime

* More correct handling of Vulkan environment variables, particularly `$VK_IMPLICIT_LAYER_PATH` and `$VK_ADD_IMPLICIT_LAYER_PATH` (steamrt/tasks#964, [steam-runtime#808](https://github.com/ValveSoftware/steam-runtime/issues/808))
* Avoid `$PRESSURE_VESSEL_VARIABLE_DIR` being inherited by the command inside the container (steamrt/tasks#956)

### Diagnostic tools

* More correct handling of Vulkan environment variables, particularly `$VK_IMPLICIT_LAYER_PATH` and `$VK_ADD_IMPLICIT_LAYER_PATH` (steamrt/tasks#964, [steam-runtime#808](https://github.com/ValveSoftware/steam-runtime/issues/808))
* Clearer output if there are no locale issues to report (steamrt/tasks#837)

## Steam Linux Runtime 3.0 (sniper) depot 3.0.20260316.216289 (Steampipe build ID 22381420)

*contains
[steam-runtime-tools 0.20260313.0](https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/tags/v0.20260313.0);
built using
[flatdeb-steam 0.20260310.0](https://gitlab.steamos.cloud/steamrt/flatdeb-steam/-/tags/v0.20260310.0);
steamrt/tasks#927; released as beta 2026-03-17, promoted to stable 2026-04-01, rolled back to 3.0.20260218.209091 on 2026-04-10*

This update was temporarily reverted due to a regression seen in some SDL games, mainly the older Source Engine titles. A future beta will re-apply the updates while avoiding the regression.

### Platform libraries

* Update SDL to 3.4.2 (steamrt/tasks#911)
* Use sdl2-compat to implement SDL 2 by default (steamrt/tasks#774)
    * If this causes a regression for specific games, "classic" SDL 2 can be forced by using Launch Options `STEAM_COMPAT_RUNTIME_SDL2=classic %command%` after reporting the bug
* Update VKD3D to 1.19 (steamrt/tasks#881, steamrt/tasks#928, steamrt/tasks#929)
* Add SDL3_mixer (steamrt/tasks#577, [steam-runtime#776](https://github.com/ValveSoftware/steam-runtime/issues/776))
    * This is currently 64-bit-only. Building new games as 64-bit is encouraged, and the 32-bit version of new libraries will not necessarily be added.
* Update packages from Debian 11 LTS:
    * `ca-certificates_20230311+deb12u1~deb11u1`, dropping local changes that were recently backported into Debian 11 LTS
    * `glib2.0_2.66.8-1+deb11u8` (CVE-2026-0988, CVE-2026-1484, CVE-2026-1485, CVE-2026-1489)
    * `gnutls28_3.7.1-5+deb11u9` (CVE-2025-9820, CVE-2025-14831)
    * `libvpx_1.15.0-2.1+deb13u1` (CVE-2026-2447, CVE-2026-1861)
    * `openssl_1.1.1w-0+deb11u5` (CVE-2025-68160, CVE-2025-69418, CVE-2025-69419, CVE-2025-69420, CVE-2025-69421, CVE-2026-22795, CVE-2026-22796)

### Container runtime

* Make more Nvidia driver libraries available, if present on host (steamrt/tasks#914)
* Make host GBM backends available for FEX thunks (steamrt/tasks#900)

### Diagnostic tools

* Don't diagnose steamrt3c as unofficial

### SDK

* Update packages from Debian 11 LTS:
    * Linux kernel headers 5.10.251-1
* Avoid merged-/usr file collisions when using the SDK as a debug runtime (steamrt/tasks#932)

## Steam Linux Runtime 3.0 (sniper) depot 3.0.20260218.209091 (Steampipe build ID  22023831)

*contains
[steam-runtime-tools 0.20260218.0](https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/tags/v0.20260218.0),
built using
[flatdeb-steam 0.20260206.0](https://gitlab.steamos.cloud/steamrt/flatdeb-steam/-/tags/v0.20260206.0);
steamrt/tasks#896; released as beta 2026-02-20, promoted to stable 2026-03-17*

### Platform libraries

* Update sdl2-compat to 2.32.64 (steamrt/tasks#905)
    * "Classic" SDL2 is still the default in this branch, but sdl2-compat is likely to become the default in a future release (steamrt/tasks#774)
* Update SDL3_image to 3.4.0 (steamrt/tasks#899)
* Update packages from Debian 11 LTS:
    * `alsa-lib_1.2.4-1.1+deb11u1` (CVE-2026-25068)
    * `libpng1.6_1.6.37-3+deb11u2` (CVE-2026-22801, CVE-2026-22695, CVE-2026-25646)
    * `python3.9_3.9.2-1+deb11u5` (CVE-2022-37454, CVE-2025-4516, CVE-2025-6069, CVE-2025-6075, CVE-2025-8194, CVE-2025-8291, CVE-2025-12084, CVE-2025-13836, CVE-2025-13837,  CVE-2025-11468, CVE-2025-15282, CVE-2025-15366, CVE-2025-15367, CVE-2026-0672, CVE-2026-0865, CVE-2026-1299)

### Container runtime

* "Capture" GBM backend modules from the graphics provider. These are needed for accelerated EGL in some Nvidia driver versions, and for some streaming-related use-cases since Mesa 24.3.0. (steamrt/tasks#900, [steam-runtime#797](https://github.com/ValveSoftware/steam-runtime/issues/797))
* Optionally "capture" OpenXR layers from the graphics stack provider into the container, similar to Vulkan layers. Like its equivalent for OpenXR runtimes, this is considered experimental, and could cause regressions by pulling in layers with non-trivial shared library dependencies, so for now it is only done if requested by setting environment variable `PRESSURE_VESSEL_IMPORT_OPENXR_1_LAYERS` to `1`. (steamrt/tasks#734, [steam-runtime#765](https://github.com/ValveSoftware/steam-runtime/issues/765))
* Always use the Steam Runtime's time zone info `/usr/share/zoneinfo`, even if the host OS's glibc defaults to something non-FHS ([steam-runtime#795](https://github.com/ValveSoftware/steam-runtime/issues/795))
* pressure-vessel includes local copies of `srt-logger`, `s-r-check-requirements`, `s-r-steam-remote` (steamrt/tasks#669)

### Diagnostic tools

* `steam-runtime-system-info` detects GBM backends (steamrt/tasks#900)
* `steam-runtime-system-info` detects OpenXR layers (steamrt/tasks#733)

### SDK

* Update packages from Debian 11 LTS:
    * `linux_5.10.249-1`
    * `python3-urllib3_1.26.5-1~exp1+deb11u3` (CVE-2026-21441)
    * `sudo_1.9.5p2-3+deb11u3` (CVE-2023-28486, CVE-2023-28487)
* The sysroot tarball no longer contains `/dev` (steamrt/tasks#903)

## Steam Linux Runtime 3.0 (sniper) depot 3.0.20260119.200241 (Steampipe build ID 21588693)

*contains
[steam-runtime-tools 0.20260115.0](https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/tags/v0.20260115.0),
built using
[flatdeb-steam 0.20260115.0](https://gitlab.steamos.cloud/steamrt/flatdeb-steam/-/tags/v0.20260115.0);
steamrt/tasks#882; released 2026-01-21, promoted to stable 2026-02-20*

### Platform libraries

* Update SDL 3 to 3.4.0 (steamrt/tasks#772)
* Update SDL_image to 3.2.6 (steamrt/tasks#884)
* Update sdl2-compat to 2.32.62 (steamrt/tasks#883)
    * "Classic" SDL2 is still the default in this branch, but sdl2-compat is likely to become the default in a future release (steamrt/tasks#774)
* Merge modified packages from Debian 11 LTS:
    * `curl_7.74.0-1.3+deb11u16` (CVE-2025-9086)

### Container runtime

* Add infrastructure for an architecture-specific ld.so.conf, and use it to provide Exherbo's architecture-specific ld.so.conf filenames ([steam-runtime#791](https://github.com/ValveSoftware/steam-runtime/issues/791))

### SDK

* `registry.gitlab.steamos.cloud/steamrt/sniper/sdk/arm64-on-amd64:beta` provides cross-compiler toolchains for arm64 on x86 (steamrt/tasks#856)
* Generate cross-compiler toolchain files for CMake and Meson, included in `steamrt-crossbuild-arm64` and the above image
* For symmetry, `steamrt-crossbuild-amd64` and `steamrt-crossbuild-i386` also exist and can be installed into an arm64 container (you will most likely also need `steamrt-libdevel:amd64` or `steamrt-libdevel:i386`)
* Update packages from Debian 11 LTS:
    * `gnupg2_2.2.27-2+deb11u3` (CVE-2025-68973)
    * `python-urllib3_1.26.5-1~exp1+deb11u2` (CVE-2025-50181, CVE-2025-66418)
* Improve use of Signed-By in `/etc/apt/sources.list` (steamrt/tasks#794, steamrt/tasks#889)
* Improve automated test coverage (steamrt/tasks#856)

## Steam Linux Runtime 3.0 (sniper) depot 3.0.20251216.191774 (Steampipe build ID 21261575)

*contains
[steam-runtime-tools 0.20251210.0](https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/tags/v0.20251210.0),
built using
[flatdeb-steam 0.20250916.0](https://gitlab.steamos.cloud/steamrt/flatdeb-steam/-/tags/v0.20250916.0);
steamrt/tasks#876; released as beta 2025-12-19, promoted to stable 2026-01-21*

### Platform libraries

* Update SDL to version 3.2.28 (steamrt/tasks#875)
* Update sdl2-compat to version 2.32.60 (steamrt/tasks#874)
* Update packages from Debian 11 LTS:
    * `glib2.0_2.66.8-1+deb11u7` (CVE-2025-13601, CVE-2025-14087, CVE-2025-14512, CVE-2025-4373, CVE-2025-7039)
    * `libpng1.6_1.6.37-3+deb11u1` (CVE-2025-64505, CVE-2025-64506, CVE-2025-64720, CVE-2025-65018, CVE-2025-66293)
    * `libsndfile_1.0.31-2+deb11u2` (CVE-2021-4156)
    * `libsoup2.4_2.72.0-2+deb11u3` (CVE-2025-4945, CVE-2025-4476, CVE-2025-4948, CVE-2025-4969)
    * `tzdata_2025b-0+deb11u2` (update leap second data)

### Container runtime

* CPU emulators can now declare `server_argv` (steamrt/tasks#833, steamrt/tasks#870)
* Fix error reporting for some failure cases in `main()`

### SDK

* Update packages from Debian 11 LTS:
    * Linux kernel headers v5.10.247

---

## Older versions

* [2025](Sniper release notes/2025)
* [2024](Sniper release notes/2024)
* [2023](Sniper release notes/2023)
* [2022](Sniper release notes/2022)
