import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Value;
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:v2next/http/api.dart';
import 'package:v2next/model/base_controller.dart';
import 'package:v2next/model/model.dart';
import 'package:v2next/utils/event_bus.dart';
import 'package:v2next/utils/utils.dart';

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
    updateAndSave();
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

  Future getData() async {
    post = Get.arguments;
    isShowFixedTitle = false;
    final postDao = bc.database.postDao;

    var s = await postDao.getPostWithReplies(post.postId);
    if (s != null) {
      loading = false;
      update();
      print('replies.length${s.replies.length}');
      // print(s.replies[0].replyContent);
      // print(s.post.id);
      // print(s.post.postId);
      var postJson = s.post.toJson();
      post = Post.fromJson(postJson);
      post.member.username = postJson['memberUsername'];
      post.member.avatar = postJson['memberAvatar'];
      post.node.name = postJson['nodeName'];
      post.node.title = postJson['nodeTitle'];
      post.replyList = s.replies.map((v) {
        var json = v.toJson();
        json['replyUsers'] = jsonDecode(json['replyUsers']);
        var r = Reply.fromJson(json);
        if (r.replyUsers.length == 1) {
          r.hideCallUserReplyContent = r.replyContent.replaceAll(RegExp(r'@<a href="/member/[\s\S]+?</a>(\s#[\d]+)?\s(<br>)?'), '');
        } else {
          r.hideCallUserReplyContent = r.replyContent;
        }
        return r;
      }).toList();
      rebuildList();
    } else {
      loading = true;
    }

    update();

    var res = await Api.getPostDetail(Get.arguments.postId);
    if (post.member.avatar.isEmpty) {
      res.member.avatar = res.member.avatarLarge;
    } else {
      res.member.avatar = post.member.avatar;
    }
    post = res;
    // post = await Api.getPostDetail('825072');
    loading = false;
    update();
    bc.addRead({post.postId.toString(): post.replyCount});
    EventBus().emit(EventKey.postDetail, post);
    observerController.reattach();

    if (s == null) {
      postDao.insertPost(post, post.replyList);
    } else {
      postDao.updatePost(post, post.replyList);
    }
  }

  @override
  void onClose() {
    print('onClose');
    super.onClose();
    scrollController.dispose();
  }

  updateAndSave() {
    update();
    final postDao = bc.database.postDao;
    postDao.updatePost(post, post.replyList);
  }
}
