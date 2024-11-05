import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PostListLoading extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SliverList(
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
                // Const.lineWidget,
              ],
            );
          },
          childCount: 7,
        ));
  }
}
