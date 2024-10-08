import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserTag extends StatelessWidget {
  final String type;

  const UserTag({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 6.w, bottom: 2.w),
        padding: EdgeInsets.fromLTRB(3.w, 0.w, 3.w, 0.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.r),
          border: new Border.all(color: Color(0xff1484cd), width: 1.w),
        ),
        child: Text(
          type,
          style: TextStyle(color: Color(0xff1484cd), fontSize: 10.sp),
        ));
  }
}
