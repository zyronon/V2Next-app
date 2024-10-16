import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'base_divider.dart';

class LoadingListPage extends StatelessWidget {
  final int type;

  const LoadingListPage({this.type = 0});

  Widget _buildItem() {
    return Skeletonizer.zone(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Bone.circle(size: 28),
            SizedBox(width: 10.w),
            Bone.text(width: 80.w),
          ], crossAxisAlignment: CrossAxisAlignment.center, verticalDirection: VerticalDirection.down),
          Padding(padding: EdgeInsets.only(top: 10), child: Bone.multiText()),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Row(
                  children: [
                    Bone.text(width: 40.w),
                    SizedBox(width: 10.w),
                    Bone.text(width: 70.w),
                    SizedBox(width: 10.w),
                    Bone.text(width: 70.w),
                    SizedBox(width: 10.w),
                    Bone.text(width: 70.w),
                  ],
                ),
                Bone.text(width: 30.w),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
          )
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (type == 1) {
      return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return _buildItem();
        }, childCount: 7),
      );
    }
    return ListView.separated(
      physics: new AlwaysScrollableScrollPhysics(),
      itemCount: 7,
      itemBuilder: (BuildContext context, int index) {
        return _buildItem();
      },
      //分割器构造器
      separatorBuilder: (BuildContext context, int index) {
        return BaseDivider();
      },
    );
  }
}
