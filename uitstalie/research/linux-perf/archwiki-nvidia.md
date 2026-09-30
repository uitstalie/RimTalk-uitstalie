> 来源: https://wiki.archlinux.org/title/NVIDIA
> 标题: Arch Wiki - NVIDIA
> 抓取: HTTP 200 | Content-Type: text/html; charset=UTF-8 | 原始字节: 112092

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

# NVIDIA

8 languages

- Deutsch

- Español

- Magyar

- 日本語

- Português

- Русский

- Türkçe

- 中文（简体）

From ArchWiki

Related articles

- NVIDIA/Tips and tricks

- NVIDIA/Troubleshooting

- Nouveau

- NVIDIA Optimus

- PRIME

- Bumblebee

- nvidia-xrun

- Vulkan

This article covers the official NVIDIA graphics card drivers. For the community open-source driver, see Nouveau . If you have a laptop with hybrid graphics, see also NVIDIA Optimus .

## Installation

Warning Avoid installing the NVIDIA driver through the package provided from the NVIDIA website. Installation through pacman allows upgrading the driver together with the rest of the system.

Note When dual booting on a system with hybrid graphics , enabling Windows or third-party apps Eco mode (like ASUS Eco mode ) may fully disable the NVIDIA discrete GPU, making it undetectable.

First, find the family of your card (e.g. NV110, NVC0, etc.) on nouveau wiki's code names page corresponding to its model/official name obtained with:

```
$ lspci -k -d ::03xx

Then, install the appropriate driver for your card:

| GPU family

| Driver

| Status

| Blackwell (GBXXX) and newer

| nvidia-open for linux
nvidia-open-lts for linux-lts
nvidia-open-dkms for any kernel(s)

| Recommended by upstream
Current, supported 1

| Ada Lovelace (NV190/ADXXX)
Ampere (NV170/GAXXX)
Turing (NV160/TUXXX)

| nvidia-open for linux (possible crashes on Ampere-equipped laptops 2 )
nvidia-open-lts for linux-lts
nvidia-open-dkms for any kernel(s)
or
nvidia-580xx-dkms AUR (proprietary)

| Supported

| Volta (NV140/GV100)
Pascal (NV130/GPXXX)
Maxwell (NV110/GMXXX)

| nvidia-580xx-dkms AUR

| Legacy, supported

| Kepler (NVE0/GKXXX)

| nvidia-470xx-dkms AUR

| Legacy, unsupported 3,4

| Fermi (NVC0/GF1XX)

| nvidia-390xx-dkms AUR

| Tesla (NV50/G80-90-GT2XX)

| nvidia-340xx-dkms AUR

| Curie (NV40/G70) and older

| No longer packaged

- If these packages do not work (usually due to new hardware releases), nvidia-open-beta AUR may have a newer version that offers support.

- NVIDIA's GSP firmware is known to cause issues, including complete failure on some laptops containing Ampere GPUs . If affected, use the proprietary driver (e.g. nvidia-580xx-dkms AUR ) with the module parameter NVreg_EnableGpuFirmware=0 instead.

- May not function correctly on Linux 5.18 (or later) on systems with Intel CPUs 11th Gen and newer due an incompatibility with Indirect Branch Tracking . You can disable it by setting the ibt=off kernel parameter from the boot loader . Be aware, this security feature is responsible for mitigating a class of exploit techniques .

- NVIDIA no longer actively supports these cards and their drivers may not officially support the current Xorg version . It might be easier to use the nouveau driver; however, NVIDIA's legacy drivers are still available and might provide better 3D performance/stability.

Note

- When installing dkms , read Dynamic Kernel Module Support#Installation .

- The DKMS variants are not tied to a specific kernel, as they recompile the NVIDIA kernel module for each kernel for which header files are installed.

For 32-bit application support, also install the corresponding lib32 package from the multilib repository (e.g. lib32-nvidia-utils ).

The nvidia-utils package contains a file which blacklists the nouveau module once you reboot. Optionally, you can also remove kms from the HOOKS array in /etc/mkinitcpio.conf and regenerate the initramfs . This will prevent the initramfs from containing the nouveau module making sure the kernel cannot load it during early boot.

Note

- Wayland users should not restart before following #DRM kernel mode setting or they may end up with a black screen. They can then continue to #Wayland configuration .

- Xorg users can continue to #Xorg configuration .

### Custom kernel

Ensure your kernel has CONFIG_DRM_SIMPLEDRM=y , and if using CONFIG_DEBUG_INFO_BTF , then the following line is needed in the PKGBUILD (since kernel 5.16):

```
install -Dt "$builddir/tools/bpf/resolve_btfids" tools/bpf/resolve_btfids/resolve_btfids

