import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:v2ex/components/BaseAvatar.dart';
import 'package:v2ex/components/reply_item.dart';
import 'package:v2ex/model/BaseController.dart';
import 'package:v2ex/model/Post2.dart';
import 'package:v2ex/utils/http.dart';
import 'package:v2ex/utils/storage.dart';
import 'package:v2ex/utils/topic.dart';
import 'package:v2ex/utils/utils.dart';

class UserConfig {
  bool showTopReply = true;
}

class PostDetailController extends GetxController {
  bool isShowFixedTitle = false;
  Post2 post = new Post2();
  Reply reply = new Reply();
  int scrollIndex = 0;
  bool loading = false;
  UserConfig config = UserConfig();
  ScrollController _scrollController = ScrollController();
  late SliverObserverController observerController = SliverObserverController(controller: _scrollController);

  setShowFixedTitle(bool val) {
    this.isShowFixedTitle = val;
    update();
  }

  static to() => Get.find<PostDetailController>();

  static PostDetailController get to2 => Get.find();

  setReply(Reply val) {
    reply = val;
    update();
  }

  rebuildList() {
    post = Utils.buildList(post, post.replyList);
    update();
    observerController.reattach();
  }

  List<Reply> getReplyList() {
    return post.nestedReplies;
  }

  getListLength() {
    return getReplyList().length + post.topReplyList.length + 1;
  }

  Reply getReplyItem(index) {
    return post.replyList[index - 1];
  }

