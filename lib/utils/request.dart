import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:native_dio_adapter/native_dio_adapter.dart';
import 'package:v2ex/utils/ConstVal.dart';
import 'package:v2ex/utils/interceptor.dart';
import 'package:v2ex/utils/string.dart';
import 'package:v2ex/utils/utils.dart';

class Http {
  static late final Http _instance = Http._internal();
  static late final Dio dio;
  static late CookieManager cookieManager;

  factory Http() => _instance;

  Http._internal() {
    //BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
    BaseOptions options = BaseOptions(
        //请求基地址,可以包含子路径
        baseUrl: Strings.v2exHost,
        connectTimeout: const Duration(seconds: 12),
        contentType: Headers.formUrlEncodedContentType,
        headers: {
          'Origin': Strings.v2exHost,
          'user-agent': Platform.isIOS ? Const.agent.ios : Const.agent.android,
        });

    dio = Dio(options);
    //使用原生平台的http。不然太慢了
    dio.httpClientAdapter = NativeAdapter();

    setCookie();
    //添加拦截器
    dio.interceptors
      ..add(ApiInterceptor())
      // 日志拦截器 输出请求、响应内容
      ..add(LogInterceptor(
        request: false,
        requestHeader: false,
        responseHeader: false,
      ));
    dio.options.validateStatus = (status) {
      return status! >= 200 && status < 300 || status == 304 || status == 302;
    };
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
   * get请求
   */
  Future<Response> get(url, {data, isMobile = true}) async {
    return request(url, query: data, isMobile: isMobile, method: 'GET');
  }

  /*
   * post请求
   */
  Future<Response> post(url, {data, isMobile = true}) async {
    return request(url, data: data, isMobile: isMobile, method: 'POST');
  }

  Future<Response> request(url, {query = const <String, dynamic>{}, data = const <String, dynamic>{}, method, isMobile = true}) async {
    Options options = Options();
    options.method = method;
    if (!isMobile) {
      options.headers = {'user-agent': Const.agent.pc};
    }
    // print('post-data: $data');
    try {
      Response response = await dio.request(
        url,
        data: data,
        queryParameters: query,
        options: options,
      );
      // debugPrint('post success---------${response.data}');
      return response;
    } on DioException catch (e) {
      debugPrint('post error---------$e');
      return Future.error(ApiInterceptor.dioError(e));
    }
  }
}
