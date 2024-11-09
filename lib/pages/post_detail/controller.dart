import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Value;
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:v2ex/model/BaseController.dart';
import 'package:v2ex/model/database.dart';
import 'package:v2ex/model/model.dart';
import 'package:v2ex/http/api.dart';
import 'package:v2ex/utils/utils.dart';

class PostDetailController extends GetxController {
  bool isShowFixedTitle = false;
  Post post = new Post();
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

    var s = await bc.database.managers.todoItems.filter((f) => f.postId(post.id)).getSingleOrNull();
    if (s != null) {
      print(s.title);
      print(s.contentRendered);
      print(s.createDate);
      post = Post.fromJson(s.toJson());
    }else{
      loading = true;
    }

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
    if (s == null) {
      await bc.database.into(bc.database.todoItems).insert(
            TodoItemsCompanion.insert(
              postId: post.id,
              title: post.title,
              contentRendered: post.contentRendered,
              contentText: post.contentText,
              createDate: post.createDate,
              createDateAgo: post.createDateAgo,
              lastReplyDate: post.lastReplyDate,
              lastReplyDateAgo: post.lastReplyDateAgo,
              lastReplyUsername: post.lastReplyUsername,
              replyCount: Value(post.replyCount),
              thankCount: Value(post.thankCount),
              collectCount: Value(post.collectCount),
              isTop: Value(post.isTop),
              isFavorite: Value(post.isFavorite),
              isIgnore: Value(post.isIgnore),
              isThanked: Value(post.isThanked),
              isReport: Value(post.isReport),
              isAppend: Value(post.isAppend),
              isEdit: Value(post.isEdit),
              isMove: Value(post.isMove),
            ),
          );
    }
  }

  @override
  void onClose() {
    print('onClose');
    super.onClose();
    scrollController.dispose();
  }
}