If your kernel is compiled with CONFIG_NOVA_CORE enabled, you may need to prevent the new NVIDIA GPU driver Nova from loading. nvidia-utils adds it to the blacklist by default. You can check this by running systemd-analyze . If you have installed a different version of the driver, you may need to blacklist the nova_core and nova_drm modules manually.

### DRM kernel mode setting

Kernel mode setting (KMS) is required to make Wayland compositors function properly. KMS is also required for native Wayland rendering on NVIDIA dedicated GPUs for hybrid graphics setups. NVIDIA does not support automatic KMS late loading without enabling DRM ( Direct Rendering Manager ). Starting from nvidia-utils 560.35.03-5, DRM is enabled by default .

To verify that DRM is actually enabled, execute the following:

```
# cat /sys/module/nvidia_drm/parameters/modeset

Which should now return Y , and not N .

For drivers older than version 560, manually set the modeset=1 kernel module parameter for the nvidia_drm module.

Officially supported kernels enable simpledrm , while NVIDIA driver requires efifb or vesafb when its own fbdev is disabled (or unavailable, with driver versions older than 545): see BBS#307164 for a possible workaround if you experience issues.

#### Early loading

For basic functionality, just adding the kernel parameter should suffice. If you want to ensure it is loaded as early as possible, or you are noticing startup issues (such as the nvidia kernel module being loaded after the display manager ), you can add nvidia , nvidia_modeset , nvidia_uvm and nvidia_drm to the initramfs. See Kernel module#Early module loading to learn how to configure your initramfs generator.

Note Early loading the modules will break hibernation, as video memory preservation is enabled by default.

### Hardware accelerated video decoding

Accelerated video decoding with VDPAU is supported on GeForce 8 series cards and newer. Accelerated video decoding with NVDEC is supported on Fermi (~400 series) cards and newer. See Hardware video acceleration for details.

### Hardware accelerated video encoding with NVENC

NVENC requires the nvidia_uvm module and the creation of related device nodes under /dev .

The latest driver package provides a udev rule which creates device nodes automatically, so no further action is required.

If you are using an old driver (e.g. nvidia-340xx-dkms AUR ), you need to create device nodes. Invoking the nvidia-modprobe utility automatically creates them. You can create /etc/udev/rules.d/70-nvidia.rules to run it automatically:

```
/etc/udev/rules.d/70-nvidia.rules

```
ACTION=="add", DEVPATH=="/bus/pci/drivers/nvidia", RUN+="/usr/bin/nvidia-modprobe -c 0 -u"

## Wayland configuration

Regarding Xwayland take a look at Wayland#Xwayland .

For further configuration options, take a look at the wiki pages or documentation of the respective compositor .

Note Prior to driver version 555.xx, or when using a Wayland compositor that does not support Explicit Sync via the linux-drm-syncobj-v1 protocol, the NVIDIA driver can have major issues manifesting as flickering, out of order frames, and more, in both native Wayland and Xwayland applications.

### Basic support

There are two kernel parameters for the nvidia_drm module to be considered: modeset and fbdev . Both are enabled by default when using the nvidia-utils package. NVIDIA also plans to enable them by default in a future release .

#### modeset

Enabling modeset is necessary for all Wayland configurations to function properly.

For unsupported drivers, where modeset needs to be enabled manually, see #DRM kernel mode setting , and Wayland#Requirements for more information.

#### fbdev

The supported driver versions from NVIDIA provide a framebuffer . For legacy driver versions that are no longer supported, enabling the fbdev kernel module parameter for the nvidia_drm module might be necessary for some Wayland configurations.

It is specifically a hard requirement on Linux 6.11 and later, but it is currently unclear whether this is intended behavior or a bug, see [1] for more details.

To verify that the NVIDIA framebuffer is actually enabled, execute the following:

```
# cat /sys/module/nvidia_drm/parameters/fbdev

