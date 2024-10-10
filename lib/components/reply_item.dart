import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:v2ex/components/user_tag.dart';
import 'package:v2ex/model/Post2.dart';

import 'BaseAvatar.dart';

class ReplyItem extends StatelessWidget {
  final Reply item;
  final Function onThank;
  final Function onMenu;
  final Function onTap;
  final int type; //0为高赞回复，1为普通回复；高赞回复需要显示出@用户和楼层
  final int index;

  const ReplyItem({super.key, required this.item, required this.onThank, required this.onMenu, required this.type, required this.index, required this.onTap});

  getPadding() {
    if (item.level == 0 || type == 0) {
      return EdgeInsets.fromLTRB(10.w, 8.w, 8.w, 8.w);
    }
    return EdgeInsets.only(top: index > 0 ? 6.w : 0.w);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: getPadding(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          //头像、名字
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    BaseAvatar(src: item.avatar, diameter: 26.w, radius: 4.w),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            SelectableText(
                              item.username,
                              style: TextStyle(fontSize: 13.sp, height: 1.2, fontWeight: FontWeight.bold, color: Colors.black54),
                            ),
                            if (item.isOp) UserTag(type: 'OP'),
                            if (item.isMod) UserTag(type: 'MOD'),
                          ]),
                          Row(
                            children: [
                              Text(
                                item.floor.toString() + '楼',
                                style: TextStyle(fontSize: 11.sp, height: 1.2, color: Colors.grey),
                              ),
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.only(left: 8.w),
                                child: Text(
                                  item.date,
                                  style: TextStyle(fontSize: 11.sp, height: 1.2, color: Colors.grey),
                                ),
                              ))
                            ],
                          )
                        ],
                      ),
                    )),
                  ],
                ),
              ),
              Row(
                children: [
                  if (item.thankCount != 0)
                    InkWell(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              item.isThanked ? Icons.favorite : Icons.favorite_border,
                              size: 18.sp,
                              color: Colors.red,
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 4.w),
                                child: Text(
                                  item.thankCount.toString(),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 14.sp, color: Colors.red, height: 1.2),
                                ))
                          ],
                        ),
                        onTap: () => onThank(item)),
                  InkWell(
                      child: Padding(
                        padding: EdgeInsets.only(left: 4.w),
                        child: Icon(
                          Icons.more_vert,
                          size: 22.sp,
                          color: Colors.grey,
                        ),
                      ),
                      onTap: () => onMenu(item))
                ],
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            verticalDirection: VerticalDirection.down,
          ),
          Padding(
            padding: EdgeInsets.only(top: 6.w, bottom: item.children.length == 0 ? 0.w : 6.w),
            child: SelectionArea(
                child: InkWell(
              child: Container(
                width: double.infinity,
                child: HtmlWidget(
                  type == 0 ? item.replyContent : item.hideCallUserReplyContent,
                  renderMode: RenderMode.column,
                  textStyle: TextStyle(fontSize: 14.sp, height: 1.4),
                ),
              ),
              onTap: () => onTap(item),
            )),
          ),
          if (item.children.length != 0)
            Row(
              children: [
                // Container(
                //   margin: EdgeInsets.only(right: 0.w),
                //   color: Colors.grey[200],
                //   width: 1.w,
                //   height: double.infinity,
                //   // height: 100.w,
                // ),
                Expanded(
                  child: Column(
                    children: [
                      ...item.children.asMap().entries.map((entry) {
                        int idx = entry.key;
                        Reply val = entry.value;
                        return Padding(
                          padding: EdgeInsets.only(left: 10.w),
                          child: ReplyItem(
                            index: idx,
                            type: 1,
                            item: val,
                            onThank: (e) => onThank(e),
                            onMenu: (e) => onMenu(e),
                            onTap: (e) => onTap(e),
                          ),
                        );
                      })
                    ],
                  ),
                )
              ],
            )
        ]),
      ),
      onTap: () => onTap(item),
    );
  }
}