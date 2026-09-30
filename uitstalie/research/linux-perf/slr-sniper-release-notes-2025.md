> 来源: https://gitlab.steamos.cloud/steamrt/steamrt/-/wikis/Sniper-release-notes/2025
> 标题: Steam Linux Runtime 3.0 (sniper) release notes 2025
> 抓取: HTTP 200 (GitLab API v4 /wikis, 原始 Markdown)

---

[Newer versions](Sniper release notes)

---

## Steam Linux Runtime 3.0 (sniper) depot 3.0.20251216.191774 (Steampipe build ID 21261575)

*contains
[steam-runtime-tools 0.20251210.0](https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/tags/v0.20251210.0),
built using
[flatdeb-steam 0.20250916.0](https://gitlab.steamos.cloud/steamrt/flatdeb-steam/-/tags/v0.20250916.0);
steamrt/tasks#876; released as beta 2025-12-19*

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

## Steam Linux Runtime 3.0 (sniper) depot 3.0.20251202.187502 (Steampipe build ID 21041130)

*contains
[steam-runtime-tools 0.20251201.0](https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/tags/v0.20251201.0),
built using
[flatdeb-steam 0.20250916.0](https://gitlab.steamos.cloud/steamrt/flatdeb-steam/-/tags/v0.20250916.0);
steamrt/tasks#849; released as beta 2025-12-03, superseded 2025-12-19*

### Platform libraries

* Upgrade DXVK Native to version 2.7.1 (steamrt/tasks#778)
    * Note that this version requires Mesa 25.0+ or Nvidia proprietary driver 550.54.14+. These versions are available in Debian 13, Ubuntu 24.04 and their contemporaries, but not in older LTS distributions such as Debian 12 or Ubuntu 22.04. See [DXVK 2.7 release notes](https://github.com/doitsujin/dxvk/releases/tag/v2.7) for more information. Upgrading to the newest stable/LTS version of your distribution is recommended.
* Upgrade `gdbserver` to version 16.3, backported from Debian 13 (steamrt/tasks#871)
* Update packages from Debian 11 LTS:
    * `qtbase-opensource-src_5.15.2+dfsg-9+deb11u2` (CVE-2024-39936)

### Container runtime

* `/usr/lib64`, `/usr/lib32`, `/usr/lib/x86_64-linux-gnu` and other similar distro-specific directories are searched for libraries if the library is not present in `/etc/ld.so.cache` ([steam-runtime#704](https://github.com/ValveSoftware/steam-runtime/issues/704), steamrt/tasks#868)
* CPU-emulation enhancements (steamrt/tasks#809, steamrt/tasks#828, steamrt/tasks#831, steamrt/tasks#839, steamrt/tasks#844, steamrt/tasks#846, steamrt/tasks#847, steamrt/tasks#851, steamrt/tasks#865, steamrt/tasks#866, steamrt/tasks#868)
* `pv-adverb` no longer provides `--shell` or `--terminal` options: equivalent functionality has moved back into `pv-wrap` (steamrt/tasks#868) 
* Make `libsystemd.so.0` available in the container if possible, for optional Journal logging (steamrt/tasks#853)
* arm64 versions of pressure-vessel are now built in a steamrt3c environment, replacing Debian 11 which was previously used. x86 pressure-vessel is likely to move from scout to steamrt3c [when Steam requires glibc 2.31](https://help.steampowered.com/en/faqs/view/107F-BB20-FB5A-1CE4): officially this is a requirement already, but we're providing an additional grace period for now.
* An experimental `pressure-vessel-arm64+amd64+i386` relocatable tarball carries all the libraries and helper executables necessary to implement x86 CPU emulation on arm64 (steamrt/tasks#845)

### Diagnostic tools

* When testing a sysroot, use the sysroot's ld.so(8) and glibc to run helper executables where applicable, or skip tests where this is not enough (steamrt/tasks#828)

### SDK

* Upgrade `gdb` to version 16.3, backported from Debian 13 (steamrt/tasks#871)
* Update packages from Debian 11 LTS:
    * `libarchive_3.4.3-2+deb11u3` (CVE-2025-5914, CVE-2025-5916, CVE-2025-5917, CVE-2025-5918)
    * `unbound_1.13.1-1+deb11u7` (CVE-2025-11411)

## Steam Linux Runtime 3.0 (sniper) depot 3.0.20251110.180943 (Steampipe build ID 20785795)

*contains
[steam-runtime-tools 0.20251103.0](https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/tags/v0.20251103.0),
built using
[flatdeb-steam 0.20250916.0](https://gitlab.steamos.cloud/steamrt/flatdeb-steam/-/tags/v0.20250916.0);
steamrt/tasks#814; released as beta 2025-11-13, superseded 2025-12-03*

### Platform libraries

* Update SDL 3 to 3.2.26 (steamrt/tasks#819, steamrt/tasks#834)
* Update sdl2-compat to 2.32.58 (steamrt/tasks#817)
* Update packages from Debian 11 LTS:
    * `gdk-pixbuf_2.42.2+dfsg-1+deb11u4` (CVE-2025-7345)
    * `libxml2_2.9.10+dfsg-6.7+deb11u9` (CVE-2025-9714, CVE-2025-7425)
    * `openssl_1.1.1w-0+deb11u4` (CVE-2025-9230)
* Merge modified packages from Debian 11 LTS:
    * `tiff_4.2.0-1+deb11u7` (CVE-2024-13978, CVE-2025-9900)

### Container runtime

* Better compatibility with multiple architectures and CPU emulation (steamrt/tasks#785, steamrt/tasks#786, steamrt/tasks#821, steamrt/tasks#787)
* Change how we handle per-architecture modules for `LD_PRELOAD`, `LD_AUDIT`, VDPAU drivers, `SDL_DYNAMIC_API` and `SDL3_DYNAMIC_API` so it can scale to multiple architectures
* Fix a small memory leak while setting up VDPAU drivers

### Diagnostic tools

* Update steam-runtime-tools to 0.20251103.0
* Fix a memory leak in a rare error scenario

### SDK

* Add `libjson-perl`, `libjson-xs-perl`, `libutfcpp-dev` (steamrt/tasks#812)
* Update packages from Debian 11 LTS:
    * `git_1:2.30.2-1+deb11u5` (CVE-2025-27613, CVE-2025-46835, CVE-2025-48384)
    * `unbound_1.13.1-1+deb11u6` (CVE-2025-11411)
    * `xorg-server_2:1.20.11-1+deb11u17` (CVE-2025-62229, CVE-2025-62230, CVE-2025-62231)
    * Linux kernel headers 5.10.244
* A backport of `package-notes` from Debian 13 is available to install via apt, but is not part of the SDK (steamrt/tasks#772)

### Internal changes

* Lots of refactoring in libsteam-runtime-tools and pressure-vessel
* Better test coverage

## Steam Linux Runtime 3.0 (sniper) depot 3.0.20250929.168600 (Steampipe build ID 20178252)

*contains
[steam-runtime-tools 0.20250926.0](https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/tags/v0.20250926.0),
built using
[flatdeb-steam 0.20250916.0](https://gitlab.steamos.cloud/steamrt/flatdeb-steam/-/tags/v0.20250916.0);
steamrt/tasks#799; released as beta 2025-09-30, promoted to stable 2025-11-13*

### Platform libraries

* Update default SDL2 to 2.32.10 (steamrt/tasks#798)
* Update default SDL2 to provide `/usr/lib/*/sdl2-classic/`, in preparation for a future transition to sdl2-compat (steamrt/tasks#774)
* Resync sdl2-compat packaging with Debian testing (steamrt/tasks#774)
* Update SDL3 to 3.2.22 plus post-release bug fixes (steamrt/tasks#798)
* Backport root CA certificates for Sectigo Public Server Authentication Root E46, R46 (steamrt/tasks#797, Debian#1095913)
* Update packages from Debian 11 LTS:
    * `cups_2.3.3op2-3+deb11u10` (CVE-2025-58060, CVE-2025-58364)
    * `libsndfile_1.0.31-2+deb11u1` (CVE-2022-33065, CVE-2024-50612)
    * `libxslt_1.1.34-4+deb11u3` (CVE-2023-40403, CVE-2025-7424, CVE-2025-9714)
    * `pam_1.4.0-9+deb11u2` (CVE-2024-22365, CVE-2025-6020)

### Container runtime

* Fix a potential crash during game launch on unusual systems (steam-runtime-tools!849)
* Improve correctness of different JSON manifests referring to the same Vulkan/EGL/etc. driver on different architectures (steamrt/tasks#805)
* Fix handling of `LD_PRELOAD` values resembling `libfoo.so.0` (steam-runtime-tools!830)
* `STEAM_COMPAT_RUNTIME_SDL2=classic` will select "classic" SDL2, even in future versions where sdl2-compat might become the default (steamrt/tasks#774)
* Slightly improve startup performance by making better use of cache (steam-runtime-tools!831, steam-runtime-tools!832)
* Add experimental options to select separate graphics stack providers for x86_64 and i386 (steamrt/tasks#785)

### Diagnostic tools

* x86_64 is now sorted before i386 in `steam-runtime-system-info` output

### SDK

* Add `python3-requests` and its dependencies (steamrt/tasks#799)

### Internal changes

* pressure-vessel refactoring (steamrt/tasks#785, steamrt/tasks#786)

## Steam Linux Runtime 3.0 (sniper) depot 3.0.20250826.159138 (Steampipe build ID 19757659)

*contains
[steam-runtime-tools 0.20250820.0](https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/tags/v0.20250820.0),
built using
[flatdeb-steam 0.20250819.0](https://gitlab.steamos.cloud/steamrt/flatdeb-steam/-/tags/v0.20250819.0);
steamrt/tasks#776; released as beta 2025-08-27; promoted to stable 2025-09-30*

### Platform libraries

* Fix some DXVK D3D9 regressions (steamrt/tasks#781)
* Update SDL3 to 3.2.20 (steamrt/tasks#771)
* Resync sdl2-compat packaging with Debian forky, no functional changes
* Add `libnm.so.0` on arm64 (steamrt/tasks#779)
* Add `steamrt-archive-keyring` package, containing the apt repository signing keys (steamrt/tasks#751)
* Update packages from Debian 11 LTS:
    * `gnutls28_3.7.1-5+deb11u8` (CVE-2025-6395, CVE-2025-32988, CVE-2025-32990)
    * `libxml2_2.9.10+dfsg-6.7+deb11u8` (CVE-2024-34459, CVE-2025-6021, CVE-2025-6170, CVE-2025-49794, CVE-2025-49796)
    * `systemd_247.3-7+deb11u7` (CVE-2025-4598)

### Diagnostic tools

* Update steam-runtime-tools; no practical effect on this branch (steamrt/tasks#766, steamrt/tasks#767)

### SDK

* Re-export 2048-bit signing key with a stronger self-signature. This ensures that the apt-secure(8) infrastructure will continue to treat it as valid in 2026 and beyond. (steamrt/tasks#751)
* Mark a newly-generated 4096-bit signing key as trusted, starting the process of key rotation to this new key. We will sign the apt repository with both keys for a while, and the old key can eventually be phased out. (steamrt/tasks#751)
* Use `archive.debian.org` to download packages from Debian 11, except for packages that have a security update available
* Use `deb.debian.org` CDN to download security updates
* Add empty directories required by some Toolbx use-cases
* Add `flatpak-spawn` command to the `PATH`, required by some Toolbx use-cases
* Add `steamrt-archive-keyring` package, containing the apt repository signing keys (steamrt/tasks#751)

Old repository signing key fingerprint:

```
pub   rsa2048 2013-11-05 [SC]
      48FD43308E37C3A418B92A157DEEB7438ABDDD96
uid                      Valve SteamOS Release Key <steamos@steampowered.com>
```

[New repository signing key](https://gitlab.steamos.cloud/steamrt/flatdeb-steam/-/raw/master/suites/c948c57e-steam-runtime-2025.gpg?ref_type=heads) fingerprint:

```
pub   rsa4096 2025-08-18 [SC]
      93CF361A9F43CAF9823C72CB25A6D1CCC948C57E
uid                      Valve Steam Runtime repository signing key (2025)
```

## Steam Linux Runtime 3.0 (sniper) depot 3.0.20250723.149183 (Steampipe build ID 19501069)

*contains
[steam-runtime-tools 0.20250718.0](https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/tags/v0.20250718.0),
built using
[flatdeb-steam 0.20250616.0](https://gitlab.steamos.cloud/steamrt/flatdeb-steam/-/tags/v0.20250616.0);
steamrt/tasks#760; released as beta 2025-08-06, promoted to stable 2025-08-27*

### Platform libraries

* Update packages from Debian 11 LTS:
    * gdk-pixbuf (CVE-2025-6199)
    * sudo (CVE-2025-32462)

### SDK

* Update packages from Debian 11 LTS:
    * xorg-server (CVE-2025-49175, CVE-2025-49176, CVE-2025-49178, CVE-2025-49179, CVE-2025-49180)

## Steam Linux Runtime 3.0 (sniper) depot 3.0.20250616.139560 (Steampipe build ID 19052629)

*contains
[steam-runtime-tools 0.20250616.0](https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/tags/v0.20250616.0),
built using
[flatdeb-steam 0.20250616.0](https://gitlab.steamos.cloud/steamrt/flatdeb-steam/-/tags/v0.20250616.0);
steamrt/tasks#748; released as beta 2025-06-30; promoted to stable 2025-08-06*

### Platform libraries

* Update DXVK Native to 2.6.2 (steamrt/tasks#755)
* Update SDL 3 to 3.2.16 (steamrt/tasks#754)
* Update SDL 2 to 2.32.8 (steamrt/tasks#754)
* Update VKD3D to 1.16 (steamrt/tasks#744)
* Update packages from Debian 11 LTS:
    * glibc (CVE-2025-4802)
    * icu (CVE-2025-5222)
    * krb5 (CVE-2025-3576)
    * libvpx (CVE-2025-5283)
    * openssl (CVE-2024-13176)
* Merge modified packages from Debian 11 LTS:
    * curl (fix CVE-2023-27534 regression)

### Container runtime

* Avoid filenames containing `:` in `pressure-vessel/` (steamrt/tasks#746)
* Relax restrictions on `~` in filenames (steamrt/tasks#746)
* Optionally import OpenXR 1 runtimes from the graphics stack provider
    into the container, similar to the way Vulkan drivers are handled.
    This is considered experimental, and could cause regressions by
    pulling in runtimes with non-trivial shared library dependencies,
    so for now it is only done if requested by setting environment
    variable `PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES` to `1`.
    (steamrt/tasks#607)
* Write original path to Vulkan layers, etc. into JSON manifests.
    This allows the module to load other libraries via `${ORIGIN}` or load
    data files relative to its own location from `dladdr1()`, and helps
    gdb to load detached debug symbols via `.gnu_debuglink` references.
    (steamrt/tasks#736)
* Stop generating `SteamLinuxRuntime_sniper.sh`, no longer needed (steamrt/tasks#739)
* Stop generating `SteamLinuxRuntime_sniper.VERSIONS.txt`, no longer needed (steamrt/tasks#739)

### SDK

* Update packages from Debian 11 LTS:
    * setuptools (CVE-2025-47273)
    * Linux kernel headers to 5.10.237

## Steam Linux Runtime 3.0 (sniper) depot 3.0.20250519.130773 (Steampipe build ID 18646220)

*contains
[steam-runtime-tools 0.20250516.0](https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/tags/v0.20250516.0),
built using
[flatdeb-steam 0.20250410.0](https://gitlab.steamos.cloud/steamrt/flatdeb-steam/-/tags/v0.20250410.0);
steamrt/tasks#705; released as beta 2025-05-28; promoted to stable 2025-06-30*

### Platform libraries

* Update SDL 3 to 3.2.14 (steamrt/tasks#728)
* Update sdl2-compat to 2.32.56 (steamrt/tasks#728) (not yet used for SDL 2 games in sniper by default)
* Link `bash` with static `libtinfo` for better robustness (steamrt/tasks#341, steamrt/tasks#638)
* Update packages from Debian 11 LTS:
    * expat (CVE-2024-50602)
    * freetype (CVE-2025-27363)
    * glib2.0 (CVE-2025-3360, steamrt/tasks#725)
    * glibc (CVE-2025-0395)
    * libsoup2.4 (CVE-2025-2784, CVE-2025-32050, CVE-2025-32052, CVE-2025-32053, CVE-2025-32906, CVE-2025-32909, CVE-2025-32910, CVE-2025-32911, CVE-2025-32913, CVE-2025-32914, CVE-2025-32912, Debian#1091502)
    * libxml2 (CVE-2025-32414, CVE-2025-32415)
    * shadow (CVE-2023-4641, CVE-2023-29383)
    * tzdata (add America/Coyhaique)

### Container runtime

* Avoid distributing files whose names contain commas, brackets or Unicode (steamrt/tasks#719)
* Experimental aarch64 (arm64) Platform image, `registry.gitlab.steamos.cloud/steamrt/sniper/platform/arm64:beta` (steamrt/tasks#708)
    * This requires either an aarch64 CPU or transparent emulation via qemu

### Diagnostic tools

* Update steam-runtime-tools (steamrt/tasks#595, steamrt/tasks#708, steamrt/tasks#719, steamrt/tasks#724)
* steam-runtime-system-info now detects OpenXR runtimes (steamrt/tasks#608)

### SDK

* Experimental aarch64 (arm64) SDK image, `registry.gitlab.steamos.cloud/steamrt/sniper/sdk/arm64:beta` (steamrt/tasks#708)
    * This is a native SDK, not a cross-compiler, so it requires either an aarch64 CPU or transparent emulation via qemu
* The apt repository `deb https://repo.steampowered.com/steamrt3/apt sniper_beta main` now has arm64 packages
* Avoid Conflicts with `xdg-utils`, allowing more source packages to be built in the SDK
* Update packages from Debian 11 LTS:
    * abseil (CVE-2025-0838)
    * bubblewrap (add `--bind-fd`, `--ro-bind-fd`)
    * wget (CVE-2024-38428)

## Steam Linux Runtime 3.0 (sniper) depot 3.0.20250408.124536 (Steampipe build ID 18196166)

*contains
[steam-runtime-tools 0.20250408.0](https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/tags/v0.20250408.0),
built using
[flatdeb-steam 0.20250401.0](https://gitlab.steamos.cloud/steamrt/flatdeb-steam/-/tags/v0.20250401.0);
steamrt/tasks#695; released as beta 2025-04-22, promoted to stable 2025-05-28*

### Platform libraries

* Update SDL2 to 2.32.4 (steamrt/tasks#704)
* Update SDL3 to 3.2.10 (steamrt/tasks#704)
* Update sdl2-compat (not used by default) to 2.32.54 (steamrt/tasks#704)
* Update DXVK Native to 2.6.1, and enable its SDL3 windowing system interface in addition to SDL2 (steamrt/tasks#697)
* Update VKD3D to 1.15 (steamrt/tasks#704, steamrt/tasks#698)
* Merge libsdl2-mixer packaging updates from Debian testing
* Update packages from Debian 11 LTS:
    * libcap2 (CVE-2023-2602, CVE-2023-2603, CVE-2025-1390)
    * libxslt (CVE-2024-55549, CVE-2025-24855)
    * python3.9 (CVE-2025-0938, CVE-2022-0391, CVE-2025-1795)
    * tzdata 2025a (time zone update for Paraguay, no leap second on 2025-06-30)

### Container runtime

* Make the AT-SPI accessibility bus available in the container (steamrt/tasks#699)

### Diagnostic tools

* Improve correctness of the VA-API check (steamrt/tasks#702, [steam-runtime#752](https://github.com/ValveSoftware/steam-runtime/issues/752))

### SDK

* Update i686-linux-gnu-gcc-10 cross-compiler from 10.2.1 to 10.3.0 (steamrt/tasks#694)
* Strip debug symbols from i686-linux-gnu-gcc-10 cross-compiler to make the SDK much smaller (steamrt/tasks#694)
* Update gcc-14 backport to 14.2.0-19 from Debian testing, incorporating bug fixes from upstream gcc-14 branch up to 2025-03-15 (steamrt/tasks#672)
* Provide cross-compilers for i686-linux-gnu-gcc-14, etc. instead of wrappers around `gcc-14 -m32`, etc. (steamrt/tasks#672)
* Better `-dbgsym` coverage (steamrt/tasks#701)

## Steam Linux Runtime 3.0 (sniper) depot 3.0.20250306.120299 (Steampipe build ID 17679755)

*contains
[steam-runtime-tools 0.20250225.0](https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/tags/v0.20250225.0),
built using
[flatdeb-steam 0.20250225.0](https://gitlab.steamos.cloud/steamrt/flatdeb-steam/-/tags/v0.20250225.0);
steamrt/tasks#656; released as beta 2025-03-11, promoted to stable 2025-04-22*

### Platform libraries

* Update SDL 2 to 2.32.2 (steamrt/tasks#670, steamrt/tasks#686)
* Update SDL2_image to 2.8.8 (steamrt/tasks#668, steamrt/tasks#686)
* Update SDL2_mixer to 2.8.1 (steamrt/tasks#668)
* Update SDL 3 to 3.2.8 (steamrt/tasks#668, steamrt/tasks#686)
* Add SDL3_ttf (steamrt/tasks#576)
* Add sdl2-compat; note that this is off-by-default, and "classic" SDL2 is still the default for SDL2 games (steamrt/tasks#579, steamrt/tasks#668, steamrt/tasks#686)
* Update packages from Debian 11 LTS:
    * gnutls28 (CVE-2024-12243)
    * krb5 (CVE-2025-24528)
    * libtasn1-6 (CVE-2024-12133)
    * libxml2 (CVE-2024-25062, CVE-2023-45322, CVE-2023-39615, CVE-2022-49043, CVE-2024-56171, CVE-2025-24928, CVE-2025-27113)

### Container runtime

* Improve handling of `LD_PRELOAD` modules such as MangoHud (steamrt/tasks#595)
* Make it possible to select the experimental sdl2-compat via `STEAM_COMPAT_RUNTIME_SDL2=sdl2-compat %command%` in Launch Options (steamrt/tasks#579)

### SDK

* Add sdl2-compat automated and manual tests
* Add SDL3_image automated and manual tests
* Add SDL3_ttf manual tests
* Update packages from Debian 11 LTS:
    * Linux kernel headers 5.10.234
    * Xvfb (CVE-2025-26594, CVE-2025-26595, CVE-2025-26596, CVE-2025-26597, CVE-2025-26598, CVE-2025-26599, CVE-2025-26600, CVE-2025-26601)

## Steam Linux Runtime 3.0 (sniper) depot  3.0.20250210.116596 (Steampipe build ID 17326928)

*contains
[steam-runtime-tools 0.20250122.0](https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/tags/v0.20250122.0),
built using
[flatdeb-steam 0.20250129.0](https://gitlab.steamos.cloud/steamrt/flatdeb-steam/-/tags/v0.20250129.0);
steamrt/tasks#671; released as beta 2025-02-11, promoted to stable 2025-02-17*

### Platform libraries

* Update SDL 2 to 2.30.12 (steamrt/tasks#660)
* Update SDL 3 to 3.2.2 (steamrt/tasks#660)
* Add SDL3_image (steamrt/tasks#575)

### SDK

* Preinstall a backport of `gcc-14` and `g++-14`. Previously these were available via `apt`, but not preinstalled. (steamrt/tasks#623, steamrt/tasks#662)
    * Users of Meson can select this with `--native-file gcc-14.txt`, `--cross-file gcc-14-m32.txt` or `--cross-file i686-linux-gnu-gcc-14.txt`
    * Users of CMake can select this with `--toolchain=/usr/share/steamrt/cmake/gcc-14.cmake` or `--toolchain=/usr/share/steamrt/cmake/gcc-14-m32.cmake` or `--toolchain=/usr/share/steamrt/cmake/i686-linux-gnu-gcc-14.cmake`
    * Users of other build systems can select 64-bit output with `CC=gcc-14 CXX=g++-14` or similar, or with `PATH=/usr/lib/gcc-14/bin:$PATH`
    * Users of other build systems can select 32-bit output with `CC=i686-linux-gnu-gcc-14 CXX=i686-linux-gnu-g++-14` or similar, or by using the `-m32` option, or with `CC=i686-linux-gnu-gcc CXX=i686-linux-gnu-g++ PATH=/usr/lib/gcc-14/bin:$PATH`
* Preinstall the `mold` linker (steamrt/tasks#623, steamrt/tasks#639)
    * Users of Meson can select this with `--native-file gcc-14.txt --native-file mold.txt` or `--cross-file gcc-14-m32.txt --cross-file mold.txt`
    * Users of other build systems can select this with `LDFLAGS=-B/usr/libexec/mold` or similar, or with `PATH=/usr/libexec/mold:${PATH}`
* Add CMake toolchain files for all supported compilers ([SDL#12113](https://github.com/libsdl-org/SDL/issues/12113)). These can be selected via `cmake --toolchain`:
    * `/usr/share/steamrt/cmake/gcc{,-10,-14}.cmake`: 64-bit output
    * `/usr/share/steamrt/cmake/clang{,-11}.cmake`: 64-bit output
    * `/usr/share/steamrt/cmake/i686-linux-gnu-gcc{,-10,-14}.cmake`: 32-bit output
    * `/usr/share/steamrt/cmake/i686-linux-gnu-clang{,-11}.cmake`: 32-bit output
    * `/usr/share/steamrt/cmake/gcc{,-10,-14}-m32.cmake`: 32-bit output via `-m32`
* Add an example of how libogg and libvorbis can be used from CMake, and include it in automated test coverage ([steam-runtime#735](https://github.com/ValveSoftware/steam-runtime/issues/735))
* Update packages from Debian 11 LTS:
    * git (CVE-2024-50349, CVE-2024-52006)
* sdl2-compat 2.30.52 and SDL3_ttf preview release 3.1.0 are available from the `sniper_beta` branch in the apt repository (`apt install libsdl2-compat libsdl3-ttf-dev`). Note that this apt source is not enabled by default, even in beta SDKs: it can be configured in `/etc/apt/sources.list`. (steamrt/tasks#579)

## Steam Linux Runtime 3.0 (sniper) depot 3.0.20250123.114697 (Steampipe build ID 17108377)

*contains
[steam-runtime-tools 0.20250122.0](https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/tags/v0.20250122.0),
built using
[flatdeb-steam 0.20250115.0](https://gitlab.steamos.cloud/steamrt/flatdeb-steam/-/tags/v0.20250115.0);
steamrt/tasks#633; released as beta 2025-01-23, promoted to stable 2025-02-11*

### Platform libraries

* Add SDL 3, core library only (steamrt/tasks#554)
* Merge modified packages from Debian 11 LTS
    * tiff (CVE-2023-2908, CVE-2023-3316, CVE-2023-3618, CVE-2023-25433, CVE-2023-26965, CVE-2023-26966, CVE-2023-52356, CVE-2024-7006)

### Diagnostic tools

* Backport upstream bug fix for attaching `gdbserver` to 32-bit programs on AVX512-capable hardware (steamrt/tasks#631)
* Disable readline support in `pw-cli` for better robustness (steamrt/tasks#634, steamrt/tasks#341)
* Stop installing `pw-top` (steamrt/tasks#634, steamrt/tasks#341)
* Internal changes in `steam-runtime-tools`

### SDK

* Update packages from Debian 11 LTS:
    * busybox (CVE-2021-28831, CVE-2021-42374, CVE-2021-42378, CVE-2021-42379, CVE-2021-42380, CVE-2021-42381, CVE-2021-42382, CVE-2021-42384, CVE-2021-42385, CVE-2021-42386, CVE-2022-48174, CVE-2023-42364, CVE-2023-42365)
    * rsync (CVE-2024-12085, CVE-2024-12086, CVE-2024-12087, CVE-2024-12088, CVE-2024-12747)
* Backport mold linker v2.36.0 from Debian testing/unstable (steamrt/tasks#623)
* Make Meson machine-files more forward-compatible
* A backport of gcc-14 and g++-14 is available from the beta apt repository as `gcc-14-monolithic` (steamrt/tasks#623)
* An experimental preview build of SDL_image 3 is available from the ~~beta~~ apt repository. To try this, ~~add an apt source for `deb https://repo.steampowered.com/steamrt3/apt sniper_beta main contrib non-free`, then~~ `apt update` and `apt install libsdl3-image-dev`. Note that SDL_image 3 is not yet included in `SteamLinuxRuntime_sniper`, so it is not yet possible to ship games that require it. (steamrt/tasks#575)

## Steam Linux Runtime 3.0 (sniper) depot 3.0.20250108.112707 (Steampipe build ID 16954349)

*contains
[steam-runtime-tools 0.20250107.0](https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/tags/v0.20250107.0),
built using
[flatdeb-steam 0.20250106.0](https://gitlab.steamos.cloud/steamrt/flatdeb-steam/-/tags/v0.20250106.0);
steamrt/tasks#612; released as beta 2025-01-09, promoted to stable 2025-01-23*

Happy new year! Releases from this runtime branch are now versioned 3.0.YYYYMMDD.x instead of the previous 0.YYYYMMDD.x. This makes it clearer which branch a particular version number refers to, but doesn't represent any functional change.

### Platform libraries

* Update packages from Debian 11 LTS:
    * avahi (CVE-2023-1981, CVE-2023-38469, CVE-2023-38470, CVE-2023-38471, CVE-2023-38472, CVE-2023-38473)
    * libsoup2.4 (CVE-2024-52530, CVE-2024-52531, CVE-2024-52532)
    * python3.9 (CVE-2015-20107, CVE-2020-10735, CVE-2021-3426, CVE-2021-3733, CVE-2021-3737, CVE-2021-4189, CVE-2021-28861, CVE-2021-29921, CVE-2022-42919, CVE-2022-45061, CVE-2023-6597, CVE-2023-24329, CVE-2023-27043, CVE-2023-40217, CVE-2024-0397, CVE-2024-0450, CVE-2024-4032, CVE-2024-6232, CVE-2024-6923, CVE-2024-7592, CVE-2024-8088, CVE-2024-9287, CVE-2024-11168)
    * tzdata
* Update SDL to 2.30.11 (steamrt/tasks#616)
* Update SDL_image to 2.8.4 (steamrt/tasks#616)
* Update SDL_ttf to 2.24.0 (steamrt/tasks#616)

### Container runtime

* When unpacking `steam-runtime-sniper.tar.xz` for `steamwebhelper`, detect corrupted archives more quickly (this will need to be combined with changes in `steam.sh` to be fully effective). ([steam-for-linux#11602](https://github.com/ValveSoftware/steam-for-linux/issues/11602), steam-runtime-tools!775)

### SDK

* Merge modified packages from Debian 11 LTS:
    * debootstrap

### Internal changes

* The container runtime and diagnostic tools now treat environment variable `DEBUG_INVOCATION=1` as a request for detailed debug information
* Add infrastructure for providing newer packages in the Platform than in the SDK, in case we need a glibc backport or similar change in future (steamrt/tasks#619)

## Steam Linux Runtime 3.0 (sniper) depot 0.20241127.109710 (Steampipe build ID 16645450)

*contains
[steam-runtime-tools 0.20241125.0](https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/tags/v0.20241125.0),
built using
[flatdeb-steam 0.20240717.0](https://gitlab.steamos.cloud/steamrt/flatdeb-steam/-/tags/v0.20240717.0);
steamrt/tasks#601; released as beta 2024-12-05, promoted to stable 2025-01-09*

### Platform libraries

* Update packages from Debian 11 LTS:
    * glib2.0 (CVE-2024-52533)
    * mpg123 (CVE-2024-10573)
* Merge modified packages from Debian 11 LTS:
    * curl (CVE-2024-8096)
* Update DXVK Native to 2.5.1 (steamrt/tasks#591)
* Update VKD3D to 1.14 (steamrt/tasks#590)
* Backport a libwayland-cursor bug fix to avoid infinite recursion with misconfigured cursor themes (steamrt/tasks#572)

### Container runtime

* Interoperability with `systemd-homed` or remote user directories such as LDAP, when running games that disregard `$HOME` ([ValveSoftware/steam-runtime#705](https://github.com/ValveSoftware/steam-runtime/issues/705))

### Diagnostic tools

* Remove obsolete `--directory=''` from a debug hint shown by s-r-launcher-service

### SDK

* Provide both 32- and 64-bit development files for libgcrypt and libgpg-error (steamrt/tasks#604)


---

## Older versions

* [2024](Sniper release notes/2024)
* [2023](Sniper release notes/2023)
* [2022](Sniper release notes/2022)
