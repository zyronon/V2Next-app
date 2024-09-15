import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../model/Post.dart';

class Me extends StatefulWidget {
  const Me({super.key});

  @override
  State<Me> createState() => MeState();
}

class MeState extends State<Me> {
  late final WebViewController controller;

  double stateHeight = 0;
  // Post item = new Post(new Member('avatar', 'avatar_large', 'username'),
  //     'headerTemplate', 'title', 'createDateAgo');

  @override
  void initState() {
    stateHeight = MediaQueryData.fromWindow(window).padding.top;

    super.initState();

    var message =
        '[{\"allReplyUsers\":[],\"content_rendered\":\"\",\"createDate\":\"\",\"createDateAgo\":\"\",\"lastReplyDate\":\"17 小时 23 分钟前\",\"lastReplyUsername\":\"Admstor\",\"fr\":\"\",\"replyList\":[],\"topReplyList\":[],\"nestedReplies\":[],\"nestedRedundReplies\":[],\"username\":\"\",\"url\":\"https://www.v2ex.com/api/topics/show.json?id=1073167\",\"href\":\"https://www.v2ex.com/t/1073167#reply66\",\"member\":{\"avatar\":\"https://cdn.v2ex.com/gravatar/eb9f93e315a76487f1ca6e3c4efa6d02?s=24&d=retro\",\"username\":\"Earsum\"},\"node\":{\"title\":\"问与答\",\"url\":\"https://www.v2ex.com/go/qna\"},\"headerTemplate\":\"\",\"title\":\"现在阿里系的购物软件真的还有必要存在吗？\",\"id\":1073167,\"type\":\"post\",\"once\":\"\",\"replyCount\":66,\"clickCount\":0,\"thankCount\":0,\"collectCount\":0,\"lastReadFloor\":0,\"isFavorite\":false,\"isIgnore\":false,\"isThanked\":false,\"isReport\":false,\"inList\":false},{\"allReplyUsers\":[],\"content_rendered\":\"\",\"createDate\":\"\",\"createDateAgo\":\"\",\"lastReplyDate\":\"8 分钟前\",\"lastReplyUsername\":\"Admstor\",\"fr\":\"\",\"replyList\":[],\"topReplyList\":[],\"nestedReplies\":[],\"nestedRedundReplies\":[],\"username\":\"\",\"url\":\"https://www.v2ex.com/api/topics/show.json?id=1073207\",\"href\":\"https://www.v2ex.com/t/1073207#reply62\",\"member\":{\"avatar\":\"https://cdn.v2ex.com/gravatar/f85de639bb82e0f83cbf419a15fbb947?s=24&d=retro\",\"username\":\"t4we\"},\"node\":{\"title\":\"NAS\",\"url\":\"https://www.v2ex.com/go/nas\"},\"headerTemplate\":\"\",\"title\":\"原来云盘文件在 Server 是不加密的\",\"id\":1073207,\"type\":\"post\",\"once\":\"\",\"replyCount\":62,\"clickCount\":0,\"thankCount\":0,\"collectCount\":0,\"lastReadFloor\":0,\"isFavorite\":false,\"isIgnore\":false,\"isThanked\":false,\"isReport\":false,\"inList\":false},{\"allReplyUsers\":[],\"content_rendered\":\"\",\"createDate\":\"\",\"createDateAgo\":\"\",\"lastReplyDate\":\"1 小时 2 分钟前\",\"lastReplyUsername\":\"wweerrgtc\",\"fr\":\"\",\"replyList\":[],\"topReplyList\":[],\"nestedReplies\":[],\"nestedRedundReplies\":[],\"username\":\"\",\"url\":\"https://www.v2ex.com/api/topics/show.json?id=1073179\",\"href\":\"https://www.v2ex.com/t/1073179#reply56\",\"member\":{\"avatar\":\"https://cdn.v2ex.com/gravatar/e589f3bcac3d146c80b717b18c16ac1e?s=24&d=retro\",\"username\":\"phx13ye\"},\"node\":{\"title\":\"程序员\",\"url\":\"https://www.v2ex.com/go/programmer\"},\"headerTemplate\":\"\",\"title\":\"退役老旧电脑，没卖的话，你们会用来干什么？ 2024 版\",\"id\":1073179,\"type\":\"post\",\"once\":\"\",\"replyCount\":56,\"clickCount\":0,\"thankCount\":0,\"collectCount\":0,\"lastReadFloor\":0,\"isFavorite\":false,\"isIgnore\":false,\"isThanked\":false,\"isReport\":false,\"inList\":false},{\"allReplyUsers\":[],\"content_rendered\":\"\",\"createDate\":\"\",\"createDateAgo\":\"\",\"lastReplyDate\":\"39 分钟前\",\"lastReplyUsername\":\"ZeawinL\",\"fr\":\"\",\"replyList\":[],\"topReplyList\":[],\"nestedReplies\":[],\"nestedRedundReplies\":[],\"username\":\"\",\"url\":\"https://www.v2ex.com/api/topics/show.json?id=1073176\",\"href\":\"https://www.v2ex.com/t/1073176#reply41\",\"member\":{\"avatar\":\"https://cdn.v2ex.com/avatar/b87a/4d18/451225_normal.png?m=1726372399\",\"username\":\"imblues\"},\"node\":{\"title\":\"职场话题\",\"url\":\"https://www.v2ex.com/go/career\"},\"headerTemplate\":\"\",\"title\":\"目前身边失业的人越来越多，想做一下统计。\",\"id\":1073176,\"type\":\"post\",\"once\":\"\",\"replyCount\":41,\"clickCount\":0,\"thankCount\":0,\"collectCount\":0,\"lastReadFloor\":0,\"isFavorite\":false,\"isIgnore\":false,\"isThanked\":false,\"isReport\":false,\"inList\":false},{\"allReplyUsers\":[],\"content_rendered\":\"\",\"createDate\":\"\",\"createDateAgo\":\"\",\"lastReplyDate\":\"1 小时 41 分钟前\",\"lastReplyUsername\":\"sunmker\",\"fr\":\"\",\"replyList\":[],\"topReplyList\":[],\"nestedReplies\":[],\"nestedRedundReplies\":[],\"username\":\"\",\"url\":\"https://www.v2ex.com/api/topics/show.json?id=1073188\",\"href\":\"https://www.v2ex.com/t/1073188#reply39\",\"member\":{\"avatar\":\"https://cdn.v2ex.com/avatar/387f/986a/60691_normal.png?m=1689252237\",\"username\":\"justincnn\"},\"node\":{\"title\":\"Google\",\"url\":\"https://www.v2ex.com/go/google\"},\"headerTemplate\":\"\",\"title\":\"现在 android 有什么办法熄屏听油管么？\",\"id\":1073188,\"type\":\"post\",\"once\":\"\",\"replyCount\":39,\"clickCount\":0,\"thankCount\":0,\"collectCount\":0,\"lastReadFloor\":0,\"isFavorite\":false,\"isIgnore\":false,\"isThanked\":false,\"isReport\":false,\"inList\":false},{\"allReplyUsers\":[],\"content_rendered\":\"\",\"createDate\":\"\",\"createDateAgo\":\"\",\"lastReplyDate\":\"40 分钟前\",\"lastReplyUsername\":\"Donaldo\",\"fr\":\"\",\"replyList\":[],\"topReplyList\":[],\"nestedReplies\":[],\"nestedRedundReplies\":[],\"username\":\"\",\"url\":\"https://www.v2ex.com/api/topics/show.json?id=1073161\",\"href\":\"https://www.v2ex.com/t/1073161#reply37\",\"member\":{\"avatar\":\"https://cdn.v2ex.com/gravatar/cf088dd4af96fb317a7c820cd3064a62?s=24&d=retro\",\"username\":\"omz\"},\"node\":{\"title\":\"Telegram\",\"url\":\"https://www.v2ex.com/go/telegram\"},\"headerTemplate\":\"\",\"title\":\"请问哪里开 TG 会员便宜？\",\"id\":1073161,\"type\":\"post\",\"once\":\"\",\"replyCount\":37,\"clickCount\":0,\"thankCount\":0,\"collectCount\":0,\"lastReadFloor\":0,\"isFavorite\":false,\"isIgnore\":false,\"isThanked\":false,\"isReport\":false,\"inList\":false},{\"allReplyUsers\":[],\"content_rendered\":\"\",\"createDate\":\"\",\"createDateAgo\":\"\",\"lastReplyDate\":\"52 分钟前\",\"lastReplyUsername\":\"lanmorsylvia0210\",\"fr\":\"\",\"replyList\":[],\"topReplyList\":[],\"nestedReplies\":[],\"nestedRedundReplies\":[],\"username\":\"\",\"url\":\"https://www.v2ex.com/api/topics/show.json?id=1073189\",\"href\":\"https://www.v2ex.com/t/1073189#reply37\",\"member\":{\"avatar\":\"https://cdn.v2ex.com/gravatar/46ebf42d3ed4c89801dc7ef397010f48?s=24&d=retro\",\"username\":\"XuYijie\"},\"node\":{\"title\":\"生活方式\",\"url\":\"https://www.v2ex.com/go/lifestyle\"},\"headerTemplate\":\"\",\"title\":\"友友们，奢侈品牌男装有哪些呀\",\"id\":1073189,\"type\":\"post\",\"once\":\"\",\"replyCount\":37,\"clickCount\":0,\"thankCount\":0,\"collectCount\":0,\"lastReadFloor\":0,\"isFavorite\":false,\"isIgnore\":false,\"isThanked\":false,\"isReport\":false,\"inList\":false},{\"allReplyUsers\":[],\"content_rendered\":\"\",\"createDate\":\"\",\"createDateAgo\":\"\",\"lastReplyDate\":\"1 小时 21 分钟前\",\"lastReplyUsername\":\"kkbear\",\"fr\":\"\",\"replyList\":[],\"topReplyList\":[],\"nestedReplies\":[],\"nestedRedundReplies\":[],\"username\":\"\",\"url\":\"https://www.v2ex.com/api/topics/show.json?id=1073168\",\"href\":\"https://www.v2ex.com/t/1073168#reply36\",\"member\":{\"avatar\":\"https://cdn.v2ex.com/avatar/694d/0934/655828_normal.png?m=1717637009\",\"username\":\"EndlessMemory\"},\"node\":{\"title\":\"问与答\",\"url\":\"https://www.v2ex.com/go/qna\"},\"headerTemplate\":\"\",\"title\":\"晚上睡觉总是入睡很慢咋办？还容易中途醒\",\"id\":1073168,\"type\":\"post\",\"once\":\"\",\"replyCount\":36,\"clickCount\":0,\"thankCount\":0,\"collectCount\":0,\"lastReadFloor\":0,\"isFavorite\":false,\"isIgnore\":false,\"isThanked\":false,\"isReport\":false,\"inList\":false},{\"allReplyUsers\":[],\"content_rendered\":\"\",\"createDate\":\"\",\"createDateAgo\":\"\",\"lastReplyDate\":\"3 小时 9 分钟前\",\"lastReplyUsername\":\"NatsuSaw\",\"fr\":\"\",\"replyList\":[],\"topReplyList\":[],\"nestedReplies\":[],\"nestedRedundReplies\":[],\"username\":\"\",\"url\":\"https://www.v2ex.com/api/topics/show.json?id=1073226\",\"href\":\"https://www.v2ex.com/t/1073226#reply33\",\"member\":{\"avatar\":\"https://cdn.v2ex.com/avatar/4733/13f5/631937_normal.png?m=1685605797\",\"username\":\"NatsuSaw\"},\"node\":{\"title\":\"职场话题\",\"url\":\"https://www.v2ex.com/go/career\"},\"headerTemplate\":\"\",\"title\":\"公司规矩越来越多，准备跑路，能帮我分析后续做什么方向更好一点吗？\",\"id\":1073226,\"type\":\"post\",\"once\":\"\",\"replyCount\":33,\"clickCount\":0,\"thankCount\":0,\"collectCount\":0,\"lastReadFloor\":0,\"isFavorite\":false,\"isIgnore\":false,\"isThanked\":false,\"isReport\":false,\"inList\":false},{\"allReplyUsers\":[],\"content_rendered\":\"\",\"createDate\":\"\",\"createDateAgo\":\"\",\"lastReplyDate\":\"8 小时 41 分钟前\",\"lastReplyUsername\":\"gojo\",\"fr\":\"\",\"replyList\":[],\"topReplyList\":[],\"nestedReplies\":[],\"nestedRedundReplies\":[],\"username\":\"\",\"url\":\"https://www.v2ex.com/api/topics/show.json?id=1073154\",\"href\":\"https://www.v2ex.com/t/1073154#reply29\",\"member\":{\"avatar\":\"https://cdn.v2ex.com/gravatar/b3a6fc71b74c1a2798cb4e1fae79183a?s=24&d=retro\",\"username\":\"xiaoshiforking\"},\"node\":{\"title\":\"电影\",\"url\":\"https://www.v2ex.com/go/movie\"},\"headerTemplate\":\"\",\"title\":\"观影小组成立啦！\",\"id\":1073154,\"type\":\"post\",\"once\":\"\",\"replyCount\":29,\"clickCount\":0,\"thankCount\":0,\"collectCount\":0,\"lastReadFloor\":0,\"isFavorite\":false,\"isIgnore\":false,\"isThanked\":false,\"isReport\":false,\"inList\":false},{\"allReplyUsers\":[],\"content_rendered\":\"\",\"createDate\":\"\",\"createDateAgo\":\"\",\"lastReplyDate\":\"1 小时 58 分钟前\",\"lastReplyUsername\":\"lixintcwdsg\",\"fr\":\"\",\"replyList\":[],\"topReplyList\":[],\"nestedReplies\":[],\"nestedRedundReplies\":[],\"username\":\"\",\"url\":\"https://www.v2ex.com/api/topics/show.json?id=1073187\",\"href\":\"https://www.v2ex.com/t/1073187#reply28\",\"member\":{\"avatar\":\"https://cdn.v2ex.com/avatar/cefd/e096/126810_normal.png?m=1592616370\",\"username\":\"cz5424\"},\"node\":{\"title\":\"硬件\",\"url\":\"https://www.v2ex.com/go/hardware\"},\"headerTemplate\":\"\",\"title\":\"求推荐一款显示器，需要 4k 和反向充电，兼顾 Win 玩游戏\",\"id\":1073187,\"type\":\"post\",\"once\":\"\",\"replyCount\":28,\"clickCount\":0,\"thankCount\":0,\"collectCount\":0,\"lastReadFloor\":0,\"isFavorite\":false,\"isIgnore\":false,\"isThanked\":false,\"isReport\":false,\"inList\":false},{\"allReplyUsers\":[],\"content_rendered\":\"\",\"createDate\":\"\",\"createDateAgo\":\"\",\"lastReplyDate\":\"9 小时 26 分钟前\",\"lastReplyUsername\":\"dream7758522\",\"fr\":\"\",\"replyList\":[],\"topReplyList\":[],\"nestedReplies\":[],\"nestedRedundReplies\":[],\"username\":\"\",\"url\":\"https://www.v2ex.com/api/topics/show.json?id=1073164\",\"href\":\"https://www.v2ex.com/t/1073164#reply22\",\"member\":{\"avatar\":\"https://cdn.v2ex.com/avatar/1445/6b2d/640833_normal.png?m=1726362284\",\"username\":\"ZTBOXS\"},\"node\":{\"title\":\"分享发现\",\"url\":\"https://www.v2ex.com/go/share\"},\"headerTemplate\":\"\",\"title\":\"百度网盘偷偷把我网盘数据清了！给别的用户使用\",\"id\":1073164,\"type\":\"post\",\"once\":\"\",\"replyCount\":22,\"clickCount\":0,\"thankCount\":0,\"collectCount\":0,\"lastReadFloor\":0,\"isFavorite\":false,\"isIgnore\":false,\"isThanked\":false,\"isReport\":false,\"inList\":false},{\"allReplyUsers\":[],\"content_rendered\":\"\",\"createDate\":\"\",\"createDateAgo\":\"\",\"lastReplyDate\":\"1 小时 24 分钟前\",\"lastReplyUsername\":\"cwxiaos\",\"fr\":\"\",\"replyList\":[],\"topReplyList\":[],\"nestedReplies\":[],\"nestedRedundReplies\":[],\"username\":\"\",\"url\":\"https://www.v2ex.com/api/topics/show.json?id=1073193\",\"href\":\"https://www.v2ex.com/t/1073193#reply22\",\"member\":{\"avatar\":\"https://cdn.v2ex.com/avatar/bf21/15ea/396773_normal.png?m=1716031759\",\"username\":\"1014982466\"},\"node\":{\"title\":\"宽带症候群\",\"url\":\"https://www.v2ex.com/go/bb\"},\"headerTemplate\":\"\",\"title\":\"在香港买 6Ghz 路由器带回来能否用 6Ghz？\",\"id\":1073193,\"type\":\"post\",\"once\":\"\",\"replyCount\":22,\"clickCount\":0,\"thankCount\":0,\"collectCount\":0,\"lastReadFloor\":0,\"isFavorite\":false,\"isIgnore\":false,\"isThanked\":false,\"isReport\":false,\"inList\":false},{\"allReplyUsers\":[],\"content_rendered\":\"\",\"createDate\":\"\",\"createDateAgo\":\"\",\"lastReplyDate\":\"6 分钟前\",\"lastReplyUsername\":\"CHENYIMING\",\"fr\":\"\",\"replyList\":[],\"topReplyList\":[],\"nestedReplies\":[],\"nestedRedundReplies\":[],\"username\":\"\",\"url\":\"https://www.v2ex.com/api/topics/show.json?id=1073211\",\"href\":\"https://www.v2ex.com/t/1073211#reply20\",\"member\":{\"avatar\":\"https://cdn.v2ex.com/avatar/cff8/15da/16836_normal.png?m=1332699166\",\"username\":\"lvdie\"},\"node\":{\"title\":\"问与答\",\"url\":\"https://www.v2ex.com/go/qna\"},\"headerTemplate\":\"\",\"title\":\"老人经常走丢，推荐一款 GPS 追踪类设备\",\"id\":1073211,\"type\":\"post\",\"once\":\"\",\"replyCount\":20,\"clickCount\":0,\"thankCount\":0,\"collectCount\":0,\"lastReadFloor\":0,\"isFavorite\":false,\"isIgnore\":false,\"isThanked\":false,\"isReport\":false,\"inList\":false},{\"allReplyUsers\":[],\"content_rendered\":\"\",\"createDate\":\"\",\"createDateAgo\":\"\",\"lastReplyDate\":\"11 小时 8 分钟前\",\"lastReplyUsername\":\"Damn\",\"fr\":\"\",\"replyList\":[],\"topReplyList\":[],\"nestedReplies\":[],\"nestedRedundReplies\":[],\"username\":\"\",\"url\":\"https://www.v2ex.com/api/topics/show.json?id=1073170\",\"href\":\"https://www.v2ex.com/t/1073170#reply19\",\"member\":{\"avatar\":\"https://cdn.v2ex.com/avatar/09fe/9201/676846_normal.png?m=1713022885\",\"username\":\"gsy20050126819\"},\"node\":{\"title\":\"iPhone\",\"url\":\"https://www.v2ex.com/go/iphone\"},\"headerTemplate\":\"\",\"title\":\"钥匙链清理工具 KCleaner V2.2 已发布\",\"id\":1073170,\"type\":\"post\",\"once\":\"\",\"replyCount\":19,\"clickCount\":0,\"thankCount\":0,\"collectCount\":0,\"lastReadFloor\":0,\"isFavorite\":false,\"isIgnore\":false,\"isThanked\":false,\"isReport\":false,\"inList\":false},{\"allReplyUsers\":[],\"content_rendered\":\"\",\"createDate\":\"\",\"createDateAgo\":\"\",\"lastReplyDate\":\"2 小时 3 分钟前\",\"lastReplyUsername\":\"zoharSoul\",\"fr\":\"\",\"replyList\":[],\"topReplyList\":[],\"nestedReplies\":[],\"nestedRedundReplies\":[],\"username\":\"\",\"url\":\"https://www.v2ex.com/api/topics/show.json?id=1073174\",\"href\":\"https://www.v2ex.com/t/1073174#reply18\",\"member\":{\"avatar\":\"https://cdn.v2ex.com/gravatar/afc903abdf889c69f7ed78fb32eb4c9d?s=24&d=retro\",\"username\":\"chenxiankong\"},\"node\":{\"title\":\"健康\",\"url\":\"https://www.v2ex.com/go/fit\"},\"headerTemplate\":\"\",\"title\":\"求助，早上睡醒必鼻塞\",\"id\":1073174,\"type\":\"post\",\"once\":\"\",\"replyCount\":18,\"clickCount\":0,\"thankCount\":0,\"collectCount\":0,\"lastReadFloor\":0,\"isFavorite\":false,\"isIgnore\":false,\"isThanked\":false,\"isReport\":false,\"inList\":false},{\"allReplyUsers\":[],\"content_rendered\":\"\",\"createDate\":\"\",\"createDateAgo\":\"\",\"lastReplyDate\":\"54 分钟前\",\"lastReplyUsername\":\"wweerrgtc\",\"fr\":\"\",\"replyList\":[],\"topReplyList\":[],\"nestedReplies\":[],\"nestedRedundReplies\":[],\"username\":\"\",\"url\":\"https://www.v2ex.com/api/topics/show.json?id=1073222\",\"href\":\"https://www.v2ex.com/t/1073222#reply18\",\"member\":{\"avatar\":\"https://cdn.v2ex.com/avatar/a1e0/f36a/606787_normal.png?m=1726390724\",\"username\":\"iampure\"},\"node\":{\"title\":\"问与答\",\"url\":\"https://www.v2ex.com/go/qna\"},\"headerTemplate\":\"\",\"title\":\"现在 ios 有什么办法熄屏听油管么？\",\"id\":1073222,\"type\":\"post\",\"once\":\"\",\"replyCount\":18,\"clickCount\":0,\"thankCount\":0,\"collectCount\":0,\"lastReadFloor\":0,\"isFavorite\":false,\"isIgnore\":false,\"isThanked\":false,\"isReport\":false,\"inList\":false},{\"allReplyUsers\":[],\"content_rendered\":\"\",\"createDate\":\"\",\"createDateAgo\":\"\",\"lastReplyDate\":\"2 小时 46 分钟前\",\"lastReplyUsername\":\"shouh\",\"fr\":\"\",\"replyList\":[],\"topReplyList\":[],\"nestedReplies\":[],\"nestedRedundReplies\":[],\"username\":\"\",\"url\":\"https://www.v2ex.com/api/topics/show.json?id=1073156\",\"href\":\"https://www.v2ex.com/t/1073156#reply16\",\"member\":{\"avatar\":\"https://cdn.v2ex.com/gravatar/8ced7c8da7ab5b6a1667ef426d9c3774?s=24&d=retro\",\"username\":\"selich\"},\"node\":{\"title\":\"投资\",\"url\":\"https://www.v2ex.com/go/invest\"},\"headerTemplate\":\"\",\"title\":\"如果一个人研究出了一个正期望的量化交易策略，他接下来会如何做？\",\"id\":1073156,\"type\":\"post\",\"once\":\"\",\"replyCount\":16,\"clickCount\":0,\"thankCount\":0,\"collectCount\":0,\"lastReadFloor\":0,\"isFavorite\":false,\"isIgnore\":false,\"isThanked\":false,\"isReport\":false,\"inList\":false},{\"allReplyUsers\":[],\"content_rendered\":\"\",\"createDate\":\"\",\"createDateAgo\":\"\",\"lastReplyDate\":\"22 分钟前\",\"lastReplyUsername\":\"Nosub\",\"fr\":\"\",\"replyList\":[],\"topReplyList\":[],\"nestedReplies\":[],\"nestedRedundReplies\":[],\"username\":\"\",\"url\":\"https://www.v2ex.com/api/topics/show.json?id=1073259\",\"href\":\"https://www.v2ex.com/t/1073259#reply16\",\"member\":{\"avatar\":\"https://cdn.v2ex.com/avatar/697a/ffe6/545915_normal.png?m=1694762151\",\"username\":\"LitterGopher\"},\"node\":{\"title\":\"Linux\",\"url\":\"https://www.v2ex.com/go/linux\"},\"headerTemplate\":\"\",\"title\":\"原本打算换电脑，但是突然觉得还可以再坚持几年\",\"id\":1073259,\"type\":\"post\",\"once\":\"\",\"replyCount\":16,\"clickCount\":0,\"thankCount\":0,\"collectCount\":0,\"lastReadFloor\":0,\"isFavorite\":false,\"isIgnore\":false,\"isThanked\":false,\"isReport\":false,\"inList\":false},{\"allReplyUsers\":[],\"content_rendered\":\"\",\"createDate\":\"\",\"createDateAgo\":\"\",\"lastReplyDate\":\"10 小时 55 分钟前\",\"lastReplyUsername\":\"yb2313\",\"fr\":\"\",\"replyList\":[],\"topReplyList\":[],\"nestedReplies\":[],\"nestedRedundReplies\":[],\"username\":\"\",\"url\":\"https://www.v2ex.com/api/topics/show.json?id=1073158\",\"href\":\"https://www.v2ex.com/t/1073158#reply15\",\"member\":{\"avatar\":\"https://cdn.v2ex.com/avatar/5fd5/33c7/136189_normal.png?m=1723538364\",\"username\":\"andforce\"},\"node\":{\"title\":\"分享创造\",\"url\":\"https://www.v2ex.com/go/create\"},\"headerTemplate\":\"\",\"title\":\"[开源] 打造自己的语音电话助理，用魔法打败垃圾推销电话， AI-Phone-Call\",\"id\":1073158,\"type\":\"post\",\"once\":\"\",\"replyCount\":15,\"clickCount\":0,\"thankCount\":0,\"collectCount\":0,\"lastReadFloor\":0,\"isFavorite\":false,\"isIgnore\":false,\"isThanked\":false,\"isReport\":false,\"inList\":false}]';
    var te = json.decode(message);
    // Post.fromJson(jsonDecode('{"reply_content": "@<a href=\"/member/steve009\">steve009</a> #1 有趣的观点😂，不过也确实有道理"}'));
    setState(() {
      // item = te;
    });

    print(te['allReplyUsers'].toString());
    // print(item.member.avatar_large);
    return;
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
      ..addJavaScriptChannel('Channel',
          onMessageReceived: (JavaScriptMessage message) {
        print('v2-channel' + message.message);
      });
  }

