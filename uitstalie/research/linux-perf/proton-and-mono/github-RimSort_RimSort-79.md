> 来源: https://github.com/RimSort/RimSort/issues/79
> 抓取方式: GitHub REST API (/repos/RimSort/RimSort/issues/79)

# fatal uncaught exception on launch LINUX

- 仓库: RimSort/RimSort
- 编号: #79 (Issue)
- 状态: closed  |  创建: 2023-05-12T09:51:28Z  |  更新: 2023-10-01T20:01:53Z  |  关闭: 2023-05-17T17:28:10Z
- 作者: FOFAD-hg
- 标签: Linux🐧
- 评论数: 2
- URL: https://github.com/RimSort/RimSort/issues/79

## 正文

distro : opensuse tumbleweed
kernel : 6.3.1-1 default
arch : x86_x64
default python interpereter : 3.9.13

cli output + trace : 
   ❯ ./RimSort.bin
RimSort.py: <_MainProcess name='MainProcess' parent=None started>
__name__: __main__
sys.argv: ['./RimSort.bin']
steamworks.wrapper: <_MainProcess name='MainProcess' parent=None started>
__name__: util.steam.steamworks.wrapper
sys.argv: ['./RimSort.bin']
main_content_panel.py: <_MainProcess name='MainProcess' parent=None started>
__name__: view.main_content_panel
sys.argv: ['./RimSort.bin']
Fontconfig warning: "/usr/share/fontconfig/conf.avail/05-reset-dirs-sample.conf", line 6: unknown element "reset-dirs"
[2023-05-12 13:13:33] WARNING: Running using Nuitka bundle
[2023-05-12 13:13:33] WARNING: Skipping parsing data from empty workshop mods path. Is the workshop mods path configured?
[2023-05-12 13:13:36] ERROR: The main application instantiation has failed with an uncaught exception:
[2023-05-12 13:13:36] ERROR: Traceback (most recent call last):
  File "/home/fofimofi/Desktop/RimWorld/RimSort/RimSort.py", line 146, in main_thread
  File "/home/fofimofi/Desktop/RimWorld/RimSort/RimSort.py", line 110, in __init__
  File "/home/fofimofi/Desktop/RimWorld/RimSort/view/main_content_panel.py", line 246, in __init__
  File "/home/fofimofi/Desktop/RimWorld/RimSort/watchdog/observers/api.py", line 261, in start
  File "/home/fofimofi/Desktop/RimWorld/RimSort/watchdog/utils/__init__.py", line 92, in start
  File "/home/fofimofi/Desktop/RimWorld/RimSort/watchdog/observers/inotify.py", line 119, in on_thread_start
  File "/home/fofimofi/Desktop/RimWorld/RimSort/watchdog/observers/inotify_buffer.py", line 37, in __init__
  File "/home/fofimofi/Desktop/RimWorld/RimSort/watchdog/observers/inotify_c.py", line 179, in __init__
  File "/home/fofimofi/Desktop/RimWorld/RimSort/watchdog/observers/inotify_c.py", line 402, in _add_dir_watch
  File "/home/fofimofi/Desktop/RimWorld/RimSort/watchdog/observers/inotify_c.py", line 416, in _add_watch
  File "/home/fofimofi/Desktop/RimWorld/RimSort/watchdog/observers/inotify_c.py", line 428, in _raise_error
OSError: [Errno 28] inotify watch limit reached

[2023-05-12 13:13:38] ERROR: The main application loop has failed with an uncaught exception
Traceback (most recent call last):
  File "/home/fofimofi/Desktop/RimWorld/RimSort/RimSort.py", line 203, in <module>
  File "/home/fofimofi/Desktop/RimWorld/RimSort/RimSort.py", line 171, in main_thread
UnboundLocalError: local variable 'window' referenced before assignment


Log file : 

[RimSort.log](https://github.com/oceancabbage/RimSort/files/11461773/RimSort.log)



## 评论 (2)

### @FOFAD-hg - 2023-05-12T12:51:10Z

also  tried building from source following instructions and requirements mentioned in development guide  but the same errors were encountered after build was finished

### @twstagg - 2023-05-17T17:28:10Z

Please read: https://unix.stackexchange.com/questions/13751/kernel-inotify-watch-limit-reached

You just have enough mods (and files under there that it is watching for changes) that your kernel is reaching it's inotify limit. You can adjust this to your preference accordingly. I will be adding a toggle to disable watchdog altogether for those who do not want to use it, eventually :)
