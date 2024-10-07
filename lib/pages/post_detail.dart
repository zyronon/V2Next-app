import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:v2ex/components/BaseAvatar.dart';
import 'package:v2ex/model/Controller.dart';
import 'package:v2ex/model/Post2.dart';
import 'package:v2ex/utils/http.dart';
import 'package:v2ex/utils/storage.dart';
import 'package:v2ex/utils/topic.dart';

class PostDetailController extends GetxController {
  bool isShowFixedTitle = false;
  late Reply reply;
  int scrollIndex = 0;

  setTitle(bool val) {
    this.isShowFixedTitle = val;
    update();
  }

  static to() => Get.find<PostDetailController>();

  setReply(Reply val) {
    reply = val;
    update();
  }
}

class PostDetail extends StatefulWidget {
  // final Post post;
  // const Me({super.key, required this.post});

  const PostDetail({super.key});

  @override
  State<PostDetail> createState() => PostDetailState();
}

class PostDetailState extends State<PostDetail> {
  final ScrollController _scrollController = ScrollController();
  late ListObserverController observerController;
  PostDetailController ctrl = Get.put(PostDetailController());
  TextEditingController _replyCtrl = new TextEditingController();

  Post2 post = new Post2();
  int _totalPage = 1; // 总页数
  int _currentPage = 0; // 当前页数
  bool reverseSort = false; // 倒序
  bool isLoading = false; // 请求状态 正序/倒序

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    observerController = ListObserverController(controller: _scrollController);

