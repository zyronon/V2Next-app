import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:v2ex/components/footer.dart';
import 'package:v2ex/components/reply_item.dart';
import 'package:v2ex/pages/post_detail/components/reply_new.dart';
import 'package:v2ex/model/BaseController.dart';
import 'package:v2ex/model/Post2.dart';
import 'package:v2ex/pages/post_detail/components/post_navbar.dart';
import 'package:v2ex/pages/post_detail/components/post_space.dart';
import 'package:v2ex/pages/post_detail/components/post_toolbar.dart';
import 'package:v2ex/utils/ConstVal.dart';
import 'package:v2ex/utils/api.dart';
import 'package:v2ex/utils/storage.dart';
import 'package:v2ex/utils/utils.dart';

import 'components/post_header.dart';
import 'components/post_list_header.dart';
import 'components/post_list_loading.dart';
import 'controller.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({super.key});

  @override
  State<PostDetailPage> createState() => PostDetailPageState();
}

class PostDetailPageState extends State<PostDetailPage> {
  late String id = Get.arguments.id;
  late PostDetailController ctrl;

  BaseController bc = BaseController.to;
  TextEditingController _replyCtrl = new TextEditingController();
  BuildContext? headerCtx;
  BuildContext? normalListCtx; //正常回复
  BuildContext? topListCtx; //高赞回复
  BuildContext? firstChildCtx;
  bool reverseSort = false; // 倒序

  @override
  void initState() {
    super.initState();
    ctrl = Get.put(PostDetailController(), tag: id);
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<PostDetailController>(tag: id);
  }

  submit() {
    print("test");
    // controller.loadRequest(Uri.parse('https://v2ex.com'));
    // Navigator.pushNamed(context, 'Home');
  }

  Widget _buildReplyMenuOptionWrapper({required Widget child, bool disabled = false}) {
    return Opacity(
        opacity: disabled ? 0.4 : 1,
        child: Container(
          margin: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: child,
        ));
  }

