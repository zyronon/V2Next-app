import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:v2ex/components/base_avatar.dart';
import 'package:v2ex/components/base_html.dart';
import 'package:v2ex/model/BaseController.dart';

import '../controller.dart';

//标题和内容
class PostHeader extends StatelessWidget {
  final String postId;

  PostHeader({required this.postId});

  @override
  Widget build(BuildContext context) {
    BaseController bc = BaseController.to;
    return GetBuilder<PostDetailController>(
        tag: postId,
        builder: (ctrl) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        verticalDirection: VerticalDirection.down,
                        children: [
                          BaseAvatar(src: ctrl.post.member.avatar, diameter: bc.fontSize * 1.6, radius: bc.fontSize * 0.25),
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //用户名
                              Padding(
                                padding: EdgeInsets.only(left: 10.w),
                                child: SelectableText(
                                  ctrl.post.member.username == 'default' ? '' : ctrl.post.member.username,
                                  style: TextStyle(fontSize: bc.fontSize * 0.8, height: 1.2, fontWeight: FontWeight.bold, color: Colors.black54),
                                ),
                              ),
                              //时间、点击量
                              Padding(
                                padding: EdgeInsets.only(left: 10.w),
                                child: Text(
                                  ctrl.post.createDateAgo + '   ' + ctrl.post.clickCount.toString() + '次点击',
                                  style: TextStyle(fontSize: bc.fontSize * 0.7, height: 1.2, color: Colors.grey),
                                ),
                              ),
                            ],
                          ))
                        ],
                      )),
                      if (ctrl.post.node.title.isNotEmpty)
                        InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(3.0), //3像素圆角
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                              child: Text(
                                ctrl.post.node.title,
                                style: TextStyle(color: Colors.black, fontSize: bc.fontSize * 0.8),
                              ),
                            ),
                          ),
                          onTap: () {
                            Get.toNamed('/node_detail', arguments: ctrl.post.node);
                          },
                        )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 6.w, bottom: 6.w),
                    child: SelectableText(
                      ctrl.post.title,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: bc.layout.fontSize * 1.2, height: bc.layout.lineHeight, fontWeight: FontWeight.bold),
                    ),
                  ),
                  (ctrl.loading && ctrl.post.contentRendered.isEmpty)
                      ? Skeletonizer.zone(
                          child: Padding(padding: EdgeInsets.only(top: 6.w), child: Bone.multiText(lines: 7, style: TextStyle(height: 1.6))),
                        )
                      : BaseHtml(html: ctrl.post.contentRendered),
                ],
              ),
            ),
          );
        });
  }
}
