> 来源: https://docs.unity3d.com/2022.3/Documentation/Manual/performance-managed-memory.html
> 标题: Unity Manual 2022.3 - Managed memory
> 抓取: HTTP 200 | Content-Type: text/html,text/html; charset=utf-8 | 原始字节: 21881

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





Memory in Unity




Garbage collector overview








# Managed memory





Unity’s managed memory system is a C# scripting environment based on the Mono or IL2CPP Virtual Machines (VMs) . The benefit of the managed memory system is that it manages the release of memory, so you don’t need to manually request the release of memory through your code.


Unity’s managed memory system uses a garbage collector and a managed heap to automatically free memory allocations when your scripts A piece of code that allows you to create your own Components, trigger game events, modify Component properties over time and respond to user input in any way you like. garbage collector and a managed heap to automatically free memory allocations when your scripts A piece of code that allows you to create your own Components, trigger game events, modify Component properties over time and respond to user input in any way you like. More info
See in Glossary no longer hold any references to those allocations. This helps safeguard against memory leaks. Memory leaks occur when memory is allocated, the reference to it is lost, and then the memory is never freed because it needs a reference to it to free it.


This memory management system also guards memory access, which means that you can’t access memory that has been freed, or that was never valid for your code to access. However, this memory management process impacts runtime performance, because allocating managed memory is time-consuming for the CPU. Garbage collection might also stop the CPU from doing other work until it completes.






## Value and reference types


When a method is called, the scripting back end copies the values of its parameters to an area of memory reserved for that specific call, in a data structure called a call stack . The scripting back end can quickly copy data types that occupy a few bytes. However, it’s common for objects, strings, and arrays to be much larger, and it’s inefficient for the scripting back end to copy these types of data on a regular basis.


All non-null reference-type objects and all boxed value-typed objects in managed code must be allocated on the managed heap.


It’s important that you are familiar with value and reference types, so that you can effectively manage your code. For more information, see Microsoft’s documentation on value types , and reference types .



## Automatic memory management


When an object is created, Unity allocates the memory required to store it from a central pool called the heap , which is a section of memory that your Unity project’s selected scripting runtime (Mono or IL2CPP) automatically manages. When an object is no longer in use, the memory it once occupied can be reclaimed and used for something else.



Unity’s scripting back ends use a garbage collector to automatically manage your application’s memory, so that you don’t need to allocate and release these blocks of memory with explicit method calls. Automatic memory management requires less coding effort than explicit allocation/release and reduces the potential for memory leaks.






### Managed heap overview


The managed heap is a section of memory that your Unity project’s selected scripting runtime (Mono or IL2CPP) automatically manages.




A quantity of memory. Marked A on the diagram is some free memory. 


In the above diagram, the blue box represents a quantity of memory that Unity allocates to the managed heap. The white boxes within it represent data values that Unity stores within the managed heap’s memory space. When additional data values are needed, Unity allocates them free space from the managed heap (annotated A ).



### Memory fragmentation and heap expansion




A quantity of memory, with some objects released represented by grey dashed lines. 


The above diagram shows an example of memory fragmentation. When Unity releases an object, the memory that the object occupied is freed up. However, the free space doesn’t become part of a single large pool of “free memory.”


The objects on either side of the released object might still be in use. Because of this, the freed space is a “gap” between other segments of memory. Unity can only use this gap to store data of identical or lesser size than the released object.


This situation is called memory fragmentation . This happens when there is a large amount of memory available in the heap, but it is only available in the “gaps” between objects. This means that even though there is enough total space for a large memory allocation, the managed heap can’t find a large enough single block of contiguous memory to assign to the allocation.




The object annotated A, is the new object needed to be added to the heap. The items annotated B are the memory space that the released objects took up, plus the free, unreserved memory. Even though there is enough total free space, because there isn’t enough contiguous space, the memory for the new object annotated A can’t fit on the heap, and the garbage collector must run. 


If a large object is allocated and there is insufficient contiguous free space to accommodate it, as illustrated above, the Unity memory manager performs two operations:




- First, the garbage collector runs, if it hasn’t already done so. This attempts to free up enough space to fulfill the allocation request.


- If, after the garbage collector runs, there is still not enough contiguous space to fit the requested amount of memory, the heap must expand. The specific amount that the heap expands is platform-dependent; however, on most platforms, when the heap expands, it expands by double the amount of the previous expansion.




### Managed heap expansion considerations


The unexpected expansion of the heap can be problematic. Unity’s garbage collection strategy tends to fragment memory more often. You should be aware of the following:




- Unity doesn’t release the memory allocated to the managed heap when it expands regularly; instead, it retains the expanded heap, even if a large section of it is empty. This is to prevent the need to re-expand the heap if further large allocations occur.


- On most platforms, Unity eventually releases the memory that the empty portions of the managed heap uses back to the operating system. The interval at which this happens isn’t guaranteed and is unreliable.


- The garbage collector does not clear out native memory objects or other native allocations. Resources.UnloadUnusedAssets does that for any native object that no longer has any references pointing to it. It also triggers a GC.Collect to make sure the state of these references is up to date. Bear in mind that:



- 
UnloadUnusedAssets is not triggered automatically, only manually and on scene A Scene contains the environments and menus of your game. Think of each unique Scene file as a unique level. In each Scene, you place your environments, obstacles, and decorations, essentially designing and building your game in pieces. More info
See in Glossary changes. If you want to free that memory earlier, which can be crucial, for example, for fullscreen RenderTextures on platforms with low RAM, you should call Destroy on the objects to make optimal use of the memory you have.


- There’s a risk of managed memory leaks. If you’ve kept references to the cleaned-up objects, you risk leaking the native objects that the managed objects reference. Static fields and events are are common sources of this kind of memory leak. For more information on how to analyze these issues with the Memory Profiler A window that helps you to optimize your game. It shows how much time is spent in the various areas of your game. For example, it can report the percentage of time spent rendering, animating, or in your game logic. More info
See in Glossary , refer to Managed shell objects in the Memory Profiler package documentation.


- Calling UnloadUnusedAssets or GC.Collect triggers a CPU-intensive process that you might want to avoid during Gameplay.









Memory in Unity




Garbage collector overview








Copyright © 2026 Unity Technologies. Publication Date: 2026-07-02.


Tutorials Community Answers Knowledge Base Forums Asset Store Terms of use Legal Privacy Policy Cookies Do Not Sell or Share My Personal Information Your Privacy Choices (Cookie Settings)
