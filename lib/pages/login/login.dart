import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:v2next/model/base_controller.dart';
import 'package:v2next/model/model.dart';
import 'package:v2next/http/login_api.dart';
import 'package:v2next/utils/const_val.dart';
import 'package:v2next/utils/event_bus.dart';
import 'package:v2next/utils/storage.dart';
import 'package:v2next/utils/utils.dart';

class Controller extends GetxController {
  var codeImg = '';
  var showPwd = true.obs;
  var loadingCodeImg = true.obs;
  var loadingLogin = false.obs;
  late LoginDetailModel loginKey = LoginDetailModel();

  showBanModal(List val) {
    SmartDialog.show(
      animationType: SmartAnimationType.centerFade_otherSlide,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('提示'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                val[0],
                style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).colorScheme.error),
              ),
              const SizedBox(height: 4),
              Text(val[1]),
            ],
          ),
          actions: [
            TextButton(onPressed: (() => {SmartDialog.dismiss()}), child: const Text('关闭'))
          ],
        );
      },
    );
  }

  getSignKey() async {
    loadingCodeImg.value = true;
    var res = await LoginApi.getLoginKey();
    loadingCodeImg.value = false;
    if (res.success) {
      if (res.data.twoFa) {
        Utils.twoFADialog();
      } else {
        loginKey = res.data;
      }
    } else {
      showBanModal(res.data);
    }
  }

  static Controller get to => Get.find();

  @override
  void onInit() {
    super.onInit();
    this.getSignKey();
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController pwdController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final FocusNode usernameTextFieldNode = FocusNode();
  final FocusNode pwdTextFieldNode = FocusNode();
  final FocusNode codeTextFieldNode = FocusNode();
  final GlobalKey _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () => Get.back(result: {'loginStatus': 'cancel'})),
        actions: [TextButton(onPressed: () => Utils.openBrowser('https://www.v2ex.com/signup'), child: const Text('注册账号')), const SizedBox(width: 12)],
      ),
      body: GetX<Controller>(
          init: Controller(),
          builder: (_) {
            return Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Form(
                  key: _formKey, //设置globalKey，用于后面获取FormState
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(height: 20),
                          Text('登录', style: Theme.of(context).textTheme.headlineLarge),
                          const SizedBox(height: 10),
                          Text('使用您的v2ex账号', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 50),
                          Listener(
                            onPointerDown: (e) => FocusScope.of(context).requestFocus(usernameTextFieldNode),
                            child: TextFormField(
                                autofillHints: [AutofillHints.name],
                                controller: usernameController,
                                focusNode: usernameTextFieldNode,
                                // autofocus: true,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText: '用户名',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                ),
                                validator: (v) => v!.trim().isNotEmpty ? null : "用户名不能为空"),
                          ),
                          const SizedBox(height: 15),
                          Listener(
                              onPointerDown: (e) => FocusScope.of(context).requestFocus(pwdTextFieldNode),
                              child: TextFormField(
                                  autofillHints: [AutofillHints.password],
                                  controller: pwdController,
                                  obscureText: _.showPwd.value,
                                  focusNode: pwdTextFieldNode,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    labelText: '密码',
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _.showPwd.value ? Icons.visibility : Icons.visibility_off,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                      onPressed: () {
                                        _.showPwd.value = !_.showPwd.value;
                                      },
                                    ),
                                  ),
                                  validator: (v) => v!.trim().length > 5 ? null : "密码不能少于6位")),
                          const SizedBox(height: 15),
                          Stack(
                            children: [
                              Listener(
                                onPointerDown: (e) => FocusScope.of(context).requestFocus(codeTextFieldNode),
                                child: TextFormField(
                                    controller: codeController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.done,
                                    focusNode: codeTextFieldNode,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6.0),
                                      ),
                                      labelText: '验证码',
                                    ),
                                    validator: (v) => v!.trim().isNotEmpty ? null : "验证码不能为空"),
                              ),
                              Positioned(
                                right: 5.w,
                                top: 5.w,
                                height: 46.w,
                                child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
                                  child: GestureDetector(
                                    onTap: () {
                                      _.getSignKey();
                                    },
                                    child: _.loadingCodeImg.value
                                        ? Container(child: SpinKitWave(color: Colors.grey[300], size: 24.w), margin: EdgeInsets.only(right: 60.w))
                                        : _.loginKey.captchaImgBytes != null
                                            ? Image.memory(
                                                _.loginKey.captchaImgBytes!,
                                                height: 52.w,
                                                fit: BoxFit.fitHeight,
                                              )
                                            : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                              height: 94,
                              padding: const EdgeInsets.all(20),
                              child: TDButton(
                                text: '登录',
                                style: TDButtonStyle(backgroundColor: Const.primaryColor, textColor: Colors.white),
                                iconWidget: _.loadingLogin.value
                                    ? TDLoading(
                                        size: TDLoadingSize.small,
                                        icon: TDLoadingIcon.circle,
                                        iconColor: TDTheme.of(context).whiteColor1,
                                      )
                                    : null,
                                width: double.infinity,
                                size: TDButtonSize.large,
                                type: TDButtonType.fill,
                                shape: TDButtonShape.rectangle,
                                theme: TDButtonTheme.primary,
                                onTap: () async {
                                  if ((_formKey.currentState as FormState).validate()) {
                                    print(usernameController.text);
                                    print(pwdController.text);
                                    print(codeController.text);
                                    _.loginKey.username = usernameController.text;
                                    _.loginKey.pwd = pwdController.text;
                                    _.loginKey.code = codeController.text;
                                    // 键盘收起
                                    codeTextFieldNode.unfocus();
                                    if (_.loadingLogin.value) return;
                                    _.loadingLogin.value = true;
                                    Result res = await LoginApi.login(_.loginKey);
                                    _.loadingLogin.value = false;
                                    if (res.success) {
                                      if (res.data == '2fa') {
                                        Utils.twoFADialog();
                                      } else {
                                        BaseController.to.setUserinfo(res.data);
                                        EventBus().emit(EventKey.startTask);
                                        Get.back(result: {'loginStatus': 'success'});
                                      }
                                    } else {
                                      if (res.data.length == 2) {
                                        _.showBanModal(res.data);
                                      } else {
                                        SmartDialog.showToast(res.data[0]);
                                        codeController.value = const TextEditingValue(text: '');
                                        Timer(const Duration(milliseconds: 500), () {
                                          _.getSignKey();
                                        });
                                      }
                                    }
                                  }
                                },
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () => Utils.openBrowser('https://www.v2ex.com/forgot'),
                                child: Text(
                                  '忘记密码？',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).padding.bottom + 30,
                  child: TextButton(
                    onPressed: () async {
                      int once = GStorage().getOnce();
                      // Utils.openURL('https://www.v2ex.com/auth/google?once=$once');
                      var result = await Get.toNamed('/google_login', arguments: {'aUrl': '${Const.v2exHost}/auth/google?once=$once'});
                      if (result != null && result['signInGoogle'] == 'success') {
                        SmartDialog.showLoading(msg: '获取信息...');
                        Result res = await LoginApi.getUserInfo();
                        SmartDialog.dismiss();
                        if (res.success) {
                          if (res.data == '2fa') {
                            Utils.twoFADialog();
                          } else {
                            BaseController.to.setUserinfo(res.data);
                            EventBus().emit(EventKey.startTask);
                            Get.back(result: {'loginStatus': 'success'});
                          }
                        } else {
                          Utils.toast(msg: '登录失败了');
                        }
                      } else {
                        Utils.toast(msg: '取消登录');
                      }
                    },
                    child: Row(children: [
                      Image.asset('assets/images/google.png', width: 25, height: 25),
                      const SizedBox(width: 10),
                      Text('Sign in with Google', style: Theme.of(context).textTheme.bodyMedium)
                    ]),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
