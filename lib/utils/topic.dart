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
    String url = isCollect ? ("/unfavorite/topic/$topicId?once=$once") : ("/favorite/topic/$topicId?once=$once");
    var response = await Request().get(url, extra: {'ua': 'mob'});
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
  static Future<String> onSubmitReplyTopic(String id, String replyContent) async {
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
