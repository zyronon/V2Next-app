import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter/material.dart';
import 'package:v2ex/model/Post2.dart';
import 'package:v2ex/utils/init.dart';
import 'package:v2ex/utils/storage.dart';
import 'package:v2ex/utils/utils.dart';
import 'package:v2ex/utils/string.dart'; // 常量
// import 'package:v2ex/utils/storage.dart'; // 本地存储
// import 'package:dio_http_cache/dio_http_cache.dart'; // dio缓存
// import 'package:v2ex/models/web/item_tab_topic.dart';
// import 'package:v2ex/models/web/model_topic_detail.dart'; // 主题详情
// import 'package:v2ex/models/web/item_topic_reply.dart'; // 主题回复
// import 'package:v2ex/models/web/item_topic_subtle.dart'; // 主题附言
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart'; // 弹窗

class TopicWebApi {
  // 获取帖子详情及下面的评论信息
  static Future<Post2> getTopicDetail(String topicId, int p) async {
    Post2 post = Post2();
    // List<TopicSubtleItem> subtleList = []; // 附言
    List<Reply> replies = [];
    var response = await Request().get(
      "/t/$topicId",
      data: {'p': p},
      // cacheOptions:
      //     buildCacheOptions(const Duration(days: 4), forceRefresh: true),
      extra: {'ua': 'mob'},
    );
    var s = DateTime.now();
    print('请求结束$s');
    // Use html parser and query selector
    var document = parse(response.data);
    post.id = topicId;

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
      post.replyList = replies;
      // post.isAuth = true;
      return post;
    }

    var rootDom = parse(response.data);
    var userCellWrap = rootDom.querySelectorAll('div#site-header-menu > div#menu-body > div.cell');
    var onceHref = userCellWrap.last.querySelector('a')!.attributes['href'];
    int once = int.parse(onceHref!.split('once=')[1]);
    print('once');
    print(once.toString());
    // post.once = once.toString();
    GStorage().setOnce(once);

    /// 头部内容
    /// 查询头部内容公共头

    const String wrapperQuery = '#Wrapper';

    /// main box 正文
    const String mainBoxQuery = '$wrapperQuery > div > div:nth-child(1)';
    const String headerQuery = '$mainBoxQuery > div.header';
    const String innerQuery = '$mainBoxQuery > div.inner';

    post.member.avatarLarge = document.querySelector('$headerQuery > div.fr > a > img')!.attributes["src"]!;

    post.member.username = document.querySelector('$headerQuery > small > a')!.text;

    post.node.url = document.querySelector('$headerQuery > a:nth-child(6)')!.attributes["href"]!.replaceAll('/go/', '');

