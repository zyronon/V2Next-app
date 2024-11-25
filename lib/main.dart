import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:v2next/http/login_dio.dart';
import 'package:v2next/http/request.dart';
import 'package:v2next/pages/edit_tab.dart';
import 'package:v2next/pages/layout.dart';
import 'package:v2next/pages/login/google_login.dart';
import 'package:v2next/pages/login/login.dart';
import 'package:v2next/pages/member/post_list.dart';
import 'package:v2next/pages/member/reply_list.dart';
import 'package:v2next/pages/node_detail.dart';
import 'package:v2next/pages/node_group.dart';
import 'package:v2next/pages/search_node.dart';
import 'package:v2next/pages/post_detail/post_detail.dart';
import 'package:v2next/pages/search.dart';
import 'package:v2next/pages/setting.dart';
import 'package:v2next/utils/const_val.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:v2next/utils/utils.dart';
import 'firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'pages/index.dart';
import 'pages/member/member.dart';

class IndexController extends GetxController {
  double textScaleFactor = 1;

  static IndexController get to => Get.find<IndexController>();
}

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await ScreenUtil.ensureScreenSize();
  LoginDio().setCookie();
  Http().setCookie();
  //在 FirebaseAnalytics 上调用 instance getter 来创建一个新的 Firebase Analytics 实例：
  FirebaseAnalytics.instance.logEvent(name: 'start');
  Utils.report(name: 'start');

  if (GetPlatform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      //如果直接在下面的AppBarTheme里设置了，后续无法再手动修改了
      // statusBarColor: Colors.transparent, // 去除状态栏遮罩
      statusBarColor: Colors.white,
      systemNavigationBarColor: Colors.white.withOpacity(0.1), // 底部导航栏颜色
      statusBarIconBrightness: Brightness.dark, // 状态栏图标字体颜色
    ));
  }
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 750),
        minTextAdapt: true,
        builder: (context, child) {
          return GetMaterialApp(
              title: 'V2Next',
              theme: ThemeData(
                useMaterial3: true,
                splashColor: Colors.transparent,
                // 点击时的高亮效果设置为透明
                highlightColor: Colors.transparent,
                // 长按时的扩散效果设置为透明
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
                appBarTheme: AppBarTheme(
                  toolbarHeight: 40.w,
                  elevation: 0,
                  centerTitle: true,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  surfaceTintColor: Colors.transparent,
                ),
                colorScheme: ColorScheme.light(
                  primary: Const.primaryColor,
                  // 背景色，包括状态栏
                  surface: Colors.white,
                  surfaceBright: Color(0x00FFFFFF), // 透明背景
                  onSurface: Colors.black,
                ),
              ),
              navigatorObservers: [FlutterSmartDialog.observer],
              // builder: FlutterSmartDialog.init(),
              builder: (BuildContext context, Widget? child) {
                return GetBuilder(
                    init: IndexController(),
                    builder: (_) {
                      return FlutterSmartDialog(
                        child: MediaQuery(
                          data: MediaQuery.of(context).copyWith(textScaleFactor: _.textScaleFactor),
                          child: DefaultTextStyle(
                            style: GoogleFonts.notoSansSc(textStyle: TextStyle(color: Colors.black, fontSize: 16.sp, height: 1)),
                            child: child!,
                          ),
                        ),
                      );
                    });
              },
              routes: {
                '/': (context) => const IndexPage(),
                '/post_detail': (context) => const PostDetailPage(),
                // '/test': (context) => const PostTest(),
                '/login': (context) => const LoginPage(),
                '/edit_tab': (context) => EditTabPage(),
                '/node_detail': (context) => NodeDetailPage(),
                '/node_group': (context) => NodeGroupPage(),
                '/search': (context) => SearchPage(),
                '/layout': (context) => LayoutPage(),
                '/search_node': (context) => SearchNodePage(),
                '/google_login': (context) => GoogleLoginPage(),
                '/setting': (context) => SettingPage(),
                '/member': (context) => MemberPage(),
                '/member_post_list': (context) => MemberPostListPage(),
                '/member_reply_list': (context) => MemberReplyListPage(),
                // '/create': (context) => Create(),
              },
              routingCallback: (routing) {
                SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                ));
              });
        });
  }
}
