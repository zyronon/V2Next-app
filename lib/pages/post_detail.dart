import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:v2ex/components/BaseAvatar.dart';
import 'package:v2ex/components/BaseHtmlWidget.dart';
import 'package:v2ex/components/footer.dart';
import 'package:v2ex/components/reply_item.dart';
import 'package:v2ex/components/reply_new.dart';
import 'package:v2ex/model/BaseController.dart';
import 'package:v2ex/model/Post2.dart';
import 'package:v2ex/utils/ConstVal.dart';
import 'package:v2ex/utils/api.dart';
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
    return post.nestedReplies;
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
    _scrollController.dispose();
  }
}

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({super.key});

  @override
  State<PostDetailPage> createState() => PostDetailPageState();
}

class PostDetailPageState extends State<PostDetailPage> {
  late String id = Get.arguments.id;
  late PostDetailController ctrl ;

  BaseController bc = Get.find<BaseController>();
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

  Widget optionItem(String text, IconData icon, [GestureTapCallback? onTap]) {
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
        onTap: onTap);
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
        Row(children: [SizedBox(width: 40.w), Expanded(child: Divider(color: Colors.grey[300], height: 1.w))]),
        _buildReplyMenuOption('感谢', TDIcons.heart, () {
          if (!bc.isLogin) {
            Get.toNamed('/login');
            return;
          }
          if (val.isThanked) {
            Utils.toast('这个回复已经被感谢过了');
            return;
          }
          if (val.username == bc.member.username) {
            Utils.toast('不能感谢自己');
            return;
          }
          Get.back();
          onThankReplyClick(val);
        }),
      ])),
      _buildReplyMenuOptionWrapper(
          child: Column(children: [
        _buildReplyMenuOption('上下文', Icons.content_paste_search, () {
          //TODO
          Utils.toast('未实现');
        }),
      ])),
      _buildReplyMenuOptionWrapper(
          child: Column(children: [
        _buildReplyMenuOption('复制', TDIcons.file_copy, () {
          Utils.copy(val.replyText);
        }),
        Row(children: [SizedBox(width: 40.w), Expanded(child: Divider(color: Colors.grey[300], height: 1.w))]),
        _buildReplyMenuOption('忽略', Icons.block, () {
          //TODO
          Utils.toast('未实现');
        }),
      ])),
      SizedBox(height: 20.w)
    ]));
  }

  //TODO
  //显示帖子菜单弹窗
  showPostMenuModal() {
    modalWrap(
        content: Column(
      children: [
        Row(children: [
          optionItem('保存', TDIcons.books, () {
            ctrl.config.showTopReply = !ctrl.config.showTopReply;
            ctrl.update();
            Get.back();
          }),
          optionItem('深色模式', Icons.bookmark_border),
          optionItem('报告', TDIcons.info_circle),
          optionItem('忽略', TDIcons.browse_off),
        ]),
        Row(children: [
          optionItem('稍后阅读', TDIcons.books),
          optionItem('复制内容', TDIcons.file_copy, () {
            Utils.copy(ctrl.post.contentText);
          }),
          optionItem('复制链接', TDIcons.link, () {
            Utils.copy(Const.v2ex + '/t/' + ctrl.post.id);
          }),
          optionItem('浏览器打开', TDIcons.logo_chrome, () {
            Get.back();
            Utils.openBrowser(Const.v2ex + '/t/' + ctrl.post.id);
          }),
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
                    margin: EdgeInsets.only(bottom: 20.w, top: 20.w),
                    decoration: BoxDecoration(color: Color(0xffcacaca), borderRadius: BorderRadius.all(Radius.circular(2.r))),
                  ),
                ),
                content
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
      // _replyCtrl.text = '#${val.username} #${val.floor} ';
      // await modalWrap(  content: _buildEditor(), color: Colors.white);
    } else {
      ctrl.setReply(new Reply());
      // await modalWrap(  content: _buildEditor());
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
    return;
    if (val != null) {
      ctrl.setReply(val);
      _replyCtrl.text = '#${val.username} #${val.floor} ';
      await modalWrap(content: _buildEditor(), color: Colors.white);
    } else {
      ctrl.setReply(new Reply());
      await modalWrap(content: _buildEditor());
    }
    _replyCtrl.text = '';
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

  Widget _buildIcon(
    IconData icon,
  ) {
    return Icon(
      icon,
      size: 24.sp,
      color: Colors.black54,
    );
  }

  Widget _buildClickIcon(IconData icon, [GestureTapCallback? onTap]) {
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
        padding: EdgeInsets.fromLTRB(14.w, 6.w, 14.w, 6.w),
        child: widget,
      ),
      onTap: onTap,
    );
  }

  //标题
  Widget _buildPostTitle() {
    return Padding(
      padding: EdgeInsets.only(top: 6.w, bottom: 6.w),
      child: SelectableText(
        ctrl.post?.title ?? '',
        textAlign: TextAlign.left,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
      ),
    );
  }

  onReply() async {
    var res = await TopicWebApi.onSubmitReplyTopic(ctrl.post.id, _replyCtrl.text);
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

  showMemberList() {
    PostDetailController pdc = Get.find();
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  ...pdc.post.allReplyUsers.map((u) {
                    return Text(u);
                  })
                ],
              )),
        );
      },
    );
  }

  Widget _buildEditor() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 10.w),
      child: Column(
        children: [
          Container(
            child: TextField(
              controller: _replyCtrl,
              maxLines: 6,
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
          Padding(
            padding: EdgeInsets.only(left: 0.w, right: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  _buildClickIcon(Icons.sentiment_satisfied_alt, () {}),
                  _buildClickIcon(Icons.alternate_email, showMemberList),
                  _buildClickIcon(Icons.add_photo_alternate),
                  _buildClickIcon(Icons.format_quote, () {
                    _replyCtrl.text = _replyCtrl.text + '\n---\n${ctrl.reply.id.isEmpty ? ctrl.post.contentText : ctrl.reply.replyText}\n---';
                  }),
                ]),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(14.w, 6.w, 14.w, 6.w),
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
            ),
          )
        ],
      ),
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
    ctrl.update();

    var res = await TopicWebApi.favoriteTopic(isFavorite, ctrl.post.id);
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
      Utils.toast('这个主题已经被感谢过了');
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
              var res = await TopicWebApi.thankTopic(ctrl.post.id);
              if (res) {
                ctrl.post.isThanked = true;
                ctrl.post.thankCount += 1;
                ctrl.update();
                Utils.toast('感谢成功');
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
      Utils.toast('这个回复已经被感谢过了');
      return;
    }
    if (val.username == bc.member.username) {
      Utils.toast('不能感谢自己');
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
              var res = await DioRequestWeb.thankReply(val.id, ctrl.post.id);
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

  Widget _buildSpace() {
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
          border: Border(bottom: BorderSide(color: Const.line)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2), // 阴影颜色
              spreadRadius: 1, // 扩散半径
              blurRadius: 10, // 模糊半径
              offset: Offset(0, 2), // 阴影偏移量 (x, y)
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  _buildClickIcon(Icons.arrow_back, () {
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
            _buildClickIcon(Icons.more_vert, showPostMenuModal)
          ],
        ));
  }

  Widget _buildToolbar() {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(14.w, 0.w, 6.w, 4.w),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Const.line)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2), // 阴影颜色
              spreadRadius: 1, // 扩散半径
              blurRadius: 10, // 模糊半径
              offset: Offset(0, -2), // 阴影偏移量 (x, y)
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: InkWell(
                child: Container(
                  child: Text(
                    '说点什么...',
                    style: TextStyle(color: Colors.black54),
                  ),
                  decoration: BoxDecoration(border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(4.r)),
                  padding: EdgeInsets.all(6.w),
                ),
                onTap: () {
                  onShowReplyModalClick();
                },
              ),
            ),
            SizedBox(width: 6.w),
            clickWidget(
                Column(
                  children: [
                    Icon(
                      ctrl.post.isFavorite ? TDIcons.star_filled : TDIcons.star,
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
                      ctrl.post.isThanked ? TDIcons.heart_filled : TDIcons.heart,
                      size: 24.sp,
                      color: ctrl.post.isThanked ? Colors.red : Colors.grey,
                    ),
                    Text(
                      ctrl.post.thankCount.toString(),
                      style: TextStyle(fontSize: 10.sp, color: ctrl.post.isThanked ? Colors.red : Colors.grey),
                    )
                  ],
                ), () {
              onThankPostClick();
            }),
            clickWidget(
                Column(
                  children: [
                    Icon(
                      TDIcons.chat,
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
      body: GetBuilder<PostDetailController>(
          tag: id,
          builder: (_) {
            return Column(
              children: [
                _buildNavbar(),
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
                                                              ctrl.post.member.username == 'default' ? '' : ctrl.post.member.username,
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
                                              if (ctrl.post.node.cnName.isNotEmpty)
                                                InkWell(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.black12,
                                                      borderRadius: BorderRadius.circular(3.0), //3像素圆角
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                                                      child: Text(
                                                        ctrl.post.node.cnName,
                                                        style: TextStyle(color: Colors.black, fontSize: 12.sp),
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    Get.toNamed('/node', arguments: ctrl.post.node);
                                                  },
                                                )
                                            ],
                                          ),
                                          _buildPostTitle(),
                                          (ctrl.loading && ctrl.post.contentRendered.isEmpty)
                                              ? Skeletonizer.zone(
                                                  child: Padding(padding: EdgeInsets.only(top: 6.w), child: Bone.multiText(lines: 7, style: TextStyle(height: 1.6))),
                                                )
                                              : BaseHtmlWidget(html: ctrl.post.contentRendered),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              _buildSpace(),

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
                                  _buildSpace(),
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
                                    return Column(children: [_buildReplyItem(ctrl.getReplyList()[index], index, 1), _buildDivider()]);
                                  },
                                  childCount: ctrl.getReplyList().length,
                                )),
                                SliverToBoxAdapter(child: FooterTips()),
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
