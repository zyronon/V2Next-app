import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// import 'package:v2ex/utils/storage.dart'; // 本地存储
// import 'package:dio_http_cache/dio_http_cache.dart'; // dio缓存
// import 'package:v2ex/models/web/item_tab_topic.dart';
// import 'package:v2ex/models/web/model_topic_detail.dart'; // 主题详情
// import 'package:v2ex/models/web/item_topic_reply.dart'; // 主题回复
// import 'package:v2ex/models/web/item_topic_subtle.dart'; // 主题附言
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart'; // 弹窗
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:v2ex/model/Post2.dart';
import 'package:v2ex/utils/init.dart';
import 'package:v2ex/utils/storage.dart';
import 'package:v2ex/utils/string.dart'; // 常量
import 'package:v2ex/utils/utils.dart';

class TopicWebApi {
  // 获取帖子详情及下面的评论信息
  static Future<Post2> getTopicDetail(String id) async {
    Post2 post = Post2();
    var response = await Request().get("/t/$id?p=1", extra: {'ua': 'pc'});
    var s = DateTime.now();
    print('请求结束$s');

    String htmlText = response.data;
    var document = parse(response.data);
    var wrapper = document.querySelector('#Main');

    if (response.redirects.isNotEmpty || document.querySelector('#Main > div.box > div.message') != null) {
      SmartDialog.show(
        useSystem: true,
        animationType: SmartAnimationType.centerFade_otherSlide,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('权限不足'),
            content: const Text('登录后查看主题内容'),
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
      // post.isAuth = true;
      return post;
    }

    // [email_protected] 转码回到正确的邮件字符串
    List<dom.Element> emailNode = document.querySelectorAll(".__cf_email__");
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
      post.node.enName = as[1].attributes['href']!;
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
    post.contentHtml = temp.innerHtml.replaceAll(' +08:00', '');
    var contentEl = temp.querySelector('.topic_content');
    if (contentEl != null) {
      post.contentText = contentEl.text.trim();
    }

    var topicButtons = document.querySelector('.topic_buttons');
    if (topicButtons != null) {
      var tbs = topicButtons.querySelectorAll('.tb');
      var favoriteNode = tbs[0];
      post.isFavorite = favoriteNode.text == '取消收藏';
      var ignoreNode = tbs[2];
      post.isIgnore = ignoreNode.text == '取消忽略';

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
      List<dom.Element> cells = boxListEl[1].querySelectorAll('.cell');
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
    return post;
  }

  static Future<Map> fetchPostOtherPageReplies(String href, int pageNo) async {
    return Future(() async {
      try {
        var response = await Request().get(href, extra: {'ua': 'pc'});
        var document = parse(response.data);
        var boxListEl = document.querySelectorAll('#Main .box');
        List<dom.Element> cells = boxListEl[1].querySelectorAll('.cell');
        return {'i': pageNo, 'replyList': parsePageReplies(cells.sublist(2))};
      } catch (e) {
        throw Exception("bad code! -> ${e.toString()}");
      }
    });
  }

  static List<Reply> parsePageReplies(List<dom.Element> nodes) {
    List<Reply> replyList = [];
    for (var node in nodes) {
      if (node.attributes['id'] == null) continue;
      Reply item = Reply();
      item.id = node.attributes['id']!.replaceAll('r_', '');
      var replyContentElement = node.querySelector('.reply_content');
      item.replyContent = Utils.checkPhotoLink2Img(replyContentElement!.innerHtml);
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

  // 感谢主题
  static Future thankTopic(String topicId) async {
    int once = GStorage().getOnce();
    SmartDialog.showLoading(msg: '表示感谢ing');
    try {
      var response = await Request().post("/thank/topic/$topicId?once=$once");
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
    SmartDialog.showLoading(msg: isCollect ? '取消中...' : '收藏中...');
    String url = isCollect ? ("/unfavorite/topic/$topicId?once=$once") : ("/favorite/topic/$topicId?once=$once");
    var response = await Request().get(url, extra: {'ua': 'mob'});
    SmartDialog.dismiss();
    // 返回的pc端ua
    if (response.statusCode == 200 || response.statusCode == 302) {
      if (response.statusCode == 200) {
        var document = parse(response.data);
        var menuBodyNode = document.querySelector("div[id='Top'] > div > div.site-nav > div.tools");
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
  static Future<String> onSubmitReplyTopic(String id, String replyContent, int totalPage) async {
    SmartDialog.showLoading(msg: '回复中...');
    int once = GStorage().getOnce();
    Options options = Options();
    options.contentType = Headers.formUrlEncodedContentType;
    options.headers = {
      // 'content-type': 'application/x-www-form-urlencoded',
      'refer': '${Strings.v2exHost}/t/$id',
      'origin': Strings.v2exHost
    };
    FormData formData = FormData.fromMap({'once': once, 'content': replyContent});
    Response response = await Request().post('/t/$id', data: formData, extra: {'ua': 'mob'}, options: options);
    SmartDialog.dismiss();
    var bodyDom = parse(response.data).body;
    if (response.statusCode == 302) {
      SmartDialog.showToast('回复成功');
      //TODO  获取最后一页最近一条
      return 'true';
    } else if (response.statusCode == 200) {
      String responseText = '回复失败了';
      var contentDom = bodyDom!.querySelector('#Wrapper');
      if (contentDom!.querySelector('div.problem') != null) {
        responseText = contentDom.querySelector('div.problem')!.text;
      }
      return responseText;
    } else {
      SmartDialog.dismiss();
      return 'false';
    }
  }
}
