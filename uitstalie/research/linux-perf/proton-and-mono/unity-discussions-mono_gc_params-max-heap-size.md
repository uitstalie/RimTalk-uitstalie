> 来源: https://discussions.unity.com/t/setting-mono_gc_params-max-heap-size-for-debugging-out-of-memory/658229
> 抓取方式: Discourse JSON 接口 (https://discussions.unity.com/t/setting-mono_gc_params-max-heap-size-for-debugging-out-of-memory/658229.json)

# Setting MONO_GC_PARAMS max-heap-size for debugging out of memory

- 分类: 172  |  创建: 2017-03-14T10:25:07.000Z  |  帖数: 2
- 标签: 
- 浏览量: 3131  |  点赞: 0

## #1 @devtoi (2017-03-14T10:25:07.000Z)

In order to debug an out of memory problem I wish to limit the available heap size for mono (swap space not an option). I found a stackoverflow thread about it how can I limit the memory size for .net / mono process - Stack Overflow  . Now I am wondering if anyone have been able to set this limit for debugging a Unity game on windows?

running “set MONO_GC_PARAMS max-heap-size=4G” then Unity from the commandline, does not seem to work. Additionally I would prefer to set this limit for the game, not the editor. Is this possible to do?

## #2 @korneidontsov (2023-12-27T11:42:53.000Z)

github.com  
   

   
    
mono/mono/blob/89f1d3cc22fd3b0848ecedbd6215b0bdfeea9477/man/mono.1#L1308  

    

      

          
In general if you have problems with encodings in your filenames you

          
should use the "convmv" program.

          
.TP

          
\fBMONO_GC_PARAMS\fR

          
When using Mono with the SGen garbage collector this variable controls

          
several parameters of the collector.  The variable's value is a comma

          
separated list of words.

          
.RS

          
.ne 8

          
.TP

          
\fBmax-heap-size=\fIsize\fR

          
Sets the maximum size of the heap. The size is specified in bytes and must

          
be a power of two. The suffixes `k', `m' and `g' can be used to

          
specify kilo-, mega- and gigabytes, respectively. The limit is the sum

          
of the nursery, major heap and large object heap. Once the limit is reached

          
the application will receive OutOfMemoryExceptions when trying to allocate.

          
Not the full extent of memory set in max-heap-size could be available to

          
satisfy a single allocation due to internal fragmentation. By default heap

          
limits is disabled and the GC will try to use all available memory.

          
.TP

          
\fBnursery-size=\fIsize\fR

      

    

   

  

    
    
  

  

 

The size is specified in bytes and must be a power of two. The suffixes `k', `m' and `g' can be used to specify kilo-, mega- and gigabytes, respectively.

While documentation says that suffixes 
k', 
m’ and `g’ can be used, it seems that Unity version of Mono runtime just ignores such definitions. But when I specify the size in bytes, like $env:MONO_GC_PARAMS = ‘max-heap-size=4294967296’ in PowerShell, then Unity Editor just refuses to launch (tested with 2022.3.5f1).
