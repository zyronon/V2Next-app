import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostListHeader extends StatelessWidget {
  final String left;
  final String? right;

  PostListHeader({required this.left, this.right});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              left,
              style: TextStyle(fontSize: 14.sp, height: 1.2, color: Colors.grey),
            ),
            if (right != null)
              Text(
                right!,
                style: TextStyle(fontSize: 14.sp, height: 1.2, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}