import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostListHeader extends StatelessWidget {
  final String left;
  final Widget? right;

  PostListHeader({required this.left, this.right});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: DefaultTextStyle(
            style: TextStyle(fontSize: 14.sp, height: 1.2, color: Colors.grey),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(left),
                if (right != null) right!,
              ],
            )),
      ),
    );
  }
}