    post.node.title = document.querySelector('$headerQuery > a:nth-child(6)')!.text;
    //  at 9 小时 26 分钟前，1608 次点击
    var pureStr = document.querySelector('$headerQuery > small')!.text.split('at ')[1];
    List pureStrList = pureStr.split('·');
    post.createDateAgo = pureStrList[0].replaceFirst(' +08:00', '');
    post.clickCount = pureStrList.length >= 2 ? int.parse(pureStrList[1].replaceAll(RegExp(r'\D'), '')) : 0;
    // APPEND EIDT MOVE
    var opActionNode = document.querySelector('$headerQuery > small');
    if (opActionNode!.querySelector('a.op') != null) {
      var opNodes = opActionNode.querySelectorAll('a.op');
      for (var i in opNodes) {
        print(i.text);
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
    post.title = document.querySelector('$headerQuery > h1')!.text;

    // [email_protected] 转码回到正确的邮件字符串
    List<dom.Element> aRootNode = document.querySelectorAll("a[class='__cf_email__']");
    List<dom.Element> bRootNode = document.querySelectorAll("span[class='__cf_email__']");
    var emailNode = aRootNode.isNotEmpty
        ? aRootNode
        : bRootNode.isNotEmpty
            ? bRootNode
            : [];
    if (emailNode.isNotEmpty) {
      for (var aNode in emailNode) {
        String encodedCf = aNode.attributes["data-cfemail"].toString();
        var newEl = document.createElement('a');
        newEl.innerHtml = Utils.cfDecodeEmail(encodedCf);
        newEl.attributes['href'] = 'mailto:${Utils.cfDecodeEmail(encodedCf)}';
        aNode.replaceWith(newEl);
      }
    }

    // 判断是否有正文
    if (document.querySelector('$mainBoxQuery > div.cell > div') != null) {
      var contentDom = document.querySelector('$mainBoxQuery > div.cell > div')!;
      post.headerTemplate = contentDom.innerHtml;
      // List decodeRes = Utils.base64Decode(contentDom);
      // if (decodeRes.isNotEmpty) {
      //   var decodeDom = '';
      //   for (var i = 0; i < decodeRes.length; i++) {
      //     decodeDom +=
      //         '<a href="base64Wechat: ${decodeRes[i]}">${decodeRes[i]}</a>';
      //     if (i != decodeRes.length - 1) {
      //       decodeDom += '<span>、</span>';
      //     }
      //   }
      //   contentDom.nodes.insert(contentDom.nodes.length,
      //       parseFragment('<p>base64解码：$decodeDom</p>'));
      // }
      // post.contentRendered = Utils.linkMatch(contentDom);
      if (contentDom.querySelector('img') != null) {
        var imgNodes = contentDom.querySelectorAll('img');
        var imgLength = imgNodes.length;
        // post.imgCount += imgLength;
        // post.imgList = [];
        // for (var imgNode in imgNodes) {
        //   post.imgList.add(Utils().imageUrl(imgNode.attributes['src']!));
        // }
      }
    }

    // // 附言
    // List<dom.Element> appendNodes =
    //     document.querySelectorAll("$mainBoxQuery > div[class='subtle']");
    // if (appendNodes.isNotEmpty) {
    //   for (var node in appendNodes) {
    //     TopicSubtleItem subtleItem = TopicSubtleItem();
    //     subtleItem.fade = node
    //         .querySelector('span.fade')!
    //         .text
    //         .replaceFirst(' +08:00', ''); // 时间（去除+ 08:00）;
    //     var contentDom = node.querySelector('div.topic_content')!;
    //     // List decodeRes = Utils.base64Decode(contentDom);
    //     // if (decodeRes.isNotEmpty) {
    //     //   var decodeDom = '';
    //     //   for (var i = 0; i < decodeRes.length; i++) {
    //     //     decodeDom +=
    //     //         '<a href="base64Wechat: ${decodeRes[i]}">${decodeRes[i]}</a>';
    //     //     if (i != decodeRes.length - 1) {
    //     //       decodeDom += '<span>、</span>';
    //     //     }
    //     //   }
    //     //   contentDom.nodes.insert(contentDom.nodes.length,
    //     //       parseFragment('<p>base64解码：$decodeDom</p>'));
    //     // }
    //     subtleItem.content = Utils.linkMatch(contentDom);
    //     if (node.querySelector('div.topic_content')!.querySelector('img') !=
    //         null) {
    //       var subImgNodes =
    //           node.querySelector('div.topic_content')!.querySelectorAll('img');
    //       post.imgCount += subImgNodes.length;
    //       for (var subImgNode in subImgNodes) {
    //         post.imgList
    //             .add(Utils().imageUrl(subImgNode.attributes['src']!));
    //       }
    //     }
    //     subtleList.add(subtleItem);
    //   }
    // }
    // post.subtleList = subtleList;

    // 收藏、感谢、屏蔽区域 未登录为null
    if (document.querySelector("$innerQuery > div > a[class='op']") != null) {
      // 收藏状态  isFavorite:true 已收藏
      String collect = document.querySelector("$innerQuery > div > a[class='op']")!.attributes["href"]!;
      post.isFavorite = collect.startsWith('/unfavorite');

      // once

      var menuBodyNode = document.querySelector("div[id='menu-body']");
      var loginOutNode = menuBodyNode!.querySelectorAll('div.cell').last.querySelector('a');
      var loginOutHref = loginOutNode!.attributes['href'];
      int once = int.parse(loginOutHref!.split('once=')[1]);
      // GStorage().setOnce(once);

      // 收藏人数
      if (document.querySelector("$innerQuery > div > span") != null) {
        String count = document.querySelector("$innerQuery > div > span")!.text;
        if (count.contains('人收藏')) {
          post.collectCount = int.parse(count.trim().split('人收藏')[0]);
        }
      }

      // 是否感谢 isThank: true已感谢
      post.isThanked = document.querySelector("$innerQuery > div > div[id='topic_thank'] > span") != null;
      print('585 - thank: ${post.isThanked}');
    }

    // 判断是否有评论
    if (document.querySelector('#no-comments-yet') == null) {
      // 表示有评论
      // tag 标签
      // var tagBoxDom =
      //     document.querySelector('$wrapperQuery > div')!.children[2];

      // 回复数 发布时间 评论
      dom.Element replyBoxDom;
      dom.Element? totalPageDom;

      // tag标签判断
      var isHasTag = document.querySelector('$wrapperQuery > div')!.children[2].querySelector('a.tag') != null;
      if (isHasTag) {
        replyBoxDom = document.querySelector('$wrapperQuery > div')!.children[4];
      } else {
        replyBoxDom = document.querySelector('$wrapperQuery > div')!.children[2];
      }
      if (replyBoxDom.querySelectorAll('div.cell > div.fr.fade').isNotEmpty) {
        totalPageDom = replyBoxDom.querySelectorAll('div.cell > div.fr.fade').last;
      }
      post.totalPage = totalPageDom != null ? int.parse(totalPageDom.text.replaceAll(RegExp(r'\D'), '')) : 1;
      post.replyCount = int.parse(replyBoxDom.querySelector('div.cell span')!.text.replaceAll(RegExp(r"\s+"), "").split('条回复')[0]);

      /// 回复楼层
      /// first td user avatar
      /// third td main content
      List<dom.Element> rootNode = document.querySelectorAll("#Wrapper > div > div[class='box'] > div[id]");
      var replyTrQuery = 'table > tbody > tr';
      for (var aNode in rootNode) {
        Reply reply = new Reply();
        reply.avatar = Uri.encodeFull(aNode.querySelector('$replyTrQuery > td:nth-child(1) > img')!.attributes["src"]!);
        reply.username = aNode.querySelector('$replyTrQuery > td:nth-child(5) > strong > a')!.text;
        if (aNode.querySelector('$replyTrQuery > td:nth-child(5) > div.badges > div.badge') != null) {
          String status = aNode.querySelector('$replyTrQuery > td:nth-child(5) > div.badges > div.badge')!.text;
          if (status == 'MOD') {
            reply.isMod = true;
          } else if (status == 'OP') {
            reply.isOp = true;
          }
        }
        reply.date = aNode.querySelector('$replyTrQuery > td:nth-child(5) > span')!.text.replaceFirst(' +08:00', ''); // 时间（去除+ 08:00）和平台（Android/iPhone）
        reply.date = reply.date.replaceAll(' PM', '');
        reply.date = reply.date.replaceAll(' AM', '');
        if (reply.date.contains('via')) {
          var platform = reply.date.split('via')[1].replaceAll(RegExp(r"\s+"), "");
          reply.date = reply.date.split('via')[0].replaceAll("/t/", "");
          reply.platform = platform;
        }

        /// @user
        if (aNode.querySelector("$replyTrQuery > td:nth-child(5) > span[class='small fade']") != null) {
          reply.thankCount = int.parse(aNode.querySelector("$replyTrQuery > td:nth-child(5) > span[class='small fade']")!.text.split(" ")[1]);
          // 感谢状态
          if (aNode.querySelector("$replyTrQuery > td:nth-child(5) > div.fr > div.thanked") != null) {
            reply.isThanked = true;
          }
        }

        reply.floor = int.parse(aNode.querySelector('$replyTrQuery > td:nth-child(5) > div.fr > span')!.text);
        var contentDom = aNode.querySelector('$replyTrQuery > td:nth-child(5) > div.reply_content')!;
        // List decodeRes = Utils.base64Decode(contentDom);
        // if (decodeRes.isNotEmpty) {
        //   var decodeDom = '';
        //   for (var i = 0; i < decodeRes.length; i++) {
        //     decodeDom +=
        //         '<a href="base64Wechat: ${decodeRes[i]}">${decodeRes[i]}</a>';
        //     if (i != decodeRes.length - 1) {
        //       decodeDom += '<span>、</span>';
        //     }
        //   }
        //   contentDom.nodes.insert(contentDom.nodes.length,
        //       parseFragment('<p>base64解码：$decodeDom</p>'));
        // }
        // reply.contentRendered = Utils.linkMatch(contentDom);
        var reply_content = aNode.querySelector('$replyTrQuery > td:nth-child(5) > div.reply_content');

        reply.replyContent = reply_content!.innerHtml;
        reply.replyText = reply_content!.text;
        // if (aNode.querySelector('$replyTrQuery > td:nth-child(5) > div.reply_content')!.querySelector('img') != null) {
        //   var imgNodes = aNode.querySelector('$replyTrQuery > td:nth-child(5) > div.reply_content')!.querySelectorAll('img');
        //   for (var imgNode in imgNodes) {
        //     reply.imgList.add(Utils().imageUrl(imgNode.attributes['src']!));
        //   }
        // }

        var parsedContent = Utils.parseReplyContent(reply.replyContent);
        var users = parsedContent['users'];
        var floor = parsedContent['floor'];
        reply.hideCallUserReplyContent = reply.replyContent;

        if (users.length == 1) {
          reply.hideCallUserReplyContent = reply.replyContent.replaceAll(RegExp(r'@<a href="\/member\/[\s\S]+?<\/a>(\s#[\d]+)?\s(<br>)?'), '');
        }

        reply.replyUsers = users;
        reply.replyFloor = floor;

        reply.id = aNode.attributes["id"]!.substring(2);
        replies.add(reply);
      }
    }
    post.replyList = replies;
    return post;
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
      // 获取最后一页最近一条
      SmartDialog.showLoading(msg: '获取最新回复');
      var replyDetail = await getTopicDetail(id, totalPage + 1);
      var lastReply = replyDetail.replyList.reversed.firstWhere((item) => item.username == GStorage().getUserInfo()['userName']);
      SmartDialog.dismiss();
      GStorage().setReplyItem(lastReply);
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
