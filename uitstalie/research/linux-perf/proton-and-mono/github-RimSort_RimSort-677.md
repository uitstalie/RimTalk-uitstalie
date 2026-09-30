> 来源: https://github.com/RimSort/RimSort/issues/677
> 抓取方式: GitHub REST API (/repos/RimSort/RimSort/issues/677)

# Allow Linux Users to Run With Proton

- 仓库: RimSort/RimSort
- 编号: #677 (Issue)
- 状态: closed  |  创建: 2024-11-09T03:12:42Z  |  更新: 2026-01-14T18:15:18Z  |  关闭: 2026-01-14T18:15:18Z
- 作者: niceiq
- 标签: feature/improvement 🆕, Linux🐧
- 评论数: 11
- URL: https://github.com/RimSort/RimSort/issues/677

## 正文

### Origin of idea

I am playing RimWorld on Linux using Steam's Proton.

I was really excited to use RimSort to start a new modded adventure, but it doesn't look like I could launch the game.

I get the following error:

```
RimSort could not start RimWorld as the game executable does not exist at the specified path: /home/iq/.local/share/Steam/steamapps/common/RimWorld/RimWorldLinux. Please check that this directory is correct and the RimWorld game executable exists in it
```

I've been looking at the wiki, and online to see if I missed a settings option, but without luck

### Suggestion/proposed solution?

I think a lot of Linux players rely on Proton for most of their gaming. 

There are some for which running natively does not work/work well.  

The idea is to allow users to enable a "run using proton" option to launch the game with Proton.

### Alternatives considered

_No response_

### Additional context

_No response_

### Code of Conduct

I agree to follow this project's Code of Conduct

### Duplicate Issue Check

I've checked for similar issues and didn't find anything

### Wiki/FAQ Check

I've checked the Wiki for a solution and didn't find a solution

## 评论 (11)

### @NotAsami - 2025-01-19T13:08:27Z

Also happening on my machine, turning off proton fixed the issue, but that is not a good solution

### @Damglador - 2025-06-13T00:03:11Z

Why even use Proton for a native game?

### @ZetaArashi - 2025-06-20T01:16:36Z

> Why even use Proton for a native game?

In my case, because Proton actually handles some mods with more stability than native Linux does. I'm not sure why exactly, but it's generally a smoother experience. 

This would also be helpful because I run NixOS, which has a lot of custom needs and cannot run standard dynamically linked executables the way 'standard' Linux can. The tool 'steam-run' usually works as a workaround, but does *not* work with RimSort. As it's been indicated there's no interest in supporting NixOS directly (which, fair, niche use case) my only option for running RimSort is via Proton or by figuring out custom patching from source. 

Hence, Proton is a better use case for me, personally.

### @LionelColaso - 2025-06-20T02:11:12Z

How do you guys currently run RimWorld through proton ? for steam and without steam
so i can try and figure out a way to add support for it

i don't own the game on steam but i have a copy of Rimworld 1.4 for linux which i can use to add support 

### @ZetaArashi - 2025-06-27T01:42:07Z

> How do you guys currently run RimWorld through proton ? for steam and without steam so i can try and figure out a way to add support for it
> 
> i don't own the game on steam but i have a copy of Rimworld 1.4 for linux which i can use to add support

Just saw this, apologies on the delay! 

For my part, I launch directly through Steam:

![Image](https://github.com/user-attachments/assets/092bc3fe-d293-4c7c-8ca2-1ec28658a9e5)

RimSort is launched through Protontricks.


### @Continous - 2025-08-04T00:51:24Z

> This would also be helpful because I run NixOS, which has a lot of custom needs and cannot run standard dynamically linked executables the way 'standard' Linux can. The tool 'steam-run' usually works as a workaround, but does _not_ work with RimSort. As it's been indicated there's no interest in supporting NixOS directly (which, fair, niche use case) my only option for running RimSort is via Proton or by figuring out custom patching from source.

There is a now a package for rimsort for NixOS that solves these issues. Would be interested to hear if anyone actually has issues with specific mods under Linux but not Windows.

### @efzapa - 2025-08-20T23:27:44Z

> Why even use Proton for a native game?

super niche case but I need to use Proton because using Native Linux is horrible on superwide and somehow **still** does not support 3840x1080, despite Microsoft and Proton supporting it just fine

### @cebarks - 2025-12-14T02:13:54Z

This should be possible now with #1586, though it's not a seamless fallback which would probably be best.

### @Draconicrose - 2025-12-26T22:24:02Z

> Why even use Proton for a native game?

I have a multi-monitor setup and the native version's borderless window fullscreen is broken. They say it's a unity bug but the proton version works just fine.

### @cebarks - 2025-12-26T23:28:06Z

> > Why even use Proton for a native game?
> 
> I have a multi-monitor setup and the native version's borderless window fullscreen is broken. They say it's a unity bug but the proton version works just fine.

What distro are you using? wayland or plain X? What DE? I'm on fedora 43 and native works great for me.

### @LionelColaso - 2026-01-14T18:13:56Z

This should be fixed in https://github.com/RimSort/RimSort/pull/1714 please let me know if it's not fixed
