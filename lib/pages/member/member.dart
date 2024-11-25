import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:v2next/components/base_avatar.dart';
import 'package:v2next/components/base_divider.dart';
import 'package:v2next/components/base_html.dart';
import 'package:v2next/components/loading_item.dart';
import 'package:v2next/components/post_item.dart';
import 'package:v2next/model/base_controller.dart';
import 'package:v2next/model/model.dart';
import 'package:v2next/pages/notifications/notice_item.dart';
import 'package:v2next/pages/post_detail/components/user_tags.dart';
import 'package:v2next/utils/const_val.dart';
import 'package:v2next/utils/utils.dart';

import 'controller.dart';

class MemberPage extends StatefulWidget {
  const MemberPage({Key? key}) : super(key: key);

  @override
  State<MemberPage> createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  late Member member = Get.arguments;
  BaseController bc = Get.find();
  final GlobalKey signStatusKey = GlobalKey();
  final GlobalKey followBtnKey = GlobalKey();
  final GlobalKey blockBtnKey = GlobalKey();

  @override
  void dispose() {
    super.dispose();
    print('dispose');
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MemberController>(
        init: MemberController(),
        tag: member.username,
        builder: (ctrl) {
          return Scaffold(
              appBar: AppBar(
                actions: [
                  if (!ctrl.isOwner) ...[
                    TextButton(
                      onPressed: () => ctrl.onFollowMemeber(context),
                      child: Text(ctrl.info.isFollow ? '取消关注' : '关注'),
                    ),
                    TextButton(
                        onPressed: () => ctrl.onBlockMember(context),
                        child: Text(
                          ctrl.info.isBlock ? '取消屏蔽' : '屏蔽',
                          style: TextStyle(color: Theme.of(context).colorScheme.error),
                        )),
                  ]
                ],
              ),
              body: _buildView(ctrl));
        });
  }

  Widget _buildView(MemberController ctrl) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
              padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      BaseAvatar(src: ctrl.info.mbAvatar.isNotEmpty ? ctrl.info.mbAvatar : ctrl.memberAvatar, diameter: 70.r),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectableText(
                              ctrl.memberId,
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 24.sp,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(ctrl.info.mbSort),
                            Text(ctrl.info.mbCreatedTime),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (bc.currentConfig.openTag) UserTags(username: member.username),
                  if (ctrl.info.socialList.isNotEmpty) ...[
                    SizedBox(height: 10.w),
                    Wrap(
                      spacing: 10,
                      runSpacing: 6,
                      direction: Axis.horizontal,
                      children: nodesChildList(ctrl.info.socialList),
                    ),
                  ],
                  if (ctrl.info.mbSign.isNotEmpty) ...[
                    SizedBox(height: 10.w),
                    BaseHtml(html: ctrl.info.mbSign),
                  ],
                ],
              )),
        ),
        SliverToBoxAdapter(child: BaseDivider()),
        titleLine('最近发布', 'topic', ctrl, false),
        if (ctrl.loading) ...[
          SliverToBoxAdapter(
              child: Column(children: [
            LoadingItem(),
            BaseDivider(height: 1),
            LoadingItem(),
          ]))
        ] else ...[
          if (ctrl.info.isEmptyTopic) ...[
            SliverToBoxAdapter(
              child: Container(
                height: 80,
                alignment: Alignment.center,
                child: Text(
                  '没内容',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            )
          ] else if (ctrl.info.isShowTopic) ...[
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              Post item = ctrl.info.postList[index];
              return PostItem(item: item, tab: NodeItem(type: TabType.profile), space: false);
            }, childCount: ctrl.info.postList.length)),
            titleLine('» ${member.username} 创建的更多主题', 'topic', ctrl, true),
          ] else ...[
            SliverToBoxAdapter(
              child: Container(
                height: 80,
                // padding: const EdgeInsets.only(top: 20),
                alignment: Alignment.center,
                child: Text(
                  '根据 ${ctrl.memberId} 的设置，主题列表被隐藏',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            )
          ],
        ],
        SliverToBoxAdapter(child: BaseDivider()),
        titleLine('最近回复', 'reply', ctrl, false),
        if (ctrl.loading) ...[
          SliverToBoxAdapter(
              child: Column(children: [
            LoadingItem(),
            BaseDivider(height: 1),
            LoadingItem(),
          ]))
        ] else ...[
          if (ctrl.info.isEmptyReply) ...[
            SliverToBoxAdapter(
              child: Container(
                height: 80,
                alignment: Alignment.center,
                child: Text(
                  '没内容',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            )
          ] else if (ctrl.info.isShowReply) ...[
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              var v = ctrl.info.replyList[index];
              return Column(
                children: [NoticeItem(noticeItem: v, isNotice: false, onDeleteNotice: () async {}), Container(height: 1.w, color: Const.line2)],
              );
            }, childCount: ctrl.info.replyList.length)),
            titleLine('» ${member.username} 创建的更多回复', 'reply', ctrl, true),
          ] else ...[
            SliverToBoxAdapter(
              child: Container(
                height: 80,
                // padding: const EdgeInsets.only(top: 20),
                alignment: Alignment.center,
                child: Text(
                  '根据 ${ctrl.memberId} 的设置，回复列表被隐藏',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            )
          ],
        ],
        SliverToBoxAdapter(
          child: SizedBox(
            height: 100,
            child: BaseDivider(),
          ),
        )
      ],
    );
  }

  List<Widget> nodesChildList(child) {
    List<Widget>? list = [];
    for (var i in child) {
      list.add(InkWell(
        child: Container(
          padding: EdgeInsets.fromLTRB(10.w, 5.w, 10.w, 5.w),
          decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(100)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/social/${i.type}.png', width: 25, height: 25),
              const SizedBox(width: 2),
              Flexible(
                child: Text(
                  i.name,
                  style: TextStyle(color: Colors.grey[700], fontSize: 16.sp),
                ),
              ),
            ],
          ),
        ),
        onTap: () async {
          await Utils.openBrowser(i.href);
        },
      ));
    }
    return list;
  }

  Widget titleLine(title, type, ctrl, showArrow) {
    // MemberController ctrl = Get.find(tag: member.username);
    return SliverToBoxAdapter(
      child: Container(
        height: 46.w,
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Const.line)),
        ),
        child: InkWell(
          onTap: () {
            if (!showArrow) return;
            if (type == 'reply') {
              Get.toNamed('/member_reply_list', arguments: member.username);
            }
            if (type == 'topic') {
              Get.toNamed('/member_post_list', arguments: member.username);
            }
          },
          child: Ink(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(fontSize: showArrow ? 14.sp : 16.sp)),
                if (showArrow)
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 16.w,
                    color: Colors.grey,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
