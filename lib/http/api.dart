import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide Element;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart' hide Response, FormData;
import 'package:html/dom.dart' hide Text, Node;
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:v2next/http/login_dio.dart';
import 'package:v2next/http/request.dart';
import 'package:v2next/model/model.dart';

import 'package:v2next/utils/const_val.dart';
import 'package:v2next/utils/storage.dart';
import 'package:v2next/utils/utils.dart';
import 'package:xml2json/xml2json.dart';

class Api {
  //获取tab 主题列表
  static Future<Result> getPostListByTab({required NodeItem tab, int pageNo = 1, String? date}) async {
    Result res = new Result();
    Response response;
    List<Post> postList = [];
    List<V2Node> nodeList = [];
    switch (tab.type) {
      case TabType.tab:
        if (pageNo == 1) {
          //用pc网站，因为要取子tab。不取子tab可以用mobile网站
          response = await Http().get('/', data: {'tab': tab.name});
          Document document = parse(response.data);
          Utils.parseUnRead(document);
          List<Element> listEl = document.querySelectorAll("div[class='cell item']");
          List<Element> childNodeEl = document.querySelectorAll("#SecondaryTabs > a");
          for (var i in childNodeEl) {
            List<String> s = i.attributes['href']!.split('/go/');
            if (s.isNotEmpty && s.length >= 2) {
              nodeList.add(V2Node(name: s[1], title: i.text));
            }
          }
          postList = Utils.parsePagePostList(listEl);
        }
        res.success = true;
        res.data = {'list': postList, 'nodeList': nodeList, 'totalPage': 1};
        break;
      case TabType.recent:
        response = await Http().get('/recent', data: {'p': pageNo});
        Document document = parse(response.data);
        Utils.parseUnRead(document);
        List<Element> listEl = document.querySelectorAll("div[class='cell item']");
        postList = Utils.parsePagePostList(listEl);
        var totalPageNode = document.querySelectorAll('.ps_container .page_normal');
        if (totalPageNode.isNotEmpty) {
          pageNo = int.parse(totalPageNode.last.text);
        }
        res.success = true;
        res.data = {'list': postList, 'nodeList': nodeList, 'totalPage': pageNo};
        break;
      case TabType.node:
        var s = await getNodePageInfo(name: tab.name, pageNo: pageNo);
        if (s != null) {
          res.success = true;
          res.data = {'list': s['list'], 'nodeList': nodeList, 'totalPage': s['model'].totalPage};
        } else {
          res.success = false;
          res.data = Auth.notAllow;
        }
        break;
      case TabType.latest:
        res.success = true;
        if (pageNo == 1) {
          postList = await getLatestPostList(nodeId: tab.name, pageNo: pageNo);
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
      Utils.parseUnRead(document);
      res.success = true;
      res.data = Utils.parsePagePostList(aRootNode);
    } else {
      response = await Http().get(Const.v2Hot + '/hot/${date}.json');
      List<Post> list = [];
      (response.data as List).forEach((v) {
        Post item = Post.fromJson(v);
        item.member.username = v['username'];
        item.member.avatar = v['avatar'];
        item.node.title = v['nodeTitle'];
        item.node.name = v['nodeUrl'];
        item.postId = v['id'];
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

  static Future getNodePageInfo({required String name, int pageNo = 1}) async {
    //手机端 收藏人数获取不到
    Response response = await Http().get('/go/$name', data: {'p': pageNo});
    var document = parse(response.data);
    Utils.parseUnRead(document);
    var mainBox = document.body!.children[1].querySelector('#Main');
    var mainHeader = mainBox!.querySelector('.node-header');
    if (response.realUri.toString() == '/' || (response.data as String).contains('其他登录方式') || mainHeader == null) {
      print('无权限');
      //TODO 无权限
      return null;
    }
    Utils.getOnce(document);
    NodeItem data = NodeItem();
    var res = {'model': data, 'list': []};
    data.name = name;
    data.avatar = mainHeader.querySelector('img')!.attributes['src']!;
    // 节点名称
    data.title = mainHeader.querySelector('div.node-breadcrumb')!.text.split('›')[1].trim();
    // 主题总数
    data.topics = int.parse(mainHeader.querySelector('strong')!.text.replaceAll(',', ''));
    // 节点描述
    if (mainHeader.querySelector('div.intro') != null) {
      data.header = mainHeader.querySelector('div.intro')!.text;
    }
    // 节点收藏状态
    var cell_ops = mainHeader.querySelector('.cell_ops a');
    if (cell_ops != null) {
      data.isFavorite = cell_ops.text.contains('取消');
      // 数字
      data.id = int.parse(cell_ops.attributes['href']!.split('=')[0].replaceAll(RegExp(r'\D'), ''));
    }
    if (mainBox.querySelector('div.box:not(.box-title)>div.cell:not(.tab-alt-container):not(.item)') != null) {
      var totalpageNode = mainBox.querySelector('div.box:not(.box-title)>div.cell:not(.tab-alt-container)');
      if (totalpageNode!.querySelectorAll('a.page_normal').isNotEmpty) {
        data.totalPage = int.parse(totalpageNode.querySelectorAll('a.page_normal').last.text);
      }
    }

    if (mainBox.querySelector('div.box:not(.box-title)>div.cell.flex-one-row') != null) {
      var favNode = mainBox.querySelector('div.box:not(.box-title)>div.cell.flex-one-row>div');
      data.stars = int.parse(favNode!.innerHtml.replaceAll(RegExp(r'\D'), ''));
    }

    if (document.querySelector('#TopicsNode') != null) {
      var topicEle = document.querySelector('#TopicsNode')!.querySelectorAll('div.cell');
      res['list'] = Utils.parsePagePostList(topicEle);
    }
    return res;
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
          .map((e) => Post(
                postId: e['id'],
                title: e['title'],
                member: Member(
                  avatar: e['member']['avatar_normal'],
                  avatarLarge: e['member']['avatar_large'],
                  username: e['member']['username'],
                ),
                node: V2Node(
                  name: e['node']['name'],
                  title: e['node']['title'],
                ),
                contentText: e['content'],
                contentRendered: e['content_rendered'],
                replyCount: e['replies'],
                lastReplyUsername: e['last_reply_by'],
              ))
          .toList();
    } else {
      response = await Http().get(Const.v2Hot + '/hot/${date}.json');
      List<Post> list = [];
      (response.data as List).forEach((v) {
        Post item = Post.fromJson(v);
        item.postId = v['id'];
        item.member.username = v['username'];
        item.member.avatar = v['avatar'];
        item.node.title = v['nodeTitle'];
        item.node.name = v['nodeUrl'];
        list.add(item);
      });
      res.success = true;
      res.data = list;
    }
    return res;
  }

  //获取通知
  static Future<MemberNoticeModel> getNotifications({int pageNo = 1}) async {
    MemberNoticeModel data = MemberNoticeModel();
    List<MemberNoticeItem> noticeList = [];

    Response response = await Http().get('/notifications', data: {'p': pageNo});
    Document document = parse(response.data);
    List<Element> cellList = document.querySelectorAll('#notifications > .cell');
    Element? countEl = document.querySelector('#Main .box .header strong');
    if (countEl != null) {
      data.totalCount = int.parse(countEl.text);
    }
    Element? inputEl = document.querySelector('#Main .box .ps_container input');
    if (inputEl != null) {
      var max = inputEl.attributes['max'];
      if (max != null) {
        data.totalPage = int.parse(max);
      }
    }

    for (var i = 0; i < cellList.length; i++) {
      noticeList.add(Utils.parseNoticeItem(cellList[i]));
    }
    data.list = noticeList;
    return data;
  }

  // 删除消息
  static Future<MemberNoticeItem> onDelNotice(String noticeId, String once) async {
    Options options = Options();
    options.headers = {
      'Referer': '${Const.v2exHost}/notifications',
      'Origin': Const.v2exHost,
    };
    FormData formData = FormData.fromMap({'once': once});
    await Http().post('/delete/notification/$noticeId?once=$once', data: formData, options: options);
    var res = await Http().get('/notifications/below/$noticeId');
    Document document = parse(res.data);
    List<Element> cellList = document.querySelectorAll(' .cell');
    return Utils.parseNoticeItem(cellList[0]);
    ;
  }

  //获取最新帖子(特殊处理)
  static Future<List<Post>> getLatestPostList({required String nodeId, int pageNo = 0}) async {
    List<Post> list = [];
    Response response = await Http().get('/index.xml');
    final myTransformer = Xml2Json();
    myTransformer.parse(response.data);
    var json = myTransformer.toOpenRally();
    // var json = myTransformer.toBadgerfish();

    List xmlList = jsonDecode(json)['feed']['entry'];

    xmlList.forEach((item) {
      Post p = new Post();
      // print(item);
      p.title = item['title'].replaceAll(RegExp(r'^\[.*?\]'), '');
      p.title = p.title.trim();
      RegExp regExp = RegExp(r'^\[.*?\]');
      Match? match = regExp.firstMatch(item['title']);
      if (match != null) {
        String nodeText = match.group(0)!;
        p.node.title = nodeText.replaceAll('[', '').replaceAll(']', '');
      }
      String? href = item['link']['href'];
      var match1 = RegExp(r'(\d+)').allMatches(href!);
      var result = match1.map((m) => m.group(0)).toList();
      p.postId = int.parse(result[1]!);
      p.createDateAgo = Utils.timeAgo(item['published']);
      // p.contentHtml = item['content'];
      // print(item['content']);
      p.member.username = item['author']['name'];
      list.add(p);
    });
    return list;
  }

  static Future<Post> getPostDetail(int id) async {
    Post post = Post();
    var tt = DateTime.now();
    // print('请求开始$tt');
    var response = await Http().get("/t/$id?p=1", isMobile: false);
    var ss = DateTime.now();
    // print('请求结束$ss');
    var hours = tt.difference(ss);
    print('请求花费时间$hours');

    String htmlText = response.data;
    var document = parse(response.data);
    Utils.parseUnRead(document);
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

    post.postId = id;

    RegExp regExp = RegExp(r'var once = "([\d]+)";');
    Match? once = regExp.firstMatch(htmlText);
    if (once != null && once.group(1) != null) {
      GStorage().setOnce(int.parse(once.group(1)!));
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
      post.node.title = as[1].text;
      post.node.name = as[1].attributes['href']!.replaceAll('/go/', '');
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
        // post.fr = cells[0].querySelector('.cell .fr')!.innerHtml;
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
          var url = '/t/' + post.postId.toString();

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
    // print('处理结束$ss');
    hours = tt.difference(ss);
    print('总花费时间$hours');
    return post;
  }

  static List<Reply> parsePageReplies(List<Element> nodes) {
    List<Reply> replyList = [];
    for (var node in nodes) {
      if (node.attributes['id'] == null) continue;
      Reply item = Reply();
      item.replyId = int.parse(node.attributes['id']!.replaceAll('r_', ''));
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
        item.hideCallUserReplyContent = item.hideCallUserReplyContent.replaceAll(RegExp(r'@<a href="/member/[\s\S]+?</a>(\s#[\d]+)?\s(<br>)?'), '');
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

  // 感谢主题
  static Future thankTopic(int postId) async {
    int once = GStorage().getOnce();
    SmartDialog.showLoading();
    try {
      var response = await Http().post("/thank/topic/$postId?once=$once");
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
  static Future<bool> favoriteTopic(bool isCollect, int postId) async {
    int once = GStorage().getOnce();
    String url = isCollect ? ("/unfavorite/topic/$postId?once=$once") : ("/favorite/topic/$postId?once=$once");
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
  static Future<List> getNodeMap() async {
    Response response = await Http().get('/');
    List<Map<dynamic, dynamic>> nodesList = [];
    var document = parse(response.data);
    var nodesBox;
    // 【设置】中可能关闭【首页显示节点导航】
    if (document.querySelector('#Main')!.children.length >= 4) {
      nodesBox = document.querySelector('#Main')!.children.last;
    }
    if (nodesBox != null) {
      List<NodeItem> allList = await getAllNode();
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

  // 获取所有节点
  static Future<List<NodeItem>> getAllNode() async {
    Response response = await Http().get(Const.allNodes);
    GStorage().setAllNodes(response.data);
    List<NodeItem> allList = (response.data as List<dynamic>).map((e) => NodeItem.fromJson(e)).toList();
    return allList;
  }

  // 获取收藏的节点
  static Future<List<NodeItem>> getFavNodes() async {
    List<NodeItem> favNodeList = [];
    Response response = await Http().get('/my/nodes');
    var bodyDom = parse(response.data);
    var nodeListWrap = bodyDom.querySelector('div[id="my-nodes"]');
    if (nodeListWrap != null) {
      List<Element> nodeListDom = nodeListWrap.querySelectorAll('a');
      for (var i in nodeListDom) {
        NodeItem item = NodeItem();
        if (i.querySelector('img') != null) {
          item.avatar = i.querySelector('img')!.attributes['src']!;
          if (item.avatar!.contains('/static')) {
            item.avatar = '';
          }
          item.name = i.attributes['href']!.split('/')[2];
        }
        item.title = i.querySelector('span.fav-node-name')!.text;
        item.topics = int.parse(i.querySelector('span.f12.fade')!.text);
        favNodeList.add(item);
      }
    }
    return favNodeList;
  }

  // 感谢回复
  static Future thankReply(int replyId, int postId) async {
    int once = GStorage().getOnce();
    var response = await Http().post("/thank/reply/$replyId?once=$once");
    // print('1019 thankReply: $response');
    var data = jsonDecode(response.toString());
    bool responseStatus = data['success'];
    if (data['once'] != null) {
      int onceR = data['once'];
      GStorage().setOnce(onceR);
    }
    return responseStatus;
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

  // 所有节点
  static Future<List<NodeItem>> getAllNodesBySort() async {
    Response response = await Http().get(
      Const.allNodesBySort,
      data: {'fields': 'name,title,topics,aliases', 'sort_by': 'topics', 'reverse': 1},
    );
    List<dynamic> list = response.data;
    return list.map((e) => NodeItem.fromJson(e)).toList();
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

  static Future<Result> pullOnce() async {
    Response response = await Http().get('/poll_once');
    try {
      if (response.statusCode == 200) {
        var once = int.parse(response.data);
        GStorage().setOnce(once);
        return Result(success: true, data: once);
      }
    } catch (e) {
      return Result(success: false);
    }
    return Result(success: true);
  }

  // 发布主题
  static postTopic(args) async {
    SmartDialog.showLoading(msg: '发布中...');
    Options options = Options();
    options.contentType = Headers.formUrlEncodedContentType;
    options.headers = {
      // 必须字段
      // Referer :  https://www.v2ex.com/write?node=qna
      'Referer': '${Const.v2exHost}/write?node=${args['node_name']}',
      'Origin': Const.v2exHost,
      'user-agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1'
    };

    FormData formData = FormData.fromMap({
      'title': args['title'], // 标题
      'syntax': args['syntax'], // 语法 default markdown
      'content': args['content'], // 内容
      'node_name': args['node_name'], // 节点名称 en
      'once': GStorage().getOnce()
    });

    Response response = await Http().post('/write', data: formData, options: options);
    SmartDialog.dismiss();
    var document = parse(response.data);
    print('1830：${response.headers["location"]}');
    if (document.querySelector('div.problem') != null) {
      SmartDialog.show(
        useSystem: true,
        animationType: SmartAnimationType.centerFade_otherSlide,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('提示'),
            content: Text(document.querySelector('div.problem')!.text),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('确定'))],
          );
        },
      );
      return false;
    } else {
      return response.headers["location"];
    }
  }

  // 编辑主题 不可更改节点
  static eidtTopic(args) async {
    SmartDialog.showLoading(msg: '发布中...');
    Options options = Options();
    options.contentType = Headers.formUrlEncodedContentType;
    options.headers = {
      // 必须字段
      // Referer :  https://www.v2ex.com/edit/write/topic/918603
      'Referer': '${Const.v2exHost}/edit/topic/${args['topicId']}',
      'Origin': Const.v2exHost,
      'user-agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1'
    };
    FormData formData = FormData.fromMap({
      'title': args['title'], // 标题
      'syntax': args['syntax'], // 语法 0: default 1: markdown
      'content': args['content'], // 内容
    });

    Response response = await Http().post('/edit/topic/${args['topicId']}', data: formData, options: options);
    SmartDialog.dismiss();
    var document = parse(response.data);
    var mainNode = document.querySelector('#Main');
    if (mainNode != null && mainNode.querySelector('div.inner')!.text.contains('你不能编辑这个主题')) {
      return false;
    } else {
      return true;
    }
  }

  // 查询主题状态 pc
  static Future queryTopicStatus(topicId) async {
    SmartDialog.showLoading();
    Map result = {};
    Response response = await Http().get('/edit/topic/$topicId');
    SmartDialog.dismiss();
    var document = parse(response.data);
    var mainNode = document.querySelector('#Main');
    if (mainNode!.querySelector('div.inner') != null && mainNode.querySelector('div.inner')!.text.contains('你不能编辑这个主题')) {
      // 不可编辑
      result['status'] = false;
    } else {
      Map topicDetail = {};
      var topicTitle = mainNode.querySelector('#topic_title');
      topicDetail['topicTitle'] = topicTitle!.text;
      var topicContent = mainNode.querySelector('#topic_content');
      topicDetail['topicContent'] = topicContent!.text;
      var select = mainNode.querySelector('#select_syntax');
      var syntaxs = select!.querySelectorAll('option');
      var selectSyntax = '';
      for (var i in syntaxs) {
        if (i.attributes['selected'] != null) {
          selectSyntax = i.attributes['value']!;
        }
      }
      topicDetail['syntax'] = selectSyntax;
      result['topicDetail'] = topicDetail;
      result['status'] = true;
    }
    return result;
  }

  // 查询是否可以增加附言
  static Future appendStatus(topicId) async {
    SmartDialog.showLoading();
    Response response = await Http().get('/append/topic/$topicId', isMobile: true);
    SmartDialog.dismiss();
    print(response);
    var document = parse(response.data);
    if (document.querySelectorAll('input').length > 2) {
      var onceNode = document.querySelectorAll('input')[1];
      GStorage().setOnce(int.parse(onceNode.attributes['value']!));
      return true;
    } else {
      return false;
    }
  }

  // 增加附言
  static Future appendContent(args) async {
    SmartDialog.showLoading(msg: '正在提交...');
    Options options = Options();
    options.contentType = Headers.formUrlEncodedContentType;
    options.headers = {
      // 必须字段
      // Referer :  https://www.v2ex.com/append/topic/918603
      'Referer': '${Const.v2exHost}/append/topic/${args['topicId']}',
      'Origin': Const.v2exHost,
      'user-agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1'
    };

    FormData formData = FormData.fromMap({
      'content': args['content'], // 内容
      'syntax': args['syntax'],
      'once': GStorage().getOnce()
    });
    Response? response;
    try {
      response = await Http().post('/append/topic/${args['topicId']}', data: formData, options: options);
      SmartDialog.dismiss();
      var document = parse(response.data);
      print(document);
      return true;
    } catch (err) {
      SmartDialog.dismiss();
    }
  }

  // 收藏节点
  static Future onFavNode(int nodeId, bool isFavorite) async {
    int once = GStorage().getOnce();
    var reqUrl = isFavorite ? '/unfavorite/node/$nodeId' : '/favorite/node/$nodeId';
    Response response = await Http().get(reqUrl, data: {'once': once});
    Utils.getOnce(parse(response.data));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // 举报主题
  static Future<bool> onReportPost(int topicId) async {
    int once = GStorage().getOnce();
    SmartDialog.showLoading();
    Response response = await Http().get('/report/topic/$topicId', data: {'once': once});
    SmartDialog.dismiss();
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // 屏蔽主题 完成后返回上一页
  static Future<bool> onIgnorePost(int topicId) async {
    SmartDialog.showLoading();
    int once = GStorage().getOnce();
    Response response = await Http().get('/ignore/topic/$topicId', data: {'once': once});
    SmartDialog.dismiss();
    if (response.statusCode == 200) {
      // 操作成功
      return true;
    } else {
      return false;
    }
  }

  //获取未读
  static Future<int> fetchUnRead() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    print('定时查询未读消息:$formattedDate');
    //用pc网站，因为要取子tab。不取子tab可以用mobile网站
    var response = await Http().get('/faq');
    Document document = parse(response.data);
    return Utils.parseUnRead(document);
  }

  static Future<Map> checkUpdate() async {
    Map update = {
      'lastVersion': '',
      'downloadHref': '',
      'needUpdate': false,
    };
    Response response = await Http().get('https://api.github.com/repos/${Const.gitName}/releases/latest');
    // 版本号
    var version = response.data['tag_name'];
    var updateLog = response.data['body'];
    List<String> updateLogList = updateLog.split('\r\n');
    var needUpdate = Utils.needUpdate(Const.currentVersion, version);
    if (needUpdate) {
      SmartDialog.show(
        useSystem: true,
        animationType: SmartAnimationType.centerFade_otherSlide,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('🎉 发现新版本 '),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  version,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 8),
                for (var i in updateLogList) ...[Text(i)]
              ],
            ),
            actions: [
              TextButton(onPressed: () => SmartDialog.dismiss(), child: const Text('取消')),
              TextButton(
                  onPressed: () {
                    SmartDialog.dismiss();
                    Utils.openBrowser('${Const.git}/releases');
                  },
                  child: const Text('去更新'))
            ],
          );
        },
      );
    } else {
      update[needUpdate] = true;
    }
    return update;
  }

  // 版本记录
  //https://api.github.com/repos/' + full_name + '/releases
  static Future changeLog() async {
    var res = await Http().get('https://api.github.com/repos/${Const.gitName}/releases');
    return res.data;
  }
}