  //回复菜单操作项
  Widget _buildReplyMenuOption(String text, IconData icon, GestureTapCallback onTap) {
    return InkWell(
      child: Padding(
          padding: EdgeInsets.all(14.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20.sp,
                color: Colors.black,
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
                  child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return ReplyItem(
                    item: list[index],
                    onThank: null,
                    onMenu: null,
                    type: 0,
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
              )),
              SizedBox(height: 20.w)
            ],
          ),
        );
        return Column(
          children: list
              .map((v) => ReplyItem(
                    item: v,
                    onThank: null,
                    onMenu: null,
                    type: 1,
                    index: 0,
                    onTap: (i) {
                      int rIndex = ctrl.post.replyList.indexWhere((j) => j.id == i.id);
                      if (rIndex > -1) {
                        jumpToIndexItem(index: rIndex);
                      }
                    },
                  ))
              .toList(),
        );
      },
    );
  }

  //显示回复菜单弹窗
  onShowItemMenuModalClick(Reply val) {
    ctrl.setReply(val);
    modalWrap(
        content: Column(children: [
      _buildReplyMenuOptionWrapper(
          child: Column(children: [
        _buildReplyMenuOption('回复', TDIcons.chat, () {
          if (!bc.isLogin) {
            Get.toNamed('/login');
            return;
          }
          Get.back();
          onShowReplyModalClick(val);
        }),
        _buildLine(),
        _buildReplyMenuOption('感谢', TDIcons.heart, () {
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
          Get.back();
          onThankReplyClick(val);
        }),
      ])),
      _buildReplyMenuOptionWrapper(
          child: Column(children: [
            _buildReplyMenuOption('上下文', Icons.content_paste_search, () {
              print('val.replyUsers${val.replyUsers}');
              if (val.replyUsers.length != 0) {
                showRelationReplyListModal(val);
              }
            }),
          ]),
          disabled: val.replyUsers.length == 0),
      _buildReplyMenuOptionWrapper(
          child: Column(children: [
        _buildReplyMenuOption('复制', TDIcons.file_copy, () {
          Utils.copy(val.replyText);
        }),
        _buildLine(),
        _buildReplyMenuOption('忽略', TDIcons.browse_off, () {
          //TODO
          Utils.toast(msg: '未实现');
        }),
      ])),
    ]));
  }

  //TODO
  //显示帖子菜单弹窗
  showPostMenuModal() {
    modalWrap(
        content: Column(
      children: [
        _buildReplyMenuOptionWrapper(
            child: Column(children: [
          _buildReplyMenuOption('复制内容', TDIcons.file_copy, () {
            Utils.copy(ctrl.post.contentText);
          }),
          _buildLine(),
          _buildReplyMenuOption('复制链接', TDIcons.link, () {
            Utils.copy(Const.v2exHost + '/t/' + ctrl.post.id);
          }),
        ])),
        _buildReplyMenuOptionWrapper(
            child: Column(children: [
          _buildReplyMenuOption('忽略', TDIcons.browse_off, () {
            //TODO
            Utils.toast(msg: '未实现');
          }),
          _buildLine(),
          _buildReplyMenuOption('报告', TDIcons.info_circle, () {
            //TODO
            Utils.toast(msg: '未实现');
          }),
        ])),
        _buildReplyMenuOptionWrapper(
            child: Column(children: [
          _buildReplyMenuOption('浏览器打开', TDIcons.logo_chrome, () {
            Get.back();
            Utils.openBrowser(Const.v2exHost + '/t/' + ctrl.post.id);
          }),
          _buildLine(),
          _buildReplyMenuOption('调整排版', TDIcons.view_module, () async {
            Get.back();
            await Get.toNamed('/layout');
            ctrl.update();
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
      },
    );
  }

  List<Reply> replyMemberList = [];

  //TODO 需要处理未登录逻辑
  onShowReplyModalClick([Reply? val]) async {
    if (val != null) {
      ctrl.setReply(val);
    } else {
      ctrl.setReply(new Reply());
    }
    List<Reply> replyList = List.from(ctrl.post.replyList);
    replyList.retainWhere((i) => i.isChoose);
    setState(() {
      replyMemberList = replyList;
    });
    showModalBottomSheet<Map>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ReplyNew(
          replyMemberList: replyMemberList,
          topicId: ctrl.post.id,
          replyList: ctrl.post.replyList,
        );
      },
    );
  }

  Widget _buildReplyItem(Reply item, int index, int type) {
    return ReplyItem(
      index: index,
      type: type,
      item: item,
      onThank: (e) => onThankReplyClick(e),
      onMenu: (e) => onShowItemMenuModalClick(e),
      onTap: (e) => onShowReplyModalClick(e),
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

  onReply() async {
    var res = await Api.onSubmitReplyTopic(ctrl.post.id, _replyCtrl.text);
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

  //收藏帖子
  onCollect() async {
    if (!bc.isLogin) {
      return Get.toNamed('/login');
    }
    bool isFavorite = ctrl.post.isFavorite;
    ctrl.post.isFavorite = !isFavorite;
    ctrl.post.collectCount = ctrl.post.isFavorite ? ctrl.post.collectCount + 1 : ctrl.post.collectCount - 1;
    ctrl.update();

    var res = await Api.favoriteTopic(isFavorite, ctrl.post.id);
    if (!res) {
      ctrl.post.isFavorite = !ctrl.post.isFavorite;
      ctrl.post.collectCount = ctrl.post.isFavorite ? ctrl.post.collectCount + 1 : ctrl.post.collectCount - 1;
      ctrl.update();
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
  onThankPostClick() async {
    if (!bc.isLogin) {
      return Get.toNamed('/login');
    }
    // if (ctrl.post.member.username == bc.member.username) {
    //   Utils.toast('不能感谢自己');
    //   return;
    // }
    if (ctrl.post.isThanked) {
      Utils.toast(msg: '这个主题已经被感谢过了');
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('提示'),
        content: const Text('确认向本主题创建者表示感谢吗？'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: (() async {
              var res = await Api.thankTopic(ctrl.post.id);
              if (res) {
                ctrl.post.isThanked = true;
                ctrl.post.thankCount += 1;
                ctrl.update();
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
  void thankReply(Reply val) async {}

  //感谢回复
  onThankReplyClick(Reply val) async {
    if (!bc.isLogin) {
      return Get.toNamed('/login');
    }
    if (val.isThanked) {
      Utils.toast(msg: '这个回复已经被感谢过了');
      return;
    }
    if (val.username == bc.member.username) {
      Utils.toast(msg: '不能感谢自己');
      return;
    }
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('提示'),
        content: const Text('确认向该用户表示感谢吗？，将花费10个铜板💰'),
        actions: <Widget>[
          TextButton(
            onPressed: Get.back,
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              var res = await Api.thankReply(val.id, ctrl.post.id);
              if (res) {
                var index = ctrl.post.replyList.indexWhere((v) => v.id == val.id);
                ctrl.post.replyList[index].isThanked = true;
                ctrl.post.replyList[index].thankCount += 1;
                ctrl.rebuildList();
                Get.back();
              }
            },
            child: const Text('确认'),
          ),
        ],
      ),
    );
  }

  Future<void> onRefresh() async {
    // print(ctrl.post.replyList[2].replyFloor.toString());
    // print(ctrl.post.replyList[2].replyContent.toString());
    // print(ctrl.post.replyList[2].hideCallUserReplyContent.toString());
    // print(ctrl.post.replyList[2].replyUsers.toString());
    // ctrl.rebuildList();
    ctrl.getData();
    return;
  }

  jumpToIndexItem({int index = 0}) {
    ctrl.setShowFixedTitle(true);
    firstChildCtx = normalListCtx;
    // _scrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.ease);
    ctrl.observerController.animateTo(
      sliverContext: normalListCtx,
      index: index,
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
      // offset: (v)=>24.w
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
      body: GetBuilder<PostDetailController>(
          tag: id,
          builder: (_) {
            return Column(
              children: [
                PostNavbar(id: id, onMenu: showPostMenuModal),
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
                                  return PostHeader(id: id);
                                },
                              ),
                              PostSpace(),
                              if (ctrl.loading) ...[
                                //普通回复
                                //header
                                PostListHeader(left: ctrl.post.replyCount.toString() + '条回复', right: '楼中楼'),
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
                                      return Column(children: [_buildReplyItem(ctrl.post.topReplyList[index], index, 0), Const.lineWidget]);
                                    },
                                    childCount: ctrl.post.topReplyList.length,
                                  )),
                                  PostSpace(),
                                ],

                                //普通回复
                                //header
                                PostListHeader(left: ctrl.post.replyCount.toString() + '条回复', right: '楼中楼'),
                                //list
                                SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    if (normalListCtx != context) normalListCtx = context;
                                    // return ListTile(title: Text('1111$index'));
                                    return Column(children: [_buildReplyItem(ctrl.getReplyList()[index], index, 1), Const.lineWidget]);
                                  },
                                  childCount: ctrl.getReplyList().length,
                                )),
                                SliverToBoxAdapter(child: FooterTips()),
                              ]
                            ],
                          ),
                        ),
                        onRefresh: onRefresh)),
                PostToolbar(
                    onCollect: onCollect,
                    onThank: onThankPostClick,
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
                    onEdit: onShowReplyModalClick,
                    id: id)
              ],
            );
          }),
    );
  }
}
