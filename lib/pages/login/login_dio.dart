import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:native_dio_adapter/native_dio_adapter.dart';
import 'package:v2ex/utils/const_val.dart';
import 'package:v2ex/utils/interceptor.dart';
import 'package:v2ex/utils/string.dart';
import 'package:v2ex/utils/utils.dart';

class LoginDio {
  static late final LoginDio _instance = LoginDio._internal();
  static late CookieManager cookieManager;
  static late final Dio dio;

  factory LoginDio() => _instance;

  //使用了原生平台adapter,无法登录，但不使用就太慢了...，所以复制了一份dio实例，专们用于登录
  LoginDio._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: Const.v2exHost,
      connectTimeout: const Duration(seconds: 12),
      receiveTimeout: const Duration(seconds: 12),
      headers: {
        'Origin': Const.v2exHost,
        'User-Agent': Platform.isIOS ? Const.agent.ios : Const.agent.android,
      },
    );
    dio = Dio(options);
    setCookie();
    dio.interceptors
      ..add(ApiInterceptor())
      ..add(LogInterceptor(
        request: false,
        requestHeader: false,
        responseHeader: false,
      ));
    dio.options.validateStatus = (status) {
      return status! >= 200 && status < 400;
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
  Future<Response> get(url, {data, isMobile = false, responseType}) async {
    return request(url, query: data, isMobile: isMobile, method: 'GET', responseType: responseType);
  }

  /*
   * post请求，提交
   */
  Future<Response> post(url, {data, isMobile = false, options}) async {
    return request(url, data: data, isMobile: isMobile, method: 'POST', options: options);
  }

  Future<Response> request(url, {query = const <String, dynamic>{}, data = const <String, dynamic>{}, method, isMobile = false, responseType = null, options = null}) async {
    if (options == null) {
      options = Options();
    }
    if (responseType != null) {
      options.responseType = responseType;
    }
    if (!isMobile) {
      options.headers = {'user-agent': Const.agent.pc};
    }
    options.method = method;

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
