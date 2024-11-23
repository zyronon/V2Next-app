import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:v2next/pages/post_detail/post_detail.dart';
import 'package:v2next/utils/const_val.dart';

import '../controller.dart';

class PostToolbar extends StatelessWidget {
  final GestureTapCallback onCollect;
  final GestureTapCallback onThank;
  final GestureTapCallback onCommit;
  final GestureTapCallback onEdit;
  final String postId;

  PostToolbar({
    required this.onCollect,
    required this.onThank,
    required this.onCommit,
    required this.onEdit,
    required this.postId,
  });

  Widget clickWidget(Widget widget, onTap) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.fromLTRB(14.w, 6.w, 14.w, 6.w),
        child: widget,
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostDetailController>(
        tag: postId,
        builder: (ctrl) {
          return Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(14.w, 0, 6.w, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Const.line)),
                boxShadow: [Const.boxShadowTop],
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
                      onTap: onEdit,
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
                      ),
                      onCollect),
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
                      ),
                      onThank),
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
                      ),
                      onCommit),
                ],
              ));
        });
  }
}
