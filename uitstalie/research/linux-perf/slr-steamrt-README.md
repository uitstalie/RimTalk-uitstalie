> 来源: https://gitlab.steamos.cloud/steamrt/steamrt/-/blob/steamrt/sniper/README.md
> 标题: steamrt (dependency metapackages) README - sniper branch
> 抓取: HTTP 200 (via GitLab API v4 raw)

---

Steam Runtime 3 'sniper'
========================

Steam Runtime 3 'sniper' is a Linux runtime environment for Steam.
Instead of forming a `LD_LIBRARY_PATH` that merges the host OS's shared
libraries with the shared libraries provided by Valve, it uses Linux
namespace (container) technology to build a more predictable environment.

This runtime is used for Proton 8.0, 9.0 and 10.0, and for some native Linux
games such as
Battle for Wesnoth,
Counter-Strike 2,
Dota 2,
Endless Sky and
Retroarch.

For new native Linux games,
using [steamrt4][] instead is recommended.
steamrt4 is also used for Proton 11.

It is structurally the same as the [Steam Runtime 2 'soldier'][soldier]
environment used by Proton 5.13, 6.3 and 7.0, but it is based on Debian 11
instead of Debian 10, so most of the included libraries are approximately
2 years newer.

sniper was previously also used internally by Steam to run the
`steamwebhelper` process that provides most of Steam's user interface,
but that role has now been taken by [steamrt3c][].

* [General information about the container runtimes][container runtimes]
* [Release notes][]
* [SDK][]
* [Guide for game developers][]

Requirements
------------

The various Steam Runtime components share several
[assumptions about the host distribution][distro assumptions] with
the Steam client.

How this fits into the overall Steam Runtime project
----------------------------------------------------

1. Build .deb packages for the content of the Steam Runtime.
    `steamrt` is one of these packages.

2. Put together the .deb packages into a Flatpak-style container runtime.
    This step is done by [flatdeb-steam][],
    but the choice of the actual packages to include is mostly delegated to
    `steamrt`.

3. Turn the container runtime into a Steampipe depot. This is controlled by
    the `populate-depot` script and requires adding a copy of the
    `pressure-vessel` container runtime launcher, both of which are part of
    [steam-runtime-tools][].
    The dependencies for `pressure-vessel` are taken from
    [Steam Runtime 1 'scout'][scout]
    to ensure that it can be run on any system that is able to run the
    Steam client.

Release notes
-------------

[Release notes for sniper updates are available][Release notes].
The newest entries in these release notes will often describe beta
releases that are not yet installed by default.

Where can I get it?
-------------------

The "Steam Linux Runtime 3.0 (sniper)" compatibility tool (app ID 1628350)
can be added to your Steam library in the same way as older container
runtimes.
It will install into `steamapps/common/SteamLinuxRuntime_sniper`.
The third-party SteamDB site tracks it as
<https://steamdb.info/app/1628350/>.

Installing or upgrading a game that runs in the sniper environment will
download this compatibility tool automatically.
It can also be installed by running this command:

    steam steam://install/1628350

A public beta version is available.
To activate this, locate "Steam Linux Runtime 3.0 (sniper)" in your Steam
library, open the Properties dialog, and select a beta branch from the
Betas tab.
Please report any regressions as
[Steam Runtime issues][]
so that they can be fixed.

<https://repo.steampowered.com/steamrt3/images/> contains
several versions of sniper. Each version's subdirectory contains:

* source code in the `sources` subdirectory
* detached debug symbols in the `dbgsym` subdirectory
* "Platform" container images that can run games
  (`*.Platform-*-runtime.tar.gz`, which can also be converted into Flatpak
  runtimes)
* "SDK" container images that can run games with debugging tools available
  (`*.Sdk-*-runtime.tar.gz` and `*.Sdk-*-debug.tar.gz`,
  which can also be converted into Flatpak runtimes)
* "Platform" container images for testing and QA
  (`*.Platform-*-sysroot.tar.gz`, and `*.Platform-*-sysroot.Dockerfile`,
  which are published as a Docker image via the
  [steamrt/sniper/platform Gitlab project][Platform])
* "SDK" container images for compiling your own software
  (`*.Sdk-*-sysroot.tar.gz`, and `*.Sdk-*-sysroot.Dockerfile`,
  which are published as a Docker image via the
  [steamrt/sniper/sdk Gitlab project][SDK])

What's in this repository?
--------------------------

This repository mostly provides "metapackages". This is Debian jargon for
a package that is (almost) empty, and pulls in desired packages by having
dependencies on them.

