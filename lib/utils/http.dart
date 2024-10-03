import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:html/parser.dart';
import 'package:v2ex/model/Post.dart';
import 'package:v2ex/model/Post2.dart';
import 'package:v2ex/model/model_login_detail.dart';
import 'package:v2ex/package/xpath/src/xpath_base.dart';
import 'package:v2ex/utils/init.dart';
import 'package:v2ex/utils/storage.dart';
import 'package:v2ex/utils/string.dart';

class DioRequestWeb {
  static dynamic _parseAndDecode(String response) {
    return jsonDecode(response);
  }

  static Future parseJson(String text) {
    return compute(_parseAndDecode, text);
  }

  // 获取主页分类内容
  static Future getTopicsByTabKey(
    String type,
    String id,
    int p,
  ) async {
    var res = {};
    List<Post2> topicList = [];
    List childNodeList = [];
    List actionCounts = [];
    String balance = '';
    Response response;
    // type
    // all 默认节点 一页   /?tab=xxx
    // recent 最新主题 翻页 /recent?p=1
    // go 子节点 翻页 /go/xxx
    switch (type) {
      case 'tab':
        response = await Request().get(
          '/',
          data: {'tab': id},
          extra: {'ua': 'pc'},
        );
        break;
      // case 'recent':
      //   return await getTopicsRecent('recent', p).then((value) => value);
      // case 'changes':
      //   return await getTopicsRecent('changes', p).then((value) => value);
      // case 'go':
      //   return await NodeWebApi.getTopicsByNodeId(id, p)
      //       .then((value) => value.topicList);
      default:
        response = await Request().get(
          '/',
          data: {'tab': 'all'},
          extra: {'ua': 'mob'},
        );
        break;
    }

    DioRequestWeb().resolveNode(response, 'pc');
    // 用户信息解析 mob
    var rootDom = parse(response.data);

    var userCellWrap = rootDom.querySelectorAll('div.tools > a');
    if (userCellWrap.length >= 6) {
      var onceHref = userCellWrap.last.attributes['onclick'];
      final RegExp regex = RegExp(r"once=(\d+)");
      final RegExpMatch match = regex.firstMatch(onceHref!)!;
      // GStorage().setOnce(int.parse(match.group(1)!));
    }

    var aRootNode = rootDom.querySelectorAll("div[class='cell item']");
    if (aRootNode.isNotEmpty) {
      for (var aNode in aRootNode) {
        Post2 item = Post2();
        var titleInfo = aNode.querySelector("span[class='item_title'] > a");
        item.title = titleInfo!.text;
        var titleInfoUrl = titleInfo.attributes['href'];
        final match = RegExp(r'(\d+)').allMatches(titleInfoUrl!);
        final result = match.map((m) => m.group(0)).toList();
        item.id = result[0]!;
        item.replyCount = int.parse(result[1]!);
        item.member.avatar = aNode.querySelector('img')!.attributes['src']!;
        var topicInfo = aNode.querySelector('span[class="topic_info"]');
        if (topicInfo!.querySelector('span') != null) {
          item.lastReplyDate = topicInfo.querySelector('span')!.text;
        }
        var tagANodes = topicInfo.querySelectorAll('a');
        if (tagANodes[0].attributes['class'] == 'node') {
          item.node.title = tagANodes[0].text;
          item.node.url = tagANodes[0].attributes['href']!.replaceFirst('/go/', '');
        }
        if (tagANodes[1].attributes['href'] != null) {
          item.member.username = tagANodes[1].attributes['href']!.replaceFirst('/member/', '');
        }
        if (tagANodes.length >= 3 && tagANodes[2].attributes['href'] != null) {
          // item.lastReplyMId =
          //     tagANodes[2].attributes['href']!.replaceFirst('/member/', '');
        }
        topicList.add(item);
      }
    }
    try {
      // Read().mark(topicList);
    } catch (err) {
      print(err);
    }
    res['topicList'] = topicList;
    var childNode = rootDom.querySelector("div[id='SecondaryTabs']");
    if (childNode != null) {
      var childNodeEls = childNode.querySelectorAll('a').where((el) => el.attributes['href']!.startsWith('/go'));
      if (childNodeEls.isNotEmpty) {
        for (var i in childNodeEls) {
          print(i);
          var nodeItem = {};
          nodeItem['nodeId'] = i.attributes['href']!.split('/go/')[1];
          nodeItem['nodeName'] = i.text;
          childNodeList.add(nodeItem);
        }
      }
    }
    res['childNodeList'] = childNodeList;

    var rightBarNode = rootDom.querySelector('#Rightbar > div.box');
    List tableList = rightBarNode!.querySelectorAll('table');
    if (tableList.isNotEmpty) {
      var actionNodes = tableList[1]!.querySelectorAll('span.bigger');
      for (var i in actionNodes) {
        actionCounts.add(int.parse(i.text ?? 0));
      }
      if (rightBarNode.querySelector('#money') != null) {
        balance = rightBarNode.querySelector('#money >a')!.innerHtml;
      }
      var noticeEl = rightBarNode.querySelectorAll('a.fade');
      if (noticeEl.isNotEmpty) {
        var unRead = noticeEl[0].text.replaceAll(RegExp(r'\D'), '');
        print('$unRead条未读消息');
        if (int.parse(unRead) > 0) {
          // eventBus.emit('unRead', int.parse(unRead));
        }
      }
    }
    res['actionCounts'] = actionCounts;
    res['balance'] = balance;
    return res;
  }

