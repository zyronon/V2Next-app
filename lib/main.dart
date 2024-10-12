import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:v2ex/pages/login.dart';
import 'package:v2ex/pages/post_detail.dart';
import 'package:v2ex/utils/init.dart';
import 'package:v2ex/utils/request.dart';

import 'pages/index.dart';

class IndexController extends GetxController {
  double textScaleFactor = 1;
}

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize(); // Dio 初始化
  await Request().setCookie();
  await Http().setCookie();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
        designSize: const Size(375, 750),
        minTextAdapt: true,
        builder: (context, child) {
          return GetMaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              useMaterial3: true,
              //使用谷歌NotoSansSc字体，默认字体在安卓的小米手机上很粗
              textTheme: GoogleFonts.notoSansScTextTheme(),
              // 去除TabBar底部线条
              tabBarTheme: const TabBarTheme(dividerColor: Colors.transparent),
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: <TargetPlatform, PageTransitionsBuilder>{
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                },
              ),
              appBarTheme: const AppBarTheme(
                  systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent, // 去除状态栏遮罩
                statusBarIconBrightness: Brightness.dark, // 状态栏图标字体颜色
                systemNavigationBarColor: Colors.white, // 底部导航栏颜色
              )),
              colorScheme: const ColorScheme.light(
                surface: Colors.white,
                // 和底部导航栏保持一致
                // surfaceBright: Color(0x00FFFFFF), // 透明背景
                primary: Color.fromARGB(255, 89, 54, 133),
                secondary: Color(0xFFE3EDF2),
                tertiary: Colors.black,
                onSecondary: Colors.black,
                secondaryContainer: Color(0xFFE3EDF2),
                // 骨架屏底色
                onSecondaryContainer: Color.fromARGB(255, 242, 247, 251),
                // 骨架屏亮色
                inversePrimary: Colors.black54,
              ),
            ),
            navigatorObservers: [FlutterSmartDialog.observer],
            // builder: FlutterSmartDialog.init(),
            builder: (BuildContext context, Widget? child) {
              return GetBuilder(
                  init: IndexController(),
                  builder: (_){
                return FlutterSmartDialog(
                  child: MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: _.textScaleFactor),
                    child: DefaultTextStyle(
                      style: GoogleFonts.notoSansSc(textStyle: TextStyle(color: Colors.black, fontSize: 14.sp)),
                      child: child!,
                    ),
                  ),
                );
              });
            },
            routes: {
              '/': (context) => const Index(),
              '/post-detail': (context) => const PostDetail(),
              // '/test': (context) => const PostTest(),
              '/login': (context) => const LoginPage(),
            },
          );
        });
  }
}
