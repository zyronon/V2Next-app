import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:v2ex/model/BaseController.dart';
import 'package:v2ex/model/Post2.dart';
import 'package:v2ex/http/api.dart';
import 'package:v2ex/utils/utils.dart';

class PostDetailController extends GetxController {
  bool isShowFixedTitle = false;
  Post2 post = new Post2();
  Reply reply = new Reply();
  int scrollIndex = 0;
  bool loading = false;
  UserConfig config = UserConfig();
  BaseController bc = BaseController.to;
  ScrollController scrollController = ScrollController();
  late SliverObserverController observerController = SliverObserverController(controller: scrollController);

  setShowFixedTitle(bool val) {
    this.isShowFixedTitle = val;
    update();
  }

  static to(id) => Get.find<PostDetailController>(tag: id);

  static PostDetailController get to2 => Get.find<PostDetailController>();

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
    switch (bc.currentConfig.commentDisplayType) {
      case CommentDisplayType.Nest:
      case CommentDisplayType.NestAndCall:
        return post.nestedReplies;
      case CommentDisplayType.Hot:
        return post.hotReplyList;
      case CommentDisplayType.Origin:
        return post.replyList;
      case CommentDisplayType.Op:
        return post.replyList.where((v) => v.username == post.member.username).toList();
      case CommentDisplayType.New:
        return post.newReplyList;
      default:
        return post.nestedReplies;
    }
  }

  getListLength() {
    return getReplyList().length + post.topReplyList.length + 1;
  }

  Reply getReplyItem(index) {
    return post.replyList[index - 1];
  }

  @override
  onInit() {
    super.onInit();
    getData();
  }

  getData() async {
    post = Get.arguments;
    isShowFixedTitle = false;
    loading = true;
    update();
    // Post2 topicDetailModel = await TopicWebApi.getTopicDetail('1058393' );
    // Post2 topicDetailModel = await TopicWebApi.getTopicDetail('889129');
    // post = await Api.getPostDetail('825072');
    // post = await Api.getPostDetail('1026938');
    post = await Api.getPostDetail(Get.arguments.id);
    // post = await Api.getPostDetail('825072');
    loading = false;
    update();
    observerController.reattach();
  }

  @override
  void onClose() {
    print('onClose');
    super.onClose();
    scrollController.dispose();
  }
}
