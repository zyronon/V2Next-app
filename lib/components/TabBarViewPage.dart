import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:v2ex/bus.dart';
import 'package:v2ex/model/Post.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TabBarViewPage extends StatefulWidget {
  final String node;

  const TabBarViewPage({super.key, required this.node});

  @override
  State<TabBarViewPage> createState() => _TabBarViewPageState();
}

class _TabBarViewPageState extends State<TabBarViewPage> with AutomaticKeepAliveClientMixin {
  late final WebViewController controller;
  double stateHeight = 0;
  List<Post> list = [];

  List tabs = ["最热", "最新", '全部', "问与答", "酷工作", "最新"];

  @override
  void initState() {
    stateHeight = MediaQueryData.fromWindow(window).padding.top;
    print('请求数据' + widget.node);

    super.initState();
    // var message ='';
    var message =
        '[{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"36 天前","lastReplyUsername":"Maca","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1061976","href":"https://www.v2ex.com/t/1061976#reply43","member":{"avatar":"https://cdn.v2ex.com/avatar/0d36/88cc/328450_normal.png?m=1705040400","username":"whitecosm0s"},"node":{"title":"分享创造","url":"https://www.v2ex.com/go/create"},"headerTemplate":"","title":"[送兑换码]提醒英雄更新了 1.7 版本, 新增检查清单，持续提醒等功能。这是一个高颜值，设计优雅的\\"提醒事项\\"替代品","id":1061976,"type":"post","once":"","replyCount":43,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false}]';
    message =
        '[{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"17 小时 15 分钟前","lastReplyUsername":"fengsi","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1073167","href":"https://www.v2ex.com/t/1073167#reply65","member":{"avatar":"https://cdn.v2ex.com/gravatar/eb9f93e315a76487f1ca6e3c4efa6d02?s=24&d=retro","username":"Earsum"},"node":{"title":"问与答","url":"https://www.v2ex.com/go/qna"},"headerTemplate":"","title":"现在阿里系的购物软件真的还有必要存在吗？","id":"1073167","type":"post","once":"","replyCount":65,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false}]';
    // var message ='[{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"5 小时 38 分钟前","lastReplyUsername":"1145148964","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1073009","href":"https://www.v2ex.com/t/1073009#reply2","member":{"avatar":"https://cdn.v2ex.com/gravatar/e2e572807688a5c9c2c02aa111fa7662?s=24&d=retro","username":"1145148964"},"node":{"title":"投资","url":"https://www.v2ex.com/go/invest"},"headerTemplate":"","title":"百万美元鏖战纽约交易所","id":1073009,"type":"post","once":"","replyCount":2,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"","lastReplyUsername":"","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1070308","href":"https://www.v2ex.com/t/1070308#reply0","member":{"avatar":"https://cdn.v2ex.com/gravatar/e2e572807688a5c9c2c02aa111fa7662?s=24&d=retro","username":"1145148964"},"node":{"title":"推广","url":"https://www.v2ex.com/go/promotions"},"headerTemplate":"","title":"各位对海外私募基金有兴趣吗？","id":1070308,"type":"post","once":"","replyCount":0,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"10 天前","lastReplyUsername":"dividez","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1066039","href":"https://www.v2ex.com/t/1066039#reply206","member":{"avatar":"https://cdn.v2ex.com/avatar/0c61/fe34/503476_normal.png?m=1724034473","username":"lijianan"},"node":{"title":"职场话题","url":"https://www.v2ex.com/go/career"},"headerTemplate":"","title":"时隔一个月，我又来分享面试经历了","id":1066039,"type":"post","once":"","replyCount":206,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"13 天前","lastReplyUsername":"crocoBaby","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1069255","href":"https://www.v2ex.com/t/1069255#reply34","member":{"avatar":"https://cdn.v2ex.com/gravatar/e2e572807688a5c9c2c02aa111fa7662?s=24&d=retro","username":"1145148964"},"node":{"title":"职场话题","url":"https://www.v2ex.com/go/career"},"headerTemplate":"","title":"楼主被从“中部省会”调到乌鲁木齐了。工资 1.5 倍。准备辞职了。","id":1069255,"type":"post","once":"","replyCount":34,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"16 天前","lastReplyUsername":"whitecosm0s","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1067222","href":"https://www.v2ex.com/t/1067222#reply84","member":{"avatar":"https://cdn.v2ex.com/avatar/0d36/88cc/328450_normal.png?m=1705040400","username":"whitecosm0s"},"node":{"title":"分享创造","url":"https://www.v2ex.com/go/create"},"headerTemplate":"","title":"提醒清单，利用后台任务实现绝对提醒，从此拥有高效自律的生活，送出 10000 个优惠代码！","id":1067222,"type":"post","once":"","replyCount":84,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"34 天前","lastReplyUsername":"VikingX","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1060838","href":"https://www.v2ex.com/t/1060838#reply194","member":{"avatar":"https://cdn.v2ex.com/avatar/0c61/fe34/503476_normal.png?m=1724034473","username":"lijianan"},"node":{"title":"求职","url":"https://www.v2ex.com/go/cv"},"headerTemplate":"","title":"五年前端，记录下最近一年的面试记录，顺便求个内推","id":1060838,"type":"post","once":"","replyCount":194,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"36 天前","lastReplyUsername":"Maca","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1061976","href":"https://www.v2ex.com/t/1061976#reply43","member":{"avatar":"https://cdn.v2ex.com/avatar/0d36/88cc/328450_normal.png?m=1705040400","username":"whitecosm0s"},"node":{"title":"分享创造","url":"https://www.v2ex.com/go/create"},"headerTemplate":"","title":"[送兑换码]提醒英雄更新了 1.7 版本, 新增检查清单，持续提醒等功能。这是一个高颜值，设计优雅的\"提醒事项\"替代品","id":1061976,"type":"post","once":"","replyCount":43,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"39 天前","lastReplyUsername":"li24361","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1062448","href":"https://www.v2ex.com/t/1062448#reply16","member":{"avatar":"https://cdn.v2ex.com/gravatar/e2e572807688a5c9c2c02aa111fa7662?s=24&d=retro","username":"1145148964"},"node":{"title":"问与答","url":"https://www.v2ex.com/go/qna"},"headerTemplate":"","title":"求推荐 2000 左右的显卡。200 左右的键盘鼠标。","id":1062448,"type":"post","once":"","replyCount":16,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"45 天前","lastReplyUsername":"blessedbin","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1061344","href":"https://www.v2ex.com/t/1061344#reply3","member":{"avatar":"https://cdn.v2ex.com/gravatar/6bc4908bdb8220db75b3a194b2c8534f?s=24&d=retro","username":"echosoar"},"node":{"title":"分享创造","url":"https://www.v2ex.com/go/create"},"headerTemplate":"","title":"第 93 期 - 偷懒爱好者周刊 24/07/31","id":1061344,"type":"post","once":"","replyCount":3,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"53 天前","lastReplyUsername":"whitecosm0s","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1055571","href":"https://www.v2ex.com/t/1055571#reply227","member":{"avatar":"https://cdn.v2ex.com/avatar/0d36/88cc/328450_normal.png?m=1705040400","username":"whitecosm0s"},"node":{"title":"分享创造","url":"https://www.v2ex.com/go/create"},"headerTemplate":"","title":"[抽奖送码🎁]提醒英雄，把重要事项始终放在锁屏界面，彻底解决你的健忘症","id":1055571,"type":"post","once":"","replyCount":227,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"56 天前","lastReplyUsername":"stonedongdong","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1057558","href":"https://www.v2ex.com/t/1057558#reply24","member":{"avatar":"https://cdn.v2ex.com/avatar/0c61/fe34/503476_normal.png?m=1724034473","username":"lijianan"},"node":{"title":"求职","url":"https://www.v2ex.com/go/cv"},"headerTemplate":"","title":"[杭州][求职] 前端/5 年/技术栈 React/TS/Next/杭州求内推","id":1057558,"type":"post","once":"","replyCount":24,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"66 天前","lastReplyUsername":"muxinF","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1054390","href":"https://www.v2ex.com/t/1054390#reply43","member":{"avatar":"https://cdn.v2ex.com/avatar/0c61/fe34/503476_normal.png?m=1724034473","username":"lijianan"},"node":{"title":"求职","url":"https://www.v2ex.com/go/cv"},"headerTemplate":"","title":"[杭州][求职] 前端/5 年/技术栈 React+TypeScript 杭州求内推","id":1054390,"type":"post","once":"","replyCount":43,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"83 天前","lastReplyUsername":"echo1937","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1051759","href":"https://www.v2ex.com/t/1051759#reply2","member":{"avatar":"https://cdn.v2ex.com/gravatar/e2e572807688a5c9c2c02aa111fa7662?s=24&d=retro","username":"1145148964"},"node":{"title":"分享发现","url":"https://www.v2ex.com/go/share"},"headerTemplate":"","title":"东南亚注意事项","id":1051759,"type":"post","once":"","replyCount":2,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"","lastReplyUsername":"","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1056399","href":"https://www.v2ex.com/t/1056399#reply0","member":{"avatar":"https://cdn.v2ex.com/gravatar/6bc4908bdb8220db75b3a194b2c8534f?s=24&d=retro","username":"echosoar"},"node":{"title":"分享发现","url":"https://www.v2ex.com/go/share"},"headerTemplate":"","title":"第 90 期 - 偷懒爱好者周刊 24/07/10","id":1056399,"type":"post","once":"","replyCount":0,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"95 天前","lastReplyUsername":"1145148964","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1048473","href":"https://www.v2ex.com/t/1048473#reply2","member":{"avatar":"https://cdn.v2ex.com/gravatar/e2e572807688a5c9c2c02aa111fa7662?s=24&d=retro","username":"1145148964"},"node":{"title":"分享发现","url":"https://www.v2ex.com/go/share"},"headerTemplate":"","title":"iPhone Mirroring 似乎也是期货功能中的一个。目前无法使用","id":1048473,"type":"post","once":"","replyCount":2,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"98 天前","lastReplyUsername":"fairytale","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1047550","href":"https://www.v2ex.com/t/1047550#reply11","member":{"avatar":"https://cdn.v2ex.com/gravatar/e2e572807688a5c9c2c02aa111fa7662?s=24&d=retro","username":"1145148964"},"node":{"title":"分享发现","url":"https://www.v2ex.com/go/share"},"headerTemplate":"","title":"HPE ProLiant MicroServer Gen11 发布了","id":1047550,"type":"post","once":"","replyCount":11,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"104 天前","lastReplyUsername":"vice","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1045988","href":"https://www.v2ex.com/t/1045988#reply12","member":{"avatar":"https://cdn.v2ex.com/gravatar/e2e572807688a5c9c2c02aa111fa7662?s=24&d=retro","username":"1145148964"},"node":{"title":"随想","url":"https://www.v2ex.com/go/random"},"headerTemplate":"","title":"写在儿童节。我们至少应该注意什么？至少应该做什么？","id":1045988,"type":"post","once":"","replyCount":12,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"108 天前","lastReplyUsername":"FSZR","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1044882","href":"https://www.v2ex.com/t/1044882#reply3","member":{"avatar":"https://cdn.v2ex.com/gravatar/6bc4908bdb8220db75b3a194b2c8534f?s=24&d=retro","username":"echosoar"},"node":{"title":"分享发现","url":"https://www.v2ex.com/go/share"},"headerTemplate":"","title":"第 84 期 - 偷懒爱好者周刊 24/05/29","id":1044882,"type":"post","once":"","replyCount":3,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"111 天前","lastReplyUsername":"ryan4290","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1043721","href":"https://www.v2ex.com/t/1043721#reply9","member":{"avatar":"https://cdn.v2ex.com/gravatar/e2e572807688a5c9c2c02aa111fa7662?s=24&d=retro","username":"1145148964"},"node":{"title":"职场话题","url":"https://www.v2ex.com/go/career"},"headerTemplate":"","title":"你们公司还有人住公司吗？","id":1043721,"type":"post","once":"","replyCount":9,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false},{"allReplyUsers":[],"content_rendered":"","createDate":"","createDateAgo":"","lastReplyDate":"111 天前","lastReplyUsername":"tagtag","fr":"","replyList":[],"topReplyList":[],"nestedReplies":[],"nestedRedundReplies":[],"username":"","url":"https://www.v2ex.com/api/topics/show.json?id=1043771","href":"https://www.v2ex.com/t/1043771#reply14","member":{"avatar":"https://cdn.v2ex.com/gravatar/e2e572807688a5c9c2c02aa111fa7662?s=24&d=retro","username":"1145148964"},"node":{"title":"分享发现","url":"https://www.v2ex.com/go/share"},"headerTemplate":"","title":"Airtag 平替使用经历分享。","id":1043771,"type":"post","once":"","replyCount":14,"clickCount":0,"thankCount":0,"collectCount":0,"lastReadFloor":0,"isFavorite":false,"isIgnore":false,"isThanked":false,"isReport":false,"inList":false}]';
    var te = json.decode(message);
    // Timer(Duration(seconds: 3), () {
    //   // setState(() {
    //   //   // list = te;
    //   //   list = List<Post>.from(te!.map((x) => Post.fromJson(x)));
    //   // });
    //   bus.emit('emitJsBridge', {'func': 'getNodePostList', 'val': widget.node});
    // });
    bus.on("loaded", (ars) {
      bus.emit('emitJsBridge', {'func': 'getNodePostList', 'val': widget.node});
    });

    bus.on("onJsBridge", (args) {
      print('onJsBridge' + args['type'] + args['node']);
      if (args['type'] == 'list' && args['node'] == widget.node) {
        setState(() {
          list = List<Post>.from(args['data']!.map((x) => Post.fromJson(x)));
        });
      }
    });
  }

