import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:v2next/components/base_button.dart';
import 'package:v2next/model/base_controller.dart';

class NoData extends StatelessWidget {
  Function? cb;
  String text;

  NoData({this.cb, this.text = '没有权限'});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BaseController>(builder: (_) {
      return SingleChildScrollView(
          physics: new AlwaysScrollableScrollPhysics(),
          child: Container(
            height: 0.8.sh,
            child: Center(
                child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/nodata.png', width: 125, height: 125),
                  if (text.isNotEmpty) Text(text, style: TextStyle(fontSize: 20.sp,color: Colors.grey[700])),
                  SizedBox(height: 20.w),
                  if (!_.isLogin)
                    BaseButton(
                      text: '登录',
                      size: TDButtonSize.large,
                      theme: TDButtonTheme.primary,
                      onTap: () async {
                        await Get.toNamed('/login');
                        cb?.call();
                      },
                    )
                ],
              ),
            )),
          ));
    });
  }
}