It will return Y if the framebuffer is enabled.

### Suspend support

Wayland suspend can suffer from the defaults more than X does, see /Tips and tricks#Preserve video memory after suspend for details.

If you use GDM, also see GDM#Wayland and the proprietary NVIDIA driver .

### nvidia-application-profiles-rc.d

Some Wayland compositors will consume a large quantity of VRAM by default if the GLVidHeapReuseRatio application profile key is not applied against their process name . For example, niri users can free up to ~2.5GiB of idle VRAM consumption with the following:

```
/etc/nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-wayland-compositors.json

```
{
"rules": [
{
"pattern": {
"feature": "procname",
"matches": "niri"
},
"profile": "Limit free buffer pool on Wayland compositors"
}
],
"profiles": [
{
"name": "Limit free buffer pool on Wayland compositors",
"settings": [
{
"key": "GLVidHeapReuseRatio",
"value": 0
}
]
}
]
}

## Xorg configuration

The proprietary NVIDIA graphics card driver does not need any Xorg server configuration file. You can start X to see if the Xorg server will function correctly without a configuration file. However, it may be required to create a configuration file (prefer /etc/X11/xorg.conf.d/20-nvidia.conf over /etc/X11/xorg.conf ) in order to adjust various settings. This configuration can be generated by the NVIDIA Xorg configuration tool, or it can be created manually. If created manually, it can be a minimal configuration (in the sense that it will only pass the basic options to the Xorg server), or it can include a number of settings that can bypass Xorg's auto-discovered or pre-configured options.

Tip For more configuration options, see NVIDIA/Troubleshooting .

### Automatic configuration

The nvidia-utils package includes an automatic configuration tool to create a Xorg server configuration file ( xorg.conf ) and can be run with:

```
# nvidia-xconfig

It will auto-detect and create (or edit, if already present) the /etc/X11/xorg.conf configuration according to present hardware; see nvidia-xconfig(1) .

Double-check your /etc/X11/xorg.conf to make sure your default depth, horizontal sync, vertical refresh, and resolutions are acceptable.

### nvidia-settings

The nvidia-settings tool lets you configure many options using either CLI or GUI. Running nvidia-settings without any options launches the GUI. For CLI options, see nvidia-settings(1) .

You can run the CLI/GUI as a non-root user and save the settings to ~/.nvidia-settings-rc by using the option Save Current Configuration under nvidia-settings Configuration tab.

To load the ~/.nvidia-settings-rc for the current user:

```
$ nvidia-settings --load-config-only

See Autostarting to start this command on every boot.

Note Xorg may not start or crash on startup after saving nvidia-settings changes. Adjusting or deleting the generated ~/.nvidia-settings-rc and/or Xorg file(s) should recover normal startup.

### Manual configuration

Several tweaks (which cannot be enabled automatically or with nvidia-settings ) can be performed by editing your configuration file. The Xorg server will need to be restarted before any changes are applied.

See NVIDIA Accelerated Linux Graphics Driver README and Installation Guide for additional details and options.

#### Minimal configuration

A basic configuration block in 20-nvidia.conf (or deprecated in xorg.conf ) would look like this:

```
/etc/X11/xorg.conf.d/20-nvidia.conf

```
Section "Device"
Identifier "NVIDIA Card"
Driver "nvidia"
VendorName "NVIDIA Corporation"
BoardName "GeForce GTX 1050 Ti"
EndSection

#### Disabling the logo on startup

If you are using an old driver ( nvidia-340xx-dkms AUR ), you may want to disable the NVIDIA logo splash screen that is displayed at X startup. Add the "NoLogo" option under section Device :

```
Option "NoLogo" "1"

#### Overriding monitor detection

The "ConnectedMonitor" option under section Device allows overriding monitor detection when X server starts, which may save a significant amount of time at start up. The available options are: "CRT" for analog connections, "DFP" for digital monitors and "TV" for televisions.

The following statement forces the NVIDIA driver to bypass startup checks and recognize the monitor as DFP:

```
Option "ConnectedMonitor" "DFP"

