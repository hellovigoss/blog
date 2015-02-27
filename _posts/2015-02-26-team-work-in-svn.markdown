---
layout: post
title:  "更好的使用SVN"
date:   2015-02-26 19:39:50
categories: TECHNOLOGY
---

很多团队仅仅把svn当作一个代码仓库来使用。表现是：无论多大的项目、多少开发人员，都从主干中直接checkout一份最新的代码进行开发，完毕后也直接commit到最新的主干中。  
这么做的后果往往是，多个不同的需求同时进行。A小组有小王和小八，B小组有小绿和小豆。这一天，小王同小八说：“把你的代码上到svn上吧，窝要修改一下”。这时候一个update，发现把小绿昨天提交的东西更新了下来，duang～更叼的是，这部分代码也没有稳定，达不到进入svn的标准，yao了亲命。你污染我我污染你

![](/img/team-work-in-svn/a.jpg)  

一般来说，对于svn的分支有两种使用方法：  

* 主干开发，分支发布
* 主干发布，分支开发

> 假设svn远程Repository地址为：http://localhost/svn  
> svn服务目录为：  
> |--trunk --workspace  
> |--branch  
> |--tag
> 主干的本地工作副本为trunk\_workcopy，分支工作副本为branch\_workcopy

这里只讨论第二种模式  
1. 接收到新的开发任务，开启新分支：  
```shell
svn copy http://localhost/svn/trunk/workspace http://localhost/svn/branch/{Y-m-d}{分支任务简要概述}/workspace -m "new branch {分支任务简要概述}"
```  
2. 任务内相关人员签出分支Repository进行开发：  
```shell
svn co http://localhost/svn/branch/{Y-m-d}{分支任务简要概述}/workspace branch\_workcopy
```  
3. 任务开发完毕，更新本地主干以及分支工作副本
首先，将主干副本merge到当前的工作分支的本地副本
解决所有冲突之后，确保本地工作副本没有问题，进行一次回归测试后，便可将分支副本merge到本地的主干工作副本，最后提交

```
svn up trunk\_workcopy
svn up branch\_workcopy
svn merge trunk\_workcopy branch\_workcopy
svn commit branch\_workcopy
svn merge branch\_workcopy trunk\_workcopy
svn commit trunk\_workcopy
```

大部分人习惯使用win下的GUI工具，具体步骤如下：  
*(以下部分转自[http://www.cnblogs.com/cxd4321/archive/2012/07/12/2588110.html](http://www.cnblogs.com/cxd4321/archive/2012/07/12/2588110.html))*  
1. 创建branch  
在/trunk/MyProject目录上右键，依次选择"TortoiseSVN" -> "Branch/tag..."，在弹出窗口的"To URL"中填入分支的地址，在这里目标revision选择HEAD revision，如下图所示，添加log后点击ok分支便建立了。这个操作速度非常快，新建的branch在repository中其实只是一个指向trunk某个revision的软连接而已，并没有真的复制文件。
![](/img/team-work-in-svn/win.gif)  
2. Check out分支  
右键TestSVN目录选择"TortoiseSVN Update"即可将刚刚建立的分支下载回本地。进入/branches/MyProject目录下你会发现其文件结构和/trunk/MyProject一模一样。  
3. branch提交一个新文件  
![](/img/team-work-in-svn/win2.gif)  
4. trunk紧接着提交一个修改  
![](/img/team-work-in-svn/win3.gif)  
5. branch再次提交一个修改  
![](/img/team-work-in-svn/win4.gif)   
6. 将trunk中的修改同步到branch    
3-5演示的是branch和trunk在独立、并行地开发。为了防止在“错误”的道路上越走越远，现在branch意识到是时候和trunk来一次同步了（将trunk合并到branch）。  
首先，在本地trunk中先update一下，有冲突的解决冲突，保证trunk和repository已经完全同步，然后在/branches/MyProject上右键，依次选择"TortoiseSVN" -> “Merge...”，在弹出的窗口中选择第一项"Merge a range of revision"，这个类型的Merge已经介绍得很清楚，适用于将某个分支或主线上提交的多个revision间的变化合并到另外一个分支上。  
![](/img/team-work-in-svn/win5.gif)   
点击next后，出现如下窗口：  
![](/img/team-work-in-svn/win6.gif)   
由于是要从trunk合并到branch，理所当然这里的"URL to merge from"应该填trunk的路径，"Revision range to merge"很好理解，就是你要将trunk的哪些revision所对应的变化合并到branch中，可以是某一连串的revision，比如4-7，15-HEAD，也可以是某个单独的revision号。由于在r4中，trunk修改了Person.java中的talk()方法，所以这里的revision只需填4即可。点击next后出现下图：  
![](/img/team-work-in-svn/win7.gif)   
在这里只需保留默认设置即可。在点击Merge按钮前你可以先Test merge一把，看成功与否，以及merge的详细信息。点击Merge按钮后trunk所做的修改将同步到branch中。  
7. 提交合并后的branch  
![](/img/team-work-in-svn/win8.gif)   
至此，branch已经完全和trunk同步，branch和trunk的代码相处很融洽，没有任何冲突，如果branch已经开发结束，那是时候将branch合并回trunk了，当然，如果branch还要继续开发，那你将不断地重复6-10这几个步骤。  
8. 将branch合并回trunk  
在/trunk/MyProject上右键（注意是在主线的目录上右键），依次选择"TortoiseSVN" -> "Merge..."，在弹出的窗口中，Merge type选择第二项"Reintegrate a branch"，这种类型的合并适合在分支开发结束后将所有的改动合并回主线。  
![](/img/team-work-in-svn/win9.gif)   
点击next后出现如下窗口：  
![](/img/team-work-in-svn/win10.gif)   
在这里，"From URL"选择/branches/MyProject，无需选择revision号，Reintegrate会将branch上所有修改合并到trunk。后面的步骤和上文第9步中的一样，不再啰嗦了。如无意外，branch将成功合并到trunk，你需要做的只是将合并后的trunk赶紧commit！  
9. 提交合并后的trunk
