import 'dart:convert';

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
    final postDao = bc.database.postDao;

    var s = await postDao.getPostWithReplies(post.postId);
    if (s != null) {
      print('replies.lengt');
      print(s.replies[0].replyContent);
      // print(s.post.id);
      // print(s.post.postId);
      post = Post.fromJson(s.post.toJson());
      post.replyList = s.replies.map((v) {
        var r = Reply.fromJson(v.toJson());
        r.replyUsers = jsonDecode(v.replyUsers);
        return r;
      }).toList();
      rebuildList();
    } else {
      loading = true;
    }

    update();
    post = await Api.getPostDetail(Get.arguments.postId);
    // post = await Api.getPostDetail('825072');
    loading = false;
    update();
    observerController.reattach();

    if (s == null) {
      int postAutoId = await postDao.insertPost(post, post.replyList);
      // postDao.insertReply(postAutoId, post.replyList[0]);
    } else {
      // postDao.updatePost(post, post.replyList);
    }
  }

  @override
  void onClose() {
    print('onClose');
    super.onClose();
    scrollController.dispose();
  }
}
