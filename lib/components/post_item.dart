import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:v2ex/components/base_avatar.dart';
import 'package:v2ex/components/base_divider.dart';
import 'package:v2ex/model/BaseController.dart';

import 'package:v2ex/model/model.dart';

class PostItem extends StatelessWidget {
  Post item;
  NodeItem tab;

  PostItem({required this.item, required this.tab});

  goPostDetail() {
    Get.toNamed('/post_detail', arguments: item);
  }

  @override
  Widget build(BuildContext context) {
    BaseController bc = BaseController.to;
    return InkWell(
      child: Column(children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                Row(children: [
                  if (tab.type != TabType.latest)
                    Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: BaseAvatar(src: item.member.avatar, diameter: bc.fontSize * 1.6, radius: bc.fontSize * 0.25),
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.member.username,
                        style: TextStyle(fontSize: bc.fontSize * 0.8, height: 1.2),
                      ),
                      SizedBox(height: 4.w),
                      Row(
                        children: [
                          if (item.isTop) ...[
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(3.r),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.w),
                                child: Text(
                                  '置顶',
                                  style: TextStyle(color: Colors.white, fontSize: 10.sp, height: 1.4),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                          ],
                          if (item.lastReplyDateAgo.isNotEmpty) ...[
                            Text(
                              item.lastReplyDateAgo,
                              style: TextStyle(fontSize: bc.fontSize * 0.7, height: 1.2, color: Colors.grey),
                            ),
                            SizedBox(width: 10.w),
                          ],
                          if (item.createDateAgo.isNotEmpty) ...[
                            Text(
                              item.createDateAgo + '发布',
                              style: TextStyle(fontSize: bc.fontSize * 0.7, height: 1.2, color: Colors.grey),
                            ),
                            SizedBox(width: 10.w),
                          ],
                          if (item.node.title.isNotEmpty)
                            // 这里的点击事件，最新index.xml获取到的数据没有url
                            InkWell(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Color(0xffe4e4e4),
                                  borderRadius: BorderRadius.circular(3.r),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.w),
                                  child: Text(
                                    item.node.title,
                                    style: TextStyle(color: Colors.black54, fontSize: bc.fontSize * 0.6, height: 1.4),
                                  ),
                                ),
                              ),
                              onTap: () {
                                if (item.node.name.isEmpty) {
                                  Get.snackbar('提示', '抱歉，由于源数据未提供节点url，所以无法跳转');
                                  return;
                                }
                                Get.toNamed('/node_detail', arguments: item.node);
                              },
                            ),
                        ],
                      )
                    ],
                  )
                ]),
                if (item.replyCount != 0)
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(4.r), //3像素圆角
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.w),
                      child: Text(
                        item.replyCount.toString(),
                        style: TextStyle(color: Colors.black, fontSize: bc.fontSize * 0.6, fontWeight: FontWeight.w500, height: 1.4),
                      ),
                    ),
                  ),
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              verticalDirection: VerticalDirection.down,
            ),
            InkWell(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 10,
                ),
                child: Text(
                  item.title,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: bc.layout.fontSize, height: bc.layout.lineHeight),
                ),
              ),
              onTap: goPostDetail,
            ),
            // InkWell(
            //   child: Padding(
            //     padding: EdgeInsets.only(
            //       top: 10,
            //     ),
            //     child: BaseHtmlWidget(html: item.contentHtml),
            //   ),
            //   onTap: () => {getPost(item)},
            // ),
          ]),
        ),
        BaseDivider()
      ]),
      onTap: goPostDetail,
    );
  }
}