  getData() async {
    var message =
        '{\"type\":\"post\",\"data\":{\"allReplyUsers\":[\"liansishen\",\"SleepyRaven\",\"fengci\",\"gimp\",\"qingxiangcool\",\"jiurenmeng\",\"zsl199512101234\",\"cbythe434\",\"steve009\",\"PoorBe\"],\"content_rendered\":\"\",\"createDate\":\"\",\"createDateAgo\":\"14 小时 47 分钟前\",\"lastReplyDate\":\"\",\"lastReplyUsername\":\"\",\"fr\":\"\",\"replyList\":[{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283327\",\"reply_content\":\"不会主动来找你聊天的话十有八九没戏的<br>早点脱身挺好\",\"reply_text\":\"不会主动来找你聊天的话十有八九没戏的早点脱身挺好\",\"hideCallUserReplyContent\":\"不会主动来找你聊天的话十有八九没戏的<br>早点脱身挺好\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 43 分钟前\",\"username\":\"liansishen\",\"avatar\":\"https://cdn.v2ex.com/gravatar/0d45b7a7ca9de80b6e33af28ffd98ec6?s=24&d=retro\",\"floor\":1},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283328\",\"reply_content\":\"“一次对方加班，一次是赶上中秋回家”<br>我个人觉得这两次拒绝的理由如果属实的话，还算合理...\",\"reply_text\":\"“一次对方加班，一次是赶上中秋回家”我个人觉得这两次拒绝的理由如果属实的话，还算合理...\",\"hideCallUserReplyContent\":\"“一次对方加班，一次是赶上中秋回家”<br>我个人觉得这两次拒绝的理由如果属实的话，还算合理...\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 43 分钟前\",\"username\":\"SleepyRaven\",\"avatar\":\"https://cdn.v2ex.com/avatar/b952/aae5/551488_normal.png?m=1723688056\",\"floor\":2},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283337\",\"reply_content\":\"<a target=\\"_blank\\" href=\\"https://i.imgur.com/L62ZP7V.png\\" rel=\\"nofollow noopener\\"><img src=\\"https://i.imgur.com/L62ZP7V.png\\" class=\\"embedded_image\\" rel=\\"noreferrer\\"></a>下一个更好。\",\"reply_text\":\"下一个更好。\",\"hideCallUserReplyContent\":\"<a target=\\"_blank\\" href=\\"https://i.imgur.com/L62ZP7V.png\\" rel=\\"nofollow noopener\\"><img src=\\"https://i.imgur.com/L62ZP7V.png\\" class=\\"embedded_image\\" rel=\\"noreferrer\\"></a>下一个更好。\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 43 分钟前\",\"username\":\"fengci\",\"avatar\":\"https://cdn.v2ex.com/avatar/92ce/e689/279994_normal.png?m=1699355384\",\"floor\":3},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283343\",\"reply_content\":\"这种就是对你没感觉，直接放弃就好，不用有心里负担。\",\"reply_text\":\"这种就是对你没感觉，直接放弃就好，不用有心里负担。\",\"hideCallUserReplyContent\":\"这种就是对你没感觉，直接放弃就好，不用有心里负担。\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 42 分钟前\",\"username\":\"gimp\",\"avatar\":\"https://cdn.v2ex.com/avatar/d03f/fbc5/136804_normal.png?m=1444699066\",\"floor\":4},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283370\",\"reply_content\":\"强扭的瓜不甜。\",\"reply_text\":\"强扭的瓜不甜。\",\"hideCallUserReplyContent\":\"强扭的瓜不甜。\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 40 分钟前\",\"username\":\"qingxiangcool\",\"avatar\":\"https://cdn.v2ex.com/gravatar/4a796b20c7433e0ac60fd8f348f7a19d?s=24&d=retro\",\"floor\":5},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283375\",\"reply_content\":\"大家其实都知道，其实忙也没那么忙。<br>尽快抽身，多做尝试吧（多约几个妹子）\",\"reply_text\":\"大家其实都知道，其实忙也没那么忙。尽快抽身，多做尝试吧（多约几个妹子）\",\"hideCallUserReplyContent\":\"大家其实都知道，其实忙也没那么忙。<br>尽快抽身，多做尝试吧（多约几个妹子）\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 40 分钟前\",\"username\":\"jiurenmeng\",\"avatar\":\"https://cdn.v2ex.com/gravatar/f9cf2410a9b8aeaf34a00f3d48353461?s=24&d=retro\",\"floor\":6},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283376\",\"reply_content\":\"放弃吧，几次恋爱基本第一次见面，晚上散步的时候就上手了\",\"reply_text\":\"放弃吧，几次恋爱基本第一次见面，晚上散步的时候就上手了\",\"hideCallUserReplyContent\":\"放弃吧，几次恋爱基本第一次见面，晚上散步的时候就上手了\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 40 分钟前\",\"username\":\"zsl199512101234\",\"avatar\":\"https://cdn.v2ex.com/avatar/546f/ab9f/366461_normal.png?m=1629461617\",\"floor\":7},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283388\",\"reply_content\":\"给对方？？\",\"reply_text\":\"给对方？？\",\"hideCallUserReplyContent\":\"给对方？？\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 38 分钟前\",\"username\":\"cbythe434\",\"avatar\":\"https://cdn.v2ex.com/gravatar/f32828fb7612c9460773fc36e6ab79f6?s=24&d=retro\",\"floor\":8},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283441\",\"reply_content\":\"我还是给对方发了好人卡+祝福语<br>-----<br>如果一直内耗很难受的话，这样是对的。<br>如果之后你看开一些，再遇到合适的 可以适当观察几个月看看，不用急着下结论，相亲是 概率+长期的过程。<br><br>当然, 从来不会主动找你聊天的，那是得 PASS\",\"reply_text\":\"我还是给对方发了好人卡+祝福语-----如果一直内耗很难受的话，这样是对的。如果之后你看开一些，再遇到合适的 可以适当观察几个月看看，不用急着下结论，相亲是 概率+长期的过程。当然, 从来不会主动找你聊天的，那是得 PASS\",\"hideCallUserReplyContent\":\"我还是给对方发了好人卡+祝福语<br>-----<br>如果一直内耗很难受的话，这样是对的。<br>如果之后你看开一些，再遇到合适的 可以适当观察几个月看看，不用急着下结论，相亲是 概率+长期的过程。<br><br>当然, 从来不会主动找你聊天的，那是得 PASS\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 34 分钟前\",\"username\":\"steve009\",\"avatar\":\"https://cdn.v2ex.com/avatar/ba03/2b0f/647267_normal.png?m=1709169951\",\"floor\":9},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283465\",\"reply_content\":\"沉默不理你就换啊，多相几次你就坦然了\",\"reply_text\":\"沉默不理你就换啊，多相几次你就坦然了\",\"hideCallUserReplyContent\":\"沉默不理你就换啊，多相几次你就坦然了\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 32 分钟前\",\"username\":\"PoorBe\",\"avatar\":\"https://cdn.v2ex.com/avatar/a78c/2231/516237_normal.png?m=1713942445\",\"floor\":10}],\"topReplyList\":[],\"nestedReplies\":[{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283327\",\"reply_content\":\"不会主动来找你聊天的话十有八九没戏的<br>早点脱身挺好\",\"reply_text\":\"不会主动来找你聊天的话十有八九没戏的早点脱身挺好\",\"hideCallUserReplyContent\":\"不会主动来找你聊天的话十有八九没戏的<br>早点脱身挺好\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 43 分钟前\",\"username\":\"liansishen\",\"avatar\":\"https://cdn.v2ex.com/gravatar/0d45b7a7ca9de80b6e33af28ffd98ec6?s=24&d=retro\",\"floor\":1,\"children\":[]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283328\",\"reply_content\":\"“一次对方加班，一次是赶上中秋回家”<br>我个人觉得这两次拒绝的理由如果属实的话，还算合理...\",\"reply_text\":\"“一次对方加班，一次是赶上中秋回家”我个人觉得这两次拒绝的理由如果属实的话，还算合理...\",\"hideCallUserReplyContent\":\"“一次对方加班，一次是赶上中秋回家”<br>我个人觉得这两次拒绝的理由如果属实的话，还算合理...\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 43 分钟前\",\"username\":\"SleepyRaven\",\"avatar\":\"https://cdn.v2ex.com/avatar/b952/aae5/551488_normal.png?m=1723688056\",\"floor\":2,\"children\":[]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283337\",\"reply_content\":\"<a target=\\"_blank\\" href=\\"https://i.imgur.com/L62ZP7V.png\\" rel=\\"nofollow noopener\\"><img src=\\"https://i.imgur.com/L62ZP7V.png\\" class=\\"embedded_image\\" rel=\\"noreferrer\\"></a>下一个更好。\",\"reply_text\":\"下一个更好。\",\"hideCallUserReplyContent\":\"<a target=\\"_blank\\" href=\\"https://i.imgur.com/L62ZP7V.png\\" rel=\\"nofollow noopener\\"><img src=\\"https://i.imgur.com/L62ZP7V.png\\" class=\\"embedded_image\\" rel=\\"noreferrer\\"></a>下一个更好。\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 43 分钟前\",\"username\":\"fengci\",\"avatar\":\"https://cdn.v2ex.com/avatar/92ce/e689/279994_normal.png?m=1699355384\",\"floor\":3,\"children\":[]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283343\",\"reply_content\":\"这种就是对你没感觉，直接放弃就好，不用有心里负担。\",\"reply_text\":\"这种就是对你没感觉，直接放弃就好，不用有心里负担。\",\"hideCallUserReplyContent\":\"这种就是对你没感觉，直接放弃就好，不用有心里负担。\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 42 分钟前\",\"username\":\"gimp\",\"avatar\":\"https://cdn.v2ex.com/avatar/d03f/fbc5/136804_normal.png?m=1444699066\",\"floor\":4,\"children\":[]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283370\",\"reply_content\":\"强扭的瓜不甜。\",\"reply_text\":\"强扭的瓜不甜。\",\"hideCallUserReplyContent\":\"强扭的瓜不甜。\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 40 分钟前\",\"username\":\"qingxiangcool\",\"avatar\":\"https://cdn.v2ex.com/gravatar/4a796b20c7433e0ac60fd8f348f7a19d?s=24&d=retro\",\"floor\":5,\"children\":[]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283375\",\"reply_content\":\"大家其实都知道，其实忙也没那么忙。<br>尽快抽身，多做尝试吧（多约几个妹子）\",\"reply_text\":\"大家其实都知道，其实忙也没那么忙。尽快抽身，多做尝试吧（多约几个妹子）\",\"hideCallUserReplyContent\":\"大家其实都知道，其实忙也没那么忙。<br>尽快抽身，多做尝试吧（多约几个妹子）\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 40 分钟前\",\"username\":\"jiurenmeng\",\"avatar\":\"https://cdn.v2ex.com/gravatar/f9cf2410a9b8aeaf34a00f3d48353461?s=24&d=retro\",\"floor\":6,\"children\":[]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283376\",\"reply_content\":\"放弃吧，几次恋爱基本第一次见面，晚上散步的时候就上手了\",\"reply_text\":\"放弃吧，几次恋爱基本第一次见面，晚上散步的时候就上手了\",\"hideCallUserReplyContent\":\"放弃吧，几次恋爱基本第一次见面，晚上散步的时候就上手了\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 40 分钟前\",\"username\":\"zsl199512101234\",\"avatar\":\"https://cdn.v2ex.com/avatar/546f/ab9f/366461_normal.png?m=1629461617\",\"floor\":7,\"children\":[]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283388\",\"reply_content\":\"给对方？？\",\"reply_text\":\"给对方？？\",\"hideCallUserReplyContent\":\"给对方？？\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 38 分钟前\",\"username\":\"cbythe434\",\"avatar\":\"https://cdn.v2ex.com/gravatar/f32828fb7612c9460773fc36e6ab79f6?s=24&d=retro\",\"floor\":8,\"children\":[]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283441\",\"reply_content\":\"我还是给对方发了好人卡+祝福语<br>-----<br>如果一直内耗很难受的话，这样是对的。<br>如果之后你看开一些，再遇到合适的 可以适当观察几个月看看，不用急着下结论，相亲是 概率+长期的过程。<br><br>当然, 从来不会主动找你聊天的，那是得 PASS\",\"reply_text\":\"我还是给对方发了好人卡+祝福语-----如果一直内耗很难受的话，这样是对的。如果之后你看开一些，再遇到合适的 可以适当观察几个月看看，不用急着下结论，相亲是 概率+长期的过程。当然, 从来不会主动找你聊天的，那是得 PASS\",\"hideCallUserReplyContent\":\"我还是给对方发了好人卡+祝福语<br>-----<br>如果一直内耗很难受的话，这样是对的。<br>如果之后你看开一些，再遇到合适的 可以适当观察几个月看看，不用急着下结论，相亲是 概率+长期的过程。<br><br>当然, 从来不会主动找你聊天的，那是得 PASS\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 34 分钟前\",\"username\":\"steve009\",\"avatar\":\"https://cdn.v2ex.com/avatar/ba03/2b0f/647267_normal.png?m=1709169951\",\"floor\":9,\"children\":[]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283465\",\"reply_content\":\"沉默不理你就换啊，多相几次你就坦然了\",\"reply_text\":\"沉默不理你就换啊，多相几次你就坦然了\",\"hideCallUserReplyContent\":\"沉默不理你就换啊，多相几次你就坦然了\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 32 分钟前\",\"username\":\"PoorBe\",\"avatar\":\"https://cdn.v2ex.com/avatar/a78c/2231/516237_normal.png?m=1713942445\",\"floor\":10,\"children\":[]}],\"nestedRedundReplies\":[{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283327\",\"reply_content\":\"不会主动来找你聊天的话十有八九没戏的<br>早点脱身挺好\",\"reply_text\":\"不会主动来找你聊天的话十有八九没戏的早点脱身挺好\",\"hideCallUserReplyContent\":\"不会主动来找你聊天的话十有八九没戏的<br>早点脱身挺好\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 43 分钟前\",\"username\":\"liansishen\",\"avatar\":\"https://cdn.v2ex.com/gravatar/0d45b7a7ca9de80b6e33af28ffd98ec6?s=24&d=retro\",\"floor\":1,\"children\":[]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283328\",\"reply_content\":\"“一次对方加班，一次是赶上中秋回家”<br>我个人觉得这两次拒绝的理由如果属实的话，还算合理...\",\"reply_text\":\"“一次对方加班，一次是赶上中秋回家”我个人觉得这两次拒绝的理由如果属实的话，还算合理...\",\"hideCallUserReplyContent\":\"“一次对方加班，一次是赶上中秋回家”<br>我个人觉得这两次拒绝的理由如果属实的话，还算合理...\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 43 分钟前\",\"username\":\"SleepyRaven\",\"avatar\":\"https://cdn.v2ex.com/avatar/b952/aae5/551488_normal.png?m=1723688056\",\"floor\":2,\"children\":[]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283337\",\"reply_content\":\"<a target=\\"_blank\\" href=\\"https://i.imgur.com/L62ZP7V.png\\" rel=\\"nofollow noopener\\"><img src=\\"https://i.imgur.com/L62ZP7V.png\\" class=\\"embedded_image\\" rel=\\"noreferrer\\"></a>下一个更好。\",\"reply_text\":\"下一个更好。\",\"hideCallUserReplyContent\":\"<a target=\\"_blank\\" href=\\"https://i.imgur.com/L62ZP7V.png\\" rel=\\"nofollow noopener\\"><img src=\\"https://i.imgur.com/L62ZP7V.png\\" class=\\"embedded_image\\" rel=\\"noreferrer\\"></a>下一个更好。\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 43 分钟前\",\"username\":\"fengci\",\"avatar\":\"https://cdn.v2ex.com/avatar/92ce/e689/279994_normal.png?m=1699355384\",\"floor\":3,\"children\":[]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283343\",\"reply_content\":\"这种就是对你没感觉，直接放弃就好，不用有心里负担。\",\"reply_text\":\"这种就是对你没感觉，直接放弃就好，不用有心里负担。\",\"hideCallUserReplyContent\":\"这种就是对你没感觉，直接放弃就好，不用有心里负担。\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 42 分钟前\",\"username\":\"gimp\",\"avatar\":\"https://cdn.v2ex.com/avatar/d03f/fbc5/136804_normal.png?m=1444699066\",\"floor\":4,\"children\":[]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283370\",\"reply_content\":\"强扭的瓜不甜。\",\"reply_text\":\"强扭的瓜不甜。\",\"hideCallUserReplyContent\":\"强扭的瓜不甜。\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 40 分钟前\",\"username\":\"qingxiangcool\",\"avatar\":\"https://cdn.v2ex.com/gravatar/4a796b20c7433e0ac60fd8f348f7a19d?s=24&d=retro\",\"floor\":5,\"children\":[]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283375\",\"reply_content\":\"大家其实都知道，其实忙也没那么忙。<br>尽快抽身，多做尝试吧（多约几个妹子）\",\"reply_text\":\"大家其实都知道，其实忙也没那么忙。尽快抽身，多做尝试吧（多约几个妹子）\",\"hideCallUserReplyContent\":\"大家其实都知道，其实忙也没那么忙。<br>尽快抽身，多做尝试吧（多约几个妹子）\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 40 分钟前\",\"username\":\"jiurenmeng\",\"avatar\":\"https://cdn.v2ex.com/gravatar/f9cf2410a9b8aeaf34a00f3d48353461?s=24&d=retro\",\"floor\":6,\"children\":[]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283376\",\"reply_content\":\"放弃吧，几次恋爱基本第一次见面，晚上散步的时候就上手了\",\"reply_text\":\"放弃吧，几次恋爱基本第一次见面，晚上散步的时候就上手了\",\"hideCallUserReplyContent\":\"放弃吧，几次恋爱基本第一次见面，晚上散步的时候就上手了\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 40 分钟前\",\"username\":\"zsl199512101234\",\"avatar\":\"https://cdn.v2ex.com/avatar/546f/ab9f/366461_normal.png?m=1629461617\",\"floor\":7,\"children\":[]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283388\",\"reply_content\":\"给对方？？\",\"reply_text\":\"给对方？？\",\"hideCallUserReplyContent\":\"给对方？？\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 38 分钟前\",\"username\":\"cbythe434\",\"avatar\":\"https://cdn.v2ex.com/gravatar/f32828fb7612c9460773fc36e6ab79f6?s=24&d=retro\",\"floor\":8,\"children\":[]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283441\",\"reply_content\":\"我还是给对方发了好人卡+祝福语<br>-----<br>如果一直内耗很难受的话，这样是对的。<br>如果之后你看开一些，再遇到合适的 可以适当观察几个月看看，不用急着下结论，相亲是 概率+长期的过程。<br><br>当然, 从来不会主动找你聊天的，那是得 PASS\",\"reply_text\":\"我还是给对方发了好人卡+祝福语-----如果一直内耗很难受的话，这样是对的。如果之后你看开一些，再遇到合适的 可以适当观察几个月看看，不用急着下结论，相亲是 概率+长期的过程。当然, 从来不会主动找你聊天的，那是得 PASS\",\"hideCallUserReplyContent\":\"我还是给对方发了好人卡+祝福语<br>-----<br>如果一直内耗很难受的话，这样是对的。<br>如果之后你看开一些，再遇到合适的 可以适当观察几个月看看，不用急着下结论，相亲是 概率+长期的过程。<br><br>当然, 从来不会主动找你聊天的，那是得 PASS\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 34 分钟前\",\"username\":\"steve009\",\"avatar\":\"https://cdn.v2ex.com/avatar/ba03/2b0f/647267_normal.png?m=1709169951\",\"floor\":9,\"children\":[]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15283465\",\"reply_content\":\"沉默不理你就换啊，多相几次你就坦然了\",\"reply_text\":\"沉默不理你就换啊，多相几次你就坦然了\",\"hideCallUserReplyContent\":\"沉默不理你就换啊，多相几次你就坦然了\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"14 小时 32 分钟前\",\"username\":\"PoorBe\",\"avatar\":\"https://cdn.v2ex.com/avatar/a78c/2231/516237_normal.png?m=1713942445\",\"floor\":10,\"children\":[]}],\"username\":\"\",\"url\":\"\",\"href\":\"\",\"member\":{\"avatar\":\"\",\"username\":\"yunshangzhou\",\"avatar_large\":\"https://cdn.v2ex.com/avatar/205f/180e/600305_large.png?m=1726042527\"},\"node\":{\"title\":\"生活\",\"url\":\"https://www.v2ex.com/go/life\"},\"headerTemplate\":\"<div class=\\"cell\\"><div class=\\"topic_content\\"><div class=\\"markdown_body\\"><p>天时弄人，约了 2 次饭，被拒了 2 次，一次对方加班，一次是赶上中秋回家。当然之前提到场地费的事，节前送了盒美心月饼表示了一下。随后又是好几天以沉默报以沉默。</p><p>期间我看了些对罗翔、毛不易、李雪琴等节目里对爱情的观念。有好几句话是戳中我的:</p><ul><li>如果你今天给了人不切实际的希望，也相当于给了人绝望</li><li>两人没有共同爱好，那是为什么在一起？</li><li>我希望有一段好的关系，能让我有一次学习爱与被爱的能力</li><li>我相信爱情，但不相信爱情能降临在我身上。</li></ul><p>我感觉大家都是尝试过迁就对方的，回想到第一次线下聊天互相卡壳，为了缓解尴尬而想话题聊天，可能真的不合适。而且经过 2 次拒绝，没有信心再约第三次了，经历了一段时间的思想内斗，我还是给对方发了好人卡+祝福语。抱歉让各位期待后续的瓜友失望了。</p></div></div></div><div class=\\"subtle\\"><span class=\\"fade\\">第 1 条附言 &nbsp;·&nbsp; 13 小时 52 分钟前</span><div class=\\"sep\\"></div><div class=\\"topic_content\\">这个女生算是亲戚(副校长)介绍来的，所以人品毋庸置疑，大家不要再恶意揣测了。<br><br>关于 200 多的月饼，我觉得大方是最容易的事情，如果把关注点放在钱上，做人是做不开的。<br><br>至于话说死，不合适也不要谈后续死灰复燃的，没多少人真的会吃回头草。<br><br>相处过程中对方挺友好的，就这样。</div></div>\",\"title\":\"26 岁母胎 solo 的第一次相亲 (后续)\",\"id\":\"1074269\",\"type\":\"post\",\"once\":\"59126\",\"replyCount\":10,\"clickCount\":10119,\"thankCount\":0,\"collectCount\":37,\"lastReadFloor\":0,\"isFavorite\":false,\"isIgnore\":false,\"isThanked\":false,\"isReport\":false,\"inList\":false}}';
    var te = json.decode(message);
    post = Get.arguments;
    isShowFixedTitle = false;
    update();

    var t = DateTime.now();
    loading = true;
    update();
    print('请求开始$t');
    Post2 topicDetailModel = await TopicWebApi.getTopicDetail(Get.arguments.id);
    // Post2 topicDetailModel = await TopicWebApi.getTopicDetail('1058393' );
    // Post2 topicDetailModel = await TopicWebApi.getTopicDetail('825072');
    // Post2 topicDetailModel = await TopicWebApi.getTopicDetail('889129');
    loading = false;
    update();
    var s = DateTime.now();
    print('处理结束$s');
    var hours = t.difference(s);
    print('花费时间$hours');

    post = topicDetailModel;
    update();
    observerController.reattach();
  }