    var message =
        '{\"type\":\"post\",\"data\":{\"allReplyUsers\":[\"liansishen\",\"SleepyRaven\",\"fengci\",\"gimp\",\"qingxiangcool\",\"jiurenmeng\",\"zsl199512101234\",\"cbythe434\",\"steve009\",\"PoorBe\"],\"content_rendered\":\"\",\"createDate\":\"\",\"createDateAgo\":\"14 小时 47 分钟前\",\"lastReplyDate\":\"\",\"lastReplyUsername\":\"\",\"fr\":\"\",\"replyList\":[{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283327\",\"reply_content\":\"不会主动来找你聊天的话十有八九没戏的<br>早点脱身挺好\",\"reply_text\":\"不会主动来找你聊天的话十有八九没戏的早点脱身挺好\",\"hideCallUserReplyContent\":\"不会主动来找你聊天的话十有八九没戏的<br>早点脱身挺好\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 43 分钟前\",\"username\":\"liansishen\",\"avatar\":\"https://cdn.v2ex.com/gravatar/0d45b7a7ca9de80b6e33af28ffd98ec6?s=24&d=retro\",\"floor\":1},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283328\",\"reply_content\":\"“一次对方加班，一次是赶上中秋回家”<br>我个人觉得这两次拒绝的理由如果属实的话，还算合理...\",\"reply_text\":\"“一次对方加班，一次是赶上中秋回家”我个人觉得这两次拒绝的理由如果属实的话，还算合理...\",\"hideCallUserReplyContent\":\"“一次对方加班，一次是赶上中秋回家”<br>我个人觉得这两次拒绝的理由如果属实的话，还算合理...\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 43 分钟前\",\"username\":\"SleepyRaven\",\"avatar\":\"https://cdn.v2ex.com/avatar/b952/aae5/551488_normal.png?m=1723688056\",\"floor\":2},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283337\",\"reply_content\":\"<a target=\\"_blank\\" href=\\"https://i.imgur.com/L62ZP7V.png\\" rel=\\"nofollow noopener\\"><img src=\\"https://i.imgur.com/L62ZP7V.png\\" class=\\"embedded_image\\" rel=\\"noreferrer\\"></a>下一个更好。\",\"reply_text\":\"下一个更好。\",\"hideCallUserReplyContent\":\"<a target=\\"_blank\\" href=\\"https://i.imgur.com/L62ZP7V.png\\" rel=\\"nofollow noopener\\"><img src=\\"https://i.imgur.com/L62ZP7V.png\\" class=\\"embedded_image\\" rel=\\"noreferrer\\"></a>下一个更好。\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 43 分钟前\",\"username\":\"fengci\",\"avatar\":\"https://cdn.v2ex.com/avatar/92ce/e689/279994_normal.png?m=1699355384\",\"floor\":3},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283343\",\"reply_content\":\"这种就是对你没感觉，直接放弃就好，不用有心里负担。\",\"reply_text\":\"这种就是对你没感觉，直接放弃就好，不用有心里负担。\",\"hideCallUserReplyContent\":\"这种就是对你没感觉，直接放弃就好，不用有心里负担。\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 42 分钟前\",\"username\":\"gimp\",\"avatar\":\"https://cdn.v2ex.com/avatar/d03f/fbc5/136804_normal.png?m=1444699066\",\"floor\":4},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283370\",\"reply_content\":\"强扭的瓜不甜。\",\"reply_text\":\"强扭的瓜不甜。\",\"hideCallUserReplyContent\":\"强扭的瓜不甜。\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 40 分钟前\",\"username\":\"qingxiangcool\",\"avatar\":\"https://cdn.v2ex.com/gravatar/4a796b20c7433e0ac60fd8f348f7a19d?s=24&d=retro\",\"floor\":5},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283375\",\"reply_content\":\"大家其实都知道，其实忙也没那么忙。<br>尽快抽身，多做尝试吧（多约几个妹子）\",\"reply_text\":\"大家其实都知道，其实忙也没那么忙。尽快抽身，多做尝试吧（多约几个妹子）\",\"hideCallUserReplyContent\":\"大家其实都知道，其实忙也没那么忙。<br>尽快抽身，多做尝试吧（多约几个妹子）\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 40 分钟前\",\"username\":\"jiurenmeng\",\"avatar\":\"https://cdn.v2ex.com/gravatar/f9cf2410a9b8aeaf34a00f3d48353461?s=24&d=retro\",\"floor\":6},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283376\",\"reply_content\":\"放弃吧，几次恋爱基本第一次见面，晚上散步的时候就上手了\",\"reply_text\":\"放弃吧，几次恋爱基本第一次见面，晚上散步的时候就上手了\",\"hideCallUserReplyContent\":\"放弃吧，几次恋爱基本第一次见面，晚上散步的时候就上手了\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 40 分钟前\",\"username\":\"zsl199512101234\",\"avatar\":\"https://cdn.v2ex.com/avatar/546f/ab9f/366461_normal.png?m=1629461617\",\"floor\":7},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283388\",\"reply_content\":\"给对方？？\",\"reply_text\":\"给对方？？\",\"hideCallUserReplyContent\":\"给对方？？\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 38 分钟前\",\"username\":\"cbythe434\",\"avatar\":\"https://cdn.v2ex.com/gravatar/f32828fb7612c9460773fc36e6ab79f6?s=24&d=retro\",\"floor\":8},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283441\",\"reply_content\":\"我还是给对方发了好人卡+祝福语<br>-----<br>如果一直内耗很难受的话，这样是对的。<br>如果之后你看开一些，再遇到合适的 可以适当观察几个月看看，不用急着下结论，相亲是 概率+长期的过程。<br><br>当然, 从来不会主动找你聊天的，那是得 PASS\",\"reply_text\":\"我还是给对方发了好人卡+祝福语-----如果一直内耗很难受的话，这样是对的。如果之后你看开一些，再遇到合适的 可以适当观察几个月看看，不用急着下结论，相亲是 概率+长期的过程。当然, 从来不会主动找你聊天的，那是得 PASS\",\"hideCallUserReplyContent\":\"我还是给对方发了好人卡+祝福语<br>-----<br>如果一直内耗很难受的话，这样是对的。<br>如果之后你看开一些，再遇到合适的 可以适当观察几个月看看，不用急着下结论，相亲是 概率+长期的过程。<br><br>当然, 从来不会主动找你聊天的，那是得 PASS\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 34 分钟前\",\"username\":\"steve009\",\"avatar\":\"https://cdn.v2ex.com/avatar/ba03/2b0f/647267_normal.png?m=1709169951\",\"floor\":9},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283465\",\"reply_content\":\"沉默不理你就换啊，多相几次你就坦然了\",\"reply_text\":\"沉默不理你就换啊，多相几次你就坦然了\",\"hideCallUserReplyContent\":\"沉默不理你就换啊，多相几次你就坦然了\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 32 分钟前\",\"username\":\"PoorBe\",\"avatar\":\"https://cdn.v2ex.com/avatar/a78c/2231/516237_normal.png?m=1713942445\",\"floor\":10}],\"topReplyList\":[],\"nestedReplies\":[{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283327\",\"reply_content\":\"不会主动来找你聊天的话十有八九没戏的<br>早点脱身挺好\",\"reply_text\":\"不会主动来找你聊天的话十有八九没戏的早点脱身挺好\",\"hideCallUserReplyContent\":\"不会主动来找你聊天的话十有八九没戏的<br>早点脱身挺好\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 43 分钟前\",\"username\":\"liansishen\",\"avatar\":\"https://cdn.v2ex.com/gravatar/0d45b7a7ca9de80b6e33af28ffd98ec6?s=24&d=retro\",\"floor\":1,\"children\":[]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283328\",\"reply_content\":\"“一次对方加班，一次是赶上中秋回家”<br>我个人觉得这两次拒绝的理由如果属实的话，还算合理...\",\"reply_text\":\"“一次对方加班，一次是赶上中秋回家”我个人觉得这两次拒绝的理由如果属实的话，还算合理...\",\"hideCallUserReplyContent\":\"“一次对方加班，一次是赶上中秋回家”<br>我个人觉得这两次拒绝的理由如果属实的话，还算合理...\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 43 分钟前\",\"username\":\"SleepyRaven\",\"avatar\":\"https://cdn.v2ex.com/avatar/b952/aae5/551488_normal.png?m=1723688056\",\"floor\":2,\"children\":[]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283337\",\"reply_content\":\"<a target=\\"_blank\\" href=\\"https://i.imgur.com/L62ZP7V.png\\" rel=\\"nofollow noopener\\"><img src=\\"https://i.imgur.com/L62ZP7V.png\\" class=\\"embedded_image\\" rel=\\"noreferrer\\"></a>下一个更好。\",\"reply_text\":\"下一个更好。\",\"hideCallUserReplyContent\":\"<a target=\\"_blank\\" href=\\"https://i.imgur.com/L62ZP7V.png\\" rel=\\"nofollow noopener\\"><img src=\\"https://i.imgur.com/L62ZP7V.png\\" class=\\"embedded_image\\" rel=\\"noreferrer\\"></a>下一个更好。\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 43 分钟前\",\"username\":\"fengci\",\"avatar\":\"https://cdn.v2ex.com/avatar/92ce/e689/279994_normal.png?m=1699355384\",\"floor\":3,\"children\":[]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283343\",\"reply_content\":\"这种就是对你没感觉，直接放弃就好，不用有心里负担。\",\"reply_text\":\"这种就是对你没感觉，直接放弃就好，不用有心里负担。\",\"hideCallUserReplyContent\":\"这种就是对你没感觉，直接放弃就好，不用有心里负担。\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 42 分钟前\",\"username\":\"gimp\",\"avatar\":\"https://cdn.v2ex.com/avatar/d03f/fbc5/136804_normal.png?m=1444699066\",\"floor\":4,\"children\":[]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283370\",\"reply_content\":\"强扭的瓜不甜。\",\"reply_text\":\"强扭的瓜不甜。\",\"hideCallUserReplyContent\":\"强扭的瓜不甜。\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 40 分钟前\",\"username\":\"qingxiangcool\",\"avatar\":\"https://cdn.v2ex.com/gravatar/4a796b20c7433e0ac60fd8f348f7a19d?s=24&d=retro\",\"floor\":5,\"children\":[]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283375\",\"reply_content\":\"大家其实都知道，其实忙也没那么忙。<br>尽快抽身，多做尝试吧（多约几个妹子）\",\"reply_text\":\"大家其实都知道，其实忙也没那么忙。尽快抽身，多做尝试吧（多约几个妹子）\",\"hideCallUserReplyContent\":\"大家其实都知道，其实忙也没那么忙。<br>尽快抽身，多做尝试吧（多约几个妹子）\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 40 分钟前\",\"username\":\"jiurenmeng\",\"avatar\":\"https://cdn.v2ex.com/gravatar/f9cf2410a9b8aeaf34a00f3d48353461?s=24&d=retro\",\"floor\":6,\"children\":[]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283376\",\"reply_content\":\"放弃吧，几次恋爱基本第一次见面，晚上散步的时候就上手了\",\"reply_text\":\"放弃吧，几次恋爱基本第一次见面，晚上散步的时候就上手了\",\"hideCallUserReplyContent\":\"放弃吧，几次恋爱基本第一次见面，晚上散步的时候就上手了\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 40 分钟前\",\"username\":\"zsl199512101234\",\"avatar\":\"https://cdn.v2ex.com/avatar/546f/ab9f/366461_normal.png?m=1629461617\",\"floor\":7,\"children\":[]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283388\",\"reply_content\":\"给对方？？\",\"reply_text\":\"给对方？？\",\"hideCallUserReplyContent\":\"给对方？？\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 38 分钟前\",\"username\":\"cbythe434\",\"avatar\":\"https://cdn.v2ex.com/gravatar/f32828fb7612c9460773fc36e6ab79f6?s=24&d=retro\",\"floor\":8,\"children\":[]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283441\",\"reply_content\":\"我还是给对方发了好人卡+祝福语<br>-----<br>如果一直内耗很难受的话，这样是对的。<br>如果之后你看开一些，再遇到合适的 可以适当观察几个月看看，不用急着下结论，相亲是 概率+长期的过程。<br><br>当然, 从来不会主动找你聊天的，那是得 PASS\",\"reply_text\":\"我还是给对方发了好人卡+祝福语-----如果一直内耗很难受的话，这样是对的。如果之后你看开一些，再遇到合适的 可以适当观察几个月看看，不用急着下结论，相亲是 概率+长期的过程。当然, 从来不会主动找你聊天的，那是得 PASS\",\"hideCallUserReplyContent\":\"我还是给对方发了好人卡+祝福语<br>-----<br>如果一直内耗很难受的话，这样是对的。<br>如果之后你看开一些，再遇到合适的 可以适当观察几个月看看，不用急着下结论，相亲是 概率+长期的过程。<br><br>当然, 从来不会主动找你聊天的，那是得 PASS\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 34 分钟前\",\"username\":\"steve009\",\"avatar\":\"https://cdn.v2ex.com/avatar/ba03/2b0f/647267_normal.png?m=1709169951\",\"floor\":9,\"children\":[]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283465\",\"reply_content\":\"沉默不理你就换啊，多相几次你就坦然了\",\"reply_text\":\"沉默不理你就换啊，多相几次你就坦然了\",\"hideCallUserReplyContent\":\"沉默不理你就换啊，多相几次你就坦然了\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 32 分钟前\",\"username\":\"PoorBe\",\"avatar\":\"https://cdn.v2ex.com/avatar/a78c/2231/516237_normal.png?m=1713942445\",\"floor\":10,\"children\":[]}],\"nestedRedundReplies\":[{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283327\",\"reply_content\":\"不会主动来找你聊天的话十有八九没戏的<br>早点脱身挺好\",\"reply_text\":\"不会主动来找你聊天的话十有八九没戏的早点脱身挺好\",\"hideCallUserReplyContent\":\"不会主动来找你聊天的话十有八九没戏的<br>早点脱身挺好\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 43 分钟前\",\"username\":\"liansishen\",\"avatar\":\"https://cdn.v2ex.com/gravatar/0d45b7a7ca9de80b6e33af28ffd98ec6?s=24&d=retro\",\"floor\":1,\"children\":[]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283328\",\"reply_content\":\"“一次对方加班，一次是赶上中秋回家”<br>我个人觉得这两次拒绝的理由如果属实的话，还算合理...\",\"reply_text\":\"“一次对方加班，一次是赶上中秋回家”我个人觉得这两次拒绝的理由如果属实的话，还算合理...\",\"hideCallUserReplyContent\":\"“一次对方加班，一次是赶上中秋回家”<br>我个人觉得这两次拒绝的理由如果属实的话，还算合理...\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 43 分钟前\",\"username\":\"SleepyRaven\",\"avatar\":\"https://cdn.v2ex.com/avatar/b952/aae5/551488_normal.png?m=1723688056\",\"floor\":2,\"children\":[]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283337\",\"reply_content\":\"<a target=\\"_blank\\" href=\\"https://i.imgur.com/L62ZP7V.png\\" rel=\\"nofollow noopener\\"><img src=\\"https://i.imgur.com/L62ZP7V.png\\" class=\\"embedded_image\\" rel=\\"noreferrer\\"></a>下一个更好。\",\"reply_text\":\"下一个更好。\",\"hideCallUserReplyContent\":\"<a target=\\"_blank\\" href=\\"https://i.imgur.com/L62ZP7V.png\\" rel=\\"nofollow noopener\\"><img src=\\"https://i.imgur.com/L62ZP7V.png\\" class=\\"embedded_image\\" rel=\\"noreferrer\\"></a>下一个更好。\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 43 分钟前\",\"username\":\"fengci\",\"avatar\":\"https://cdn.v2ex.com/avatar/92ce/e689/279994_normal.png?m=1699355384\",\"floor\":3,\"children\":[]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283343\",\"reply_content\":\"这种就是对你没感觉，直接放弃就好，不用有心里负担。\",\"reply_text\":\"这种就是对你没感觉，直接放弃就好，不用有心里负担。\",\"hideCallUserReplyContent\":\"这种就是对你没感觉，直接放弃就好，不用有心里负担。\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 42 分钟前\",\"username\":\"gimp\",\"avatar\":\"https://cdn.v2ex.com/avatar/d03f/fbc5/136804_normal.png?m=1444699066\",\"floor\":4,\"children\":[]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283370\",\"reply_content\":\"强扭的瓜不甜。\",\"reply_text\":\"强扭的瓜不甜。\",\"hideCallUserReplyContent\":\"强扭的瓜不甜。\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 40 分钟前\",\"username\":\"qingxiangcool\",\"avatar\":\"https://cdn.v2ex.com/gravatar/4a796b20c7433e0ac60fd8f348f7a19d?s=24&d=retro\",\"floor\":5,\"children\":[]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283375\",\"reply_content\":\"大家其实都知道，其实忙也没那么忙。<br>尽快抽身，多做尝试吧（多约几个妹子）\",\"reply_text\":\"大家其实都知道，其实忙也没那么忙。尽快抽身，多做尝试吧（多约几个妹子）\",\"hideCallUserReplyContent\":\"大家其实都知道，其实忙也没那么忙。<br>尽快抽身，多做尝试吧（多约几个妹子）\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 40 分钟前\",\"username\":\"jiurenmeng\",\"avatar\":\"https://cdn.v2ex.com/gravatar/f9cf2410a9b8aeaf34a00f3d48353461?s=24&d=retro\",\"floor\":6,\"children\":[]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283376\",\"reply_content\":\"放弃吧，几次恋爱基本第一次见面，晚上散步的时候就上手了\",\"reply_text\":\"放弃吧，几次恋爱基本第一次见面，晚上散步的时候就上手了\",\"hideCallUserReplyContent\":\"放弃吧，几次恋爱基本第一次见面，晚上散步的时候就上手了\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 40 分钟前\",\"username\":\"zsl199512101234\",\"avatar\":\"https://cdn.v2ex.com/avatar/546f/ab9f/366461_normal.png?m=1629461617\",\"floor\":7,\"children\":[]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283388\",\"reply_content\":\"给对方？？\",\"reply_text\":\"给对方？？\",\"hideCallUserReplyContent\":\"给对方？？\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 38 分钟前\",\"username\":\"cbythe434\",\"avatar\":\"https://cdn.v2ex.com/gravatar/f32828fb7612c9460773fc36e6ab79f6?s=24&d=retro\",\"floor\":8,\"children\":[]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283441\",\"reply_content\":\"我还是给对方发了好人卡+祝福语<br>-----<br>如果一直内耗很难受的话，这样是对的。<br>如果之后你看开一些，再遇到合适的 可以适当观察几个月看看，不用急着下结论，相亲是 概率+长期的过程。<br><br>当然, 从来不会主动找你聊天的，那是得 PASS\",\"reply_text\":\"我还是给对方发了好人卡+祝福语-----如果一直内耗很难受的话，这样是对的。如果之后你看开一些，再遇到合适的 可以适当观察几个月看看，不用急着下结论，相亲是 概率+长期的过程。当然, 从来不会主动找你聊天的，那是得 PASS\",\"hideCallUserReplyContent\":\"我还是给对方发了好人卡+祝福语<br>-----<br>如果一直内耗很难受的话，这样是对的。<br>如果之后你看开一些，再遇到合适的 可以适当观察几个月看看，不用急着下结论，相亲是 概率+长期的过程。<br><br>当然, 从来不会主动找你聊天的，那是得 PASS\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 34 分钟前\",\"username\":\"steve009\",\"avatar\":\"https://cdn.v2ex.com/avatar/ba03/2b0f/647267_normal.png?m=1709169951\",\"floor\":9,\"children\":[]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283465\",\"reply_content\":\"沉默不理你就换啊，多相几次你就坦然了\",\"reply_text\":\"沉默不理你就换啊，多相几次你就坦然了\",\"hideCallUserReplyContent\":\"沉默不理你就换啊，多相几次你就坦然了\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 32 分钟前\",\"username\":\"PoorBe\",\"avatar\":\"https://cdn.v2ex.com/avatar/a78c/2231/516237_normal.png?m=1713942445\",\"floor\":10,\"children\":[]}],\"username\":\"\",\"url\":\"\",\"href\":\"\",\"member\":{\"avatar\":\"\",\"username\":\"yunshangzhou\",\"avatar_large\":\"https://cdn.v2ex.com/avatar/205f/180e/600305_large.png?m=1726042527\"},\"node\":{\"title\":\"生活\",\"url\":\"https://www.v2ex.com/go/life\"},\"headerTemplate\":\"<div class=\\"cell\\"><div class=\\"topic_content\\"><div class=\\"markdown_body\\"><p>天时弄人，约了 2 次饭，被拒了 2 次，一次对方加班，一次是赶上中秋回家。当然之前提到场地费的事，节前送了盒美心月饼表示了一下。随后又是好几天以沉默报以沉默。</p><p>期间我看了些对罗翔、毛不易、李雪琴等节目里对爱情的观念。有好几句话是戳中我的:</p><ul><li>如果你今天给了人不切实际的希望，也相当于给了人绝望</li><li>两人没有共同爱好，那是为什么在一起？</li><li>我希望有一段好的关系，能让我有一次学习爱与被爱的能力</li><li>我相信爱情，但不相信爱情能降临在我身上。</li></ul><p>我感觉大家都是尝试过迁就对方的，回想到第一次线下聊天互相卡壳，为了缓解尴尬而想话题聊天，可能真的不合适。而且经过 2 次拒绝，没有信心再约第三次了，经历了一段时间的思想内斗，我还是给对方发了好人卡+祝福语。抱歉让各位期待后续的瓜友失望了。</p></div></div></div><div class=\\"subtle\\"><span class=\\"fade\\">第 1 条附言 &nbsp;·&nbsp; 13 小时 52 分钟前</span><div class=\\"sep\\"></div><div class=\\"topic_content\\">这个女生算是亲戚(副校长)介绍来的，所以人品毋庸置疑，大家不要再恶意揣测了。<br><br>关于 200 多的月饼，我觉得大方是最容易的事情，如果把关注点放在钱上，做人是做不开的。<br><br>至于话说死，不合适也不要谈后续死灰复燃的，没多少人真的会吃回头草。<br><br>相处过程中对方挺友好的，就这样。</div></div>\",\"title\":\"26 岁母胎 solo 的第一次相亲 (后续)\",\"id\":\"1074269\",\"type\":\"post\",\"once\":\"59126\",\"replyCount\":10,\"clickCount\":10119,\"thankCount\":0,\"collectCount\":37,\"lastReadFloor\":0,\"isFavorite\":false,\"isIgnore\":false,\"isThanked\":false,\"isReport\":false,\"inList\":false}}';
    var te = json.decode(message);
    setState(() {
      // item = Post.fromJson(te['data']);
      post = Get.arguments;
    });

