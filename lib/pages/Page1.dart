import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:v2ex/bus.dart';
import 'package:v2ex/model/Post.dart';
import 'package:v2ex/pages/Me.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  late final WebViewController controller;
  double stateHeight = 0;
  List<Post> list = [];

  @override
  void initState() {
    stateHeight = MediaQueryData.fromWindow(window).padding.top;

    super.initState();
    // var message ='';
    var message =
        '[{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"36 天前","lastReplyUsername":"Maca","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1061976","href":"https://www.v2ex.com/t/1061976#reply43","member":{"avatar":"https://cdn.v2ex.com/avatar/0d36/88cc/328450_normal.png?m=1705040400","username":"whitecosm0s"},"node":{"title":"分享创造","url":"https://www.v2ex.com/go/create"},"headerTemplate":"","title":"[送兑换码]提醒英雄更新了 1.7 版本, 新增检查清单，持续提醒等功能。这是一个高颜值，设计优雅的\\"提醒事项\\"替代品","id":1061976,"type":"post","once":"","replyCount":43,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false}]';
    message =
        '[{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"17 小时 15 分钟前","lastReplyUsername":"fengsi","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1073167","href":"https://www.v2ex.com/t/1073167#reply65","member":{"avatar":"https://cdn.v2ex.com/gravatar/eb9f93e315a76487f1ca6e3c4efa6d02?s=24&d=retro","username":"Earsum"},"node":{"title":"问与答","url":"https://www.v2ex.com/go/qna"},"headerTemplate":"","title":"现在阿里系的购物软件真的还有必要存在吗？","id":1073167,"type":"post","once":"","replyCount":65,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"23 分钟前","lastReplyUsername":"james122333","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1073207","href":"https://www.v2ex.com/t/1073207#reply61","member":{"avatar":"https://cdn.v2ex.com/gravatar/f85de639bb82e0f83cbf419a15fbb947?s=24&d=retro","username":"t4we"},"node":{"title":"NAS","url":"https://www.v2ex.com/go/nas"},"headerTemplate":"","title":"原来云盘文件在 Server 是不加密的","id":1073207,"type":"post","once":"","replyCount":61,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"1 小时 14 分钟前","lastReplyUsername":"phx13ye","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1073179","href":"https://www.v2ex.com/t/1073179#reply55","member":{"avatar":"https://cdn.v2ex.com/gravatar/e589f3bcac3d146c80b717b18c16ac1e?s=24&d=retro","username":"phx13ye"},"node":{"title":"程序员","url":"https://www.v2ex.com/go/programmer"},"headerTemplate":"","title":"退役老旧电脑，没卖的话，你们会用来干什么？ 2024 版","id":1073179,"type":"post","once":"","replyCount":55,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"32 分钟前","lastReplyUsername":"sunmker","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1073188","href":"https://www.v2ex.com/t/1073188#reply39","member":{"avatar":"https://cdn.v2ex.com/avatar/387f/986a/60691_normal.png?m=1689252237","username":"justincnn"},"node":{"title":"Google","url":"https://www.v2ex.com/go/google"},"headerTemplate":"","title":"现在 android 有什么办法熄屏听油管么？","id":1073188,"type":"post","once":"","replyCount":39,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"48 分钟前","lastReplyUsername":"LuckyLauncher","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1073176","href":"https://www.v2ex.com/t/1073176#reply37","member":{"avatar":"https://cdn.v2ex.com/avatar/b87a/4d18/451225_normal.png?m=1726372399","username":"imblues"},"node":{"title":"职场话题","url":"https://www.v2ex.com/go/career"},"headerTemplate":"","title":"目前身边失业的人越来越多，想做一下统计。","id":1073176,"type":"post","once":"","replyCount":37,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"13 分钟前","lastReplyUsername":"kkbear","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1073168","href":"https://www.v2ex.com/t/1073168#reply36","member":{"avatar":"https://cdn.v2ex.com/avatar/694d/0934/655828_normal.png?m=1717637009","username":"EndlessMemory"},"node":{"title":"问与答","url":"https://www.v2ex.com/go/qna"},"headerTemplate":"","title":"晚上睡觉总是入睡很慢咋办？还容易中途醒","id":1073168,"type":"post","once":"","replyCount":36,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"20 分钟前","lastReplyUsername":"cs4814751","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1073189","href":"https://www.v2ex.com/t/1073189#reply35","member":{"avatar":"https://cdn.v2ex.com/gravatar/46ebf42d3ed4c89801dc7ef397010f48?s=24&d=retro","username":"XuYijie"},"node":{"title":"生活方式","url":"https://www.v2ex.com/go/lifestyle"},"headerTemplate":"","title":"友友们，奢侈品牌男装有哪些呀","id":1073189,"type":"post","once":"","replyCount":35,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"14 分钟前","lastReplyUsername":"x86","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1073161","href":"https://www.v2ex.com/t/1073161#reply34","member":{"avatar":"https://cdn.v2ex.com/gravatar/cf088dd4af96fb317a7c820cd3064a62?s=24&d=retro","username":"omz"},"node":{"title":"Telegram","url":"https://www.v2ex.com/go/telegram"},"headerTemplate":"","title":"请问哪里开 TG 会员便宜？","id":1073161,"type":"post","once":"","replyCount":34,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"2 小时 1 分钟前","lastReplyUsername":"NatsuSaw","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1073226","href":"https://www.v2ex.com/t/1073226#reply33","member":{"avatar":"https://cdn.v2ex.com/avatar/4733/13f5/631937_normal.png?m=1685605797","username":"NatsuSaw"},"node":{"title":"职场话题","url":"https://www.v2ex.com/go/career"},"headerTemplate":"","title":"公司规矩越来越多，准备跑路，能帮我分析后续做什么方向更好一点吗？","id":1073226,"type":"post","once":"","replyCount":33,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"7 小时 33 分钟前","lastReplyUsername":"gojo","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1073154","href":"https://www.v2ex.com/t/1073154#reply29","member":{"avatar":"https://cdn.v2ex.com/gravatar/b3a6fc71b74c1a2798cb4e1fae79183a?s=24&d=retro","username":"xiaoshiforking"},"node":{"title":"电影","url":"https://www.v2ex.com/go/movie"},"headerTemplate":"","title":"观影小组成立啦！","id":1073154,"type":"post","once":"","replyCount":29,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"50 分钟前","lastReplyUsername":"lixintcwdsg","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1073187","href":"https://www.v2ex.com/t/1073187#reply28","member":{"avatar":"https://cdn.v2ex.com/avatar/cefd/e096/126810_normal.png?m=1592616370","username":"cz5424"},"node":{"title":"硬件","url":"https://www.v2ex.com/go/hardware"},"headerTemplate":"","title":"求推荐一款显示器，需要 4k 和反向充电，兼顾 Win 玩游戏","id":1073187,"type":"post","once":"","replyCount":28,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"8 小时 17 分钟前","lastReplyUsername":"dream7758522","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1073164","href":"https://www.v2ex.com/t/1073164#reply22","member":{"avatar":"https://cdn.v2ex.com/avatar/1445/6b2d/640833_normal.png?m=1726362284","username":"ZTBOXS"},"node":{"title":"分享发现","url":"https://www.v2ex.com/go/share"},"headerTemplate":"","title":"百度网盘偷偷把我网盘数据清了！给别的用户使用","id":1073164,"type":"post","once":"","replyCount":22,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"15 分钟前","lastReplyUsername":"cwxiaos","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1073193","href":"https://www.v2ex.com/t/1073193#reply22","member":{"avatar":"https://cdn.v2ex.com/avatar/bf21/15ea/396773_normal.png?m=1716031759","username":"1014982466"},"node":{"title":"宽带症候群","url":"https://www.v2ex.com/go/bb"},"headerTemplate":"","title":"在香港买 6Ghz 路由器带回来能否用 6Ghz？","id":1073193,"type":"post","once":"","replyCount":22,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"10 小时 0 分钟前","lastReplyUsername":"Damn","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1073170","href":"https://www.v2ex.com/t/1073170#reply19","member":{"avatar":"https://cdn.v2ex.com/avatar/09fe/9201/676846_normal.png?m=1713022885","username":"gsy20050126819"},"node":{"title":"iPhone","url":"https://www.v2ex.com/go/iphone"},"headerTemplate":"","title":"钥匙链清理工具 KCleaner V2.2 已发布","id":1073170,"type":"post","once":"","replyCount":19,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"55 分钟前","lastReplyUsername":"zoharSoul","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1073174","href":"https://www.v2ex.com/t/1073174#reply18","member":{"avatar":"https://cdn.v2ex.com/gravatar/afc903abdf889c69f7ed78fb32eb4c9d?s=24&d=retro","username":"chenxiankong"},"node":{"title":"健康","url":"https://www.v2ex.com/go/fit"},"headerTemplate":"","title":"求助，早上睡醒必鼻塞","id":1073174,"type":"post","once":"","replyCount":18,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"2 小时 5 分钟前","lastReplyUsername":"szx300","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1073222","href":"https://www.v2ex.com/t/1073222#reply17","member":{"avatar":"https://cdn.v2ex.com/avatar/a1e0/f36a/606787_normal.png?m=1726390724","username":"iampure"},"node":{"title":"问与答","url":"https://www.v2ex.com/go/qna"},"headerTemplate":"","title":"现在 ios 有什么办法熄屏听油管么？","id":1073222,"type":"post","once":"","replyCount":17,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"1 小时 38 分钟前","lastReplyUsername":"shouh","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1073156","href":"https://www.v2ex.com/t/1073156#reply16","member":{"avatar":"https://cdn.v2ex.com/gravatar/8ced7c8da7ab5b6a1667ef426d9c3774?s=24&d=retro","username":"selich"},"node":{"title":"投资","url":"https://www.v2ex.com/go/invest"},"headerTemplate":"","title":"如果一个人研究出了一个正期望的量化交易策略，他接下来会如何做？","id":1073156,"type":"post","once":"","replyCount":16,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"9 小时 47 分钟前","lastReplyUsername":"yb2313","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1073158","href":"https://www.v2ex.com/t/1073158#reply15","member":{"avatar":"https://cdn.v2ex.com/avatar/5fd5/33c7/136189_normal.png?m=1723538364","username":"andforce"},"node":{"title":"分享创造","url":"https://www.v2ex.com/go/create"},"headerTemplate":"","title":"[开源] 打造自己的语音电话助理，用魔法打败垃圾推销电话， AI-Phone-Call","id":1073158,"type":"post","once":"","replyCount":15,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"26 分钟前","lastReplyUsername":"YiCherish","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1073211","href":"https://www.v2ex.com/t/1073211#reply15","member":{"avatar":"https://cdn.v2ex.com/avatar/cff8/15da/16836_normal.png?m=1332699166","username":"lvdie"},"node":{"title":"问与答","url":"https://www.v2ex.com/go/qna"},"headerTemplate":"","title":"老人经常走丢，推荐一款 GPS 追踪类设备","id":1073211,"type":"post","once":"","replyCount":15,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"6 分钟前","lastReplyUsername":"AmazingEveryDay","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1073201","href":"https://www.v2ex.com/t/1073201#reply14","member":{"avatar":"https://cdn.v2ex.com/avatar/23e2/5f2c/456908_normal.png?m=1670654099","username":"Mythologyli"},"node":{"title":"分享发现","url":"https://www.v2ex.com/go/share"},"headerTemplate":"","title":"CSDN 毫无下限，居然在我不知情的情况下擅自把我的文章设置成仅 VIP 可见","id":1073201,"type":"post","once":"","replyCount":14,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false}]';
    // var message ='[{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"5 小时 38 分钟前","lastReplyUsername":"1145148964","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1073009","href":"https://www.v2ex.com/t/1073009#reply2","member":{"avatar":"https://cdn.v2ex.com/gravatar/e2e572807688a5c9c2c02aa111fa7662?s=24&d=retro","username":"1145148964"},"node":{"title":"投资","url":"https://www.v2ex.com/go/invest"},"headerTemplate":"","title":"百万美元鏖战纽约交易所","id":1073009,"type":"post","once":"","replyCount":2,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"","lastReplyUsername":"","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1070308","href":"https://www.v2ex.com/t/1070308#reply0","member":{"avatar":"https://cdn.v2ex.com/gravatar/e2e572807688a5c9c2c02aa111fa7662?s=24&d=retro","username":"1145148964"},"node":{"title":"推广","url":"https://www.v2ex.com/go/promotions"},"headerTemplate":"","title":"各位对海外私募基金有兴趣吗？","id":1070308,"type":"post","once":"","replyCount":0,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"10 天前","lastReplyUsername":"dividez","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1066039","href":"https://www.v2ex.com/t/1066039#reply206","member":{"avatar":"https://cdn.v2ex.com/avatar/0c61/fe34/503476_normal.png?m=1724034473","username":"lijianan"},"node":{"title":"职场话题","url":"https://www.v2ex.com/go/career"},"headerTemplate":"","title":"时隔一个月，我又来分享面试经历了","id":1066039,"type":"post","once":"","replyCount":206,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"13 天前","lastReplyUsername":"crocoBaby","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1069255","href":"https://www.v2ex.com/t/1069255#reply34","member":{"avatar":"https://cdn.v2ex.com/gravatar/e2e572807688a5c9c2c02aa111fa7662?s=24&d=retro","username":"1145148964"},"node":{"title":"职场话题","url":"https://www.v2ex.com/go/career"},"headerTemplate":"","title":"楼主被从“中部省会”调到乌鲁木齐了。工资 1.5 倍。准备辞职了。","id":1069255,"type":"post","once":"","replyCount":34,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"16 天前","lastReplyUsername":"whitecosm0s","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1067222","href":"https://www.v2ex.com/t/1067222#reply84","member":{"avatar":"https://cdn.v2ex.com/avatar/0d36/88cc/328450_normal.png?m=1705040400","username":"whitecosm0s"},"node":{"title":"分享创造","url":"https://www.v2ex.com/go/create"},"headerTemplate":"","title":"提醒清单，利用后台任务实现绝对提醒，从此拥有高效自律的生活，送出 10000 个优惠代码！","id":1067222,"type":"post","once":"","replyCount":84,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"34 天前","lastReplyUsername":"VikingX","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1060838","href":"https://www.v2ex.com/t/1060838#reply194","member":{"avatar":"https://cdn.v2ex.com/avatar/0c61/fe34/503476_normal.png?m=1724034473","username":"lijianan"},"node":{"title":"求职","url":"https://www.v2ex.com/go/cv"},"headerTemplate":"","title":"五年前端，记录下最近一年的面试记录，顺便求个内推","id":1060838,"type":"post","once":"","replyCount":194,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"36 天前","lastReplyUsername":"Maca","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1061976","href":"https://www.v2ex.com/t/1061976#reply43","member":{"avatar":"https://cdn.v2ex.com/avatar/0d36/88cc/328450_normal.png?m=1705040400","username":"whitecosm0s"},"node":{"title":"分享创造","url":"https://www.v2ex.com/go/create"},"headerTemplate":"","title":"[送兑换码]提醒英雄更新了 1.7 版本, 新增检查清单，持续提醒等功能。这是一个高颜值，设计优雅的\"提醒事项\"替代品","id":1061976,"type":"post","once":"","replyCount":43,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"39 天前","lastReplyUsername":"li24361","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1062448","href":"https://www.v2ex.com/t/1062448#reply16","member":{"avatar":"https://cdn.v2ex.com/gravatar/e2e572807688a5c9c2c02aa111fa7662?s=24&d=retro","username":"1145148964"},"node":{"title":"问与答","url":"https://www.v2ex.com/go/qna"},"headerTemplate":"","title":"求推荐 2000 左右的显卡。200 左右的键盘鼠标。","id":1062448,"type":"post","once":"","replyCount":16,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"45 天前","lastReplyUsername":"blessedbin","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1061344","href":"https://www.v2ex.com/t/1061344#reply3","member":{"avatar":"https://cdn.v2ex.com/gravatar/6bc4908bdb8220db75b3a194b2c8534f?s=24&d=retro","username":"echosoar"},"node":{"title":"分享创造","url":"https://www.v2ex.com/go/create"},"headerTemplate":"","title":"第 93 期 - 偷懒爱好者周刊 24/07/31","id":1061344,"type":"post","once":"","replyCount":3,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"53 天前","lastReplyUsername":"whitecosm0s","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1055571","href":"https://www.v2ex.com/t/1055571#reply227","member":{"avatar":"https://cdn.v2ex.com/avatar/0d36/88cc/328450_normal.png?m=1705040400","username":"whitecosm0s"},"node":{"title":"分享创造","url":"https://www.v2ex.com/go/create"},"headerTemplate":"","title":"[抽奖送码🎁]提醒英雄，把重要事项始终放在锁屏界面，彻底解决你的健忘症","id":1055571,"type":"post","once":"","replyCount":227,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"56 天前","lastReplyUsername":"stonedongdong","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1057558","href":"https://www.v2ex.com/t/1057558#reply24","member":{"avatar":"https://cdn.v2ex.com/avatar/0c61/fe34/503476_normal.png?m=1724034473","username":"lijianan"},"node":{"title":"求职","url":"https://www.v2ex.com/go/cv"},"headerTemplate":"","title":"[杭州][求职] 前端/5 年/技术栈 React/TS/Next/杭州求内推","id":1057558,"type":"post","once":"","replyCount":24,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"66 天前","lastReplyUsername":"muxinF","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1054390","href":"https://www.v2ex.com/t/1054390#reply43","member":{"avatar":"https://cdn.v2ex.com/avatar/0c61/fe34/503476_normal.png?m=1724034473","username":"lijianan"},"node":{"title":"求职","url":"https://www.v2ex.com/go/cv"},"headerTemplate":"","title":"[杭州][求职] 前端/5 年/技术栈 React+TypeScript 杭州求内推","id":1054390,"type":"post","once":"","replyCount":43,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"83 天前","lastReplyUsername":"echo1937","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1051759","href":"https://www.v2ex.com/t/1051759#reply2","member":{"avatar":"https://cdn.v2ex.com/gravatar/e2e572807688a5c9c2c02aa111fa7662?s=24&d=retro","username":"1145148964"},"node":{"title":"分享发现","url":"https://www.v2ex.com/go/share"},"headerTemplate":"","title":"东南亚注意事项","id":1051759,"type":"post","once":"","replyCount":2,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"","lastReplyUsername":"","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1056399","href":"https://www.v2ex.com/t/1056399#reply0","member":{"avatar":"https://cdn.v2ex.com/gravatar/6bc4908bdb8220db75b3a194b2c8534f?s=24&d=retro","username":"echosoar"},"node":{"title":"分享发现","url":"https://www.v2ex.com/go/share"},"headerTemplate":"","title":"第 90 期 - 偷懒爱好者周刊 24/07/10","id":1056399,"type":"post","once":"","replyCount":0,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"95 天前","lastReplyUsername":"1145148964","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1048473","href":"https://www.v2ex.com/t/1048473#reply2","member":{"avatar":"https://cdn.v2ex.com/gravatar/e2e572807688a5c9c2c02aa111fa7662?s=24&d=retro","username":"1145148964"},"node":{"title":"分享发现","url":"https://www.v2ex.com/go/share"},"headerTemplate":"","title":"iPhone Mirroring 似乎也是期货功能中的一个。目前无法使用","id":1048473,"type":"post","once":"","replyCount":2,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"98 天前","lastReplyUsername":"fairytale","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1047550","href":"https://www.v2ex.com/t/1047550#reply11","member":{"avatar":"https://cdn.v2ex.com/gravatar/e2e572807688a5c9c2c02aa111fa7662?s=24&d=retro","username":"1145148964"},"node":{"title":"分享发现","url":"https://www.v2ex.com/go/share"},"headerTemplate":"","title":"HPE ProLiant MicroServer Gen11 发布了","id":1047550,"type":"post","once":"","replyCount":11,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"104 天前","lastReplyUsername":"vice","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1045988","href":"https://www.v2ex.com/t/1045988#reply12","member":{"avatar":"https://cdn.v2ex.com/gravatar/e2e572807688a5c9c2c02aa111fa7662?s=24&d=retro","username":"1145148964"},"node":{"title":"随想","url":"https://www.v2ex.com/go/random"},"headerTemplate":"","title":"写在儿童节。我们至少应该注意什么？至少应该做什么？","id":1045988,"type":"post","once":"","replyCount":12,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"108 天前","lastReplyUsername":"FSZR","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1044882","href":"https://www.v2ex.com/t/1044882#reply3","member":{"avatar":"https://cdn.v2ex.com/gravatar/6bc4908bdb8220db75b3a194b2c8534f?s=24&d=retro","username":"echosoar"},"node":{"title":"分享发现","url":"https://www.v2ex.com/go/share"},"headerTemplate":"","title":"第 84 期 - 偷懒爱好者周刊 24/05/29","id":1044882,"type":"post","once":"","replyCount":3,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"111 天前","lastReplyUsername":"ryan4290","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1043721","href":"https://www.v2ex.com/t/1043721#reply9","member":{"avatar":"https://cdn.v2ex.com/gravatar/e2e572807688a5c9c2c02aa111fa7662?s=24&d=retro","username":"1145148964"},"node":{"title":"职场话题","url":"https://www.v2ex.com/go/career"},"headerTemplate":"","title":"你们公司还有人住公司吗？","id":1043721,"type":"post","once":"","replyCount":9,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"111 天前","lastReplyUsername":"tagtag","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1043771","href":"https://www.v2ex.com/t/1043771#reply14","member":{"avatar":"https://cdn.v2ex.com/gravatar/e2e572807688a5c9c2c02aa111fa7662?s=24&d=retro","username":"1145148964"},"node":{"title":"分享发现","url":"https://www.v2ex.com/go/share"},"headerTemplate":"","title":"Airtag 平替使用经历分享。","id":1043771,"type":"post","once":"","replyCount":14,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false}]';
    // var te = json.decode(message);
    // setState(() {
    // list = te;
    // });
    // return;
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) async {
            rootBundle.loadString('assets/index.js').then((data) {
              print('页面加载完全');
              controller.runJavaScript(data);
            });
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
        ),
      )
      ..loadRequest(Uri.parse('https://v2ex.com'))
      ..addJavaScriptChannel('Channel', onMessageReceived: (JavaScriptMessage message) {
        print('v2-channel' + message.message);
        var te = json.decode(message.message);
        if (te['type'] == 'list') {
          print(te['data'][0]['member']['avatar']);
          print(te['data'][0]['title']);
          print(te['data'][0]['content_rendered']);
          setState(() {
            list = List<Post>.from(te['data']!.map((x) => Post.fromJson(x)));
          });
        }
        if (te['type'] == 'post') {
          bus.emit("postData", te['data']);
        }
      });
    bus.on("getPost", (arg) {
      print('on-getPost' + arg);
      controller.runJavaScript('jsBridge("getPost",' + arg + ')');
    });
  }

  submit() {
    print("test");
    controller.loadRequest(Uri.parse('https://v2ex.com'));
    // Navigator.pushNamed(context, 'Home');
  }

  getPost(post) {
    // print('object-getpost' + id.toString());
    // Navigator.pushNamed(context, 'Me', arguments: id);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Me(post: post)),
    );
    // controller.runJavaScript('jsBridge("getPost",' + id.toString() + ')');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: DefaultTextStyle(
              style: TextStyle(color: Colors.black, fontSize: 14.sp),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                    minWidth: double.infinity, //宽度尽可能大
                    minHeight: double.infinity),
                child: Stack(
                  children: <Widget>[
                    // Positioned(
                    //     top: 0,
                    //     left: 0,
                    //     width: MediaQuery.of(context).size.width,
                    //     height: 600,
                    //     child: WebViewWidget(controller: controller)),
                    Positioned(
                        top: 0,
                        left: 0,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Container(
                          color: Colors.white,
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                  top: 0,
                                  left: 0,
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  child: ListView.separated(
                                    itemCount: list.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          Row(children: [
                                            CircleAvatar(
                                              maxRadius: 14.w,
                                              backgroundImage: NetworkImage(list?[index]?.member?.avatar ?? ''),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 10),
                                              child: Text(
                                                list[index].member?.username ?? '',
                                                style: TextStyle(fontSize: 14.sp, height: 1.2),
                                              ),
                                            ),
                                          ], crossAxisAlignment: CrossAxisAlignment.center, verticalDirection: VerticalDirection.down),
                                          InkWell(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                top: 10,
                                              ),
                                              child: Text(
                                                list[index].title ?? '',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                              ),
                                            ),
                                            onTap: () => {getPost(list[index])},
                                          ),
                                          // Text(
                                          //   '为什么很多人  或「」',
                                          //   textAlign: TextAlign.left,
                                          // ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 10),
                                            child: Row(
                                              children: [
                                                Row(
                                                  children: [
                                                    DecoratedBox(
                                                      decoration: BoxDecoration(
                                                        color: Colors.black12,
                                                        borderRadius: BorderRadius.circular(3.0), //3像素圆角
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                                                        child: Text(
                                                          list[index]?.node?.title ?? '',
                                                          style: TextStyle(color: Colors.black, fontSize: 10.sp),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(left: 10),
                                                      child: Text(
                                                        list[index]?.lastReplyDate ?? '',
                                                        style: TextStyle(fontSize: 10, height: 1.2),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(left: 10),
                                                      child: Text(
                                                        '最后回复来自',
                                                        style: TextStyle(fontSize: 10, height: 1.2),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(left: 0),
                                                      child: Text(
                                                        list[index]?.lastReplyUsername ?? '',
                                                        style: TextStyle(fontSize: 13, height: 1.2, fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                DecoratedBox(
                                                  decoration: BoxDecoration(
                                                    color: Colors.black12,
                                                    borderRadius: BorderRadius.circular(6.0), //3像素圆角
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                                                    child: Text(
                                                      list[index]?.replyCount?.toString() ?? '',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 10.sp,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            ),
                                          )
                                        ]),
                                      );
                                    },
                                    //分割器构造器
                                    separatorBuilder: (BuildContext context, int index) {
                                      return Container(
                                        height: 6,
                                        color: Color(0xfff1f1f1),
                                      );
                                    },
                                  )),
                              Positioned(
                                bottom: 200,
                                right: 100,
                                child: ElevatedButton(
                                  child: Text("刷新"),
                                  onPressed: () {
                                    controller.reload();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
              )),
        ),
        onWillPop: () async {
          print("返回键点击了");
          // Navigator.pop(context);
          var isFinish = await controller.canGoBack().then((value) {
            if (value) {
              controller.goBack();
            }
            return !value;
          });
          return isFinish;
          return false;
        });
  }
}