  @override
  void onClose() {
    print('onClose');
    super.onClose();
    _scrollController.dispose();
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
  PostDetailController ctrl = Get.put(PostDetailController());
  TextEditingController _replyCtrl = new TextEditingController();
  BuildContext? headerCtx;
  BuildContext? normalListCtx; //正常回复
  BuildContext? topListCtx; //高赞回复
  BuildContext? firstChildCtx;
  bool reverseSort = false; // 倒序
  bool isLoading = false; // 请求状态 正序/倒序

  @override
  void initState() {
    super.initState();
    ctrl.getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  submit() {
    print("test");
    // controller.loadRequest(Uri.parse('https://v2ex.com'));
    // Navigator.pushNamed(context, 'Home');
  }

  //回复菜单操作项
  Widget _buildReplyMenuOption(String text, IconData icon, GestureTapCallback onTap) {
    return InkWell(
      child: Padding(
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
          )),
      onTap: onTap,
    );
  }

  Widget optionItem(
    String text,
    IconData icon,
  ) {
    return InkWell(
        child: Container(
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
        ),
        onTap: () {
          debugPrint('1');
          ctrl.config.showTopReply = !ctrl.config.showTopReply;
          ctrl.update();
          Get.back();
        });
  }

  //显示回复菜单弹窗
  showItemMenuModal(Reply val) {
    PostDetailController c = PostDetailController.to();
    c.setReply(val);
    modalWrap(
        getHtmlText(c.reply.replyContent),
        Column(
          children: [
            _buildReplyMenuOption('回复', Icons.chat_bubble_outline, () {
              Get.back();
              showReplyModal(val);
            }),
            _buildReplyMenuOption('感谢', Icons.favorite_border, () {
              thankReply(val);
            }),
            _buildReplyMenuOption('上下文', Icons.content_paste_search, () {}),
            _buildReplyMenuOption('复制', Icons.content_copy, () {}),
            _buildReplyMenuOption('忽略', Icons.block, () {}),
          ],
        ));
  }

  //显示帖子菜单弹窗
  showPostMenuModal() {
    modalWrap(
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [getPostTitle(), getHtmlText(ctrl.post?.headerTemplate ?? '')],
        ),
        Column(
          children: [
            Row(children: [
              optionItem('保存', Icons.bookmark_border),
              optionItem('深色模式', Icons.bookmark_border),
              optionItem('报告', Icons.bookmark_border),
              optionItem('忽略', Icons.bookmark_border),
            ]),
            Row(children: [
              optionItem('稍后阅读', Icons.bookmark_border),
              optionItem('复制内容', Icons.content_copy),
              optionItem('复制链接', Icons.link),
              optionItem('浏览器打开', Icons.travel_explore),
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
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 0.w),
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

  showReplyModal([Reply? val]) {
    PostDetailController pdc = PostDetailController.to();
    if (val != null) {
      pdc.setReply(val);
      _replyCtrl.text = '#${val.username} #${val.floor} ';
      modalWrap(getHtmlText(pdc.reply.replyContent), getTest());
    } else {
      pdc.setReply(new Reply());
      modalWrap(getHtmlText(ctrl.post.headerTemplate), getTest());
    }
  }

  Widget _buildReplyItem(Reply item, int index, int type) {
    return ReplyItem(
      index: index,
      type: type,
      item: item,
      onThank: (e) => thankReply(e),
      onMenu: (e) => showItemMenuModal(e),
      onTap: (e) => showReplyModal(e),
    );
  }

  Widget _buildIcon(IconData icon) {
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
        child: _buildIcon(icon),
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
        ctrl.post?.title ?? '',
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
        if (element.classes.contains('outdated')) {
          return {
            'color': 'gray',
            'font-size': '14px',
            'background-color': '#f9f9f9',
            'border-left': '5px solid #f0f0f0',
            'padding': '10px',
          };
        }
        return null;
      },
    ));
  }

  onReply() async {
    BaseController bc = Get.find();
    var res = await TopicWebApi.onSubmitReplyTopic(ctrl.post.id, _replyCtrl.text, 0);
    if (res == 'true') {
      if (context.mounted) {
        setState(() {
          var s = new Reply();
          s.replyContent = _replyCtrl.text;
          s.username = GStorage().getUserInfo()['userName'];
          s.avatar = GStorage().getUserInfo()['avatar'];
          s.date = '刚刚';
          s.floor = ctrl.post.replyCount + 1;
          ctrl.post.replyList.add(s);
          ctrl.rebuildList();
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
                _buildIcon(Icons.sentiment_satisfied_alt),
                SizedBox(width: 10.w),
                _buildIcon(Icons.alternate_email),
                SizedBox(width: 10.w),
                _buildIcon(Icons.add_photo_alternate),
                SizedBox(width: 10.w),
                _buildIcon(Icons.format_quote),
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
      return Get.toNamed('/login');
    }
    var res = await TopicWebApi.favoriteTopic(ctrl.post.isFavorite, ctrl.post.id);
    if (res) {
      setState(() {
        ctrl.post.isFavorite = !ctrl.post.isFavorite;
        ctrl.post.collectCount = ctrl.post.isFavorite ? ctrl.post.collectCount + 1 : ctrl.post.collectCount - 1;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ctrl.post.isFavorite ? '已收藏' : '已取消收藏'),
          showCloseIcon: true,
        ),
      );
    }
  }

  //感谢帖子
  thankPost() async {
    bool needLogin = !(GStorage().getLoginStatus());
    if (needLogin) {
      return Get.toNamed('/login');
    }
    if (ctrl.post.isThanked) {
      SmartDialog.showToast('这个主题已经被感谢过了');
    } else {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
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
                var res = await TopicWebApi.thankTopic(ctrl.post.id);
                print('54: $res');
                if (res) {
                  setState(() {
                    ctrl.post.isThanked = true;
                    ctrl.post.thankCount += 1;
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
    var s = ctrl.post?.replyList?[index - 1];
    if (s != Null) {
      setState(() {
        ctrl.post?.replyList?[index - 1].isThanked = true;
      });
    }
  }

  // 感谢回复 request
  void onThankReply(Reply val) async {
    var res = await DioRequestWeb.thankReply(val.id, ctrl.post.id);
    if (res) {
      var index = ctrl.post.replyList.indexWhere((v) => v.id == val.id);
      ctrl.post.replyList[index].isThanked = true;
      ctrl.post.replyList[index].thankCount += 1;
      ctrl.rebuildList();
    }
  }

  //感谢回复
  thankReply(Reply val) {
    BaseController bc = Get.find();
    if (!bc.isLogin) {
      return Get.toNamed('/login');
    }

    if (val.isThanked) {
      SmartDialog.showToast('这个回复已经被感谢过了');
      return;
    }
    if (val.username == bc.member.username) {
      SmartDialog.showToast('不能感谢自己');
      return;
    }

    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
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
              onThankReply(val);
            },
            child: const Text('确认'),
          ),
        ],
      ),
    );
  }

  Widget space() {
    return SliverToBoxAdapter(
      child: Container(
        width: 100.sw,
        height: 14.w,
        color: Colors.grey[100],
      ),
    );
  }

  Future<void> onRefresh() async {
    // print(ctrl.post.replyList[2].replyFloor.toString());
    // print(ctrl.post.replyList[2].replyContent.toString());
    // print(ctrl.post.replyList[2].hideCallUserReplyContent.toString());
    // print(ctrl.post.replyList[2].replyUsers.toString());
    ctrl.rebuildList();
    // ctrl.getData();
    return;
  }

  Widget _buildNavbar() {
    return Container(
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
                      opacity: ctrl.isShowFixedTitle ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        ctrl.post.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    ),
                    onTap: () {
                      ctrl._scrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.ease);
                    },
                  ))
                ],
              ),
            ),
            clickIcon(Icons.more_vert, showPostMenuModal)
          ],
        ));
  }

  Widget _buildToolbar() {
    return Container(
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
                  showReplyModal();
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
                      ctrl.post.isFavorite ? Icons.star : Icons.star_border,
                      size: 24.sp,
                      color: ctrl.post.isFavorite ? Colors.red : Colors.grey,
                    ),
                    Text(
                      ctrl.post.collectCount.toString(),
                      style: TextStyle(fontSize: 10.sp, color: ctrl.post.isFavorite ? Colors.red : Colors.grey),
                    )
                  ],
                ), () {
              onCollect();
            }),
            clickWidget(
                Column(
                  children: [
                    Icon(
                      ctrl.post.isThanked ? Icons.favorite : Icons.favorite_border,
                      size: 24.sp,
                      color: ctrl.post.isThanked ? Colors.red : Colors.grey,
                    ),
                    Text(
                      ctrl.post.thankCount.toString(),
                      style: TextStyle(fontSize: 10.sp, color: ctrl.post.isThanked ? Colors.red : Colors.grey),
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
                      ctrl.post.replyCount.toString(),
                      style: TextStyle(fontSize: 10.sp, color: Colors.black54),
                    )
                  ],
                ), () {
              if (firstChildCtx == null || firstChildCtx == headerCtx) {
                debugPrint('当前是 - headerCtx');
                ctrl.setShowFixedTitle(true);
                firstChildCtx = normalListCtx;
                // _scrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.ease);
                ctrl.observerController.animateTo(
                  sliverContext: normalListCtx,
                  index: 0,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.ease,
                  // offset: (v)=>24.w
                );
              } else {
                debugPrint('当前是 - listCtx');
                ctrl.setShowFixedTitle(false);
                ctrl._scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.ease);
                firstChildCtx = headerCtx;
              }
            }),
          ],
        ));
  }

  Widget _buildDivider() {
    return Divider(color: Color(0xfff1f1f1), height: 1.w);
  }

  Widget _buildListHeader(String left, [bool right = true]) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              left,
              style: TextStyle(fontSize: 14.sp, height: 1.2, color: Colors.grey),
            ),
            if (right)
              Text(
                '楼中楼',
                style: TextStyle(fontSize: 14.sp, height: 1.2, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: GetBuilder<PostDetailController>(builder: (_) {
        return Column(
          children: [
            _buildNavbar(),
            Expanded(
                child: RefreshIndicator(
                    child: SliverViewObserver(
                      controller: ctrl.observerController,
                      onObserveViewport: (res) {
                        firstChildCtx = res.firstChild.sliverContext;
                        if (firstChildCtx == headerCtx) {
                          ctrl.setShowFixedTitle(false);
                          debugPrint('onObserveViewport - headerCtx');
                        } else if (firstChildCtx == topListCtx) {
                          ctrl.setShowFixedTitle(true);
                          debugPrint('onObserveViewport - topListCtx');
                        } else {
                          ctrl.setShowFixedTitle(true);
                          debugPrint('onObserveViewport - listCtx');
                        }
                      },
                      sliverContexts: () {
                        return [
                          if (headerCtx != null) headerCtx!,
                          if (normalListCtx != null) normalListCtx!,
                          if (topListCtx != null) topListCtx!,
                        ];
                      },
                      child: CustomScrollView(
                        physics: new AlwaysScrollableScrollPhysics(),
                        controller: ctrl._scrollController,
                        slivers: [
                          //标题和内容
                          SliverLayoutBuilder(
                            builder: (context, _) {
                              if (headerCtx != context) headerCtx = context;
                              return SliverToBoxAdapter(
                                child: Padding(
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
                                              BaseAvatar(src: ctrl.post.member.avatarLarge, diameter: 30.w, radius: 4.w),
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
                                                          ctrl.post.member.username,
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
                                                          ctrl.post.createDateAgo,
                                                          style: TextStyle(fontSize: 11.sp, height: 1.2, color: Colors.grey),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(left: 10.w),
                                                        child: Text(
                                                          ctrl.post.clickCount.toString() + '次点击',
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
                                                ctrl.post.node.title,
                                                style: TextStyle(color: Colors.black, fontSize: 12.sp),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      getPostTitle(),
                                      ctrl.loading
                                          ? Skeletonizer.zone(
                                              child: Padding(padding: EdgeInsets.only(top: 6.w), child: Bone.multiText(lines: 7, style: TextStyle(height: 1.6))),
                                            )
                                          : getHtmlText(ctrl.post.headerTemplate),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          space(),

                          if (ctrl.loading) ...[
                            //普通回复
                            //header
                            _buildListHeader(ctrl.post.replyCount.toString() + '条回复'),
                            SliverList(
                                delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return Column(
                                  children: [
                                    Skeletonizer.zone(
                                      child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          Row(children: [
                                            Bone.circle(size: 28),
                                            SizedBox(width: 10.w),
                                            Bone.text(width: 80.w),
                                          ], crossAxisAlignment: CrossAxisAlignment.center, verticalDirection: VerticalDirection.down),
                                          Padding(padding: EdgeInsets.only(top: 6.w), child: Bone.multiText(style: TextStyle(height: 1.6))),
                                        ]),
                                      ),
                                    ),
                                    _buildDivider()
                                  ],
                                );
                              },
                              childCount: 7,
                            )),
                          ] else ...[
                            //高赞回复
                            if (ctrl.config.showTopReply && ctrl.post.topReplyList.length != 0) ...[
                              //header
                              _buildListHeader(ctrl.post.topReplyList.length.toString() + '条高赞回复', false),
                              //list
                              SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  if (topListCtx != context) topListCtx = context;
                                  return Column(children: [_buildReplyItem(ctrl.post.topReplyList[index], index, 0), _buildDivider()]);
                                },
                                childCount: ctrl.post.topReplyList.length,
                              )),
                              space(),
                            ],

                            //普通回复
                            //header
                            _buildListHeader(ctrl.post.replyCount.toString() + '条回复'),
                            //list
                            SliverList(
                                delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                if (normalListCtx != context) normalListCtx = context;
                                // return ListTile(title: Text('1111$index'));
                                return Column(children: [_buildReplyItem(ctrl.getReplyList()[index], index, 0), _buildDivider()]);
                              },
                              childCount: ctrl.getReplyList().length,
                            )),
                            SliverToBoxAdapter(
                                child: Container(
                              height: 100.w,
                              child: Center(
                                child: Text('没有更多了'),
                              ),
                            )),
                          ]
                        ],
                      ),
                    ),
                    onRefresh: onRefresh)),
            _buildToolbar()
          ],
        );
      }),
    );
  }
}