    var t = DateTime.now();
    print('请求开始$t');
    Post2 topicDetailModel = await TopicWebApi.getTopicDetail(Get.arguments.id, _currentPage + 1);
    // Post2 topicDetailModel = await TopicWebApi.getTopicDetail('1078049', _currentPage + 1);
    var s = DateTime.now();
    print('处理结束$s');
    var hours = t.difference(s);
    print('花费时间$hours');

    setState(() {
      post = topicDetailModel;
      rebuildList();
    });
  }

  rebuildList() {
    post.replyCount = post.replyList.length;
    post.topReplyList = List.of(post.replyList).where((v) {
      return v.thankCount >= 3;
    }).toList();
    post.topReplyList.sort((a, b) => b.thankCount.compareTo(a.thankCount));
    post.topReplyList = post.topReplyList.sublist(0,5);


  }

  @override
  void dispose() {
    super.dispose();
    //销毁监听器
    _scrollController.dispose();
  }

  submit() {
    print("test");
    // controller.loadRequest(Uri.parse('https://v2ex.com'));
    // Navigator.pushNamed(context, 'Home');
  }

  Reply getReplyList(index) {
    return post.replyList[index - 1];
  }

  var options = ['1', '2', '3'];

  Widget modalItem(String text, IconData icon) {
    return Padding(
        padding: EdgeInsets.only(left: 12.w, top: 16.w, bottom: 16.w),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20.sp,
              color: Colors.grey,
            ),
            Padding(
              padding: EdgeInsets.only(left: 12.w),
              child: Text(text),
            )
          ],
        ));
  }

  Widget modalPostItem(String text, IconData icon) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100.r)),
              padding: EdgeInsets.all(12.w),
              margin: EdgeInsets.only(bottom: 8.w),
              child: Icon(
                icon,
                size: 28.sp,
                color: Colors.black54,
              )),
          Text(text)
        ],
      ),
      width: .25.sw,
      padding: EdgeInsets.only(top: 10.w, bottom: 10.w),
    );
  }

  showModal() {
    PostDetailController c = PostDetailController.to();
    modalWrap(
        getHtmlText(c.reply.replyContent),
        Column(
          children: [
            modalItem('回复', Icons.chat_bubble_outline),
            modalItem('感谢', Icons.favorite_border),
            modalItem('上下文', Icons.content_paste_search),
            modalItem('复制', Icons.content_copy),
            modalItem('忽略', Icons.block),
          ],
        ));
  }

  Widget getTextSizeOptionItem(Widget text) {
    return Expanded(
        child: Container(
            height: 40.w,
            child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    text,
                    SizedBox(height: 5.w),
                    Container(
                      width: 5.w,
                      height: 5.w,
                      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10.r)),
                    )
                  ],
                ))));
  }

  modalWrap(Widget text, Widget other) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                  margin: EdgeInsets.only(bottom: 10.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                  ),
                  constraints: BoxConstraints(maxHeight: .5.sh),
                  padding: EdgeInsets.all(14.w),
                  width: ScreenUtil().screenWidth * .91,
                  child: SingleChildScrollView(child: text)),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xfff1f1f1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.r),
                    topRight: Radius.circular(10.r),
                  ),
                ),
                padding: EdgeInsets.only(bottom: MediaQuery
                    .of(context)
                    .viewInsets
                    .bottom + 0.w),
                width: double.infinity,
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        width: 40.w,
                        height: 4.w,
                        margin: EdgeInsets.only(bottom: 10.w, top: 15.w),
                        decoration: BoxDecoration(color: Color(0xffcacaca), borderRadius: BorderRadius.all(Radius.circular(2.r))),
                      ),
                    ),
                    other
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
    _replyCtrl.text = '';
  }

  replyPostItem(Reply val) {
    PostDetailController c = PostDetailController.to();
    c.setReply(val);
    _replyCtrl.text = '#${val.username} #${val.floor} ';
    modalWrap(getHtmlText(c.reply.replyContent), getTest());
  }

  replyPost() {
    PostDetailController pdc = PostDetailController.to();
    pdc.setReply(new Reply());
    modalWrap(getHtmlText(post.headerTemplate), getTest());
  }

  showPostModal() {
    modalWrap(
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [getPostTitle(), getHtmlText(post?.headerTemplate ?? '')],
        ),
        Column(
          children: [
            Row(children: [
              modalPostItem('保存', Icons.bookmark_border),
              modalPostItem('深色模式', Icons.bookmark_border),
              modalPostItem('报告', Icons.bookmark_border),
              modalPostItem('忽略', Icons.bookmark_border),
            ]),
            Row(children: [
              modalPostItem('稍后阅读', Icons.bookmark_border),
              modalPostItem('复制内容', Icons.content_copy),
              modalPostItem('复制链接', Icons.link),
              modalPostItem('浏览器打开', Icons.travel_explore),
            ]),
            Stack(
              children: [
                Positioned(
                    left: .13.sw,
                    bottom: 22.w,
                    child: Container(
                      width: 0.74.sw,
                      height: 1.w,
                      color: Colors.black54,
                    )),
                Container(
                    padding: EdgeInsets.only(bottom: 20.w),
                    child: Row(
                      children: [
                        getTextSizeOptionItem(Text('小', style: TextStyle(fontSize: 10.sp))),
                        getTextSizeOptionItem(Text('标准', style: TextStyle(fontSize: 12.sp))),
                        getTextSizeOptionItem(Text('大', style: TextStyle(fontSize: 16.sp))),
                        getTextSizeOptionItem(Text('特大', style: TextStyle(fontSize: 18.sp))),
                      ],
                    )),
                Positioned(
                    left: .23.sw,
                    bottom: 16.w,
                    child: Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50.r),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 3.w, //阴影模糊程度
                              spreadRadius: 3.w //阴影扩散程度
                          )
                        ],
                      ),
                    )),
              ],
            )
          ],
        ));
  }

  Widget getItem(Reply val, int index) {
    return InkWell(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(6.w),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              //头像、名字
              Row(
                children: [
                  Row(
                    children: [
                      BaseAvatar(src: val.avatar ?? '', diameter: 26.w, radius: 4.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: SelectableText(
                              val?.username ?? '',
                              style: TextStyle(fontSize: 13.sp, height: 1.2, fontWeight: FontWeight.bold, color: Colors.black54),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  (val.floor ?? '').toString() + '楼',
                                  style: TextStyle(fontSize: 11.sp, height: 1.2, color: Colors.grey),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  val.date ?? '',
                                  style: TextStyle(fontSize: 11.sp, height: 1.2, color: Colors.grey),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      if (val.thankCount != 0)
                        InkWell(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                val?.isThanked == true ? Icons.favorite : Icons.favorite_border,
                                size: 18.sp,
                                color: Colors.red,
                              ),
                              Padding(
                                  padding: EdgeInsets.only(left: 4.w),
                                  child: Text(
                                    val?.thankCount.toString() ?? '',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 14.sp, color: Colors.red, height: 1.2),
                                  ))
                            ],
                          ),
                          onTap: () {
                            thankReply(index);
                          },
                        ),
                      InkWell(
                        child: Padding(
                          padding: EdgeInsets.only(left: 4.w),
                          child: Icon(
                            Icons.more_vert,
                            size: 22.sp,
                            color: Colors.grey,
                          ),
                        ),
                        onTap: () {
                          replyPostItem(val);
                        },
                      )
                    ],
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                verticalDirection: VerticalDirection.down,
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 4.w,
                ),
                child: HtmlWidget(
                  val.replyContent,
                  renderMode: RenderMode.column,
                  textStyle: TextStyle(fontSize: 14.sp, height: 1.4),
                ),
              ),
            ]),
          ),
          if (val.children.length != 0)
            Column(
              children: [
                ...val.children.map((a) =>
                    Padding(
                      padding: EdgeInsets.only(left: 16.w),
                      child: getItem(a, 1),
                    ))
              ],
            ),
        ],
      ),
      onLongPress: () {
        PostDetailController c = PostDetailController.to();
        c.setReply(val);
        showModal();
      },
      onTap: () {
        replyPostItem(val);
      },
    );
  }

  Widget getIcon(IconData icon) {
    return Icon(
      icon,
      size: 24.sp,
      color: Colors.black54,
    );
  }

  Widget clickIcon(IconData icon, onTap) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 10.w),
        child: getIcon(icon),
      ),
      onTap: onTap,
    );
  }

  Widget clickWidget(Widget widget, onTap) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 10.w),
        child: widget,
      ),
      onTap: onTap,
    );
  }

  //标题
  Widget getPostTitle() {
    return Padding(
      padding: EdgeInsets.only(top: 6.w, bottom: 6.w),
      child: SelectableText(
        post?.title ?? '',
        textAlign: TextAlign.left,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
      ),
    );
  }

  //内容
  Widget getHtmlText(String html) {
    return SelectionArea(
        child: HtmlWidget(
          html,
          renderMode: RenderMode.column,
          textStyle: TextStyle(fontSize: 14.sp),
          customStylesBuilder: (element) {
            if (element.classes.contains('subtle')) {
              return {
                'background-color': '#ecfdf5e6',
                'border-left': '4px solid #a7f3d0',
                'padding': '5px',
              };
            }
            if (element.classes.contains('fade')) {
              return {'color': '#6b6b6b'};
            }
            return null;
          },
        ));
  }

  onReply() async {
    PostDetailController pdc = PostDetailController.to();
    var res = await TopicWebApi.onSubmitReplyTopic(post.id, _replyCtrl.text, 0);
    if (res == 'true') {
      if (context.mounted) {
        setState(() {
          var s = new Reply();
          s.replyContent = _replyCtrl.text;
          s.username = GStorage().getUserInfo()['userName'];
          s.avatar = GStorage().getUserInfo()['avatar'];
          s.date = '刚刚';
          s.floor = post.replyCount + 1;
          post.replyList.add(s);
          rebuildList();
        });
        _replyCtrl.text = '';
        Get.back();
      }
    } else if (res == 'success') {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('回复失败'),
            showCloseIcon: true,
          ),
        );
      }
    } else {
      SmartDialog.show(
        useSystem: true,
        animationType: SmartAnimationType.centerFade_otherSlide,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('系统提示'),
            content: Text(res),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('确定'))
            ],
          );
        },
      );
    }
  }

  getTest() {
    return Container(
      padding: EdgeInsets.all(8.w),
      child: Column(
        children: [
          Container(
            child: TextField(
              controller: _replyCtrl,
              maxLines: 10,
              autofocus: false,
              decoration: InputDecoration(
                hintText: "请尽量让自己的回复能够对别人有帮助",
                hintStyle: TextStyle(color: Colors.black26),
                border: InputBorder.none,
              ),
            ),
            padding: EdgeInsets.only(left: 8.w, right: 8.w),
            decoration: BoxDecoration(color: Color(0xfff1f1f1), borderRadius: BorderRadius.circular(6.r)),
            margin: EdgeInsets.only(bottom: 10.w),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                getIcon(Icons.sentiment_satisfied_alt),
                SizedBox(width: 10.w),
                getIcon(Icons.alternate_email),
                SizedBox(width: 10.w),
                getIcon(Icons.add_photo_alternate),
                SizedBox(width: 10.w),
                getIcon(Icons.format_quote),
              ]),
              InkWell(
                child: Container(
                  padding: EdgeInsets.fromLTRB(12.w, 4.w, 12.w, 4.w),
                  decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(6.r)),
                  child: Text(
                    '回复',
                    style: TextStyle(fontSize: 14.sp, color: Colors.white),
                  ),
                ),
                onTap: () {
                  onReply();
                },
              )
            ],
          )
        ],
      ),
    );
  }

  //收藏帖子
  onCollect() async {
    bool needLogin = !(GStorage().getLoginStatus());
    if (needLogin) {
      return Get.toNamed('/Login');
    }
    var res = await TopicWebApi.favoriteTopic(post.isFavorite, post.id);
    if (res) {
      setState(() {
        post.isFavorite = !post.isFavorite;
        post.collectCount = post.isFavorite ? post.collectCount + 1 : post.collectCount - 1;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(post.isFavorite ? '已收藏' : '已取消收藏'),
          showCloseIcon: true,
        ),
      );
    }
  }

  //感谢帖子
  thankPost() async {
    bool needLogin = !(GStorage().getLoginStatus());
    if (needLogin) {
      return Get.toNamed('/Login');
    }
    if (post.isThanked) {
      SmartDialog.showToast('这个主题已经被感谢过了');
    } else {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(
              title: const Text('提示'),
              content: const Text('确认向本主题创建者表示感谢吗？'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('手误了'),
                ),
                TextButton(
                  onPressed: (() async {
                    Navigator.pop(context, 'OK');
                    var res = await TopicWebApi.thankTopic(post.id);
                    print('54: $res');
                    if (res) {
                      setState(() {
                        post.isThanked = true;
                        post.thankCount += 1;
                      });
                      SmartDialog.showToast('感谢成功');
                    }
                  }),
                  child: const Text('确定'),
                ),
              ],
            ),
      );
    }
  }

  thank(index) {
    print(index);
    var s = post?.replyList?[index - 1];
    if (s != Null) {
      setState(() {
        post?.replyList?[index - 1].isThanked = true;
      });
    }
  }

  // 感谢回复 request
  void onThankReply(int index) async {
    var s = post.replyList[index - 1];

    var res = await DioRequestWeb.thankReply(s.id, post.id);
    if (res) {
      setState(() {
        post.replyList[index - 1].isThanked = true;
        post.replyList[index - 1].thankCount += 1;
      });
    }
  }

  //感谢回复
  thankReply(int index) {
    bool needLogin = !(GStorage().getLoginStatus());
    if (needLogin) {
      return Get.toNamed('/Login');
    }

    var s = post.replyList[index - 1];
    if (s.isThanked) {
      SmartDialog.showToast('这个回复已经被感谢过了');
      return;
    }
    showDialog<String>(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(
            title: const Text('提示'),
            content: const Text('确认向该用户表示感谢吗？，将花费10个铜板💰'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('手滑了'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'Ok');
                  onThankReply(index);
                },
                child: const Text('确认'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostDetailController>(builder: (_) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 0,
        ),
        body: DefaultTextStyle(
            style: TextStyle(color: Colors.black, fontSize: 12.sp),
            child: Column(
              children: [
                Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 4.w, bottom: 4.w),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.black12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              clickIcon(Icons.arrow_back, () {
                                Navigator.pop(context);
                              }),
                              Expanded(
                                  child: InkWell(
                                    child: AnimatedOpacity(
                                      opacity: _.isShowFixedTitle ? 1.0 : 0.0,
                                      duration: const Duration(milliseconds: 300),
                                      child: Text(
                                        // '把控制面板的全部设置项移进电脑设置里面这么难吗？为什么 Windows 8 到现在 13 年了， Windows 还是有两个设置',
                                        post?.title ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(fontSize: 16.sp),
                                      ),
                                    ),
                                    onTap: () {
                                      _scrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.ease);
                                    },
                                  ))
                            ],
                          ),
                        ),
                        clickIcon(Icons.more_vert, showPostModal)
                      ],
                    )),
                // getTest(),
                Expanded(
                    child: ListViewObserver(
                      controller: observerController,
                      onObserve: (res) {
                        PostDetailController pdc = PostDetailController.to();
                        pdc.scrollIndex = res.firstChild!.index;
                        _.setTitle(res.firstChild!.index > 0);
                      },
                      child: ListView.separated(
                        // shrinkWrap: true,
                        controller: _scrollController,
                        itemCount: 1 + (post.replyList.length ?? 0),
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //标题和内容
                                Padding(
                                    padding: EdgeInsets.all(8.w),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              verticalDirection: VerticalDirection.down,
                                              children: [
                                                BaseAvatar(src: post?.member?.avatarLarge ?? '', diameter: 30.w, radius: 4.w),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    //用户名
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.only(left: 10.w),
                                                          child: SelectableText(
                                                            post?.member?.username ?? '',
                                                            style: TextStyle(fontSize: 15.sp, height: 1.2, color: Colors.black54),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    //时间、点击量
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.only(left: 10.w),
                                                          child: Text(
                                                            post?.createDateAgo ?? '',
                                                            style: TextStyle(fontSize: 11.sp, height: 1.2, color: Colors.grey),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(left: 10.w),
                                                          child: Text(
                                                            (post?.clickCount.toString() ?? '') + '次点击',
                                                            style: TextStyle(fontSize: 11.sp, height: 1.2, color: Colors.grey),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black12,
                                                borderRadius: BorderRadius.circular(3.0), //3像素圆角
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                                                child: Text(
                                                  post?.node?.title ?? '',
                                                  style: TextStyle(color: Colors.black, fontSize: 12.sp),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        getPostTitle(),
                                        getHtmlText(post?.headerTemplate ?? ''),
                                      ],
                                    )),
                                Container(
                                  padding: EdgeInsets.all(6.w),
                                  decoration: BoxDecoration(
                                    border: Border(top: BorderSide(color: Colors.black12)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(post.createDateAgo),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 100.sw,
                                  height: 4.w,
                                  color: Colors.grey[100],
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.w),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        post.replyCount.toString() + '条回复',
                                        style: TextStyle(fontSize: 14.sp, height: 1.2, color: Colors.grey),
                                      ),
                                      Text(
                                        '楼中楼',
                                        style: TextStyle(fontSize: 14.sp, height: 1.2, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            );
                          }
                          if (index == post.replyList.length) {
                            return Padding(padding: EdgeInsets.only(bottom: 120.w), child: getItem(getReplyList(index), index));
                          }
                          return getItem(getReplyList(index), index);
                        },
                        //分割器构造器
                        separatorBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 1,
                            color: Color(0xfff1f1f1),
                          );
                        },
                      ),
                    )),
                Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(14.w, 4.w, 6.w, 4.w),
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.black12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: InkWell(
                            child: Container(
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                        '说点什么...',
                                        style: TextStyle(color: Colors.black54),
                                      )),
                                  Icon(
                                    Icons.crop_original,
                                    size: 20.sp,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 4.w),
                                  Icon(
                                    Icons.alternate_email,
                                    size: 20.sp,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 4.w),
                                  Icon(
                                    Icons.sentiment_satisfied_alt,
                                    size: 20.sp,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                              decoration: BoxDecoration(border: Border.all(color: Colors.black26), borderRadius: BorderRadius.circular(8.r)),
                              padding: EdgeInsets.all(6.w),
                            ),
                            onTap: () {
                              replyPost();
                            },
                          ),
                        ),
                        SizedBox(width: 6.w),
                        // clickWidget(
                        //     Column(
                        //       children: [
                        //         Icon(
                        //           Icons.share,
                        //           size: 24.sp,
                        //           color: Colors.grey,
                        //         ),
                        //         Text(
                        //           '分享',
                        //           style: TextStyle(fontSize: 8.sp, color: Colors.black54),
                        //         )
                        //       ],
                        //     ), () {
                        //   print('asdf');
                        // }),
                        clickWidget(
                            Column(
                              children: [
                                Icon(
                                  post.isFavorite ? Icons.grade : Icons.star_border,
                                  size: 24.sp,
                                  color: Colors.grey,
                                ),
                                Text(
                                  post.collectCount.toString(),
                                  style: TextStyle(fontSize: 10.sp, color: Colors.black54),
                                )
                              ],
                            ), () {
                          onCollect();
                        }),
                        clickWidget(
                            Column(
                              children: [
                                Icon(
                                  post.isThanked ? Icons.favorite : Icons.favorite_border,
                                  size: 24.sp,
                                  color: Colors.grey,
                                ),
                                Text(
                                  post.thankCount.toString(),
                                  style: TextStyle(fontSize: 10.sp, color: Colors.black54),
                                )
                              ],
                            ), () {
                          thankPost();
                        }),
                        clickWidget(
                            Column(
                              children: [
                                Icon(
                                  Icons.chat_bubble_outline,
                                  size: 24.sp,
                                  color: Colors.grey,
                                ),
                                Text(
                                  post.replyCount.toString(),
                                  style: TextStyle(fontSize: 10.sp, color: Colors.black54),
                                )
                              ],
                            ), () {
                          PostDetailController pdc = PostDetailController.to();
                          observerController.jumpTo(index: pdc.scrollIndex != 0 ? 0 : 1);
                        }),
                      ],
                    )),
              ],
            )),
      );
    });
  }
}
