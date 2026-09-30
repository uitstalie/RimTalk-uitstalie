> 来源: https://github.com/RimSort/RimSort/issues/1442
> 抓取方式: GitHub REST API (/repos/RimSort/RimSort/issues/1442)

# Linux PopOS Cannot detect executable when setting game location

- 仓库: RimSort/RimSort
- 编号: #1442 (Issue)
- 状态: closed  |  创建: 2025-10-30T22:41:50Z  |  更新: 2025-10-31T15:20:57Z  |  关闭: 2025-10-31T15:20:57Z
- 作者: chartowal
- 标签: bugs 🪲
- 评论数: 3
- URL: https://github.com/RimSort/RimSort/issues/1442

## 正文

### Release Type

Self-Compiled

### Version

1.0.48/ 36618b9

### Operating System

Pop!_OS 22.04 LTS with NVIDIA

### Relevant logs

_No response_

### Describe the bug

When launching RimSort, I am prompted to set the file location paths for the game.  I use the autodetect function and it correctly finds all the file paths. 

I am unable to save the file path because of a popup error that reads: "The selected game folder does not contain a valid Rimworld executable."  
All the autodetected file paths stay saved in settings, except for game location. 

<img width="1920" height="1080" alt="Image" src="https://github.com/user-attachments/assets/39ba1842-34a7-44a7-a689-3694f8102602" />
<img width="1920" height="1080" alt="Image" src="https://github.com/user-attachments/assets/6b3030ea-ce9d-47a2-b11c-f9cdfac5732e" />

### Additional context

Recent convert to Linux so bear with me. 
As I understand it, Pop OS is based off a long term support version of Ubuntu, which is missing the glibc library needed to used the precompiled linux program. So I followed instructions on the Rimsort wiki to self-compile and got Rimsort to launch. The self compile is made from version 1.0.48/ 36618b9, however I have updated my install to the newest version since. 

I moved the Rimworld install from a second drive to the primary OS drive to simplifiy the file path, autodetect  function seems to work correctly, and I can see the Rimworld executable in the given file location. Attached screenshot of the error popup and the game folder. I'm not sure where to find logs for something like this, but happy to add.  

Not sure if relevant, but I am using Proton Plus to load Proton-GE as the compatibility tool for rimworld. AFAIK Steam on Linux uses the windows executable with the compatibility tools. 

### Code of Conduct

I agree to follow this project's Code of Conduct

### Duplicate Issue Check

I've checked for similar issues and didn't find anything

### Wiki/FAQ Check

I've checked the Wiki for a solution and didn't find a solution

## 评论 (3)

### @LionelColaso - 2025-10-31T03:46:35Z

You Are trying to run window installation on Linux, that's why y you getting the popup though I will add support for it 

<img width="1231" height="358" alt="Image" src="https://github.com/user-attachments/assets/bf2dda26-e380-4c4f-97dc-8709c4981900" />

### @chartowal - 2025-10-31T12:58:35Z

Okay I see what happened, I did not know that turning on the Proton compatibility tool meant downloading the windows version instead of the native linux version. I am able to configure the file paths correctly when I stop forcing the compatibility tool. Thanks!

### @LionelColaso - 2025-10-31T14:10:57Z

> Okay I see what happened, I did not know that turning on the Proton compatibility tool meant downloading the windows version instead of the native linux version. I am able to configure the file paths correctly when I stop forcing the compatibility tool. Thanks!

I have already added support for detecting .exe for Linux, next build will have it after i finish my testing
