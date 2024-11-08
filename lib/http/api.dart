import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Element;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart' hide Response, FormData;
import 'package:html/dom.dart' hide Text, Node;
import 'package:html/parser.dart';
import 'package:v2ex/model/BaseController.dart';
import 'package:v2ex/model/Post2.dart';
import 'package:v2ex/model/TabItem.dart';
import 'package:v2ex/model/item_node.dart';
import 'package:v2ex/model/model_login_detail.dart';
import 'package:v2ex/http/login_api.dart';
import 'package:v2ex/http/login_dio.dart';
import 'package:v2ex/utils/const_val.dart';
import 'package:v2ex/http/request.dart';
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
        res.data = {'list': postList, 'nodeList': nodeList, 'totalPage': 1};
        break;
      case TabType.node:
        NodeListModel? s = await getNodePageInfo(nodeEnName: tab.enName, pageNo: pageNo);
        if (s != null) {
          res.success = true;
          res.data = {'list': s.topicList, 'nodeList': nodeList, 'totalPage': s.totalPage};
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
        res.data = {'list': postList, 'nodeList': nodeList, 'totalPage': 1};
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
      item.replyContent = replyContentElement.innerHtml;
      item.replyText = replyContentElement.text;
      item.hideCallUserReplyContent = item.replyContent;

      var noElement = node.querySelector('.no');
      item.floor = int.parse(noElement!.text);

      var parsedContent = Utils.parseReplyContent(item.replyContent);
      item.replyUsers = parsedContent['users'];
      item.replyFloor = parsedContent['floor'];
      if (item.replyUsers.length == 1) {
        item.hideCallUserReplyContent = item.replyContent.replaceAll(RegExp(r'@<a href="/member/[\s\S]+?</a>(\s#[\d]+)?\s(<br>)?'), '');
      }

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

  // 感谢主题
  static Future thankTopic(String topicId) async {
    int once = GStorage().getOnce();
    SmartDialog.showLoading(msg: '表示感谢ing');
    try {
      var response = await Http().post("/thank/topic/$topicId?once=$once");
      // ua mob
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
    } on DioError catch (e) {
      SmartDialog.dismiss();
      SmartDialog.showToast(e.message!);
    }
  }

  // 收藏主题
  static Future<bool> favoriteTopic(bool isCollect, String topicId) async {
    int once = GStorage().getOnce();
    String url = isCollect ? ("/unfavorite/topic/$topicId?once=$once") : ("/favorite/topic/$topicId?once=$once");
    var response = await Http().get(url);
    if (response.statusCode == 200 || response.statusCode == 302) {
      if (response.statusCode == 200) {
        var document = parse(response.data);
        var menuBodyNode = document.querySelector("#Top .tools");
        var loginOutNode = menuBodyNode!.querySelectorAll('a').last;
        var loginOutHref = loginOutNode.attributes['onclick']!;
        RegExp regExp = RegExp(r'\d{3,}');
        Iterable<Match> matches = regExp.allMatches(loginOutHref);
        for (Match m in matches) {
          GStorage().setOnce(int.parse(m.group(0)!));
        }
      }
      // 操作成功
      return true;
    }
    return false;
  }

  // 回复主题
  static Future<Result> onSubmitReplyTopic({required String id, required String val, bool isRetry = false}) async {
    SmartDialog.showLoading(msg: '回复中...');
    int once = GStorage().getOnce();
    Options options = Options();
    options.contentType = Headers.formUrlEncodedContentType;
    options.headers = {
      // 'content-type': 'application/x-www-form-urlencoded',
      'refer': '${Const.v2exHost}/t/$id',
      'origin': Const.v2exHost
    };
    FormData formData = FormData.fromMap({'once': once, 'content': val});
    Response response = await LoginDio().post('/t/$id', data: formData, options: options);

    String ret = '回复失败了';
    if (response.statusCode == 302) {
      SmartDialog.showToast('回复成功');
      await Api.pullOnce();
      return Result(success: true);
    } else {
      var document = parse(response.data);
      Utils.getOnce(document);
      String html = response.data;
      if (html.contains('你上一条回复的内容和这条相同'))
        ret = '你上一条回复的内容和这条相同';
      else if (html.contains('请不要在每一个回复中都包括外链，这看起来像是在 spamming'))
        ret = '请不要在每一个回复中都包括外链，这看起来像是在 spamming';
      else if (html.contains('创建新回复')) {
        ret = '回复出现了问题，请使用重试';
        if (!isRetry) {
          print('第二次重试中');
          return onSubmitReplyTopic(id: id, val: val, isRetry: true);
        }
      } else {
        var contentDom = document.querySelector('#Wrapper');
        if (contentDom!.querySelector('.problem') != null) {
          ret = contentDom.querySelector('.problem')!.text;
        }
      }
    }
    SmartDialog.dismiss();
    return Result(success: false, msg: ret);
  }

  // 获取节点地图
  static Future getNodeMap() async {
    Response response = await Http().get('/');
    List<Map<dynamic, dynamic>> nodesList = [];
    var document = parse(response.data);
    var nodesBox;
    // 【设置】中可能关闭【首页显示节点导航】
    if (document.querySelector('#Main')!.children.length >= 4) {
      nodesBox = document.querySelector('#Main')!.children.last;
    }
    if (nodesBox != null) {
      List<NodeItem> allList = await getAllNodes();
      nodesBox.children.removeAt(0);
      var nodeTd = nodesBox.children;
      for (var i in nodeTd) {
        Map nodeItem = {};
        String fName = i.querySelector('span')!.text;
        nodeItem['name'] = fName;
        List<Map> children = [];
        var cEl = i.querySelectorAll('a');
        for (var j in cEl) {
          Map item = {};
          item['name'] = j.attributes['href']!.split('/').last;
          item['title'] = j.text;

          NodeItem? r;
          try {
            r = allList.firstWhere((v) => v.name == item['name']);
          } catch (e) {
            r = null;
          }
          if (r != null) {
            String? avatar = r.avatarLarge ?? r.avatarNormal ?? r.avatarMini;
            if (avatar != '/static/img/node_default_large.png' && avatar != '') {
              item['avatar'] = avatar;
            }
          }
          children.add(item);
        }
        nodeItem['children'] = children;
        nodesList.add(nodeItem);
      }
    }
    return nodesList;
  }

  // 所有节点
  //todo 如果其他地方未使用，可以直接合并
  static Future<List<NodeItem>> getAllNodes() async {
    Response response = await Http().get(Const.allNodes);
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

  // 感谢回复
  static Future thankReply(String replyId, String topicId) async {
    int once = GStorage().getOnce();
    SmartDialog.showLoading();
    try {
      var response = await Http().post("/thank/reply/$replyId?once=$once");
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
        if (text.contains(prefix)) {
          if (text == prefix) {
            return Result(success: false, data: 1);
          } else {
            String json = text.substring(prefix.length);
            try {
              return Result(success: true, data: jsonDecode(json));
            } catch (e) {
              return Result(success: false, data: 2);
            }
          }
        } else {
          return Result(success: false, data: 0);
        }
      }
    }
    return Result(success: false, data: 0);
  }

  // 所有节点 topic
  static Future<List<TopicNodeItem>> getAllNodesT() async {
    Response response = await Http().get(
      Const.allNodesT,
      data: {'fields': 'name,title,topics,aliases', 'sort_by': 'topics', 'reverse': 1},
      // cacheOptions: DioRequestNet().cacheOptions,
    );
    List<dynamic> list = response.data;
    return list.map((e) => TopicNodeItem.fromJson(e)).toList();
  }

  // 移动主题节点
  static moveTopicNode(topicId, nodeName) async {
    SmartDialog.showLoading(msg: '移动中...');
    Options options = Options();
    options.contentType = Headers.formUrlEncodedContentType;
    options.headers = {
      // 必须字段
      // Referer :  https://www.v2ex.com/write?node=qna
      'Referer': '${Const.v2exHost}/move/topic/$topicId',
      'Origin': Const.v2exHost,
      'user-agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1'
    };

    FormData formData = FormData.fromMap({
      'destination': nodeName, // 节点
    });

    Response response = await Http().post('/move/topic/$topicId', data: formData, options: options);
    SmartDialog.dismiss();
    var document = parse(response.data);
    var mainNode = document.querySelector('#Main');
    if (mainNode!.querySelector('div.inner') != null && mainNode.querySelector('div.inner')!.text.contains('你不能移动这个主题。')) {
      return false;
    } else {
      return true;
    }
  }

  static pullOnce() async {
    Response response = await Http().get('/poll_once');
    try {
      if (response.statusCode == 200) {
        GStorage().setOnce(int.parse(response.data));
        return Result(success: true);
      }
    } catch (e) {
      return Result(success: false);
    }
    return Result(success: true);
  }
}
