import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PostLoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 7,
      itemBuilder: (BuildContext context, int index) {
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
      },
      //分割器构造器
      separatorBuilder: (BuildContext context, int index) {
        return Container(
          height: 6,
          color: Color(0xfff1f1f1),
        );
      },
    );
  }
}