Note Use "CRT" for all analog 15 pin VGA connections, even if the display is a flat panel. "DFP" is intended for DVI, HDMI, or DisplayPort digital connections only.

#### Enabling brightness control

This article or section is out of date.

Reason: Potentially obsolete [2] , upstream package also seems to be ancient. (Discuss in Talk:NVIDIA )

Add to kernel parameters:

```
nvidia.NVreg_RegistryDwords=EnableBrightnessControl=1

Alternatively, add the following under section Device :

```
Option "RegistryDwords" "EnableBrightnessControl=1"

If brightness control still does not work with this option, try installing nvidia-bl-dkms AUR .

Note Installing nvidia-bl-dkms AUR will provide a /sys/class/backlight/nvidia_backlight/ interface to backlight brightness control, but your system may continue to issue backlight control changes on /sys/class/backlight/acpi_video0/ . One solution in this case is to watch for changes on, e.g. acpi_video0/brightness with inotifywait and to translate and write to nvidia_backlight/brightness accordingly. See Backlight#sysfs modified but no brightness change .

#### Enabling SLI

This article or section is out of date.

Reason: Since version 455.23.04, some SLI modes are no longer supported. (Discuss in Talk:NVIDIA )

Warning Since the GTX 10xx Series (1080, 1070, 1060, etc) only 2-way SLI is supported. 3-way and 4-way SLI may work for CUDA/OpenCL applications, but will most likely break all OpenGL applications.

Taken from the NVIDIA driver's README Appendix B: This option controls the configuration of SLI rendering in supported configurations. A "supported configuration" is a computer equipped with an SLI-Certified Motherboard and 2 or 3 SLI-Certified GeForce GPUs.

Find the first GPU's PCI Bus ID using lspci :

```
# lspci -d ::03xx

```
00:02.0 VGA compatible controller: Intel Corporation Xeon E3-1200 v2/3rd Gen Core processor Graphics Controller (rev 09)
03:00.0 VGA compatible controller: NVIDIA Corporation GK107 [GeForce GTX 650] (rev a1)
04:00.0 VGA compatible controller: NVIDIA Corporation GK107 [GeForce GTX 650] (rev a1)
08:00.0 3D controller: NVIDIA Corporation GM108GLM [Quadro K620M / Quadro M500M] (rev a2)

Add the BusID (3 in the previous example) under section Device :

```
BusID "PCI:3:0:0"

Note The format is important. The BusID value must be specified as "PCI:<BusID>:0:0"

Add the desired SLI rendering mode value under section Screen :

```
Option "SLI" "AA"

The following table presents the available rendering modes.

| Value
| Behavior

| 0, no, off, false, Single
| Use only a single GPU when rendering.

| 1, yes, on, true, Auto
| Enable SLI and allow the driver to automatically select the appropriate rendering mode.

| AFR
| Enable SLI and use the alternate frame rendering mode.

| SFR
| Enable SLI and use the split frame rendering mode.

| AA
| Enable SLI and use SLI antialiasing. Use this in conjunction with full scene antialiasing to improve visual quality.

Alternatively, you can use the nvidia-xconfig utility to insert these changes into xorg.conf with a single command:

```
# nvidia-xconfig --busid=PCI:3:0:0 --sli=AA

To verify that SLI mode is enabled from a shell:

```
$ nvidia-settings -q all | grep SLIMode

```
Attribute 'SLIMode' (arch:0.0): AA
'SLIMode' is a string attribute.
'SLIMode' is a read-only attribute.
'SLIMode' can use the following target types: X Screen.

Warning After enabling SLI, your system may become frozen/non-responsive upon starting xorg. It is advisable that you disable your display manager before restarting.

If this configuration does not work, you may need to use the PCI Bus ID provided by nvidia-settings ,

```
$ nvidia-settings -q all | grep -i pcibus