  resolveNode(response, type) {
    List<Map<dynamic, dynamic>> nodesList = [];
    var document = parse(response.data);
    var nodesBox;
    if (type == 'mob') {
      // 【设置】中可能关闭【首页显示节点导航】
      if (document.querySelector('#Wrapper > div.content')!.children.length >= 4) {
        nodesBox = document.querySelector('#Main')!.children.last;
      }
    }
    if (type == 'pc') {
      // 【设置】中可能关闭【首页显示节点导航】
      if (document.querySelector('#Main')!.children.length >= 4) {
        nodesBox = document.querySelector('#Main')!.children.last;
      }
    }
    if (nodesBox != null) {
      nodesBox.children.removeAt(0);
      var nodeTd = nodesBox.children;
      for (var i in nodeTd) {
        Map nodeItem = {};
        String fName = i.querySelector('span')!.text;
        nodeItem['name'] = fName;
        List<Map> childs = [];
        var cEl = i.querySelectorAll('a');
        for (var j in cEl) {
          Map item = {};
          item['nodeId'] = j.attributes['href']!.split('/').last;
          item['nodeName'] = j.text;
          childs.add(item);
        }
        nodeItem['childs'] = childs;

        nodesList.add(nodeItem);
      }
      nodesList.insert(0, {'name': '已收藏', 'childs': []});
      // GStorage().setNodes(nodesList);
      return nodesList;
    }
  }

