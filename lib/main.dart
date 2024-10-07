import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:v2ex/pages/login.dart';
import 'package:v2ex/pages/post_detail.dart';
import 'package:v2ex/utils/init.dart';

import 'pages/index.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();    // Dio 初始化
  await Request().setCookie();
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
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    return ScreenUtilInit(
        designSize: const Size(375, 750),
        minTextAdapt: true,
        builder: (context, child) {
          return GetMaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              useMaterial3: true,
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
            builder: FlutterSmartDialog.init(),
            routes: {
              '/': (context) => const Index(),
              '/Home': (context) => const Index(),
              '/PostDetail': (context) => const PostDetail(),
              '/Login': (context) => const LoginPage(),
            },
          );
        });
  }
}
