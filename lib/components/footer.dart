import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FooterTips extends StatelessWidget {
  final bool loading;

  const FooterTips({Key? key, this.loading = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100 + MediaQuery.of(context).padding.bottom,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!loading) Icon(Icons.auto_awesome, size: 18.w),
            if (loading) SpinKitFadingCircle(color: Colors.grey, size: 18.w),
            SizedBox(width: 10.w),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(!loading ? '没有更多数据了' : '加载中...'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
