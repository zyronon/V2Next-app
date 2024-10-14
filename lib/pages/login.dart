import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:v2ex/model/model_login_detail.dart';
import 'package:v2ex/utils/login.dart';
import 'package:v2ex/utils/utils.dart';
import 'package:v2ex/utils/string.dart';
import 'package:v2ex/utils/http.dart';
import 'package:v2ex/utils/storage.dart';
import 'package:v2ex/utils/event_bus.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final GlobalKey _formKey = GlobalKey<FormState>();

  var codeImg = '';
  late String? _userName;
  late String? _password;
  late String? _code;

  late LoginDetailModel loginKey = LoginDetailModel();
  final FocusNode userNameTextFieldNode = FocusNode();
  final FocusNode passwordTextFieldNode = FocusNode();
  final FocusNode captchaTextFieldNode = FocusNode();
  bool passwordVisible = true; // 默认隐藏密码
  bool loadingCodeImg = true;
  bool loadingLogin = false;

  @override
  void initState() {
    super.initState();
    getSignKey();
  }

  Future<LoginDetailModel> getSignKey() async {
    setState(() {
      loadingCodeImg = true;
    });
    var res = await DioRequestWeb.getLoginKey();
    setState(() {
      loadingCodeImg = false;
    });
    if (res.twoFa) {
      Login.twoFADialog();
    } else {
      setState(() {
        loginKey = res;
      });
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () => Get.back(result: {'loginStatus': 'cancel'})),
        actions: [TextButton(onPressed: () => Utils.openURL('https://www.v2ex.com/signup'), child: const Text('注册账号')), const SizedBox(width: 12)],
      ),
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Form(
            key: _formKey, //设置globalKey，用于后面获取FormState
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20),
                Text('登录', style: Theme
                    .of(context)
                    .textTheme
                    .headlineLarge),
                const SizedBox(height: 10),
                Text('使用您的v2ex账号', style: Theme
                    .of(context)
                    .textTheme
                    .titleMedium),
                const SizedBox(height: 50),
                Container(
                  // height: 70,
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                  child: TextFormField(
                    controller: _userNameController,
                    focusNode: userNameTextFieldNode,
                    decoration: InputDecoration(
                      labelText: '用户名',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                    ),
                    // 校验用户名
                    validator: (v) {
                      return v!.trim().isNotEmpty ? null : "用户名不能为空";
                    },
                    onSaved: (val) {
                      _userName = val;
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: passwordVisible,
                    focusNode: passwordTextFieldNode,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      labelText: '密码',
                      suffixIcon: IconButton(
                        icon: Icon(
                          passwordVisible ? Icons.visibility : Icons.visibility_off,
                          color: Theme
                              .of(context)
                              .colorScheme
                              .primary,
                        ),
                        onPressed: () {
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                      ),
                    ),
                    //校验密码
                    validator: (v) {
                      return v!.trim().length > 5 ? null : "密码不能少于6位";
                    },
                    onSaved: (val) {
                      _password = val;
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                  child: Stack(
                    children: [
                      TextFormField(
                        controller: _codeController,
                        keyboardType: TextInputType.text,
                        focusNode: captchaTextFieldNode,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          labelText: '验证码',
                        ),
                        validator: (v) {
                          return v!.trim().isNotEmpty ? null : "验证码不能为空";
                        },
                        onSaved: (val) {
                          _code = val;
                        },
                      ),
                      Positioned(
                        right: 5.w,
                        top: 5.w,
                        height: 46.w,
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(6),
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                getSignKey();
                              });
                            },
                            child: loadingCodeImg
                                ? Container(child: SpinKitWave(color: Colors.grey[300], size: 24.w), margin: EdgeInsets.only(right: 60.w))
                                : Image.memory(
                              loginKey.captchaImgBytes!,
                              height: 52.w,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 94,
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (loadingLogin) ...[
                          SpinKitFadingCircle(color: Colors.grey[400], size: 24.w),
                          SizedBox(width: 10.w),
                        ],
                        Text(
                          '登录',
                          style: TextStyle(fontSize: 18.sp),
                        )
                      ],
                    ),
                    onPressed: () async {
                      if (loadingCodeImg) {
                        Get.snackbar('提示', '请输入正确的验证码');
                        return;
                      }
                      (_formKey.currentState as FormState).save();
                      loginKey.userNameValue = 'shzbkzo';
                      loginKey.passwordValue = 'o894948816O!';
                      loginKey.codeValue = _code!;
                      setState(() {
                        loadingLogin = true;
                      });
                      var result = await DioRequestWeb.onLogin(loginKey);
                      setState(() {
                        loadingLogin = false;
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
                          _codeController.value = const TextEditingValue(text: '');
                        });
                        Timer(const Duration(milliseconds: 500), () {
                          getSignKey();
                        });
                      } else if (result == '2fa') {
                        Login.twoFADialog();
                      }
                      return;
                      if ((_formKey.currentState as FormState).validate()) {
                        //验证通过提交数据
                        (_formKey.currentState as FormState).save();
                        loginKey.userNameValue = _userName!;
                        loginKey.passwordValue = _password!;
                        loginKey.codeValue = _code!;
                        // 键盘收起
                        captchaTextFieldNode.unfocus();
                        var result = await DioRequestWeb.onLogin(loginKey);
                        if (result == 'true') {
                          // 登录成功
                          GStorage().setLoginStatus(true);
                          Get.back(result: {'loginStatus': 'success'});
                        } else if (result == 'false') {
                          // 登录失败
                          setState(() {
                            // _passwordController.value =
                            //     const TextEditingValue(text: '');
                            _codeController.value = const TextEditingValue(text: '');
                          });
                          Timer(const Duration(milliseconds: 500), () {
                            getSignKey();
                          });
                        } else if (result == '2fa') {
                          Login.twoFADialog();
                        }
                      }
                    },
                  ),
                ),
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
            ),
          ),
          Positioned(
            bottom: MediaQuery
                .of(context)
                .padding
                .bottom + 30,
            child: TextButton(
              onPressed: () async {
                int once = GStorage().getOnce();
                // Utils.openURL('https://www.v2ex.com/auth/google?once=$once');
                var result = await Get.toNamed('/webView', parameters: {'aUrl': '${Strings.v2exHost}/auth/google?once=$once'});
                if (result != null && result['signInGoogle'] == 'success') {
                  SmartDialog.showLoading(msg: '获取信息...');
                  // 登录成功 获取用户信息 / 2FA
                  var signResult = await DioRequestWeb.getUserInfo();
                  if (signResult == 'true') {
                    // 登录成功
                    eventBus.emit('login', 'success');
                    Get.back(result: {'loginStatus': 'success'});
                  } else if (signResult == 'false') {
                    // 登录失败
                    SmartDialog.showToast('登录失败了');
                  } else if (result == '2fa') {
                    print('login 需要两步验证 $result');
                    Login.twoFADialog();
                  }
                } else {
                  SmartDialog.showToast('取消登录');
                }
              },
              child: Row(children: [
                Image.asset('assets/images/google.png', width: 25, height: 25),
                const SizedBox(width: 10),
                Text('Sign in with Google', style: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium)
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
