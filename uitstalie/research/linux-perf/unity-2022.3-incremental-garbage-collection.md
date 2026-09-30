> 来源: https://docs.unity3d.com/2022.3/Documentation/Manual/performance-incremental-garbage-collection.html
> 标题: Unity Manual 2022.3 - Incremental garbage collection
> 抓取: HTTP 200 | Content-Type: text/html,text/html; charset=utf-8 | 原始字节: 20247

---

- Manual


- Scripting API








- unity.com







Version: 2022.3 



- 

Supported


- 

Legacy










Language
: English 






- English


- 中文


- 日本語


- 한국어














## Unity Manual






Language
: English 






- English


- 中文


- 日本語


- 한국어











- Working in Unity


- Analysis


- Memory in Unity


- Managed memory


- Garbage collector overview


- Incremental garbage collection





Garbage collector overview




Disabling garbage collection








# Incremental garbage collection





Incremental garbage collection (GC) spreads out the process of garbage collection over multiple frames. This is the default garbage collection behavior in Unity.




To enable incremental garbage collection, open the Player Settings and enable Use incremental GC . This is enabled by default. 


Unity’s garbage collector uses the Boehm–Demers–Weiser garbage collector . By default, Unity uses it in incremental mode, which means that the garbage collector splits up its workload over multiple frames, instead of stopping the main CPU thread ( stop-the-world garbage collection ) to process all objects on the managed heap. This means that Unity makes shorter interruptions to your application’s execution, instead of one long interruption to let the garbage collector process the objects on the managed heap.


Incremental mode doesn’t make garbage collection faster overall, but because it distributes the workload over multiple frames, GC-related performance spikes are reduced. These interruptions are called GC spikes because they appear as large spikes in the Profiler window’s frame time graph.


If you disable incremental mode ( menu: Edit > Project Settings > Player > Other Settings > Configuration > Use Incremental GC ), the garbage collector must examine the entire heap when it performs a collection pass. This is known as stop-the-world garbage collection, because whenever the garbage collector runs, it stops the main CPU thread. It only resumes execution once it has processed all objects on the managed heap, which might lead to GC spikes affecting the performance of your application. The garbage collector is also non-compacting, which means that Unity doesn’t redistribute any objects in memory to close the gaps between objects.



Important: The WebGL A JavaScript API that renders 2D and 3D graphics in a web browser. The Unity WebGL build option allows Unity to publish content as JavaScript programs which use HTML5 technologies and the WebGL rendering API to run Unity content in a web browser. More info
See in Glossary platform doesn’t support incremental garbage collection.


When incremental garbage collection is disabled, a GC spike happens when Unity stops running your program code to perform garbage collection. This delay might last for hundreds of milliseconds, depending on how many allocations the garbage collector needs to process, and the platform that your application is running on.


This is problematic for real-time applications such as games, because it’s difficult for your application to sustain the consistent frame rate that smooth animation requires when the garbage collector suspends your application’s execution.



## Incremental garbage collection example


The following screenshots from the Profiler illustrate how incremental garbage collection reduces frame rate problems:




Profiling session with Incremental GC enabled 




Profiling session with Incremental GC disabled 


In the top profiling session, Incremental GC is enabled. The application has a consistent 60fps frame rate, because the garbage collector distributes the garbage collection operation over several frames, and uses a small time slice of each frame (the darker green fringe just above the yellow VSync trace).


The bottom profiling session has Incremental GC disabled, and there is a clear GC spike visible. This spike interrupts the otherwise smooth 60fps frame rate, and pushes the frame in which garbage collection happens over the 16 millisecond limit required to maintain 60fps.


If your application uses VSync Vertical synchronization (VSync) is a display setting that caps a game’s frame rate to match the refresh rate of a monitor, to prevent image tearing.
See in Glossary or Application.targetFrameRate , Unity adjusts the time it allocates to garbage collection based on the remaining available frame time. This way, Unity can run the garbage collection in the time it would otherwise spend waiting, and can carry out garbage collection with a minimal performance impact.



Note: If you set the VSync Count to anything other than Don’t Sync (in your project’s Quality settings or with the Application.VSync property) or you enable the Application.targetFrameRate property, Unity automatically uses any idle time left at the end of a given frame for incremental garbage collection.


To get more precise control over incremental garbage collection behavior, you can use the Scripting.GarbageCollector class. For example, if you don’t want to use VSync or a target frame rate, you can calculate the amount of time available before the end of a frame yourself, and provide that time to the garbage collector to use.






## Disabling incremental garbage collection


Incremental garbage collection might be problematic for your application, because when the garbage collector divides its work in this mode, it also divides the marking phase. The marking phase is the phase in which the garbage collector scans all managed objects to determine which objects are still in use, and which objects it can clean up.


Dividing up the marking phase works well when most of the references between objects don’t change between slices of work. However, when an object reference changes, the garbage collector must scan those objects again in the next iteration. This means that too many changes can overwhelm the incremental garbage collector and create a situation where the marking phase never finishes because it always has more work to do. If this happens, the garbage collector falls back to doing a full, non-incremental collection.


When Unity uses incremental garbage collection, it generates additional code (known as write barriers) to inform the garbage collector whenever a reference changes, so that it knows if it needs to rescan an object. This adds some overhead when changing references , which has a performance impact in managed code.


To disable Incremental Garbage Collection, open the Player Settings window ( Edit > Project Settings > Player > Configuration ) and disable Use Incremental GC . Most Unity projects benefit from incremental garbage collection, especially if they suffer from garbage collection spikes, but you should always use the Profiler A window that helps you to optimize your game. It shows how much time is spent in the various areas of your game. For example, it can report the percentage of time spent rendering, animating, or in your game logic. Profiler A window that helps you to optimize your game. It shows how much time is spent in the various areas of your game. For example, it can report the percentage of time spent rendering, animating, or in your game logic. More info
See in Glossary to verify that your application performs as you expect.





Garbage collector overview




Disabling garbage collection








Copyright © 2026 Unity Technologies. Publication Date: 2026-07-02.


Tutorials Community Answers Knowledge Base Forums Asset Store Terms of use Legal Privacy Policy Cookies Do Not Sell or Share My Personal Information Your Privacy Choices (Cookie Settings)