```
Attribute 'PCIBus' (host:0[gpu:0]): 101.
'PCIBus' is an integer attribute.
'PCIBus' is a read-only attribute.
'PCIBus' can use the following target types: GPU, SDI Input Device.
Attribute 'PCIBus' (host:0[gpu:1]): 23.
'PCIBus' is an integer attribute.
'PCIBus' is a read-only attribute.
'PCIBus' can use the following target types: GPU, SDI Input Device.

and comment out the PrimaryGPU option in your xorg.d configuration,

```
/usr/share/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf

```
...

Section "OutputClass"
...
# Option "PrimaryGPU" "yes"
...

Using this configuration may also solve any graphical boot issues.

### Multiple monitors

See Multihead for more general information.

#### Using nvidia-settings

The nvidia-settings tool can configure multiple monitors.

For CLI configuration, first get the CurrentMetaMode by running:

```
$ nvidia-settings -q CurrentMetaMode

```
Attribute 'CurrentMetaMode' (hostnmae:0.0): id=50, switchable=no, source=nv-control :: DPY-1: 2880x1620 @2880x1620 +0+0 {ViewPortIn=2880x1620, ViewPortOut=2880x1620+0+0}

Save everything after the :: to the end of the attribute (in this case: DPY-1: 2880x1620 @2880x1620 +0+0 {ViewPortIn=2880x1620, ViewPortOut=2880x1620+0+0} ) and use it to reconfigure your displays with nvidia-settings --assign "CurrentMetaMode= your_meta_mode " .

Tip You can create shell aliases for the different monitor and resolution configurations you use.

#### ConnectedMonitor

This article or section is out of date.

Reason: Option "TwinView" is removed in 302.07, and TwinView is always enabled, this configuration needs to be rewritten. (Discuss in Talk:NVIDIA )

If the driver does not properly detect a second monitor, you can force it to do so with ConnectedMonitor.

```
/etc/X11/xorg.conf

```

Section "Monitor"
Identifier "Monitor1"
VendorName "Panasonic"
ModelName "Panasonic MICRON 2100Ex"
HorizSync 30.0 - 121.0 # this monitor has incorrect EDID, hence Option "UseEDIDFreqs" "false"
VertRefresh 50.0 - 160.0
Option "DPMS"
EndSection

Section "Monitor"
Identifier "Monitor2"
VendorName "Gateway"
ModelName "GatewayVX1120"
HorizSync 30.0 - 121.0
VertRefresh 50.0 - 160.0
Option "DPMS"
EndSection

Section "Device"
Identifier "Device1"
Driver "nvidia"
Option "NoLogo"
Option "UseEDIDFreqs" "false"
Option "ConnectedMonitor" "CRT,CRT"
VendorName "NVIDIA Corporation"
BoardName "GeForce 6200 LE"
BusID "PCI:3:0:0"
Screen 0
EndSection

Section "Device"
Identifier "Device2"
Driver "nvidia"
Option "NoLogo"
Option "UseEDIDFreqs" "false"
Option "ConnectedMonitor" "CRT,CRT"
VendorName "NVIDIA Corporation"
BoardName "GeForce 6200 LE"
BusID "PCI:3:0:0"
Screen 1
EndSection

The duplicated device with Screen is how you get X to use two monitors on one card without TwinView . Note that nvidia-settings will strip out any ConnectedMonitor options you have added.

#### TwinView

This article or section is being considered for removal.

Reason: TwinView, and more generally Xinerama, is no longer supported by NVIDIA's open driver starting from version 610.43.02 (Discuss in Talk:NVIDIA )

You want only one big screen instead of two. Set the TwinView argument to 1 . This option should be used if you desire compositing. TwinView only works on a per-card basis, when all participating monitors are connected to the same card.

```
Option "TwinView" "1"

Example configuration:

```
/etc/X11/xorg.conf.d/10-monitor.conf

```
Section "ServerLayout"
Identifier "TwinLayout"
Screen 0 "metaScreen" 0 0
EndSection

Section "Monitor"
Identifier "Monitor0"
Option "Enable" "true"
EndSection

Section "Monitor"
Identifier "Monitor1"
Option "Enable" "true"
EndSection

Section "Device"
Identifier "Card0"
Driver "nvidia"
VendorName "NVIDIA Corporation"

