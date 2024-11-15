import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:v2ex/components/base_avatar.dart';
import 'package:v2ex/components/base_button.dart';
import 'package:v2ex/components/base_divider.dart';
import 'package:v2ex/components/base_html.dart';
import 'package:v2ex/components/footer.dart';
import 'package:v2ex/http/api.dart';
import 'package:v2ex/model/BaseController.dart';
import 'package:v2ex/model/model.dart';
import 'package:v2ex/pages/post_detail/components/editor.dart';
import 'package:v2ex/pages/post_detail/components/post_navbar.dart';
import 'package:v2ex/pages/post_detail/components/post_space.dart';
import 'package:v2ex/pages/post_detail/components/post_toolbar.dart';
import 'package:v2ex/pages/post_detail/components/reply_item.dart';
import 'package:v2ex/pages/post_detail/components/share.dart';
import 'package:v2ex/utils/const_val.dart';
import 'package:v2ex/utils/utils.dart';

import 'components/post_header.dart';
import 'components/post_list_header.dart';
import 'components/post_list_loading.dart';
import 'components/tag_manager_modal.dart';
import 'controller.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({super.key});

  @override
  State<PostDetailPage> createState() => PostDetailPageState();
}

class PostDetailPageState extends State<PostDetailPage> {
  late String postId = Get.arguments.postId.toString();
  late PostDetailController ctrl;

  BaseController bc = BaseController.to;
  BuildContext? headerCtx;
  BuildContext? normalListCtx; //正常回复
  BuildContext? topListCtx; //高赞回复
  BuildContext? firstChildCtx;
  bool reverseSort = false; // 倒序

  @override
  void initState() {
    super.initState();
    ctrl = Get.put(PostDetailController(), tag: postId);
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<PostDetailController>(tag: postId);
  }

  Widget _buildReplyMenuOptionWrapper({required Widget child}) {
    return Container(
      margin: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: child,
    );
  }

