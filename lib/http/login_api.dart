import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:html/dom.dart' hide Text, Node;
import 'package:html/parser.dart';
import 'package:v2ex/http/api.dart';
import 'package:v2ex/http/login_dio.dart';
import 'package:v2ex/http/request.dart';
import 'package:v2ex/model/BaseController.dart';
import 'package:v2ex/model/model.dart';
import 'package:v2ex/utils/const_val.dart';
import 'package:v2ex/utils/storage.dart';
import 'package:v2ex/utils/utils.dart';

class LoginApi {
  // 获取登录字段
  static Future<Result> getLoginKey() async {
    Result result = Result(success: false);
    LoginDetailModel loginKeyMap = LoginDetailModel();
    Response response = await LoginDio().get('/signin', isMobile: true);

    var document = parse(response.data);
    var tableDom = document.querySelector('table');
    if (document.body!.querySelector('.dock_area') != null) {
      // 由于当前 IP 在短时间内的登录尝试次数太多，目前暂时不能继续尝试。
      String tipsContent = document.body!.querySelector('#Wrapper  .box .cell  p')!.innerHtml;
      String tipsIp = document.body!.querySelector('#Wrapper .box .dock_area  .cell')!.text;
      result.data = [tipsIp, tipsContent];
      return result;
    }
    var trsDom = tableDom!.querySelectorAll('tr');

    for (var aNode in trsDom) {
      String keyName = aNode.querySelector('td')!.text;
      if (keyName.isNotEmpty) {
        if (keyName == '用户名') {
          loginKeyMap.usernameHash = aNode.querySelector('input')!.attributes['name']!;
        }
        if (keyName == '密码') {
          loginKeyMap.once = aNode.querySelector('input')!.attributes['value']!;
          GStorage().setOnce(int.parse(loginKeyMap.once));
          loginKeyMap.pwdHash = aNode.querySelector('input.sl')!.attributes['name']!;
        }
        if (keyName.contains('机器')) {
          loginKeyMap.codeHash = aNode.querySelector('input')!.attributes['name']!;
        }
      }
      if (aNode.querySelector('img') != null) {
        loginKeyMap.captchaImg = '${Const.v2exHost}${aNode.querySelector('img')!.attributes['src']}?once=${loginKeyMap.once}';
      }
    }

    // 获取验证码
    ResponseType resType = ResponseType.bytes;
    Response res = await LoginDio().get("/_captcha", data: {'once': loginKeyMap.once}, responseType: resType, isMobile: true);
    //  登录后未2fa 退出，第二次进入触发
    if (res.redirects.isNotEmpty && res.redirects[0].location.path == '/2fa') {
      loginKeyMap.twoFa = true;
    } else {
      if ((res.data as List<int>).isEmpty) {
        throw Exception('NetworkImage is an empty file');
      }
      loginKeyMap.captchaImgBytes = Uint8List.fromList(res.data!);
    }
    result.success = true;
    result.data = loginKeyMap;
    return result;
  }

  // 登录
  static Future<Result> login(LoginDetailModel args) async {
    Options options = Options();
    options.contentType = Headers.formUrlEncodedContentType;
    options.headers = {
      // 'content-type': 'application/x-www-form-urlencoded',
      // 必须字段
      'Referer': '${Const.v2exHost}/signin',
      'Origin': Const.v2exHost,
      'user-agent': Const.agent.ios
    };

    FormData formData = FormData.fromMap({
      args.usernameHash: args.username,
      args.pwdHash: args.pwd,
      args.codeHash: args.code,
      'once': args.once,
      'next': '/',
    });

    Result res = Result(success: false, data: []);
    Response response = await LoginDio().post('/signin', data: formData, options: options, isMobile: true);
    options.contentType = Headers.jsonContentType; // 还原
    debugger();
    print('status${response.statusCode}');

    if (response.statusCode == 302) {
      return await getUserInfo();
    } else {
      Document document = parse(response.data);
      Element? problem = document.querySelector('#Wrapper .problem');
      if (document.querySelector('.dock_area') != null) {
        // 由于当前 IP 在短时间内的登录尝试次数太多，目前暂时不能继续尝试。
        String tipsContent = document.body!.querySelector('#Wrapper  .box .cell  p')!.innerHtml;
        String tipsIp = document.body!.querySelector('#Wrapper .box .dock_area  .cell')!.text;
        res.data = [tipsIp, tipsContent];
        res.success = false;
      }
      // 登录失败，去获取错误提示信息
      else if (problem != null) {
        var text = problem.querySelector('li');
        if (text != null) {
          res.data = [text.text];
        } else {
          res.data = ['登录失败了'];
        }
        res.success = false;
      } else {
        var imgEl = document.querySelector('#menu-entry .avatar');
        if (imgEl != null) {
          return await getUserInfo();
        }
        res.data = ['登录失败'];
        res.success = false;
      }
    }
    return res;
  }