#refer to the link below for more information on each of the following options.
Option "HorizSync" "DFP-0: 28-33; DFP-1: 28-33"
Option "VertRefresh" "DFP-0: 43-73; DFP-1: 43-73"
Option "MetaModes" "1920x1080, 1920x1080"
Option "ConnectedMonitor" "DFP-0, DFP-1"
Option "MetaModeOrientation" "DFP-1 LeftOf DFP-0"
EndSection

Section "Screen"
Identifier "metaScreen"
Device "Card0"
Monitor "Monitor0"
DefaultDepth 24
Option "TwinView" "True"
SubSection "Display"
Modes "1920x1080"
EndSubSection
EndSection

Device option information .

If you have multiple cards that are SLI capable, it is possible to run more than one monitor attached to separate cards (for example: two cards in SLI with one monitor attached to each). The "MetaModes" option in conjunction with SLI Mosaic mode enables this. Below is a configuration which works for the aforementioned example and runs GNOME flawlessly.

```
/etc/X11/xorg.conf.d/10-monitor.conf

```
Section "Device"
Identifier "Card A"
Driver "nvidia"
BusID "PCI:1:00:0"
EndSection

Section "Device"
Identifier "Card B"
Driver "nvidia"
BusID "PCI:2:00:0"
EndSection

Section "Monitor"
Identifier "Right Monitor"
EndSection

Section "Monitor"
Identifier "Left Monitor"
EndSection

Section "Screen"
Identifier "Right Screen"
Device "Card A"
Monitor "Right Monitor"
DefaultDepth 24
Option "SLI" "Mosaic"
Option "Stereo" "0"
Option "BaseMosaic" "True"
Option "MetaModes" "GPU-0.DFP-0: 1920x1200+4480+0, GPU-1.DFP-0:1920x1200+0+0"
SubSection "Display"
Depth 24
EndSubSection
EndSection

Section "Screen"
Identifier "Left Screen"
Device "Card B"
Monitor "Left Monitor"
DefaultDepth 24
Option "SLI" "Mosaic"
Option "Stereo" "0"
Option "BaseMosaic" "True"
Option "MetaModes" "GPU-0.DFP-0: 1920x1200+4480+0, GPU-1.DFP-0:1920x1200+0+0"
SubSection "Display"
Depth 24
EndSubSection
EndSection

Section "ServerLayout"
Identifier "Default"
Screen 0 "Right Screen" 0 0
Option "Xinerama" "0"
EndSection

##### Vertical sync using TwinView

If you are using TwinView and vertical sync (the Sync to VBlank option in nvidia-settings ), you will notice that only one screen is being properly synced, unless you have two identical monitors. Although nvidia-settings does offer an option to change which screen is being synced (the Sync to this display device option), this does not always work. A solution is to add the following environment variables at startup, for example append in /etc/profile :

```
export __GL_SYNC_TO_VBLANK=1
export __GL_SYNC_DISPLAY_DEVICE=DFP-0
export VDPAU_NVIDIA_SYNC_DISPLAY_DEVICE=DFP-0

You can change DFP-0 with your preferred screen ( DFP-0 is the DVI port and CRT-0 is the VGA port). You can find the identifier for your display from nvidia-settings in the X Server XVideoSettings section.

##### Gaming using TwinView

In case you want to play full-screen games when using TwinView, you will notice that games recognize the two screens as being one big screen. While this is technically correct (the virtual X screen really is the size of your screens combined), you probably do not want to play on both screens at the same time.

To correct this behavior for SDL 1.2, try:

```
export SDL_VIDEO_FULLSCREEN_HEAD=1

For OpenGL, add the appropriate Metamodes to your xorg.conf in section Device and restart X:

```
Option "Metamodes" "1680x1050,1680x1050; 1280x1024,1280x1024; 1680x1050,NULL; 1280x1024,NULL;"

Another method that may either work alone or in conjunction with those mentioned above is starting games in a separate X server .

#### Mosaic mode

Mosaic mode is the only way to use more than 2 monitors across multiple graphics cards with compositing. Your window manager may or may not recognize the distinction between each monitor. Mosaic mode requires a valid SLI configuration. Even if using Base mode without SLI, the GPUs must still be SLI capable/compatible.

##### Base Mosaic

Base Mosaic mode works on any set of GeForce 8000 series or higher GPUs. It cannot be enabled from within the nvidia-setting GUI. You must either use the nvidia-xconfig command line program or edit xorg.conf by hand. Metamodes must be specified. The following is an example for four DFPs in a 2x2 configuration, each running at 1920x1024, with two DFPs connected to each of two cards:

```
# nvidia-xconfig --base-mosaic --metamodes="GPU-0.DFP-0: 1920x1024+0+0, GPU-0.DFP-1: 1920x1024+1920+0, GPU-1.DFP-0: 1920x1024+0+1024, GPU-1.DFP-1: 1920x1024+1920+1024"

Note While the documentation lists a 2x2 configuration of monitors, GeForce cards are artificially limited to 3 monitors in Base Mosaic mode. Quadro cards support more than 3 monitors. As of September 2014, the Windows driver has dropped this artificial restriction, but it remains in the Linux driver.

##### SLI Mosaic

If you have an SLI configuration and each GPU is a Quadro FX 5800, Quadro Fermi or newer, then you can use SLI Mosaic mode. It can be enabled from within the nvidia-settings GUI or from the command line with:

```
# nvidia-xconfig --sli=Mosaic --metamodes="GPU-0.DFP-0: 1920x1024+0+0, GPU-0.DFP-1: 1920x1024+1920+0, GPU-1.DFP-0: 1920x1024+0+1024, GPU-1.DFP-1: 1920x1024+1920+1024"

## NVSwitch

This article or section needs expansion.

Reason: The install instructions should be made into an AUR package. There are also no installation instructions of the OFED/MOFED drivers on Arch. (Discuss in Talk:NVIDIA )

The factual accuracy of this article or section is disputed.

Reason: The following instructions haven't been thoroughly tested on the hardware systems in question. (Discuss in Talk:NVIDIA )

From the NVIDIA page :

NVIDIA NVSwitch is a high-bandwidth, low-latency fabric that connects multiple GPUs in one system. [...] The switch behaves as a crossbar so GPUs can reach each other at NVLink rates, which matters for multi-GPU workloads that exchange data in memory on a single node.
For system support of such hardware, e.g. the DGX H100 devices, NVIDIA's Fabric Manager (FM) must be installed, as well as a kernel module matching the Fabric Manager version. Without the FM, programs like pytorch (from python-pytorch ) would be unable to find the GPUs.

Note

- NVIDIA does not officially support the Fabric Manager on Arch Linux. Only on certain Ubuntu and CentOS versions .

- The Fabric Manager is not currently available as a package on neither the official repositories or the AUR.

### Installing Fabric Manager

The FM requires the libraries libibumad3 and infiniband-diags to be installed on the target system. You can get these libraries on Arch by installing the rdma-core package.

As for the FM itself, first download the tarball from NVIDIA. Then, in the install script sbin/fm_run_package_installer.sh , set LIB_LOC to /usr/lib (after the if ... fi block). Otherwise, the libraries would be installed to architecture-dependent sub-directories (e.g. /usr/lib/x86_64-linux-gnu ) which are not supported on Arch Linux.

### Kernel driver for Fabric Manager

On DGX B200/B300, NVIDIA HGX B200/B300, and NVIDIA HGX B100 systems, an OFED or a MOFED driver is required, which are not officially distributed for Arch systems.

For other hardware systems, follow #Installation . Make sure the installed module's and the FM's versions match, and reboot the system.

The nvidia-fabricmanager service should have been automatically enabled by the install script, and thus started after a reboot.

## Tips and tricks

See NVIDIA/Tips and tricks .

## Troubleshooting

See NVIDIA/Troubleshooting .

## See also

- Current graphics driver releases in official NVIDIA Forum

- NVIDIA Developers Forum - Linux Subforum

Retrieved from " https://wiki.archlinux.org/index.php?title=NVIDIA&oldid=884018 "

Categories :
- Graphics

- X server

Hidden categories:
- Pages or sections flagged with Template:Out of date

- Sections flagged with Template:Remove

- Pages or sections flagged with Template:Expansion

- Pages or sections flagged with Template:Accuracy

Search

NVIDIA

Add topic