  // 获取登录字段
  static Future<LoginDetailModel> getLoginKey() async {
    LoginDetailModel loginKeyMap = LoginDetailModel();
    Response response;
    SmartDialog.showLoading(msg: '获取验证码...');
    response = await Request().get(
      '/signin',
      extra: {'ua': 'mob'},
    );

    var document = parse(response.data);
    var tableDom = document.querySelector('table');
    if (document.body!.querySelector('div.dock_area') != null) {
      // 由于当前 IP 在短时间内的登录尝试次数太多，目前暂时不能继续尝试。
      String tipsContent = document.body!
          .querySelector('#Main > div.box > div.cell > div > p')!
          .innerHtml;
      String tipsIp = document.body!
          .querySelector('#Main > div.box > div.dock_area > div.cell')!
          .text;
      SmartDialog.dismiss();
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
                  tipsIp,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: Theme.of(context).colorScheme.error),
                ),
                const SizedBox(height: 4),
                Text(tipsContent),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: (() => {SmartDialog.dismiss()}),
                  child: const Text('知道了'))
            ],
          );
        },
      );
      return loginKeyMap;
    }
    var trsDom = tableDom!.querySelectorAll('tr');

    for (var aNode in trsDom) {
      String keyName = aNode.querySelector('td')!.text;
      if (keyName.isNotEmpty) {
        if (keyName == '用户名') {
          loginKeyMap.userNameHash =
          aNode.querySelector('input')!.attributes['name']!;
        }
        if (keyName == '密码') {
          loginKeyMap.once = aNode.querySelector('input')!.attributes['value']!;
          loginKeyMap.passwordHash =
          aNode.querySelector('input.sl')!.attributes['name']!;
        }
        if (keyName.contains('机器')) {
          loginKeyMap.codeHash =
          aNode.querySelector('input')!.attributes['name']!;
        }
      }
      if (aNode.querySelector('img') != null) {
        loginKeyMap.captchaImg =
        '${Strings.v2exHost}${aNode.querySelector('img')!.attributes['src']}?once=${loginKeyMap.once}';
      }
    }

    // 获取验证码
    ResponseType resType = ResponseType.bytes;
    Response res = await Request().get(
      "/_captcha",
      data: {'once': loginKeyMap.once},
      extra: {'ua': 'mob', 'resType': resType},
    );
    //  登录后未2fa 退出，第二次进入触发
    if (res.redirects.isNotEmpty && res.redirects[0].location.path == '/2fa') {
      loginKeyMap.twoFa = true;
    } else {
      if ((res.data as List<int>).isEmpty) {
        throw Exception('NetworkImage is an empty file');
      }
      loginKeyMap.captchaImgBytes = Uint8List.fromList(res.data!);
    }
    SmartDialog.dismiss();
    return loginKeyMap;
  }

  // 登录
  static Future<String> onLogin(LoginDetailModel args) async {
    SmartDialog.showLoading(msg: '登录中...');
    Response response;
    Options options = Options();

    options.contentType = Headers.formUrlEncodedContentType;
    options.headers = {
      // 'content-type': 'application/x-www-form-urlencoded',
      // 必须字段
      'Referer': '${Strings.v2exHost}/signin',
      'Origin': Strings.v2exHost,
      'user-agent':
      'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1'
    };

    FormData formData = FormData.fromMap({
      args.userNameHash: args.userNameValue,
      args.passwordHash: args.passwordValue,
      args.codeHash: args.codeValue,
      'once': args.once,
      'next': args.next
    });

    response =
    await Request().post('/signin', data: formData, options: options);
    options.contentType = Headers.jsonContentType; // 还原
    if (response.statusCode == 302) {
      // 登录成功，重定向
      // SmartDialog.dismiss();
      return await getUserInfo();
    } else {
      // 登录失败，去获取错误提示信息
      var tree = ETree.fromString(response.data);
      // //*[@id="Wrapper"]/div/div[1]/div[3]/ul/li "输入的验证码不正确"
      // //*[@id="Wrapper"]/div/div[1]/div[2]/ul/li "用户名和密码无法匹配" 等
      String? errorInfo;
      if (tree.xpath('//*[@id="Wrapper"]/div/div[1]/div[3]/ul/li/text()') !=
          null) {
        errorInfo = tree
            .xpath('//*[@id="Wrapper"]/div/div[1]/div[3]/ul/li/text()')![0]
            .name;
      } else {
        errorInfo = tree
            .xpath('//*[@id="Wrapper"]/div/div[1]/div[2]/ul/li/text()')![0]
            .name;
      }
      SmartDialog.showToast(errorInfo!);
      return 'false';
    }
  }

  // 获取当前用户信息
  static Future<String> getUserInfo() async {
    print('getUserInfo');
    var response = await Request().get('/write', extra: {'ua': 'mob'});
    // SmartDialog.dismiss();
    if (response.redirects.isNotEmpty) {
      print('getUserInfo 2fa');
      // 需要两步验证
      if (response.redirects[0].location.path == "/2fa") {
        response = await Request().get('/2fa');
      }
    }
    var tree = ETree.fromString(response.data);
    var elementOfAvatarImg = tree.xpath("//*[@id='menu-entry']/img")?.first;
    if (elementOfAvatarImg != null &&
        elementOfAvatarImg.attributes['class'].contains('avatar')) {
      // 获取用户头像
      String avatar = elementOfAvatarImg.attributes["src"];
      String userName = elementOfAvatarImg.attributes["alt"];
      GStorage().setUserInfo({'avatar': avatar, 'userName': userName});
      // todo 判断用户是否开启了两步验证
      // 需要两步验证
      print('两步验证判断');
      if (response.requestOptions.path == "/2fa") {
        print('需要两步验证');
        var tree = ETree.fromString(response.data);
        // //*[@id="Wrapper"]/div/div[1]/div[2]/form/table/tbody/tr[3]/td[2]/input[1]
        String once = tree
            .xpath(
            "//*[@id='Wrapper']/div/div[1]/div[2]/form/table/tr[3]/td[2]/input[@name='once']")!
            .first
            .attributes["value"];
        GStorage().setOnce(int.parse(once));
        SmartDialog.dismiss();
        return "2fa";
      } else {
        GStorage().setLoginStatus(true);
        SmartDialog.dismiss();
        return "true";
      }
    }
    SmartDialog.dismiss();
    return "false";
  }

  static twoFALOgin(var s) async{

  }

  static loginOut() async{

  }

  // 感谢回复
  static Future thankReply(String replyId, String topicId) async {
    int once = GStorage().getOnce();
    SmartDialog.showLoading(msg: '表示感谢ing');
    try {
      var response = await Request().post("/thank/reply/$replyId?once=$once");
      // print('1019 thankReply: $response');
      var data = jsonDecode(response.toString());
      SmartDialog.dismiss();
      bool responseStatus = data['success'];
      if (responseStatus) {
        SmartDialog.showToast('操作成功');
      } else {
        SmartDialog.showToast(data['message']);
      }
      if (data['once'] != null) {
        int onceR = data['once'];
        GStorage().setOnce(onceR);
      }
      // 操作成功
      return responseStatus;
    } on DioException catch (e) {
      SmartDialog.dismiss();
      SmartDialog.showToast(e.message!);
    }
  }

}
