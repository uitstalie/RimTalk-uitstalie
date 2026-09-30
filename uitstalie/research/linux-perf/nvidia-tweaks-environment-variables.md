> 来源: https://deepwiki.com/ventureoo/nvidia-tweaks/2.3-environment-variables
> 标题: ventureoo/nvidia-tweaks - Environment Variables (DeepWiki)
> 抓取: HTTP 200 | Content-Type: text/html; charset=utf-8 | 原始字节: 342511

---

Loading...

Index your code with Devin
DeepWiki DeepWiki ventureoo/nvidia-tweaks

Index your code with

Devin
Edit Wiki Share

Loading...

Last indexed: 3 July 2025 ( 177833 )

- Overview

- Installation

- Configuration

- Kernel Module Parameters

- Device Management Rules

- Environment Variables

- System Services

- Use Cases

- Gaming and Performance

- Wayland Desktop

- Hybrid Graphics (PRIME)

- Power Management

- Technical Reference

- System Architecture

- File Reference

- Troubleshooting

- License

Menu

# Environment Variables

Relevant source files

- README.md

This page covers runtime environment variables used with NVIDIA drivers on Linux systems. These variables modify driver behavior, application compatibility, and system integration at runtime. For kernel module parameters that are set at boot time, see Kernel Module Parameters . For udev-based device management, see Device Management Rules .

## Overview

Environment variables in the nvidia-tweaks context serve three primary purposes:

- Driver optimization variables - NVIDIA-specific OpenGL and Vulkan performance tuning

- Display protocol variables - Wayland compositor compatibility and integration

- PRIME offload variables - Hybrid graphics rendering control

These variables can be set system-wide in /etc/environment , per-user in shell profiles, or per-application through launchers and gaming platforms.

## NVIDIA Driver Performance Variables

### OpenGL Optimization Variables

The NVIDIA driver provides several OpenGL-specific environment variables for performance tuning:

| Variable | Default | Purpose
| __GL_THREADED_OPTIMIZATIONS | 0 (disabled) | Enable multi-threaded OpenGL processing
| __GL_MaxFramesAllowed | 2 | Control frame buffering behavior
| __GL_YIELD | unset | Configure CPU yielding strategy
| __GL_SHADER_DISK_CACHE_SKIP_CLEANUP | 0 (disabled) | Disable shader cache size limits

#### Threaded Optimizations

```

This enables multi-threaded OpenGL processing, similar to Mesa's mesa_glthread . The variable should be used selectively as it can cause performance regressions or application crashes in some games.

#### Frame Buffering Control

```

Controls driver frame buffering behavior. Setting to "1" can reduce input latency by eliminating frame queuing, while "3" enables triple buffering for higher FPS with VSync enabled.

#### CPU Yielding Strategy

```

Configures how the driver yields CPU resources. The USLEEP value can reduce CPU load and latency in some scenarios.

Sources: README.md 298-342

### Vulkan and Compute Variables

```

Forces Vulkan applications to use the NVIDIA GPU in PRIME offload configurations, bypassing the integrated graphics.

## Wayland Integration Variables

### Core Wayland Variables

For Wayland compositor compatibility with NVIDIA GPUs, several environment variables are essential:

```

The GBM_BACKEND=nvidia-drm variable enables NVIDIA's GBM implementation for Wayland compositors. The WLR_NO_HARDWARE_CURSORS=1 variable works around cursor rendering issues in wlroots-based compositors.

### Application Integration Variables

```

These variables configure specific application frameworks:

- SDL_VIDEODRIVER=wayland forces SDL applications to use native Wayland

- QT_QPA_PLATFORM="wayland;xcb" enables Qt5 Wayland support with X11 fallback

- MOZ_DBUS_REMOTE=1 enables clipboard sharing between Wayland and Xwayland applications

- _JAVA_AWT_WM_NONREPARENTING=1 fixes Java AWT applications on tiling window managers

Sources: README.md 255-273

## PRIME Offload Variables

### Hybrid Graphics Control

For laptops with hybrid graphics configurations, PRIME offload variables control which GPU renders specific applications:

```

These variables collectively force an application to use the discrete NVIDIA GPU instead of integrated graphics.

### Runtime Usage

The variables can be used per-application:

```

Sources: README.md 534-571

## Configuration and Deployment

### System-Wide Configuration

Environment Variable Flow

```

Sources: README.md 266-267

### Variable Categories and Effects

Environment Variable Categories

```

Sources: README.md 292-351

### Recommended Configurations

#### Gaming Configuration

For gaming workloads, selective application of performance variables is recommended:

```

#### Wayland Desktop Configuration

For Wayland desktop environments, system-wide configuration in /etc/environment :

```

#### PRIME Offload Configuration

For hybrid graphics systems, per-application offload control:

```

Sources: README.md 255-273 README.md 349-351 README.md 534-571

## Security and Performance Considerations

### System-Wide vs Application-Specific

The README strongly advises against system-wide deployment of NVIDIA performance variables:

I strongly advise against specifying the above environment variables for the whole system. Please specify them for specific applications/games with nvidia-settings or using Lutris/Steam.

This recommendation stems from compatibility issues where some applications may crash or perform poorly with these optimizations enabled globally.

### Application Compatibility

Certain combinations of environment variables can cause application crashes:

- __GL_THREADED_OPTIMIZATIONS=1 causes Gamescope to crash

- Some native games (like Metro series) cannot run with threaded optimizations

- Chromium/Electron applications may be unstable on Wayland with NVIDIA

Sources: README.md 307-310 README.md 349-351 README.md 269-271

## Integration with Other Components

Environment variables work alongside other nvidia-tweaks components:

- Kernel module parameters (configured via /etc/modprobe.d/nvidia-tweaks.conf ) set boot-time driver behavior

- Udev rules (configured via /etc/udev/rules.d/60-nvidia.rules ) manage device initialization

- System services handle suspend/resume operations

The environment variables provide the runtime layer of configuration that applications see when they initialize graphics contexts.

Sources: README.md 292-351 README.md 255-273

Dismiss Refresh this wiki
Enter email to refresh

### On this page

- Environment Variables

- Overview

- NVIDIA Driver Performance Variables

- OpenGL Optimization Variables

- Threaded Optimizations

- Frame Buffering Control

- CPU Yielding Strategy

- Vulkan and Compute Variables

- Wayland Integration Variables

- Core Wayland Variables

- Application Integration Variables

- PRIME Offload Variables

- Hybrid Graphics Control

- Runtime Usage

- Configuration and Deployment

- System-Wide Configuration

- Variable Categories and Effects

- Recommended Configurations

- Gaming Configuration

- Wayland Desktop Configuration

- PRIME Offload Configuration

- Security and Performance Considerations

- System-Wide vs Application-Specific

- Application Compatibility

- Integration with Other Components
