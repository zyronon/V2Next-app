import 'package:dio/dio.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:v2next/utils/utils.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // print("响应之前");
    loginAuth(
      // response.realUri.toString(),
      response.requestOptions.path,
      response.requestOptions.method,
      redirtct: response.realUri.toString(),
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 处理网络请求错误
    SmartDialog.showToast(
      await dioError(err),
      displayType: SmartToastType.onlyRefresh,
    );
    handler.next(err);
  }

  static Future<String> dioError(DioException error) async {
    switch (error.type) {
      case DioExceptionType.badCertificate:
        return '证书有误！';
      case DioExceptionType.badResponse:
        return '服务器异常，请稍后重试！';
      case DioExceptionType.cancel:
        return "请求已被取消，请重新请求";
      case DioExceptionType.connectionError:
        return '连接错误，请检查网络设置';
      case DioExceptionType.connectionTimeout:
        return "网络连接超时，请检查网络设置";
      case DioExceptionType.receiveTimeout:
        return "响应超时，请稍后重试！";
      case DioExceptionType.sendTimeout:
        return "发送请求超时，请检查网络设置";
      case DioExceptionType.unknown:
        return "网络异常，请稍后重试！";
      default:
        return "Dio异常";
    }
  }

  // 登录验证
  loginAuth(reqPath, method, {redirtct}) {
    if (reqPath != '/write' && method == 'GET' && redirtct == '/2fa') {
      SmartDialog.dismiss();
      Utils.twoFADialog();
      throw ('该操作需要登录！');
    }
  }
}
