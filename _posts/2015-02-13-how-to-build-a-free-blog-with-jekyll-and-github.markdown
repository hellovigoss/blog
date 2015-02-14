---
layout: post
title:  "如何使用jekyll与github建立免费的不限流量的blog"
date:   2015-02-13 14:47:27
categories: 花样炸鸡
---
本文说明了如何使用jekyll搭建一个免费的、无限流量的个人博客网站，以及后续的管理
本指导适用于有一定相关github基础的专业人员使用

*[jekyll](http://jekyllrb.com/)Transform your plain text into static websites and blogs.将你的plain文本直接转换为静态网站或者博客。*

*[github](http://www.github.com)Git是一个分布式的版本控制系统，最初由Linus Torvalds编写，用作Linux内核代码的管理。在推出后，Git在其它项目中也取得了很大成功，尤其是在Ruby社区中。目前，包括Rubinius、Merb和Bitcoin在内的很多知名项目都使用了Git。Git同样可以被诸如Capistrano和Vlad the Deployer这样的部署工具所使用。*
*在这里我们就用到了github的io页功能。*

1. 进入github.com，开通一个新的repositoriy，使用yourname.github.io(其中yourname为自定义的名称)
2. 安装jekyll，参考[install guide](http://jekyllrb.com/docs/installation/)
3. 进入终端，使用jekyll创建一个空博客```jekyll new blog```
4. 进入对应目录```cd blog```，修改配置文件，```vi _config.yml```，更改其中的域名为http://yourname.github.io，保存并退出
5. 执行build命令```jekyll b```
6. 进入待部署目录```cd _site```
7. 执行git初始化```git init```
9. 初始化信息```git add .```
10. 提交```git commit -m 'initalize'```
11. 增加远端目录```git remote add orgin https://github.com/yourname/yourname.github.io```
12. 推送到master分支```git push origin master```
13. 浏览器查看[http://yourname.github.io](http://yourname.github.io)

*一个[jekyll模板网站](http://jekyllthemes.org/)，直接clone到本地覆盖然后在进行发布即可*

*如何利用自定义插件完成jekyll分类功能，[为 Jekyll 博客添加 category 分类](http://pizn.github.io/2012/02/23/use-category-plugin-for-jekyll-blog.html)*