  // 获取当前用户信息
  static Future<Result> getUserInfo({UserConfig? uc}) async {
    //有可能是刚登录，需要同步一下cookie
    await Http().setCookie();
    Result result = Result(data: []);
    print('getUserInfo');
    Member member = new Member();
    if (uc == null) uc = UserConfig();
    //移动端的有头像
    Response res = await Http().get('/notes', isMobile: true);
    if (res.data.contains('两步验证登录')) {
      print('需要两步验证登录');
      var document = parse(res.data);
      var once = document.querySelector('input[name="once"]');
      if (once != null) {
        GStorage().setOnce(int.parse(once.attributes['value']!));
        result.success = true;
        result.data = {'type': '2fa'};
        member.needAuth2fa = true;
      }
      //如果开了2fa，那么这里返回的将是电脑页面，取不到头像
      var tops = document.querySelectorAll('.top');
      member.username = tops[1].text;
    } else {
      if (!(res.data as String).contains('其他登录方式')) {
        print('已登录');
        Document document = parse(res.data);
        //获取用户信息
        Element? avatarEl = document.querySelector('#menu-entry .avatar');
        if (avatarEl != null) {
          member.username = avatarEl.attributes['alt']!;
          member.avatar = avatarEl.attributes['src']!;
          print('当前用户${member.username}');
          //获取、节点收藏、主题收藏、特别关注
          var res2 = await Http().get('/?tab=all', isMobile: false);
          Document document2 = parse(res2.data);
          var rightBarNode = document2.querySelector('#Rightbar > div.box');
          List tableList = rightBarNode!.querySelectorAll('table');
          if (tableList.isNotEmpty) {
            member.actionCounts = [];
            var actionNodes = tableList[1]!.querySelectorAll('span.bigger');
            for (var i in actionNodes) {
              member.actionCounts.add(int.parse(i.text ?? 0));
              print('actionCounts:${i.text}');
            }
            if (rightBarNode.querySelector('#money') != null) {
              var imgList = rightBarNode.querySelectorAll('#money > a img');
              imgList.forEach((img) {
                img.attributes['src'] = Const.v2exHost + img.attributes['src']!;
              });
              member.balance = rightBarNode.querySelector('#money >a')!.innerHtml;
            }
            var noticeEl = rightBarNode.querySelectorAll('a.fade');
            if (noticeEl.isNotEmpty) {
              var unRead = noticeEl[0].text.replaceAll(RegExp(r'\D'), '');
              print('$unRead条未读消息');
              member.actionCounts.add(int.parse(unRead));
            }
          }
        }

        List<Element> nodeListEl = document.querySelectorAll('#Wrapper .box .cell a');

        //配置逻辑
        bool needInitConfig = false;
        if (uc.configNoteId.isEmpty) {
          needInitConfig = true;
        } else {
          Result res = await Api.getNoteItemContent(uc.configNoteId, Const.configPrefix);
          if (res.success) {
            print('获取配置${res.data.toString()}');
            uc = UserConfig.fromJson(res.data);
          } else {
            //没有这个id的数据
            if (res.data == 0) {
              needInitConfig = true;
            } else {
              await Api.editNoteItem(Const.configPrefix + jsonEncode(uc.toJson()), uc.configNoteId);
            }
          }
        }
        if (needInitConfig) {
          //先查一下列表，有没有重复创建的
          if (nodeListEl.isNotEmpty) {
            //获取配置
            List<Element> tagItems = nodeListEl.where((v) => v.text.contains(Const.configPrefix)).toList();
            if (tagItems.isNotEmpty) {
              var configNoteId = tagItems[0].attributes['href']!.replaceAll('/notes/', '');
              Result res = await Api.getNoteItemContent(configNoteId, Const.configPrefix);
              //可能为空
              if (res.success) {
                print('获取配置${res.data.toString()}');
                uc = UserConfig.fromJson(res.data);
              } else {
                await Api.editNoteItem(Const.configPrefix + jsonEncode(uc.toJson()), configNoteId);
              }
              uc.configNoteId = configNoteId;
              needInitConfig = false;
            } else {
              needInitConfig = true;
            }
          }
          if (needInitConfig) {
            //创建配置
            print('初始化配置');
            Result r = await Api.createNoteItem(Const.configPrefix + jsonEncode(uc.toJson()));
            if (r.success) {
              uc.configNoteId = r.data;
            }
          }
        }

        if (uc.openTag) {
          //标签逻辑
          bool needInitTag = false;
          if (uc.tagNoteId.isEmpty) {
            needInitTag = true;
          } else {
            Result res = await Api.getNoteItemContent(uc.tagNoteId, Const.tagPrefix);
            if (res.success) {
              print('获取配置${res.data.toString()}');
              member.tagMap = res.data;
            } else {
              //没有这个id的数据
              if (res.data == 0) {
                needInitTag = true;
              } else {
                await Api.editNoteItem(Const.tagPrefix + jsonEncode(member.tagMap), uc.tagNoteId);
              }
            }
          }
          if (needInitTag) {
            //先查一下列表，有没有重复创建的
            if (nodeListEl.isNotEmpty) {
              //获取配置
              List<Element> tagItems = nodeListEl.where((v) => v.text.contains(Const.tagPrefix)).toList();
              if (tagItems.isNotEmpty) {
                var tagNoteId = tagItems[0].attributes['href']!.replaceAll('/notes/', '');
                Result res = await Api.getNoteItemContent(tagNoteId, Const.tagPrefix);
                //可能为空
                if (res.success) {
                  print('获取标签${res.data.toString()}');
                  member.tagMap = res.data;
                } else {
                  await Api.editNoteItem(Const.tagPrefix + jsonEncode(member.tagMap), tagNoteId);
                }
                uc.tagNoteId = tagNoteId;
                needInitTag = false;
              } else {
                needInitTag = true;
              }
            }
            if (needInitTag) {
              //创建标签
              print('初始化标签');
              Result r = await Api.createNoteItem(Const.tagPrefix + jsonEncode(member.tagMap));
              if (r.success) {
                uc.tagNoteId = r.data;
              }
            }
          }
        }

        result.success = true;
        result.data = {'type': 'ok', 'member': member, 'uc': uc};
      } else {
        print('登录失败了2');
        result.data = ['登录失败了2'];
        result.success = false;
      }
    }
    return result;
  }

