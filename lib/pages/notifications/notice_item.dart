import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:v2ex/components/base_avatar.dart';
import 'package:v2ex/components/base_html.dart';
import 'package:v2ex/model/model.dart';
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
      child: Dismissible(
        movementDuration: const Duration(milliseconds: 300),
        background: Container(
            color: Colors.redAccent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [Text('删除', style: TextStyle(color: Colors.white, fontSize: 18.sp)), SizedBox(width: 20.w)],
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
              Get.toNamed('/post_detail', arguments: Post(postId: widget.noticeItem.postId));
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
                  diameter: 30.w,
                  user: widget.noticeItem.member,
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.noticeItem.member.username),
                    SizedBox(height: 1.5.w),
                    if (widget.noticeItem.replyDate.isNotEmpty)
                      Text(widget.noticeItem.replyDate,
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
        if (widget.noticeItem.noticeType == NoticeType.thanks) Text('感谢：'),
        if (widget.noticeItem.noticeType == NoticeType.favTopic) Text('收藏：'),
        SizedBox(height: 6.w),
        if (widget.noticeItem.replyContentHtml.isNotEmpty)
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
                  child: BaseHtml(html: widget.noticeItem.replyContentHtml),
                  margin: EdgeInsets.only(left: 10.w),
                ),
              )
            ],
          ),
        SizedBox(height: 6.w),
        if (widget.noticeItem.postTitle.isNotEmpty)
          Container(
            alignment: Alignment.centerLeft,
            // decoration: BoxDecoration(
            //   color: Colors.grey[200],
            //   borderRadius: BorderRadius.circular(5.r),
            // ),
            // margin: EdgeInsets.only(top: 2.w, bottom: 10.w, right: 10.w),
            // padding: EdgeInsets.all(10.w),
            child: Text(
              widget.noticeItem.postTitle,
              style: TextStyle(color: Color(0xff2395f1), decoration: TextDecoration.underline, decorationColor: Color(0xff2395f1)),
            ),
          ),
      ],
    );
  }
}