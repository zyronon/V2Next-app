import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart' hide FormData, Response;
import 'package:html/parser.dart';
import 'package:v2ex/main.dart';
import 'package:v2ex/model/BaseController.dart';
import 'package:v2ex/model/Post2.dart';
import 'package:v2ex/model/model_login_detail.dart';
import 'package:v2ex/package/xpath/src/xpath_base.dart';
import 'package:v2ex/utils/ConstVal.dart';
import 'package:v2ex/utils/global.dart';
import 'package:v2ex/utils/init.dart';
import 'package:v2ex/utils/request.dart';
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
        response = await Http().get('/', data: {'tab': id},isMobile: false);
        break;
      // case 'recent':
      //   return await getTopicsRecent('recent', p).then((value) => value);
      // case 'changes':
      //   return await getTopicsRecent('changes', p).then((value) => value);
      case 'go':
        var r = await getTopicsByNodeId(id, p);
        res['topicList'] = r.topicList;
        return res;
        break;
      default:
        response = await Request().get(
          '/',
          data: {'tab': 'all'},
          extra: {'ua': 'mob'},
        );
        break;
    }

    // DioRequestWeb().resolveNode(response, 'pc');
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
      String tipsContent = document.body!.querySelector('#Main > div.box > div.cell > div > p')!.innerHtml;
      String tipsIp = document.body!.querySelector('#Main > div.box > div.dock_area > div.cell')!.text;
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
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).colorScheme.error),
                ),
                const SizedBox(height: 4),
                Text(tipsContent),
              ],
            ),
            actions: [
              TextButton(onPressed: (() => {SmartDialog.dismiss()}), child: const Text('知道了'))
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
          loginKeyMap.userNameHash = aNode.querySelector('input')!.attributes['name']!;
        }
        if (keyName == '密码') {
          loginKeyMap.once = aNode.querySelector('input')!.attributes['value']!;
          loginKeyMap.passwordHash = aNode.querySelector('input.sl')!.attributes['name']!;
        }
        if (keyName.contains('机器')) {
          loginKeyMap.codeHash = aNode.querySelector('input')!.attributes['name']!;
        }
      }
      if (aNode.querySelector('img') != null) {
        loginKeyMap.captchaImg = '${Strings.v2exHost}${aNode.querySelector('img')!.attributes['src']}?once=${loginKeyMap.once}';
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
      'user-agent': Const.agent.ios
    };

    FormData formData = FormData.fromMap({
      args.userNameHash: args.userNameValue,
      args.passwordHash: args.passwordValue,
      args.codeHash: args.codeValue,
      'once': args.once,
      'next': args.next,
    });

    response = await Request().post('/signin', data: formData, options: options);
    options.contentType = Headers.jsonContentType; // 还原
    print('status${response.statusCode}');
    if (response.statusCode == 302) {
      // 登录成功，重定向
      // SmartDialog.dismiss();
      return await getUserInfo();
      return 'true';
    } else {
      // 登录失败，去获取错误提示信息
      var tree = ETree.fromString(response.data);
      // //*[@id="Wrapper"]/div/div[1]/div[3]/ul/li "输入的验证码不正确"
      // //*[@id="Wrapper"]/div/div[1]/div[2]/ul/li "用户名和密码无法匹配" 等
      String? errorInfo;
      if (tree.xpath('//*[@id="Wrapper"]/div/div[1]/div[3]/ul/li/text()') != null) {
        errorInfo = tree.xpath('//*[@id="Wrapper"]/div/div[1]/div[3]/ul/li/text()')![0].name;
      } else {
        errorInfo = tree.xpath('//*[@id="Wrapper"]/div/div[1]/div[2]/ul/li/text()')![0].name;
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
    var document = parse(response.data);
    var imgEl = document.querySelector('#menu-entry .avatar');
    if (imgEl != null) {
      BaseController bc = Get.find<BaseController>();
      Member member = new Member();
      member.avatar = imgEl.attributes["src"]!;
      member.username = imgEl.attributes["alt"]!;
      bc.setMember(member);
      // todo 判断用户是否开启了两步验证
      // 需要两步验证
      print('两步验证判断');
      if (response.requestOptions.path == "/2fa") {
        print('需要两步验证');
        var tree = ETree.fromString(response.data);
        // //*[@id="Wrapper"]/div/div[1]/div[2]/form/table/tbody/tr[3]/td[2]/input[1]
        String once = tree.xpath("//*[@id='Wrapper']/div/div[1]/div[2]/form/table/tr[3]/td[2]/input[@name='once']")!.first.attributes["value"];
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

  static twoFALOgin(var s) async {}

  static loginOut() async {}

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

  // 获取节点下的主题
  static Future<NodeListModel> getTopicsByNodeId(String nodeId, int p) async {
    // print('------getTopicsByNodeKey---------');
    NodeListModel detailModel = NodeListModel();
    List<Post2> topics = [];
    Response response;
    // 请求PC端页面 lastReplyTime totalPage
    // Request().dio.options.headers = {};
    response = await Http().get(
      '/go/$nodeId',
      data: {'p': p},
      isMobile: false
    );
    var document = parse(response.data);
    if (response.realUri.toString() == '/') {
      SmartDialog.show(
        useSystem: true,
        animationType: SmartAnimationType.centerFade_otherSlide,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('权限不足'),
            content: const Text('登录后查看节点内容'),
            actions: [
              TextButton(onPressed: (() => {SmartDialog.dismiss(), Navigator.pop(context)}), child: const Text('返回上一页')),
              TextButton(
                  // TODO
                  onPressed: (() => {Navigator.of(context).pushNamed('/login')}),
                  child: const Text('去登录'))
            ],
          );
        },
      );
      return detailModel;
    }
    var mainBox = document.body!.children[1].querySelector('#Main');
    var mainHeader = document.querySelector('div.box.box-title.node-header');
    detailModel.nodeCover = mainHeader!.querySelector('img')!.attributes['src']!;
    // 节点名称
    detailModel.nodeName = mainHeader.querySelector('div.node-breadcrumb')!.text.split('›')[1];
    // 主题总数
    detailModel.topicCount = mainHeader.querySelector('strong')!.text;
    // 节点描述
    if (mainHeader.querySelector('div.intro') != null) {
      detailModel.nodeIntro = mainHeader.querySelector('div.intro')!.text;
    }
    // 节点收藏状态
    if (mainHeader.querySelector('div.cell_ops') != null) {
      detailModel.isFavorite = mainHeader.querySelector('div.cell_ops')!.text.contains('取消');
      // 数字
      detailModel.nodeId = mainHeader.querySelector('div.cell_ops > div >a')!.attributes['href']!.split('=')[0].replaceAll(RegExp(r'\D'), '');
    }
    if (mainBox!.querySelector('div.box:not(.box-title)>div.cell:not(.tab-alt-container):not(.item)') != null) {
      var totalpageNode = mainBox.querySelector('div.box:not(.box-title)>div.cell:not(.tab-alt-container)');
      if (totalpageNode!.querySelectorAll('a.page_normal').isNotEmpty) {
        detailModel.totalPage = int.parse(totalpageNode.querySelectorAll('a.page_normal').last.text);
      }
    }

    if (mainBox.querySelector('div.box:not(.box-title)>div.cell.flex-one-row') != null) {
      var favNode = mainBox.querySelector('div.box:not(.box-title)>div.cell.flex-one-row>div');
      detailModel.favoriteCount = int.parse(favNode!.innerHtml.replaceAll(RegExp(r'\D'), ''));
    }

    if (document.querySelector('#TopicsNode') != null) {
      // 主题
      var topicEle = document.querySelector('#TopicsNode')!.querySelectorAll('div.cell');
      for (var aNode in topicEle) {
        var item = Post2();

        //  头像 昵称
        if (aNode.querySelector('td > a > img') != null) {
          item.member.avatar = aNode.querySelector('td > a > img')!.attributes['src']!;
          item.member.username = aNode.querySelector('td > a > img')!.attributes['alt']!;
        }

        if (aNode.querySelector('tr > td:nth-child(5)') != null) {
          item.title =
              aNode.querySelector('td:nth-child(5) > span.item_title')!.text.replaceAll('&quot;', '"').replaceAll('&amp;', '&').replaceAll('&lt;', '<').replaceAll('&gt;', '>');
          // var topicSub = aNode
          //     .querySelector('td:nth-child(5) > span.small')!
          //     .text
          //     .replaceAll('&nbsp;', "");
          // item.memberId = topicSub.split('•')[0].trim();
          // item.clickCount =
          //     topicSub.split('•')[2].trim().replaceAll(RegExp(r'[^0-9]'), '');
        }
        if (aNode.querySelector('tr > td:nth-child(5) > span > a') != null) {
          String? topicUrl = aNode.querySelector('tr > td:nth-child(5) > span > a')!.attributes['href']; // 得到是 /t/522540#reply17
          item.id = topicUrl!.replaceAll("/t/", "").split("#")[0];
          item.replyCount = int.parse(topicUrl.replaceAll("/t/", "").split("#")[1].replaceAll(RegExp(r'\D'), ''));
        }
        if (aNode.querySelector('tr') != null) {
          var topicTd = aNode.querySelector('tr')!.children[2];
          item.lastReplyDate = topicTd.querySelector('span.topic_info > span')!.text.replaceAll("/t/", "");
        }
        // item.nodeName = aNode.xpath("/table/tr/td[3]/span[1]/a/text()")![0].name!;
        topics.add(item);
      }
    }
    try {
      // Read().mark(topics);
    } catch (err) {
      print(err);
    }
    detailModel.topicList = topics;

    var noticeNode = document.body!.querySelector('#Rightbar>div.box>div.cell.flex-one-row');
    if (noticeNode != null) {
      // 未读消息
      var unRead = noticeNode.querySelector('a')!.text.replaceAll(RegExp(r'\D'), '');
      if (int.parse(unRead) > 0) {
        // eventBus.emit('unRead', int.parse(unRead));
      }
    }

    return detailModel;
  }

  static Future<Result> createNoteItem(String itemName) async {
    FormData formData = FormData.fromMap({'content': itemName, 'parent_id': 0, 'syntax': 0});
    Response res = await Http().post('/notes/new', data: formData);

    if (res.statusCode == 302) {
      String? url = res.headers.value('location');
      if (url != null && url.contains('/notes/')) {
        url = url.replaceAll('/notes/', '');
        return Result(success: true, data: url);
      }
    }
    return Result(success: false);
  }

  static Future<Result> editNoteItem(String val, String id) async {
    FormData formData = FormData.fromMap({'content': val, 'syntax': 0});
    Response res = await Http().post('/notes/edit/$id', data: formData);
    return Result(success: res.statusCode == 302);
  }

  //获取记事本条目内容
  static Future<Result> getNoteItemContent(String id, String prefix) async {
    Response res = await Http().get('/notes/edit/${id}');
    if (res.statusCode == 200) {
      var document = parse(res.data);
      var editorEl = document.querySelector('.note_editor');
      if (editorEl != null) {
        String text = editorEl.innerHtml;
        if (text == prefix) {
          return Result(success: false);
        } else {
          String json = text.substring(prefix.length);
          try {
            return Result(success: true, data: jsonDecode(json));
          } catch (e) {
            return Result(success: false);
          }
        }
      }
    }
    return Result(success: false);
  }
}
