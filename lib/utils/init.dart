// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';

// import 'package:dio/adapter.dart';
import 'package:flutter/foundation.dart';
import 'package:cookie_jar/cookie_jar.dart';

// import 'package:flutter_v2ex/utils/utils.dart';
// import 'package:flutter_v2ex/utils/string.dart';
// import 'package:flutter_v2ex/http/interceptor.dart';
// import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:v2ex/utils/ConstVal.dart';
import 'package:v2ex/utils/interceptor.dart';
import 'package:v2ex/utils/string.dart';
import 'package:v2ex/utils/utils.dart';

class Request {
  static final Request _instance = Request._internal();
  static late CookieManager cookieManager;
  static late final Dio dio;

  factory Request() => _instance;

  // ..httpClientAdapter = Http2Adapter(
  //   ConnectionManager(
  //     idleTimeout: 10000,
  //     // Ignore bad certificate
  //     onClientCreate: (_, config) => config.onBadCertificate = (_) => true,
  //   ),
  // );

  dynamic _parseAndDecode(String response) {
    return jsonDecode(response);
  }

  Future parseJson(String text) {
    return compute(_parseAndDecode, text);
  }

  /// 设置cookie
  setCookie() async {
    var cookiePath = await Utils.getCookiePath();
    var cookieJar = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage(cookiePath),
    );
    cookieManager = CookieManager(cookieJar);
    dio.interceptors.add(cookieManager);
  }

  /*
   * config it and create
   */
  Request._internal() {
    //BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
    BaseOptions options = BaseOptions(
      //请求基地址,可以包含子路径
      baseUrl: Strings.v2exHost,
      //连接服务器超时时间，单位是毫秒.
      connectTimeout: const Duration(seconds: 12),
      //响应流上前后两次接受到数据的间隔，单位为毫秒。
      receiveTimeout: const Duration(seconds: 12),
      headers: {

      }
      //Http请求头.
      // headers: {
      //   'cookie': '',
      // },
      //请求的Content-Type，默认值是"application/json; charset=utf-8",Headers.formUrlEncodedContentType会自动编码请求体.
      // contentType: Headers.formUrlEncodedContentType,
      //表示期望以那种格式(方式)接受响应数据。接受四种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
      // responseType: ResponseType.plain,
    );

    dio = Dio(options);

    setCookie();
    //添加拦截器
    dio.interceptors
      // ..add(DioCacheManager(CacheConfig(baseUrl: Strings.v2exHost)).interceptor)
      ..add(ApiInterceptor())
      // 日志拦截器 输出请求、响应内容
      ..add(LogInterceptor(
        request: false,
        requestHeader: false,
        responseHeader: false,
      ));
    // (dio.transformer as DefaultTransformer).jsonDecodeCallback = parseJson;
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient client) {
    //   // config the http client
    //   client.findProxy = (uri) {
    //     // proxy all request to localhost:8888
    //     // return 'PROXY localhost:7890';
    //     // return 'PROXY 127.0.0.1:7890';
    //     // 不设置代理 TODO 打包前关闭代理
    //     return 'DIRECT';
    //   };
    // client.badCertificateCallback =
    //     (X509Certificate cert, String host, int port) => true;
    // return null;
    // you can also create a HttpClient to dio
    //   return client;
    // };

    dio.options.validateStatus = (status) {
      return status! >= 200 && status < 300 || status == 304 || status == 302;
    };
  }

  /*
   * get请求
   */
  get(url, {data, cacheOptions, options, cancelToken, extra}) async {
    // extra pc ok , mob error
    Response response;
    Options options;
    String ua = 'mob';
    ResponseType resType = ResponseType.json;
    if (extra != null) {
      ua = extra!['ua'] ?? 'mob';
      resType = extra!['resType'] ?? ResponseType.json;
    }
    // headerUa(pc) ResponseType.json;
    if (cacheOptions != null) {
      cacheOptions.headers = {'user-agent': headerUa(ua)};
      options = cacheOptions;
    } else {
      options = Options();
      options.headers = {'user-agent': headerUa(ua)};
      options.responseType = resType;
    }
    try {
      response = await dio.get(
        url,
        queryParameters: data,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      print('get error---------$e');
      return Future.error(ApiInterceptor.dioError(e));
    }
  }

  /*
   * post请求
   */
  post(url, {data, options, cancelToken, extra}) async {
    print('post-data: $data');
    Response response;
    try {
      response = await dio.post(
        url,
        data: data,
        options: options,
        cancelToken: cancelToken,
      );
      debugPrint('post success---------${response.data}');
      return response;
    } on DioException catch (e) {
      debugPrint('post error---------$e');
      return Future.error(ApiInterceptor.dioError(e));
    }
  }

  /*
   * post请求
   */
  post2(url, {data}) async {
    Options options = Options();
    options.contentType = Headers.formUrlEncodedContentType;
    options.headers = {
      // 'content-type': 'application/x-www-form-urlencoded',
      // 必须字段
      // 'Referer': '${Strings.v2exHost}/note',
      'Origin': Strings.v2exHost,
      'user-agent': Const.agent.ios
    };

    // print('post-data: $data');
    Response response;
    try {
      response = await dio.post(
        url,
        data: data,
        options: options,
      );
      // debugPrint('post success---------${response.data}');
      return response;
    } on DioException catch (e) {
      debugPrint('post error---------$e');
      return Future.error(ApiInterceptor.dioError(e));
    }
  }

  // /*
  //  * 下载文件
  //  */
  // downloadFile(urlPath, savePath) async {
  //   Response response;
  //   try {
  //     response = await dio.download(urlPath, savePath,
  //         onReceiveProgress: (int count, int total) {
  //       //进度
  //       // print("$count $total");
  //     });
  //     print('downloadFile success---------${response.data}');
  //
  //     return response.data;
  //   } on DioException catch (e) {
  //     print('downloadFile error---------$e');
  //     return Future.error(ApiInterceptor.dioError(e));
  //   }
  // }

  /*
   * 取消请求
   *
   * 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。
   * 所以参数可选
   */
  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }

  String headerUa(ua) {
    String headerUa = '';
    if (ua == 'mob') {
      headerUa = Platform.isIOS ? Const.agent.ios : 'Mozilla/5.0 (Linux; Android 11; Pixel 5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.91 Mobile Safari/537.36';
    } else {
      // headerUa = 'Mozilla/5.0 (MaciMozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36';
      headerUa = Const.agent.pc;
    }
    return headerUa;
  }
}
