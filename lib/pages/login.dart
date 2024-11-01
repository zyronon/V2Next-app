import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:v2ex/model/model_login_detail.dart';
import 'package:v2ex/utils/api.dart';
import 'package:v2ex/utils/login.dart';
import 'package:v2ex/utils/utils.dart';
import 'package:v2ex/utils/string.dart';
import 'package:v2ex/utils/http.dart';
import 'package:v2ex/utils/storage.dart';
import 'package:v2ex/utils/event_bus.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class Controller extends GetxController {
  var codeImg = '';
  bool passwordVisible = true; // 默认隐藏密码
  bool loadingCodeImg = true;
  bool loadingLogin = false;
  late LoginDetailModel loginKey = LoginDetailModel();

  getSignKey() async {
    loadingCodeImg = true;
    var res = await Api.getLoginKey();
    loadingCodeImg = false;
    if (res.twoFa) {
      Login.twoFADialog();
    } else {
      loginKey = res;
    }
    return res;
  }

  static Controller get to => Get.find();
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
    usernameController.text = 'shzbkzo';
    pwdController.text = 'o894948816O!';
    // _codeController.text = '1234';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () => Get.back(result: {'loginStatus': 'cancel'})),
        actions: [TextButton(onPressed: () => Utils.openURL('https://www.v2ex.com/signup'), child: const Text('注册账号')), const SizedBox(width: 12)],
      ),
      body: GetBuilder(
          init: Controller(),
          initState: Controller.to.getSignKey(),
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
                                controller: usernameController,
                                focusNode: usernameTextFieldNode,
                                autofocus: true,
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
                                  controller: pwdController,
                                  obscureText: _.passwordVisible,
                                  focusNode: pwdTextFieldNode,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    labelText: '密码',
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _.passwordVisible ? Icons.visibility : Icons.visibility_off,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _.passwordVisible = !_.passwordVisible;
                                        });
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
                                    child: _.loadingCodeImg
                                        ? Container(child: SpinKitWave(color: Colors.grey[300], size: 24.w), margin: EdgeInsets.only(right: 60.w))
                                        : Image.memory(
                                            _.loginKey.captchaImgBytes!,
                                            height: 52.w,
                                            fit: BoxFit.fitHeight,
                                          ),
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
                                iconWidget: _.loadingLogin
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
                                    //验证通过提交数据
                                    (_formKey.currentState as FormState).save();
                                    _.loginKey.userNameValue = usernameController.text;
                                    _.loginKey.passwordValue = pwdController.text;
                                    _.loginKey.codeValue = codeController.text;
                                    // 键盘收起
                                    codeTextFieldNode.unfocus();
                                    setState(() {
                                      _.loadingLogin = true;
                                    });
                                    var result = await Api.onLogin(_.loginKey);
                                    setState(() {
                                      _.loadingLogin = false;
                                    });
                                    if (result == 'true') {
                                      // 登录成功
                                      GStorage().setLoginStatus(true);
                                      Get.back(result: {'loginStatus': 'success'});
                                    } else if (result == 'false') {
                                      // 登录失败
                                      setState(() {
                                        // _passwordController.value =
                                        //     const TextEditingValue(text: '');
                                        codeController.value = const TextEditingValue(text: '');
                                      });
                                      Timer(const Duration(milliseconds: 500), () {
                                        _.getSignKey();
                                      });
                                    } else if (result == '2fa') {
                                      Login.twoFADialog();
                                    }
                                  }
                                },
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // TextButton(onPressed: () => Utils.launchURL('https://www.v2ex.com/signin'), child: Text(
                              //   '网页登录',
                              //   style: TextStyle(color: Colors.grey[600]),
                              // ),),
                              // const SizedBox(width: 10),
                              TextButton(
                                onPressed: () => Utils.openURL('https://www.v2ex.com/forgot'),
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
                      var result = await Get.toNamed('/webView', parameters: {'aUrl': '${Strings.v2exHost}/auth/google?once=$once'});
                      if (result != null && result['signInGoogle'] == 'success') {
                        SmartDialog.showLoading(msg: '获取信息...');
                        // 登录成功 获取用户信息 / 2FA
                        var signResult = await Api.getUserInfo();
                        if (signResult == 'true') {
                          // 登录成功
                          eventBus.emit('login', 'success');
                          Get.back(result: {'loginStatus': 'success'});
                        } else if (signResult == 'false') {
                          // 登录失败
                          Utils.toast(msg: '登录失败了');
                        } else if (result == '2fa') {
                          print('login 需要两步验证 $result');
                          Login.twoFADialog();
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
