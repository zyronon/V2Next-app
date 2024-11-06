import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:v2ex/components/BaseAvatar.dart';
import 'package:v2ex/components/BaseHtmlWidget.dart';
import 'package:v2ex/model/Post2.dart';
import 'package:v2ex/utils/const_val.dart';

// TODO 样式
class NoticeItem extends StatefulWidget {
  final MemberNoticeItem noticeItem;
  final Function? onDeleteNotice;

  const NoticeItem({required this.noticeItem, this.onDeleteNotice, Key? key}) : super(key: key);

  @override
  State<NoticeItem> createState() => _NoticeItemState();
}

class _NoticeItemState extends State<NoticeItem> {
  @override
  void initState() {
    super.initState();
  }

  void doNothing(BuildContext context) {
    print(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 0, right: 12, bottom: 7, left: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.hardEdge,
      child: Dismissible(
        movementDuration: const Duration(milliseconds: 300),
        background: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.clear_all_rounded), SizedBox(width: 6), Text('删除')],
            )),
        direction: DismissDirection.endToStart,
        key: ValueKey<String>(widget.noticeItem.delIdOne),
        onDismissed: (DismissDirection direction) {
          widget.onDeleteNotice?.call();
        },
        child: Material(
          color: Theme.of(context).colorScheme.onInverseSurface,
          child: InkWell(
            onTap: () {
              // String floor = widget.noticeItem.topicHref.split('#reply')[1];
              // NoticeType noticeType = widget.noticeItem.noticeType;
              // Map<String, String> parameters = {};
              // if (noticeType == NoticeType.reply || noticeType == NoticeType.thanksReply) {
              //   回复 or 感谢回复
              // parameters = {'source': 'notice', 'floor': floor};
              // }
              Get.toNamed('/post-detail', arguments: Post2(id: widget.noticeItem.topicId));
            },
            child: Ink(
              padding: const EdgeInsets.fromLTRB(15, 15, 5, 15),
              child: content(),
            ),
          ),
        ),
      ),
    );
  }

  Widget content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                BaseAvatar(
                    src: widget.noticeItem.memberAvatar,
                    diameter: 30.w,
                    onTap: () => Get.toNamed('/member', parameters: {
                          'id': widget.noticeItem.memberId,
                        })),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.noticeItem.memberId),
                    SizedBox(height: 1.5.w),
                    if (widget.noticeItem.replyTime.isNotEmpty)
                      Text(widget.noticeItem.replyTime,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey,
                          )),
                  ],
                )
              ],
            ),
          ],
        ),
        SizedBox(height: 6.w),
        if (widget.noticeItem.noticeType == NoticeType.reply) Text('回复：'),
        if (widget.noticeItem.noticeType == NoticeType.thanksTopic) Text('感谢：'),
        if (widget.noticeItem.noticeType == NoticeType.thanksReply) Text('感谢：'),
        if (widget.noticeItem.noticeType == NoticeType.favTopic) Text('收藏：'),
        SizedBox(height: 6.w),
        if (widget.noticeItem.replyContentHtml != null)
          Stack(
            children: [
              Positioned.fill(
                child: Container(color: Colors.grey[100]),
              ),
              Positioned.fill(
                child: Row(
                  children: [Container(width: 3.w, color: Colors.grey[300])],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Container(
                  padding: EdgeInsets.only(top: Const.padding, bottom: Const.padding, right: Const.padding),
                  child: BaseHtmlWidget(html: widget.noticeItem.replyContentHtml),
                  margin: EdgeInsets.only(left: 10.w),
                ),
              )
            ],
          ),
        SizedBox(height: 6.w),
        if (widget.noticeItem.topicTitle.isNotEmpty)
          Container(
            alignment: Alignment.centerLeft,
            // decoration: BoxDecoration(
            //   color: Colors.grey[200],
            //   borderRadius: BorderRadius.circular(5.r),
            // ),
            // margin: EdgeInsets.only(top: 2.w, bottom: 10.w, right: 10.w),
            // padding: EdgeInsets.all(10.w),
            child: Text(
              widget.noticeItem.topicTitle,
              style: TextStyle(color: Color(0xff2395f1), decoration: TextDecoration.underline, decorationColor: Color(0xff2395f1)),
            ),
          ),
      ],
    );
  }
}
