import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:v2ex/http/request.dart';
// import 'package:v2ex/service/local_notice.dart';
// import 'package:v2ex/utils/hive.dart';
// import 'package:v2ex/utils/proxy.dart';
import 'package:v2ex/utils/storage.dart';

class Routes {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  static const String toHomePage = '/';
  static const String toLoginPage = '/login';
}

Color getBackground(BuildContext context, tag) {
  List case_1 = ['secondBody', 'homePage', 'adaptMain'];
  List case_2 = ['searchBar', 'listItem'];

  // ipad 横屏
  // bool isiPadHorizontal = Breakpoints.large.isActive(context);
  bool isiPadHorizontal = false;
  if (isiPadHorizontal) {
    if(case_1.contains(tag)){
      return Theme.of(context).colorScheme.onInverseSurface;
    }else if(case_2.contains(tag)){
      return Theme.of(context).colorScheme.background;
    }else{
      return Theme.of(context).colorScheme.onInverseSurface;
    }
  } else {
    if(case_1.contains(tag)){
      return Theme.of(context).colorScheme.background;
    }else if(case_2.contains(tag)){
      return Theme.of(context).colorScheme.onInverseSurface;
    }else{
      return Theme.of(context).colorScheme.onInverseSurface;
    }
  }
}

class Global {
  static Future init() async {
    // 消息通知初始化
    try {
      // await LocalNoticeService().init();
    } catch (err) {
      print('LocalNoticeService err: ${err.toString()}');
    }
    // 配置代理
    // CustomProxy().init();
    // 本地存储初始化
    try {
      await GetStorage.init();
    } catch (err) {
      print('GetStorage err: ${err.toString()}');
    }
    // 高帧率滚动性能优化
    // GestureBinding.instance.resamplingEnabled = true;
  }
}