In the Steam Runtime, we are mainly interested in x86 PCs.
Our containers require a 64-bit x86 PC and use the `amd64` architecture
(Debian's name for 64-bit PCs, also known as `x86_64`).
For compatibility with older software, they also provide `i386` libraries
(Debian's name for 32-bit PCs, also known as `i586`, `i686` or IA-32).

There is also an experimental version of the runtime for `arm64`
(64-bit ARM, also known as `aarch64`).
This does not provide a secondary architecture,
which means that 32-bit ARM binaries are not supported.

The Platform container that is used to run games consists of:

* `steamrt-container` (primary architecture only)
* `steamrt-container-host-compat` (the x86 runtime has both `amd64` and `i386`)
* `steamrt-customizations` (primary architecture only)
* `steamrt-libs` (the x86 runtime has both `amd64` and `i386`)
* `steamrt-toolbx` (primary architecture only)

The SDK container used for debugging and compilation is based on the
Platform, and adds:

* `steamrt-dev` (primary architecture only)
* `steamrt-libdevel` (the x86 runtime has both `amd64` and `i386`)
* `steamrt-libdevel-non-multiarch` (primary architecture only)
* `steamrt-libdebug` (the x86 runtime has both `amd64` and `i386`)
* `steamrt-libdebug-non-multiarch` (primary architecture only)

Developing software that runs in sniper
---------------------------------------

A SDK environment is available as an OCI image, suitable for use with
OCI-compatible container tools such as Docker, Podman and Toolbx.
Please see [the SDK project][SDK] for more details.

A [guide for game developers][] provides more information on how to build
and debug games in the sniper environment.

Native Linux games that require sniper can be released on Steam.
Since October 2024, this is available as a "self-service"
feature via the Steamworks partner web interface, which can be used by
any game that benefits from a newer library stack.
To use this feature, your app must first set up a Launch Option that
supports Linux.
Once that is set up, you can use the Installation → Linux Runtime
menu item to select a runtime.

Early adopters of the sniper runtime include the Valve games
Counter-Strike 2 and
Dota 2,
and the third-party games
Battle for Wesnoth,
Endless Sky and
Retroarch.
As of early 2024, all of these games use sniper for all branches.
It is also possible to set up a game so that it will use sniper for a
beta branch, but not for its default branch, to prepare for a graceful
transition from scout to sniper.

Backporting policy
------------------

### What we can backport into sniper

This is more liberal than [scout][], because we're using a container
runtime.

In general, we can backport application-level libraries like Pipewire
and SDL, subject to some conditions:

  * The library needs to have a proper SONAME with a stable ABI,
    for example `libpipewire-0.3.so.0`.
  * If the new library has runtime dependencies which aren't satisfied
    by the Steam Runtime, we need to backport those first, or patch the
    library to avoid the dependencies.
  * If the new library has build-time dependencies which aren't satisfied
    by the Steam Runtime, we need to backport those first, or patch the
    build system to avoid the dependencies.

If the library is, or might become, part of the dependency stack for
user-space graphics drivers like Mesa, then there are some more
requirements, which in practice usually cannot be met for graphics drivers:

  * There needs to be a minor ABI version number in the library's
    physical filename, which goes up with each release.
    For example, `libpipewire-0.3.so.0 -> libpipewire-0.3.so.0.339.0`
    is suitable: each new release increases the minor ABI version.
    However, `libdrm.so.2 -> libdrm.so.2.4.0` is not suitable (see below).

If the library is not part of the dependency stack for graphics drivers
(for example GTK, GNUTLS, Pipewire, SDL), then we can backport invididual
bug-fixes and features without backporting an entire new upstream version.

If the library might become part of the dependency stack for graphics
drivers (for example glibc, zlib, libelf, libgcc, libstdc++), then we can
still can backport invididual bug-fixes and features without backporting
an entire new upstream version, but Steam and games cannot rely on having
those bug-fixes and features at runtime, because our library might have
been overridden by a newer upstream version from the host system.

### Preferred versions to backport

If we can, we prefer to backport the version that was included in a
stable release of Debian or an LTS release of Ubuntu, in preference to
using an intermediate version. This gives us a source for security and
bugfix updates.

The most likely version to be able to backport is the version from the
*next* stable release of Debian, for example backporting from Debian 12
into sniper - this matches official Debian backports. We can use a
version from bullseye-backports as-is, if it exists.

If we need a version newer than what's in the current Debian stable release,
we prefer to use the version from Debian testing or unstable, but in this
case we should plan to track its updates until the next stable release.

If we need a version newer than what's in Debian unstable, we can go to
experimental or the latest upstream version, but we need to be careful to
track newer releases in this case.

### What we can't backport

We cannot backport libraries that are closely related to the graphics
stack, notably the libraries built by Mesa, including `libgbm.so.1`. The
Steam Runtime is designed to use the version of Mesa from the host
system, to maximize the probability that it will work with the user's
kernel and hardware. For details of the specific libraries involved,
see the implementation of the `gl:` match expression in libcapsule.

We cannot safely backport libraries where the minor ABI version in
the physical filename does not increase, if they are or might become
part of the dependency stack of a graphics driver. For example,
`libdrm.so.2 -> libdrm.so.2.4.0` stays the same across multiple releases,
even while adding new ABI. This means we cannot tell whether our bundled
version is older or newer than the host version, which means we cannot
guarantee that games will be using a version that is the same as or
newer than our backport.

In general, we cannot safely backport libraries that have undergone
non-backwards-compatible changes while keeping the same SONAME.

We generally should not backport bug-fixes and new features that have
not been included in upstream's version control system, and preferably
included in a formal release as well.

<!-- References: -->

[Guide for game developers]: https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/blob/main/docs/slr-for-game-developers.md
[Release notes]: https://gitlab.steamos.cloud/steamrt/steamrt/-/wikis/Sniper-release-notes
[Platform]: https://gitlab.steamos.cloud/steamrt/sniper/platform
[SDK]: https://gitlab.steamos.cloud/steamrt/sniper/sdk
[Steam Runtime issues]: https://github.com/ValveSoftware/steam-runtime/issues
[container runtimes]: https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/blob/main/docs/container-runtime.md
[distro assumptions]: https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/blob/main/docs/distro-assumptions.md
[flatdeb-steam]: https://gitlab.steamos.cloud/steamrt/flatdeb-steam
[scout]: https://gitlab.steamos.cloud/steamrt/steamrt/-/blob/steamrt/scout/README.md
[soldier]: https://gitlab.steamos.cloud/steamrt/steamrt/-/blob/steamrt/soldier/README.md
[steamrt3c]: https://gitlab.steamos.cloud/steamrt/steamrt/-/blob/steamrt/steamrt3c/README.md
[steamrt4]: https://gitlab.steamos.cloud/steamrt/steamrt/-/blob/steamrt/steamrt4/README.md
[steam-runtime-tools]: https://gitlab.steamos.cloud/steamrt/steam-runtime-tools