  //回复菜单操作项
  Widget _buildReplyMenuOption({required String text, required GestureTapCallback onTap, IconData? icon, bool? active, Widget? right, bool disabled = false}) {
    return InkWell(
      child: Opacity(
          opacity: disabled ? 0.2 : 1,
          child: Padding(
              padding: EdgeInsets.all(14.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(children: [
                    if (icon != null)
                      Icon(
                        icon,
                        size: 20.sp,
                        color: active != null ? (active ? Colors.lightBlue : Colors.black) : Colors.black,
                      ),
                    Padding(
                      padding: EdgeInsets.only(left: 12.w),
                      child: Text(
                        text,
                        style: TextStyle(color: active != null ? (active ? Colors.lightBlue : Colors.black) : Colors.black),
                      ),
                    )
                  ]),
                  if (right != null) right
                ],
              ))),
      onTap: disabled ? null : onTap,
    );
  }

  Widget _buildLine() {
    return Row(children: [SizedBox(width: 40.w), Expanded(child: Divider(color: Colors.grey[300], height: 1.w))]);
  }

  showRelationReplyListModal(Reply val) {
    var replyUsers = val.replyUsers;
    var username = val.username;
    replyUsers.add(username);
    var floor = val.floor;
    List list = ctrl.post.replyList.where((v) {
      //找出两个人所有的回复。
      if (replyUsers.contains(v.username)) {
        //如果超过目标楼层
        if (v.floor > floor) {
          //只找回复目标的
          if (v.replyUsers.contains(username)) {
            return true;
          }
          //自己回复，并与@的人相关的
          if (v.username == username) {
            for (int i = 0; i < val.replyUsers.length; i++) {
              if (v.replyUsers.contains(val.replyUsers[i])) {
                return true;
              }
            }
          }
        } else {
          //前面的不管回复的谁都要
          return true;
        }
      }
      return false;
    }).toList();
    showMaterialModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          // clipBehavior: Clip.hardEdge,
          // height: MediaQuery.of(context).size.height - 0 - 115,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          constraints: BoxConstraints(
            maxHeight: 500.0, // 设置最大高度为 300
          ),
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.w,
                  margin: EdgeInsets.only(bottom: 10.w, top: 10.w),
                  decoration: BoxDecoration(color: Color(0xffcacaca), borderRadius: BorderRadius.all(Radius.circular(2.r))),
                ),
              ),
              Expanded(
                  child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return ReplyItem(
                    item: list[index],
                    onThank: null,
                    onMenu: null,
                    type: ReplyListType.Hot,
                    index: index,
                    isSub: false,
                    // onTap: (i) {
                    //   int rIndex = ctrl.post.replyList.indexWhere((j) => j.id == i.id);
                    //   if (rIndex > -1) {
                    //     jumpToIndexItem(index: rIndex);
                    //   }
                    // },
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return  Const.lineWidget;
                },
              )),
              SizedBox(height: 20.w)
            ],
          ),
        );
      },
    );
  }

  //显示回复菜单弹窗
  showReplyMenuModal({required Reply val, required ReplyListType type}) {
    ctrl.setReply(val);
    modalWrap(
        content: Column(children: [
      _buildReplyMenuOptionWrapper(
          child: Column(children: [
        _buildReplyMenuOption(
            text: '回复',
            icon: TDIcons.chat,
            onTap: () {
              Get.back();
              showEditor(val);
            }),
        _buildLine(),
        _buildReplyMenuOption(
            text: '感谢',
            icon: TDIcons.heart,
            onTap: () {
              Get.back();
              onThankReply(val);
            }),
      ])),
      _buildReplyMenuOptionWrapper(
          child: Column(
        children: [
          _buildReplyMenuOption(
              text: '标签管理',
              icon: Icons.tag,
              onTap: () {
                if (!bc.isLogin) {
                  Get.toNamed('/login');
                  return;
                }
                Get.back();
                Future.delayed(Duration(milliseconds: 300), () {
                  showDialog(
                    context: context,
                    builder: (context) => TagManagerModal(
                      tags: bc.getTags(val.username),
                      onSave: (e) {
                        print(e);
                        bc.setTags(val.username, e);
                        ctrl.update();
                      },
                    ),
                  );
                });
              }),
          _buildLine(),
          _buildReplyMenuOption(
              text: '上下文',
              icon: Icons.content_paste_search,
              onTap: () {
                if (val.replyUsers.length != 0) {
                  Get.back();
                  showRelationReplyListModal(val);
                }
              },
              disabled: val.replyUsers.length == 0),
          _buildLine(),
          _buildReplyMenuOption(
              text: '复制',
              icon: TDIcons.file_copy,
              onTap: () {
                Utils.copy(val.replyText);
              }),
        ],
      )),
      _buildReplyMenuOptionWrapper(
          child: Column(children: [
        // _buildLine(),
        // _buildReplyMenuOption(
        //     text: '跳转',
        //     icon: Icons.content_paste_search,
        //     onTap: () {
        //         int rIndex = ctrl.post.replyList.indexWhere((j) => j.id == val.id);
        //         if (rIndex > -1) {
        //           jumpToIndexItem(index: rIndex);
        //         }
        //     },
        //     disabled: type == ReplyListType.Normal),
        _buildReplyMenuOption(
            text: '分享',
            icon: TDIcons.share,
            onTap: () {
              Get.back();
              showShareModal(val: val);
            }),
        _buildLine(),
        _buildReplyMenuOption(
            text: '忽略',
            icon: TDIcons.browse_off,
            onTap: () {
              //TODO
              Utils.toast(msg: '未实现');
            }),
      ])),
    ]));
  }

  changeCommentDisplayType(CommentDisplayType val) {
    bc.currentConfig.commentDisplayType = val;
    bc.update();
    ctrl.update();
    Get.back();
    jumpToIndexItem(index: 0);
  }

  showSortModal() {
    return modalWrap(
        content: Column(
      children: [
        _buildReplyMenuOptionWrapper(
            child: Column(children: [
          _buildReplyMenuOption(
              text: '最新',
              icon: Icons.new_releases_outlined,
              active: bc.currentConfig.commentDisplayType == CommentDisplayType.New,
              onTap: () {
                changeCommentDisplayType(CommentDisplayType.New);
              }),
          _buildLine(),
          _buildReplyMenuOption(
              text: '最热',
              icon: Icons.local_fire_department,
              active: bc.currentConfig.commentDisplayType == CommentDisplayType.Hot,
              onTap: () {
                changeCommentDisplayType(CommentDisplayType.Hot);
              }),
          _buildLine(),
          _buildReplyMenuOption(
              text: '楼中楼',
              icon: Icons.list_alt,
              active: bc.currentConfig.commentDisplayType == CommentDisplayType.Nest,
              onTap: () {
                changeCommentDisplayType(CommentDisplayType.Nest);
              }),
          _buildLine(),
          _buildReplyMenuOption(
              text: '楼中楼(@)',
              icon: Icons.alternate_email,
              active: bc.currentConfig.commentDisplayType == CommentDisplayType.NestAndCall,
              onTap: () {
                changeCommentDisplayType(CommentDisplayType.NestAndCall);
              }),
          _buildLine(),
          _buildReplyMenuOption(
              text: 'V2原版',
              icon: Icons.notes,
              active: bc.currentConfig.commentDisplayType == CommentDisplayType.Origin,
              onTap: () {
                changeCommentDisplayType(CommentDisplayType.Origin);
              }),
          _buildLine(),
          _buildReplyMenuOption(
              text: '只看楼主',
              icon: Icons.person_outline,
              active: bc.currentConfig.commentDisplayType == CommentDisplayType.Op,
              onTap: () {
                changeCommentDisplayType(CommentDisplayType.Op);
              }),
        ])),
      ],
    ));
  }

  showShareModal({Reply? val}) {
    showMaterialModalBottomSheet<Map>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return PostShare(postId: postId, reply: val);
      },
    );
  }

  // 忽略主题
  Future onIgnorePost() async {
    Future.delayed(
      const Duration(seconds: 0),
      () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('操作提示'),
          content: const Text('确认忽略该主题吗？'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
            TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  SmartDialog.showLoading();
                  var res = await Api.onIgnorePost(ctrl.post.postId);
                  SmartDialog.dismiss();
                  SmartDialog.showToast(res ? '已忽略' : '操作失败');
                  Get.back();
                },
                child: const Text('确认'))
          ],
        ),
      ),
    );
  }

  // 举报主题
  Future onReportPost() async {
    Future.delayed(
      const Duration(seconds: 0),
      () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('操作提示'),
          content: const Text('确认举报该主题吗？'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
            TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  SmartDialog.showLoading();
                  var res = await Api.onReportPost(ctrl.post.postId);
                  SmartDialog.dismiss();
                  SmartDialog.showToast(res ? '已举报' : '操作失败');
                },
                child: const Text('确认'))
          ],
        ),
      ),
    );
  }

  //显示帖子菜单弹窗
  showPostMenuModal() {
    modalWrap(
        content: Column(
      children: [
        _buildReplyMenuOptionWrapper(
            child: Column(children: [
          _buildReplyMenuOption(
              text: '复制内容',
              icon: TDIcons.file_copy,
              onTap: () {
                Utils.copy(ctrl.post.contentText);
              }),
          _buildLine(),
          _buildReplyMenuOption(
              text: '复制链接',
              icon: TDIcons.link,
              onTap: () {
                Utils.copy(Const.v2exHost + '/t/' + ctrl.post.postId.toString());
              }),
          _buildLine(),
          _buildReplyMenuOption(
              text: '分享',
              icon: TDIcons.share,
              onTap: () {
                Get.back();
                showShareModal();
              }),
        ])),
        _buildReplyMenuOptionWrapper(
            child: Column(children: [
          _buildReplyMenuOption(
              text: '标签管理',
              icon: Icons.tag,
              onTap: () {
                if (!bc.isLogin) {
                  Get.toNamed('/login');
                  return;
                }
                Get.back();
                Future.delayed(Duration(milliseconds: 300), () {
                  showDialog(
                    context: context,
                    builder: (context) => TagManagerModal(
                      tags: bc.getTags(ctrl.post.member.username),
                      onSave: (e) {
                        print(e);
                        bc.setTags(ctrl.post.member.username, e);
                        ctrl.update();
                      },
                    ),
                  );
                });
              }),
          _buildLine(),
          _buildReplyMenuOption(
              text: '忽略',
              icon: TDIcons.browse_off,
              onTap: () {
                Get.back();
                //TODO 这里手机上还是会把已忽略的帖子显示出来，因为电脑上是靠display:none来隐藏的...
                onIgnorePost();
              }),
          _buildLine(),
          _buildReplyMenuOption(
              text: '报告',
              icon: TDIcons.info_circle,
              onTap: () {
                Get.back();
                onReportPost();
              }),
        ])),
        _buildReplyMenuOptionWrapper(
            child: Column(children: [
          _buildReplyMenuOption(
              text: '调整排序',
              icon: TDIcons.order_ascending,
              right: Text(Utils.formatCommentDisplayType(bc.currentConfig.commentDisplayType)),
              onTap: () async {
                Get.back();
                showSortModal();
              }),
          _buildLine(),
          _buildReplyMenuOption(
              text: '调整排版',
              icon: TDIcons.view_module,
              onTap: () async {
                Get.back();
                await Get.toNamed('/layout');
                ctrl.update();
              }),
          _buildLine(),
          _buildReplyMenuOption(
              text: '浏览器打开',
              icon: TDIcons.logo_chrome,
              onTap: () {
                Get.back();
                Utils.openBrowser(Const.v2exHost + '/t/' + ctrl.post.postId.toString());
              }),
        ])),
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

  modalWrap({required Widget content, Color? color = const Color(0xfff1f1f1)}) async {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return GetBuilder<PostDetailController>(
            tag: postId,
            builder: (_) {
              return SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
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
                          margin: EdgeInsets.only(bottom: 10.w, top: 10.w),
                          decoration: BoxDecoration(color: Color(0xffcacaca), borderRadius: BorderRadius.all(Radius.circular(2.r))),
                        ),
                      ),
                      content,
                      SizedBox(height: 20.w)
                    ],
                  ),
                ),
              );
            });
      },
    );
  }

  showEditor([Reply? val]) async {
    if (val != null) {
      ctrl.setReply(val);
    } else {
      ctrl.setReply(new Reply());
    }
    showModalBottomSheet<Map>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Editor(postId: ctrl.post.postId.toString());
      },
    );
  }

  Widget _buildReplyItem(Reply item, int index, ReplyListType type) {
    return ReplyItem(
      index: index,
      type: type,
      item: item,
      onThank: (e) => onThankReply(e),
      onMenu: (e) => showReplyMenuModal(val: e, type: type),
      onTap: (e) => showEditor(e),
    );
  }

  Widget clickWidget(Widget widget, onTap) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.fromLTRB(14.w, 6.w, 14.w, 6.w),
        child: widget,
      ),
      onTap: onTap,
    );
  }

  //收藏帖子
  onCollect() async {
    if (!bc.isLogin) {
      return Get.toNamed('/login');
    }
    bool isFavorite = ctrl.post.isFavorite;
    ctrl.post.isFavorite = !isFavorite;
    ctrl.post.collectCount = ctrl.post.isFavorite ? ctrl.post.collectCount + 1 : ctrl.post.collectCount - 1;
    ctrl.updateAndSave();

    var res = await Api.favoriteTopic(isFavorite, ctrl.post.postId);
    if (!res) {
      ctrl.post.isFavorite = !ctrl.post.isFavorite;
      ctrl.post.collectCount = ctrl.post.isFavorite ? ctrl.post.collectCount + 1 : ctrl.post.collectCount - 1;
      ctrl.updateAndSave();
      Get.snackbar('提示', '',
          colorText: Colors.white,
          duration: Duration(seconds: 5),
          messageText: Text(
            isFavorite ? '取消收藏失败' : '收藏失败',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          backgroundColor: Colors.redAccent);
    }
  }

  //感谢帖子
  onThankPost() async {
    if (!bc.isLogin) {
      return Get.toNamed('/login');
    }
    if (ctrl.post.member.username == bc.member.username) {
      Utils.toast(msg: '不能感谢自己发布的主题');
      return;
    }
    if (ctrl.post.isThanked) {
      Utils.toast(msg: '这个主题已经被感谢过了');
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('提示'),
        content: const Text('确认花费 10 个铜币向创建者发送感谢？'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: (() async {
              var res = await Api.thankTopic(ctrl.post.postId);
              if (res) {
                ctrl.post.isThanked = true;
                ctrl.post.thankCount += 1;
                ctrl.updateAndSave();
                Utils.toast(msg: '感谢成功');
                Get.back();
              }
            }),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  // 感谢回复 request
  void thankReply(Reply val) async {
    var index = ctrl.post.replyList.indexWhere((v) => v.replyId == val.replyId);
    ctrl.post.replyList[index].isThanked = true;
    ctrl.post.replyList[index].thankCount += 1;
    ctrl.rebuildList();

    var res = await Api.thankReply(val.replyId, ctrl.post.postId);
    if (!res) {
      ctrl.post.replyList[index].isThanked = false;
      ctrl.post.replyList[index].thankCount -= 1;
      ctrl.rebuildList();
      Get.snackbar('提示', '',
          colorText: Colors.white,
          duration: Duration(seconds: 5),
          messageText: Text(
            '感谢失败',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          backgroundColor: Colors.redAccent);
    }
  }

  //感谢回复
  onThankReply(Reply val) async {
    if (!bc.isLogin) {
      Get.toNamed('/login');
      return;
    }
    if (val.isThanked) {
      Utils.toast(msg: '这个回复已经被感谢过了');
      return;
    }
    if (val.username == bc.member.username) {
      Utils.toast(msg: '不能感谢自己');
      return;
    }

    if (bc.currentConfig.ignoreThankConfirm) {
      thankReply(val);
      return;
    }

    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('提示'),
        content: IntrinsicHeight(
          child: Column(
            children: [
              Text('确认花费 10 个铜币向 @${val.username} 的这条回复发送感谢？', style: TextStyle(fontSize: 16.sp)),
              SizedBox(height: 10.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('不再显示确认框'),
                  SizedBox(width: 10.w),
                  Builder(builder: (BuildContext builder) {
                    return TDSwitch(
                      isOn: bc.currentConfig.ignoreThankConfirm,
                      onChanged: (bool v) {
                        (context as Element).markNeedsBuild();
                        bc.currentConfig.ignoreThankConfirm = !bc.currentConfig.ignoreThankConfirm;
                        bc.saveConfig();
                        return true;
                      },
                    );
                  })
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '可在设置中恢复',
                    style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                  ),
                ],
              )
            ],
          ),
        ),
        actions: <Widget>[
          BaseButton(
            theme: TDButtonTheme.light,
            onTap: Get.back,
            text: '取消',
          ),
          BaseButton(
            onTap: () async {
              thankReply(val);
              Get.back();
            },
            text: '确认',
          ),
        ],
      ),
    );
  }

  jumpToIndexItem({int index = 0}) {
    ctrl.setShowFixedTitle(true);
    firstChildCtx = normalListCtx;
    // _scrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.ease);
    ctrl.observerController.animateTo(sliverContext: normalListCtx, index: index, duration: Duration(milliseconds: 300), curve: Curves.ease, offset: (v) => 46.w);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: GetBuilder<PostDetailController>(
          tag: postId,
          builder: (_) {
            return Column(
              children: [
                PostNavbar(postId: postId, onMenu: showPostMenuModal),
                // _buildEditor(),
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
                            controller: ctrl.scrollController,
                            slivers: [
                              //标题和内容
                              SliverLayoutBuilder(
                                builder: (context, _) {
                                  if (headerCtx != context) headerCtx = context;
                                  return PostHeader(postId: postId);
                                },
                              ),
                              PostSpace(),
                              if (ctrl.loading) ...[
                                //普通回复
                                //header
                                PostListHeader(left: ctrl.post.replyCount.toString() + '条回复', right: Text(Utils.formatCommentDisplayType(bc.currentConfig.commentDisplayType))),
                                PostListLoading()
                              ] else ...[
                                //高赞回复
                                if (ctrl.config.showTopReply && ctrl.post.topReplyList.length != 0) ...[
                                  //header
                                  PostListHeader(left: ctrl.post.topReplyList.length.toString() + '条高赞回复'),
                                  //list
                                  SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      if (topListCtx != context) topListCtx = context;
                                      return Column(children: [_buildReplyItem(ctrl.post.topReplyList[index], index, ReplyListType.Hot), Const.lineWidget]);
                                    },
                                    childCount: ctrl.post.topReplyList.length,
                                  )),
                                  PostSpace(),
                                ],

                                //普通回复
                                //header
                                PostListHeader(
                                    left: ctrl.post.replyCount.toString() + '条回复',
                                    right: InkWell(
                                      onTap: showSortModal,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 5.w, bottom: 5.w),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(TDIcons.order_ascending, size: 16),
                                            SizedBox(width: 5),
                                            Text(Utils.formatCommentDisplayType(bc.currentConfig.commentDisplayType)),
                                          ],
                                        ),
                                      ),
                                    )),
                                //list
                                SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    if (normalListCtx != context) normalListCtx = context;
                                    // return ListTile(title: Text('1111$index'));
                                    return Column(children: [_buildReplyItem(ctrl.getReplyList()[index], index, ReplyListType.Normal), Const.lineWidget]);
                                  },
                                  childCount: ctrl.getReplyList().length,
                                )),
                                SliverToBoxAdapter(child: FooterTips()),
                              ]
                            ],
                          ),
                        ),
                        onRefresh: ctrl.getData)),
                PostToolbar(
                    onCollect: onCollect,
                    onThank: onThankPost,
                    onCommit: () {
                      if (firstChildCtx == null || firstChildCtx == headerCtx) {
                        debugPrint('当前是 - headerCtx');
                        jumpToIndexItem(index: 0);
                      } else {
                        debugPrint('当前是 - listCtx');
                        ctrl.setShowFixedTitle(false);
                        ctrl.scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.ease);
                        firstChildCtx = headerCtx;
                      }
                    },
                    onEdit: showEditor,
                    postId: postId)
              ],
            );
          }),
    );
  }
}