  submit() {
    print("test");
    // controller.loadRequest(Uri.parse('https://www.v2ex.com'));
    // Navigator.pushNamed(context, 'Home');
  }

  getPost(post) {
    // print('object-getpost' + id.toString());
    Navigator.pushNamed(
      context,
      'Me',
    );
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => Me(post: post)),
    // );
    // controller.runJavaScript('jsBridge("getPost",' + id.toString() + ')');
  }

  Future<void> onRefresh() async {
    bus.emit('emitJsBridge', {'func': 'getNodePostList', 'val': widget.node});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (list.length == 0) {
      return ListView.separated(
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return Skeletonizer.zone(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Bone.circle(size: 28),
                  SizedBox(width: 10.w),
                  Bone.text(width: 80.w),
                ], crossAxisAlignment: CrossAxisAlignment.center, verticalDirection: VerticalDirection.down),
                Padding(padding: EdgeInsets.only(top: 10), child: Bone.multiText()),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Bone.text(width: 40.w),
                          SizedBox(width: 10.w),
                          Bone.text(width: 70.w),
                          SizedBox(width: 10.w),
                          Bone.text(width: 70.w),
                          SizedBox(width: 10.w),
                          Bone.text(width: 70.w),
                        ],
                      ),
                      Bone.text(width: 30.w),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                )
              ]),
            ),
          );
        },
        //分割器构造器
        separatorBuilder: (BuildContext context, int index) {
          return Container(
            height: 6,
            color: Color(0xfff1f1f1),
          );
        },
      );
    }
    return RefreshIndicator(
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
                            padding: EdgeInsets.only(left: 10.w),
                            child: Text(
                              list[index]?.lastReplyDate ?? '',
                              style: TextStyle(fontSize: 10.sp, height: 1.2),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.w),
                            child: Text(
                              '最后回复来自',
                              style: TextStyle(fontSize: 10.sp, height: 1.2),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 2.w),
                            child: Text(
                              list[index]?.lastReplyUsername ?? '',
                              style: TextStyle(fontSize: 12.sp, height: 1.2, fontWeight: FontWeight.bold),
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
        ),
        onRefresh: onRefresh);
  }

  @override
  bool get wantKeepAlive => true;
}