  submit() {
    print("test");
    controller.loadRequest(Uri.parse('https://v2ex.com'));
    // Navigator.pushNamed(context, 'Home');
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
                      child: Stack(
                        children: <Widget>[
                          // Positioned(
                          //   bottom: 200,
                          //   right: 100,
                          //   child: ElevatedButton(
                          //     child: Text("normal12"),
                          //     onPressed: () {
                          //       controller.reload();
                          //     },
                          //   ),
                          // ),
                          Positioned(
                            top: 0,
                            left: 0,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: ListView.separated(
                              itemCount: 100,
                              itemBuilder: (BuildContext context, int index) {
                                if (index == 0) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          // CircleAvatar(
                                          //   maxRadius: 14.w,
                                          //   backgroundImage: NetworkImage(
                                          //       item.title),
                                          // ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Text(
                                              // item.title,
                                              '',
                                              style: TextStyle(
                                                  fontSize: 14.sp, height: 1.2),
                                            ),
                                          ),
                                        ],
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        verticalDirection:
                                            VerticalDirection.down,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: 6,
                                        ),
                                        child: Text(
                                          // item.title,
                                          '',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ),
                                      HtmlWidget(
                                        // the first parameter (`html`) is required
                                        '''
<div data-v-f8165980="" data-v-546d3b11="" class="html-wrapper"><div data-v-f8165980="" class=""><div data-v-f8165980="">

<div class="cell">
<div class="topic_content"><div class="markdown_body"><p>事情是这样的，小区楼下有一个新疆羊肉串烧烤店，拉着小孩路过店门口的时候，小孩远远的就被店门口的霓虹灯吸引了在哪儿手舞足蹈，店门口一个四五十岁左右的新疆女人看见了上下摇着脑头笑着逗他，当我们走到店门口的时候她突然跑过来亲了一下小孩的嘴，然后又亲了一下脸，我都没反应过来连忙说了一声哎哎，然后她说了一句他在学走路呀，我说嗯，就又拉着小孩走了。</p>
<p>事后我给媳妇说了，很生气的说我们都没亲过嘴呢，我们又不认识他。我解释说到人家是喜欢你小孩，用亲吻表达出来而已，人家那边就这样吧，没有恶意，前段时间我还看见过她们店里其他女人把食物嚼碎了喂小孩的。</p>
<p>我也寻思着这是善意的还是恶意的，想问问 V 友们</p>
</div></div>
</div>
<div class="subtle">
<span class="fade">第 1 条附言 &nbsp;·&nbsp; 6 小时 51 分钟前</span>
<div class="sep"></div>
<div class="topic_content">看了回复很多挺吓人的，这个女的是烧烤店里面的一个店员，里面全是新疆人。我觉得吧恶意成分应该不大，可能他们不知道很多人会介意这样，我现在后悔的就是当时没有找她理论，表示不满。<br><br>现在事后去找她理论吗，真的有必要去医院检查吗，还有就是才一个晚上能检测出问题吗</div>
</div>
<div class="subtle">
<span class="fade">第 2 条附言 &nbsp;·&nbsp; 1 小时 58 分钟前</span>
<div class="sep"></div>
<div class="topic_content">当时没和她理论，过后去理论能说清楚吗</div>
</div>

</div></div><!----></div>
  ''',
                                        renderMode: RenderMode.column,
                                        textStyle: TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  );
                                }
                                return Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                            children: [
                                              CircleAvatar(
                                                maxRadius: 14.w,
                                                backgroundImage: NetworkImage(
                                                    "https://avatars2.githubusercontent.com/u/20411648?s=460&v=4"),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                    child: Text(
                                                      'zyronon',
                                                      style: TextStyle(
                                                          fontSize: 14.sp,
                                                          height: 1.2),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10),
                                                        child: Text(
                                                          '1楼',
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              height: 1.2),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10),
                                                        child: Text(
                                                          '1小时30分钟前',
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              height: 1.2),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              )
                                            ],
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            verticalDirection:
                                                VerticalDirection.down),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: 10,
                                          ),
                                          child: Text(
                                            '为什么很多人都用《》表示引用，而不用 “” 或「」',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Row(
                                            children: [
                                              DecoratedBox(
                                                decoration: BoxDecoration(
                                                  color: Colors.black12,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          6.0), //3像素圆角
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 6.0,
                                                      vertical: 2.0),
                                                  child: Text(
                                                    "123",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 10.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                          ),
                                        )
                                      ]),
                                );
                              },
                              //分割器构造器
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return Container(
                                  height: 1,
                                  color: Color(0xfff1f1f1),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )),
        ),
        onWillPop: () async {
          print("返回键点击了");
          Navigator.pop(context);
          // var isFinish = await controller.canGoBack().then((value) {
          //   if (value) {
          //     controller.goBack();
          //   }
          //   return !value;
          // });
          // return isFinish;
          return false;
        });
  }
}
