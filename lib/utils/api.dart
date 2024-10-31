import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide Element;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart' hide Response;
import 'package:html/dom.dart' hide Text, Node;
import 'package:html/parser.dart';
import 'package:v2ex/model/Post2.dart';
import 'package:v2ex/model/TabItem.dart';
import 'package:v2ex/model/item_node.dart';
import 'package:v2ex/utils/ConstVal.dart';
import 'package:v2ex/utils/request.dart';
import 'package:v2ex/utils/storage.dart';
import 'package:v2ex/utils/utils.dart';
import 'package:xml2json/xml2json.dart';

class Api {
  //获取tab 主题列表
  static Future<Result> getPostListByTab({required TabItem tab, int pageNo = 1, String? date}) async {
    Result res = new Result();
    Response response;
    List<Post2> postList = [];
    List<V2Node> nodeList = [];
    switch (tab.type) {
      case TabType.tab:
        if (pageNo == 1) {
          //用pc网站，因为要取子tab。不取子tab可以用mobile网站
          response = await Http().get('/', data: {'tab': tab.enName}, isMobile: false);
          Document document = parse(response.data);
          List<Element> listEl = document.querySelectorAll("div[class='cell item']");
          List<Element> childNodeEl = document.querySelectorAll("#SecondaryTabs > a");
          for (var i in childNodeEl) {
            List<String> s = i.attributes['href']!.split('/go/');
            if (s.isNotEmpty && s.length >= 2) {
              nodeList.add(V2Node(enName: s[1], cnName: i.text));
            }
          }
          postList = Utils().parsePagePostList(listEl);
        }
        res.success = true;
        res.data = {'list': postList, 'nodeList': nodeList};
        break;
      case TabType.node:
        NodeListModel? s = await getNodePageInfo(nodeEnName: tab.enName, pageNo: pageNo);
        if (s != null) {
          res.success = true;
          res.data = {'list': s.topicList, 'nodeList': nodeList};
        } else {
          res.success = false;
          res.data = Auth.notAllow;
        }
        break;
      case TabType.latest:
        res.success = true;
        if (pageNo == 1) {
          postList = await getLatestPostList(nodeId: tab.enName, pageNo: pageNo);
        }
        res.data = {'list': postList, 'nodeList': nodeList};
        break;
      // case 'changes':
      //   return await getTopicsRecent('changes', p).then((value) => value);
      // case TabType.node:
      //   var r = await getTopicsByNodeId(id, p);
      //   res['topicList'] = r.topicList;
      //   return res;
      //   break;
      default:
        response = await Http().get('/', data: {'tab': 'all'});
        break;
    }
    return res;
  }

  //获取最热主题列表
  static Future<Result> getHotPostList({String? date}) async {
    Result res = new Result();
    Response response;
    if (date == null) {
      response = await Http().get('/?tab=hot');
      Document document = parse(response.data);
      List<Element> aRootNode = document.querySelectorAll("div[class='cell item']");
      res.success = true;
      res.data = Utils().parsePagePostList(aRootNode);
    } else {
      response = await Http().get(Const.v2Hot + '/hot/${date}.json');
      List<Post2> list = [];
      (response.data as List).forEach((v) {
        Post2 item = Post2.fromJson(v);
        item.member.username = v['username'];
        item.member.avatar = v['avatar'];
        item.node.cnName = v['nodeTitle'];
        item.node.enName = v['nodeUrl'];
        list.add(item);
      });
      res.success = true;
      res.data = list;
    }
    return res;
  }

  //获取v2 最热 时间列表
  static Future<List<String>> getV2HotDateMap() async {
    List<String> list = [];
    Response response = await Http().get(Const.v2Hot + '/hot/map.json');
    if (response.data != null) {
      list = response.data.cast<String>();
    }
    return list;
  }

