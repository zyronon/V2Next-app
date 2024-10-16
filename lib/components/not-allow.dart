import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class NotAllow extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.8.sh,
      child: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/nodata.png', width: 125, height: 125),
                Text('没有数据', style: TextStyle(fontSize: 24.sp)),
                SizedBox(height: 20.w),
                TDButton(
                  text: '登录',
                  size: TDButtonSize.large,
                  type: TDButtonType.fill,
                  shape: TDButtonShape.rectangle,
                  theme: TDButtonTheme.primary,
                  onTap: () {
                    Get.toNamed('/login');
                  },
                )
              ],
            ),
          )),
    );
  }

}