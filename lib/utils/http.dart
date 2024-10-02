import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:html/parser.dart';
import 'package:v2ex/model/Post.dart';
import 'package:v2ex/model/Post2.dart';
import 'package:v2ex/utils/init.dart';

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
}