  // 2fa登录
  static Future<String> twoFALOgin(String code) async {
    SmartDialog.showLoading();
    Response response;
    FormData formData = FormData.fromMap({
      "once": GStorage().getOnce(),
      "code": code,
    });
    response = await LoginDio().post('/2fa', data: formData);
    // var document = parse(response.data);
    // log(document.body!.innerHtml);
    // var menuBodyNode = document.querySelector("div[id='menu-body']");
    // var loginOutNode =
    // menuBodyNode!.querySelectorAll('div.cell').last.querySelector('a');
    // var loginOutHref = loginOutNode!.attributes['href'];
    // int once = int.parse(loginOutHref!.split('once=')[1]);
    // GStorage().setOnce(once);
    SmartDialog.dismiss();
    if (response.statusCode == 302) {
      print('成功');
      return 'true';
    } else {
      SmartDialog.showToast('验证失败，请重新输入');
      return 'false';
    }
  }

  static Future logout() async {
    BaseController bc = BaseController.to;
    bc.setMember(Member());
    int once = GStorage().getOnce();
    await LoginDio().get('/signout?once=$once');
    await LoginDio.cookieManager.cookieJar.deleteAll();
    await Http.cookieManager!.cookieJar.deleteAll();
    LoginDio.dio.options.headers['cookie'] = '';
    Http.dio.options.headers['cookie'] = '';
    final inAppCookieManager = CookieManager.instance();
    inAppCookieManager.deleteAllCookies();
  }

  static sign() async {
    String timeNow = '${DateTime.now().toUtc().year}/${DateTime.now().toUtc().month}/${DateTime.now().toUtc().day}'; // 当前 UTC-0 时间（V2EX 按这个时间的）
    String timeOld = GStorage().getSignDate();
    if (timeOld.isEmpty || timeOld != timeNow) {
      Http().get('/mission/daily').then((r) async {
        Document document = parse(r.data);
        var item = document.querySelector('input[value^="领取"]');
        if (item != null) {
          var once = await Utils.getOnce(document);
          LoginDio().get('/mission/daily/redeem?once=${once}').then((r) {
            document = parse(r.data);
            item = document.querySelector('li.fa.fa-ok-sign');
            if (item != null) {
              RegExp loginDaysRegExp = RegExp(r'已连续登录 (\d+?) 天');
              item = document.querySelector('#Main');
              if (item != null) {
                String? loginDays = loginDaysRegExp.firstMatch(item!.text)?.group(0);
                BaseController.to.member.sign = loginDays!;
                print('[V2Next] ！$loginDays');
              }
              GStorage().setSignDate(timeNow);
              print('[V2Next] 自动签到完成！');
              BaseController.to.member.sign = '已签到';
            } else {
              print('[V2Next] 自动签到失败！请关闭其他插件或脚本。如果连续几天都签到失败，请联系作者解决！');
            }
          });
        } else {
          BaseController.to.member.sign = '已签到';
          GStorage().setSignDate(timeNow);
        }
      });
    }else{
      BaseController.to.member.sign = '已签到';
    }
  }
}
