---
layout: post
title:  "性能测试背后的秘密"
date:   2015-02-14 15:49:58
categories: Technology
---
> “跑个并发测试撒～”这句话在高并发高吞吐服务开发已经传为佳话。从撸阿撸的不服sala，到杂粮的不服跑个分，再到swooler的不服比比qps

有图有丁日：  
 ![](/img/secret-behind-testing/1.jpg)  
 上图是swoole框架在两百路并发十万个请求的性能测试结果，可以看到qps为每秒1w6,总耗时6.140秒  
 ![](/img/secret-behind-testing/2.jpg)  
 这儿是同样的机器，同样的配置，同样的并发量下nodejs表现，被swoole秒成渣了～*可怜的6k不到qps和17s的总耗时*  

这是什么gui～  

 在上个图，nodejs输出hello world的耗时  
 ![](/img/secret-behind-testing/3.jpg)  
 php如下  
 ![](/img/secret-behind-testing/4.jpg)

一目了然，平均一个请求耗费在输出这上面的时间就差了这么多，总数10W的请求数，总时间下降是必然的了～～  
 so，真的不是swoole比nodejs吞吐量高  
 从另一方面说，单纯的helloworld测试真的有那么大说服力么？**摆脱了业务逻辑的性能测试**放大了这微妙数，加上了业务逻辑，这部分瓶颈必然被掩盖，似乎hello world真的不能证明什么吧

这是在swoole加了一次redis操作之后测出的qps.发现下降了近三倍之多,下面是测试代码

```shell
Requests per second:    8260.25 [#/sec] (mean)
Time per request:       0.121 [ms] (mean, across all concurrent requests)
```

```php
<?php
$http = new swoole_http_server("0.0.0.0", 8083, 4); 
$http->set([
		'worker_num' => 1
		]);
$redis = new Redis();
$redis->connect('127.0.0.1', 6379);
$http->on('request', function (swoole_http_request $request, swoole_http_response $response) use($redis){
		$ret = $redis->get('test-key');
		$response->header('Content-Type', 'text/html');
		$response->end($ret);
		}); 
$http->start(); 
```

这是nodejs加了一次redis操作之后的qps,原来三倍的差距一下就拉近了。

```shell
Requests per second:    4900.73 [#/sec] (mean)
Time per request:       0.204 [ms] (mean, across all concurrent requests)
```

似乎连2倍都不到了？？原来的3倍差距也仅仅是因为不同的实现导致的，swoole纯c实现，而nodejs需要透过v8来运行js代码，一个简单的write操作变得非常复杂，在swoole里单个请求耗时50微秒，而nodejs需要150左右，看似真有三倍的性能提升。但是如果再加上更多的业务逻辑，比如业务逻辑耗时10毫秒，20毫秒，，那他们之间相差的那100多或者再多点200乃至300微秒的差距，真的有意义吗？？  
 本文目的不是为了做性能测试，也不是为了喷swoole,而是让大家正确对待“hello world"式的测试，一切抛开业务逻辑的测试都是在耍流氓，提醒以后大家遇到此类hello wrold式的测试就绕道而行吧！真的毫无意义。  
 非黑非粉，有理无言对～