  static Future<NodeListModel?> getNodePageInfo({required String nodeEnName, int pageNo = 1}) async {
    NodeListModel detailModel = NodeListModel();
    detailModel.nodeEnName = nodeEnName;
    //手机端 收藏人数获取不到
    Response response = await Http().get('/go/$nodeEnName', data: {'p': pageNo});
    var document = parse(response.data);
    var mainBox = document.body!.children[1].querySelector('#Main');
    var mainHeader = mainBox!.querySelector('.node-header');
    if (response.realUri.toString() == '/' || (response.data as String).contains('其他登录方式') || mainHeader == null) {
      print('无权限');
      //TODO 无权限
      return null;
    }

    detailModel.nodeCover = mainHeader.querySelector('img')!.attributes['src']!;
    // 节点名称
    detailModel.nodeCnName = mainHeader.querySelector('div.node-breadcrumb')!.text.split('›')[1];
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

      detailModel.topicList = Utils().parsePagePostList(topicEle);
    }
    return detailModel;
  }

  //获取发布页
  static Future<Result> getDiscoverInfo({String? date}) async {
    Result res = new Result();
    Response response;
    if (date == '') {
      response = await Http().get('/api/topics/hot.json');
      List<dynamic> list = response.data;
      res.success = true;
      res.data = list
          .map((e) => Post2(
                id: e['id'].toString(),
                title: e['title'],
                member: Member(
                  avatar: e['member']['avatar_normal'],
                  avatarLarge: e['member']['avatar_large'],
                  username: e['member']['username'],
                ),
                node: V2Node(
                  enName: e['node']['name'],
                  cnName: e['node']['title'],
                ),
                contentText: e['content'],
                contentRendered: e['content_rendered'],
                replyCount: e['replies'],
                lastReplyUsername: e['last_reply_by'],
              ))
          .toList();
    } else {
      response = await Http().get(Const.v2Hot + '/hot/${date}.json');
      List<Post2> list = [];
      (response.data as List).forEach((v) {
        Post2 item = Post2.fromJson(v);
        item.member.username = v['username'];
        item.member.avatar = v['avatar'];
        item.node.cnName = v['nodeTitle'];
        item.node.enName = v['nodeUrl'];
        list.add(item);
      });
      res.success = true;
      res.data = list;
    }
    return res;
  }

  //获取通知
  static Future<MemberNoticeModel> getNotifications({int pageNo = 1}) async {
    MemberNoticeModel memberNotices = MemberNoticeModel();
    List<MemberNoticeItem> noticeList = [];

    Response response = await Http().get('/notifications', data: {'p': pageNo});
    Document document = parse(response.data);
    List<Element> cellList = document.querySelectorAll('#notifications > .cell');
    Element? countEl = document.querySelector('#Main .box .header strong');
    if (countEl != null) {
      memberNotices.totalCount = int.parse(countEl.text);
    }
    Element? inputEl = document.querySelector('#Main .box .ps_container input');
    if (inputEl != null) {
      var max = inputEl.attributes['max'];
      if (max != null) {
        memberNotices.totalPage = int.parse(max);
      }
    }

    for (var i = 0; i < cellList.length; i++) {
      var aNode = cellList[i];
      MemberNoticeItem noticeItem = MemberNoticeItem();
      noticeItem.memberAvatar = aNode.querySelector('tr>td>a>img')!.attributes['src']!;
      noticeItem.memberId = aNode.querySelector('tr>td>a>img')!.attributes['alt']!;

      var td2Node = aNode.querySelectorAll('tr>td')[1];

      noticeItem.topicId = td2Node.querySelectorAll('span.fade>a')[1].attributes['href']!.split('/')[2].split('#')[0];
      noticeItem.topicTitle = td2Node.querySelectorAll('span.fade>a')[1].text;
      var noticeTypeStr = td2Node.querySelector('span.fade')!.nodes[1];

      if (noticeTypeStr.text!.contains('在回复')) {
        noticeItem.noticeType = NoticeType.reply;
      }
      if (noticeTypeStr.text!.contains('回复了你')) {
        noticeItem.noticeType = NoticeType.reply;
      }
      if (noticeTypeStr.text!.contains('收藏了你发布的主题')) {
        noticeItem.noticeType = NoticeType.favTopic;
      }
      if (noticeTypeStr.text!.contains('感谢了你发布的主题')) {
        noticeItem.noticeType = NoticeType.thanksTopic;
      }
      if (noticeTypeStr.text!.contains('感谢了你在主题')) {
        noticeItem.noticeType = NoticeType.thanksReply;
      }

      if (td2Node.querySelector('div.payload') != null) {
        noticeItem.replyContentHtml = td2Node.querySelector('div.payload')!.innerHtml;
      } else {
        noticeItem.replyContentHtml = null;
      }

      noticeItem.replyTime = td2Node.querySelector('span.snow')!.text.replaceAll('+08:00', '');
      var delNum = td2Node.querySelector('a.node')!.attributes['onclick']!.replaceAll(RegExp(r"[deleteNotification( | )]"), '');
      noticeItem.delIdOne = delNum.split(',')[0];
      noticeItem.delIdTwo = delNum.split(',')[1];
      noticeList.add(noticeItem);
    }
    memberNotices.noticeList = noticeList;
    return memberNotices;
  }

  //获取最新帖子(特殊处理)
  static Future<List<Post2>> getLatestPostList({required String nodeId, int pageNo = 0}) async {
    List<Post2> list = [];
    Response response = await Http().get('/index.xml');
    final myTransformer = Xml2Json();
    myTransformer.parse(response.data);
    var json = myTransformer.toOpenRally();
    // var json = myTransformer.toBadgerfish();

    List xmlList = jsonDecode(json)['feed']['entry'];

    xmlList.forEach((item) {
      Post2 p = new Post2();
      // print(item);
      p.title = item['title'].replaceAll(RegExp(r'^\[.*?\]'), '');
      p.title = p.title.trim();
      RegExp regExp = RegExp(r'^\[.*?\]');
      Match? match = regExp.firstMatch(item['title']);
      if (match != null) {
        String nodeText = match.group(0)!;
        p.node.cnName = nodeText.replaceAll('[', '').replaceAll(']', '');
      }
      String? href = item['link']['href'];
      var match1 = RegExp(r'(\d+)').allMatches(href!);
      var result = match1.map((m) => m.group(0)).toList();
      p.id = result[1]!;
      p.createDateAgo = Utils().timeAgo(item['published']);
      // p.contentHtml = item['content'];
      // print(item['content']);
      p.member.username = item['author']['name'];
      list.add(p);
    });
    return list;
  }

  static Future<Post2> getPostDetail(String id) async {
    Post2 post = Post2();
    var tt = DateTime.now();
    print('请求开始$tt');
    var response = await Http().get("/t/$id?p=1", isMobile: false);
    var ss = DateTime.now();
    print('请求结束$ss');
    var hours = tt.difference(ss);
    print('请求花费时间$hours');

    String htmlText = response.data;
    var document = parse(response.data);
    var wrapper = document.querySelector('#Main');

    //不知为何dio的 重写向检测不到，加上下面两个判断
    //给出提示了就是没权限
    //如果没有头像，那也是没权限
    if (response.redirects.isNotEmpty || document.querySelector('#Main > div.box > div.message') != null || document.querySelector('#Main > .box > .header .avatar') == null) {
      SmartDialog.show(
        useSystem: true,
        animationType: SmartAnimationType.centerFade_otherSlide,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('权限不足'),
            content: const Text('登录后查看主题内容'),
            actions: [
              TextButton(onPressed: (() => {SmartDialog.dismiss(), Get.back()}), child: const Text('返回')),
              TextButton(
                  // TODO
                  onPressed: (() => {Get.toNamed('/login')}),
                  child: const Text('去登录'))
            ],
          );
        },
      );
      // post.isAuth = true;
      return post;
    }

    // [email_protected] 转码回到正确的邮件字符串
    List<Element> emailNode = document.querySelectorAll(".__cf_email__");
    if (emailNode.isNotEmpty) {
      for (var aNode in emailNode) {
        String encodedCf = aNode.attributes["data-cfemail"].toString();
        var newEl = document.createElement('a');
        newEl.innerHtml = Utils.cfDecodeEmail(encodedCf);
        newEl.attributes['href'] = 'mailto:${newEl.innerHtml}';
        aNode.replaceWith(newEl);
      }
    }

    post.id = id;

    RegExp regExp = RegExp(r'var once = "([\d]+)";');
    Match? once = regExp.firstMatch(htmlText);
    if (once != null && once.group(1) != null) {
      post.once = once.group(1)!;
      GStorage().setOnce(int.parse(post.once));
    }
    post.isReport = htmlText.contains('你已对本主题进行了报告');

    // 如果没有正文（点的本站的a标签），才会解析正文
    if (post.title == '' || post.contentRendered == 'null') {
      var h1 = wrapper!.querySelector('h1');
      if (h1 != null) {
        post.title = h1.text;
      }
    }

    var as = wrapper!.querySelectorAll('.header > a');
    if (as.isNotEmpty) {
      post.node.cnName = as[1].text;
      post.node.enName = as[1].attributes['href']!.replaceAll('/go/', '');
    }

    var header = wrapper.querySelector('.header');
    if (header != null) {
      var avatarEl = header.querySelector('.avatar');
      if (avatarEl != null) {
        post.member.avatarLarge = avatarEl.attributes['src']!;
      }

      var smallEl = header.querySelector('small');
      if (smallEl != null) {
        var aName = smallEl.querySelector('a');
        if (aName != null) {
          post.member.username = aName.text;
        }

        var spanEl = smallEl.querySelector('span');
        if (spanEl != null) {
          post.createDateAgo = spanEl.text.replaceFirst(' +08:00', '');
          post.createDate = spanEl.attributes['title']!.replaceFirst(' +08:00', '');
        }

        var clickCountReg = RegExp(r'(\d+)\s*次点击').allMatches(smallEl.innerHtml);
        if (clickCountReg.isNotEmpty) {
          post.clickCount = int.parse(clickCountReg.first.group(1)!);
        }

        var opNodes = smallEl.querySelectorAll('a.op');
        if (opNodes.isNotEmpty) {
          for (var i in opNodes) {
            if (i.text.contains('APPEND')) {
              post.isAppend = true;
            }
            if (i.text.contains('EDIT')) {
              post.isEdit = true;
            }
            if (i.text.contains('MOVE')) {
              post.isMove = true;
            }
          }
        }
      }
    }

    var boxListEl = wrapper.querySelectorAll('#Main .box');

    //获取正文加附言
    var temp = boxListEl[0].clone(true);
    var t = temp.querySelector('.topic_buttons');
    if (t != null) t.remove();
    t = temp.querySelector('.inner');
    if (t != null) t.remove();
    t = temp.querySelector('.header');
    if (t != null) t.remove();
    Utils.checkPhotoLink2Img(temp);
    post.contentRendered = temp.innerHtml.replaceAll(' +08:00', '');
    var contentEl = temp.querySelector('.topic_content');
    if (contentEl != null) {
      post.contentText = contentEl.text.trim();
    }

    var topicButtons = document.querySelector('.topic_buttons');
    if (topicButtons != null) {
      var tbs = topicButtons.querySelectorAll('.tb');
      if (tbs.isNotEmpty) {
        print(tbs);
        var favoriteNode = tbs[0];
        post.isFavorite = favoriteNode.text == '取消收藏';
        if (tbs.length > 2) {
          var ignoreNode = tbs[2];
          post.isIgnore = ignoreNode.text == '取消忽略';
        }
      }

      var thankNode = topicButtons.querySelector('#topic_thank .topic_thanked');
      if (thankNode != null) {
        post.isThanked = true;
      }

      var topicStats = topicButtons.querySelector('.topic_stats');
      if (topicStats != null) {
        var text = topicStats.text;
        var collectCountReg = RegExp(r'(\d+)\s*人收藏').allMatches(text);
        if (collectCountReg.isNotEmpty) {
          post.collectCount = int.parse(collectCountReg.first.group(1)!);
        }

        var thankCountReg = RegExp(r'(\d+)\s*人感谢').allMatches(text);
        if (thankCountReg.isNotEmpty) {
          post.thankCount = int.parse(thankCountReg.first.group(1)!);
        }
      }
    }

    if (document.querySelector('#no-comments-yet') == null) {
      List<Element> cells = boxListEl[1].querySelectorAll('.cell');
      if (cells.isNotEmpty) {
        post.fr = cells[0].querySelector('.cell .fr')!.innerHtml;
        //获取最后一次回复时间
        var snow = cells[0].querySelector('.snow');
        if (snow != null) {
          var nodes = snow.parent!.nodes;
          post.lastReplyDate = nodes[nodes.length - 1].text!.replaceAll(' +08:00', '');
        }

        List<Map> repliesMap = [];
        if (cells[1].id.isNotEmpty) {
          repliesMap.add({'i': 1, 'replyList': parsePageReplies(cells.sublist(1))});
        } else {
          List<Future> promiseList = [];
          repliesMap.add({'i': 1, 'replyList': parsePageReplies(cells.sublist(2))});

          var pages = cells[1].querySelectorAll('a.page_normal');
          var url = '/t/' + post.id;

          for (var i in pages) {
            promiseList.add(fetchPostOtherPageReplies(url + '?p=' + i.text, int.parse(i.text)));
          }
          var results = await Utils.allSettled(promiseList);
          results.where((result) => result['status'] == "fulfilled").forEach((v) => repliesMap.add(v['value']));
        }
        List<Reply> replyList = Utils.getAllReply(repliesMap);
        post = Utils.buildList(post, replyList);
      }
    }
    ss = DateTime.now();
    print('处理结束$ss');
    hours = tt.difference(ss);
    print('总花费时间$hours');
    return post;
  }

  static List<Reply> parsePageReplies(List<Element> nodes) {
    List<Reply> replyList = [];
    for (var node in nodes) {
      if (node.attributes['id'] == null) continue;
      Reply item = Reply();
      item.id = node.attributes['id']!.replaceAll('r_', '');
      var replyContentElement = node.querySelector('.reply_content');
      Utils.checkPhotoLink2Img(replyContentElement!);
      item.replyContent = replyContentElement!.innerHtml;
      item.replyText = replyContentElement.text;

      var parsedContent = Utils.parseReplyContent(item.replyContent);
      item.hideCallUserReplyContent = item.replyContent;

      if (parsedContent['users'].length == 1) {
        item.hideCallUserReplyContent = item.replyContent.replaceAll(RegExp(r'@<a href="/member/[\s\S]+?</a>(\s#[\d]+)?\s(<br>)?'), '');
      }
      item.replyUsers = parsedContent['users'];
      item.replyFloor = parsedContent['floor'];

      var agoElement = node.querySelector('.ago');
      item.date = agoElement!.text;
      // 时间（去除+ 08:00）和平台（Android/iPhone）;
      item.date = item.date.replaceFirst(' +08:00', '');
      item.date = item.date.replaceAll(' PM', '');
      item.date = item.date.replaceAll(' AM', '');
      // if (item.date.contains('via')) {
      //   var platform = item.date.split('via')[1].replaceAll(RegExp(r"\s+"), "");
      //   item.date = item.date.split('via')[0].replaceAll("/t/", "");
      //   item.platform = platform;
      // }

      var userNode = node.querySelector('strong a');
      item.username = userNode!.text;

      var avatarElement = node.querySelector('td img');
      item.avatar = avatarElement!.attributes['src']!;

      var noElement = node.querySelector('.no');
      item.floor = int.parse(noElement!.text);

      var thankAreaElement = node.querySelector('.thank_area');
      if (thankAreaElement != null) {
        item.isThanked = thankAreaElement.classes.contains('thanked');
      }

      var smallElement = node.querySelector('.small');
      if (smallElement != null) {
        item.thankCount = int.parse(smallElement.text);
      }

      var opElement = node.querySelector('.op');
      if (opElement != null) {
        item.isOp = true;
      }

      var modElement = node.querySelector('.mod');
      if (modElement != null) {
        item.isMod = true;
      }

      replyList.add(item);
    }
    return replyList;
  }

  static Future<Map> fetchPostOtherPageReplies(String href, int pageNo) async {
    return Future(() async {
      try {
        var response = await Http().get(href, isMobile: false);
        var document = parse(response.data);
        var boxListEl = document.querySelectorAll('#Main .box');
        List<Element> cells = boxListEl[1].querySelectorAll('.cell');
        return {'i': pageNo, 'replyList': parsePageReplies(cells.sublist(2))};
      } catch (e) {
        throw Exception("bad code! -> ${e.toString()}");
      }
    });
  }

  thank(String id) {}

  reply(String id, String content) {}

  collect(String id, int type) {}

  // 获取所有节点 pc
  static Future getNodes() async {
    Response response;
    response = await Http().get(
      '/',
    );
    return Utils.resolveNode(response, 'pc');
  }

  // 所有节点
  static Future<List<NodeItem>> getAllNodes() async {
    Response response = await Http().get(
      Const.allNodes,
    );
    List<dynamic> list = response.data;
    return list.map((e) => NodeItem.fromJson(e)).toList();
  }

  // 获取收藏的节点
  static Future<List<NodeFavModel>> getFavNodes() async {
    List<NodeFavModel> favNodeList = [];
    Response response;
    response = await Http().get('/my/nodes');
    var bodyDom = parse(response.data).body;
    var nodeListWrap = bodyDom!.querySelector('div[id="my-nodes"]');
    List<Element> nodeListDom = [];
    if (nodeListWrap != null) {
      nodeListDom = nodeListWrap.querySelectorAll('a');
      for (var i in nodeListDom) {
        NodeFavModel item = NodeFavModel();
        if (i.querySelector('img') != null) {
          item.nodeCover = i.querySelector('img')!.attributes['src']!;
          if (item.nodeCover.contains('/static')) {
            item.nodeCover = '';
          }
          item.nodeId = i.attributes['href']!.split('/')[2];
        }
        item.nodeName = i.querySelector('span.fav-node-name')!.text;
        item.topicCount = i.querySelector('span.f12.fade')!.text;
        favNodeList.add(item);
      }
    }

    var noticeNode = bodyDom.querySelector('#Rightbar>div.box>div.cell.flex-one-row');
    if (noticeNode != null) {
      // 未读消息
      var unRead = noticeNode.querySelector('a')!.text.replaceAll(RegExp(r'\D'), '');
      if (int.parse(unRead) > 0) {
        // eventBus.emit('unRead', int.parse(unRead));
      }
    }
    return favNodeList;
  }
}
