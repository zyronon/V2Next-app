// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/material.dart' hide Element;
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' hide Cookie;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' hide Text;
import 'package:path_provider/path_provider.dart';
import 'package:v2ex/model/BaseController.dart';
import 'package:v2ex/model/Post2.dart';
import 'package:v2ex/utils/ConstVal.dart';
import 'package:v2ex/utils/request.dart';
import 'package:v2ex/utils/storage.dart';
import 'package:v2ex/utils/upload.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class Utils {
  static Future<String> getCookiePath() async {
    Directory tempDir = await getApplicationDocumentsDirectory();
    String tempPath = "${tempDir.path}/v2nexCookie";
    Directory dir = Directory(tempPath);
    bool b = await dir.exists();
    if (!b) {
      dir.createSync(recursive: true);
    }

    return tempPath;
  }

  // https://usamaejaz.com/cloudflare-email-decoding/
  // cloudflare email 转码
  static String cfDecodeEmail(String encodedString) {
    var email = "", r = int.parse(encodedString.substring(0, 2), radix: 16), n, i;
    for (n = 2; encodedString.length - n > 0; n += 2) {
      i = int.parse(encodedString.substring(n, n + 2), radix: 16) ^ r;
      email += String.fromCharCode(i);
    }
    return email;
  }

  static openURL(aUrl) async {
    bool linkOpenType = GStorage().getLinkOpenInApp();
    if (!linkOpenType) {
      // 1. openWithSystemBrowser
      try {
        await InAppBrowser.openWithSystemBrowser(url: WebUri(aUrl));
      } catch (err) {
        SmartDialog.showToast(err.toString());
      }
    } else {
      // 2. openWithAppBrowser
      try {
        await ChromeSafariBrowser().open(url: WebUri(aUrl));
      } catch (err) {
        // SmartDialog.showToast(err.toString());
        // https://github.com/guozhigq/flutter_v2ex/issues/49
        GStorage().setLinkOpenInApp(false);
        try {
          await InAppBrowser.openWithSystemBrowser(url: WebUri(aUrl));
        } catch (err) {
          SmartDialog.showToast('openURL: $err');
        }
      }
    }
  }

  static Map<String, dynamic> parseReplyContent(String str) {
    if (str.isEmpty) return {};

    List<String> users = [];
    void getUsername(String userStr) {
      int endIndex = userStr.indexOf('">');
      if (endIndex > -1) {
        String user = userStr.substring(0, endIndex);
        if (!users.contains(user)) {
          users.add(user);
        }
      }
    }

    RegExp userReg = RegExp(r'@<a href="\/member\/([\s\S]+?)<\/a>');
    Iterable<RegExpMatch> has = userReg.allMatches(str);
    List<RegExpMatch> res2 = has.toList();

    if (res2.length > 1) {
      for (var item in res2) {
        getUsername(item.group(1)!);
      }
    }
    if (res2.length == 1) {
      getUsername(res2[0].group(1)!);
    }

    int floor = -1;

    if (users.length == 1) {
      RegExp floorReg = RegExp(r'@<a href="\/member\/[\s\S]+?<\/a>[\s]+#([\d]+)');
      Iterable<RegExpMatch> hasFloor = floorReg.allMatches(str);
      List<RegExpMatch> res = hasFloor.toList();
      if (res.isNotEmpty) {
        floor = int.parse(res[0].group(1)!);
      }
    }

    return {'users': users, 'floor': floor};
  }

  static List<Reply> getAllReply([List<Map> repliesMap = const []]) {
    repliesMap.sort((a, b) => a['i'].compareTo(b['i']));
    return repliesMap.fold<List<Reply>>([], (pre, i) {
      pre.addAll(i['replyList']);
      return pre;
    });
  }

  static List<Reply> createNestedList({List<Reply> list = const [], List<Reply> topReplyList = const []}) {
    if (list.isEmpty) return [];

    var s = list.map((v) => 'floor:${v.floor} | isUse:${v.isUse}').toString();
    print('ss:${s}');
    List<Reply> nestedList = [];
    for (int index = 0; index < list.length; index++) {
      var item = list[index];

      List<Reply> startList = list.sublist(0, index);
      // 用于918489这种情况，@不存在的人
      Set startReplyUsers = startList.map((v) => v.username).toSet();

      List<Reply> endList = list.sublist(index + 1);

      // print('floor:${item.floor.toString()} | use:${item.isUse.toString()}');

      if (index == 0) {
        nestedList.add(findChildren(item, endList, list, topReplyList));
      } else {
        if (!item.isUse) {
          // 是否是一级回复
          bool isOneLevelReply = false;
          if (item.replyUsers.isNotEmpty) {
            if (item.replyUsers.length > 1) {
              isOneLevelReply = true;
            } else {
              isOneLevelReply = !startReplyUsers.contains(item.replyUsers[0]);
            }
          } else {
            isOneLevelReply = true;
          }
          if (isOneLevelReply) {
            item.level = 0;
            nestedList.add(findChildren(item, endList, list, topReplyList));
          }
        }
      }
    }
    return nestedList;
  }

  //查找子回复
  static Reply findChildren(Reply item, List<Reply> endList, List<Reply> all, List<Reply> topReplyList) {
    void fn(Reply child, List<Reply> endList2, Reply parent) {
      child.level = parent.level + 1;
      //用于标记为已使用，直接标记源数据靠谱点，标记child可能会有问题
      int rIndex = all.indexWhere((v) => v.floor == child.floor);
      if (rIndex > -1) {
        all[rIndex].isUse = true;
      }
      parent.children.add(findChildren(child, endList2, all, topReplyList));
    }

    item.children = [];
    List<dynamic> floorReplyList = [];

    //先找到指定楼层的回复，再去循环查找子回复
    for (int i = 0; i < endList.length; i++) {
      var currentItem = endList[i];
      //如果已被使用，直接跳过
      if (currentItem.isUse) continue;
      if (currentItem.replyFloor == item.floor) {
        //必须楼层对应的名字和@人的名字相同。因为经常出现不相同的情况
        if (currentItem.replyUsers.length == 1 && currentItem.replyUsers[0] == item.username) {
          //先标记为使用，不然遇到“问题930155”，会出现重复回复
          currentItem.isUse = true;
          floorReplyList.add({'endList': endList.sublist(i + 1), 'currentItem': currentItem});
        } else {
          currentItem.isWrong = true;
        }
      }
    }

    //从后往前找
    floorReplyList.reversed.forEach((element) {
      fn(element['currentItem'], element['endList'], item);
    });

    //下一个我的下标，如果有下一个我，那么当前item的子回复应在当前和下个我的区间内查找
    int nextMeIndex = endList.indexWhere((v) => (v.username == item.username) && (v.replyUsers.isNotEmpty && v.replyUsers[0] != item.username));
    List<Reply> findList = nextMeIndex > -1 ? endList.sublist(0, nextMeIndex) : endList;

    for (int i = 0; i < findList.length; i++) {
      var currentItem = findList[i];
      //如果已被使用，直接跳过
      if (currentItem.isUse) continue;

      if (currentItem.replyUsers.length == 1) {
        //如果这条数据指定了楼层，并且名字也能匹配上，那么直接忽略
        if (currentItem.replyFloor != -1) {
          if (all[currentItem.replyFloor - 1].username == currentItem.replyUsers[0]) {
            continue;
          }
        }
        List<Reply> endList2 = endList.sublist(i + 1);
        //如果是下一条是同一人的回复，那么跳出循环
        if (currentItem.username == item.username) {
          //自己回复自己的特殊情况
          if (currentItem.replyUsers[0] == item.username) {
            fn(currentItem, endList2, item);
          }
          break;
        } else {
          if (currentItem.replyUsers[0] == item.username) {
            fn(currentItem, endList2, item);
          }
        }
      } else {
        //下一条是同一人的回复，并且均未@人。直接跳过
        if (currentItem.username == item.username) break;
      }
    }

    //排序，因为指定楼层时，是从后往前找的
    item.children.sort((a, b) => a.floor.compareTo(b.floor));
    item.replyCount = item.children.fold(0, (a, b) => a + (b.children.isNotEmpty ? b.replyCount + 1 : 1));

    int rIndex = topReplyList.indexWhere((v) => v.floor == item.floor);
    if (rIndex > -1) {
      topReplyList[rIndex].children = item.children;
      topReplyList[rIndex].replyCount = item.replyCount;
    }
    return item;
  }

  static Post2 buildList(Post2 post, List<Reply> replyList) {
    post.replyList = clone(replyList);
    post.replyCount = post.replyList.length;
    post.topReplyList = clone(post.replyList).where((v) {
      return v.thankCount >= 3;
    }).toList();
    post.topReplyList.sort((a, b) => b.thankCount.compareTo(a.thankCount));
    post.topReplyList = post.topReplyList.sublist(0, post.topReplyList.length > 5 ? 5 : post.topReplyList.length);
    post.allReplyUsers = post.replyList.map((v) => v.username).toList().toSet().toList();
    post.nestedReplies = createNestedList(list: clone(replyList), topReplyList: post.topReplyList);
    return post;
  }

  static List<Reply> clone(List<Reply> val) {
    return val.map((v) => Reply.fromJson(v.toJson())).toList();
  }

  //TODO
  static String checkPhotoLink2Img(String val) {
    return val;
  }

  // 定义一个函数，返回一个处理后的Future，包含状态和结果
  static Future<Map<String, dynamic>> allSettledWrapper(Future future) async {
    try {
      var result = await future;
      return {'status': 'fulfilled', 'value': result};
    } catch (error) {
      return {'status': 'rejected', 'reason': error};
    }
  }

// 实现类似 Promise.allSettled 的方法
  static Future<List<Map<String, dynamic>>> allSettled(List<Future> futures) async {
    // 对每个 Future 都调用 wrapper 函数
    return Future.wait(futures.map((f) => allSettledWrapper(f)));
  }

  String headerUa(ua) {
    String headerUa = '';
    if (ua == 'mob') {
      headerUa = Platform.isIOS ? Const.agent.ios : Const.agent.android;
    } else {
      // headerUa = 'Mozilla/5.0 (MaciMozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36';
      headerUa = Const.agent.pc;
    }
    return headerUa;
  }

  List<Post2> parsePagePostList(List<Element> list) {
    List<Post2> topicList = [];
    if (list.isNotEmpty) {
      for (Element aNode in list) {
        Post2 item = Post2();
        Element? titleInfo = aNode.querySelector(".topic-link");
        if (titleInfo != null) {
          item.title = titleInfo.text;
          String? href = titleInfo.attributes['href'];
          var match = RegExp(r'(\d+)').allMatches(href!);
          var result = match.map((m) => m.group(0)).toList();
          item.id = result[0]!;
        }
        Element? countEl = aNode.querySelector('.count_livid');
        if (countEl != null) {
          item.replyCount = int.parse(countEl.text);
        }

        var avatarEl = aNode.querySelector('.avatar');
        if (avatarEl != null) {
          item.member.avatar = avatarEl.attributes['src']!;
        }

        Element? nodeEl = aNode.querySelector('.node');
        if (nodeEl != null) {
          item.node.cnName = nodeEl.text;
          item.node.enName = nodeEl.attributes['href']!.replaceFirst('/go/', '');
        }

        List<Element> spanList = aNode.querySelectorAll('span[class="small fade"]');
        // print('spanList${spanList.length}',);
        if (spanList.isNotEmpty) {
          Element topInfo = spanList[0];
          Element? username = topInfo.querySelector('strong a');
          if (username != null) {
            item.member.username = username.text;
          }
          if (spanList.length > 1) {
            Element bottomInfo = spanList[1];
            Element? username = bottomInfo.querySelector('a');
            if (username != null) {
              item.lastReplyUsername = username.text;
              //移除了好取parent的text;
              username.remove();
            }
            String s = bottomInfo.text.replaceAll('•  最后回复来自', '').trim();
            item.lastReplyDateAgo = s.replaceFirst(' +08:00', '').trim();
            if (item.lastReplyDateAgo == '置顶') {
              item.isTop = true;
              item.lastReplyDateAgo = '';
            }
          }
        } else {
          String? style = aNode.attributes['style'];
          if (style != null) {
            item.isTop = style.length != 0;
          }
          Element? topicInfoEl = aNode.querySelector('.topic_info');
          if (topicInfoEl != null) {
            List<Element> strongList = topicInfoEl.querySelectorAll('strong');
            if (strongList.isNotEmpty) {
              item.member.username = strongList[0].text;

              if (strongList.length > 1) {
                item.lastReplyUsername = strongList[1].text;
              }
            }

            Element? date = topicInfoEl.querySelector('span');
            if (date != null) {
              item.lastReplyDateAgo = date.text.replaceFirst(' +08:00', '');
              ;
            }
          }
        }
        topicList.add(item);
      }
    }
    return topicList;
  }

  showNotAllowDialog() {
    BaseController bc = Get.find();
    SmartDialog.show(
      useSystem: true,
      animationType: SmartAnimationType.centerFade_otherSlide,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('权限不足'),
          content: Text(bc.isLogin ? '' : '登录后查看节点内容'),
          actions: [
            TextButton(
              onPressed: (() => {SmartDialog.dismiss(), Get.back()}),
              child: const Text('返回上一页'),
            ),
            TextButton(
                // TODO
                onPressed: (() => {Navigator.of(context).pushNamed('/login')}),
                child: const Text('去登录'))
          ],
        );
      },
    );
  }

  String _twoDigits(int n) {
    return n >= 10 ? "$n" : "0$n";
  }

  String timeAgo(String dateTime) {
    final d = DateTime.parse(dateTime);
    final now = DateTime.now();
    final difference = now.difference(d);

    if (difference.inSeconds < 60) {
      return "${difference.inSeconds}秒前";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes}分钟前";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}小时前";
    } else if (difference.inDays < 3) {
      return "${difference.inDays}天前";
    } else {
      // 超过3天，显示具体日期
      // 超过3天，显示具体日期，手动格式化日期
      return "${d.year}-${_twoDigits(d.month)}-${_twoDigits(d.day)} "
          "${_twoDigits(d.hour)}:${_twoDigits(d.minute)}";
    }
  }

  Future uploadImage() async {
    final List<AssetEntity>? assets = await AssetPicker.pickAssets(
      Get.context!,
      pickerConfig: const AssetPickerConfig(
        maxAssets: 1,
        requestType: RequestType.image,
      ),
    );
    if (assets != null && assets.isNotEmpty) {
      SmartDialog.showLoading(msg: '上传中...');
      AssetEntity? file = assets[0];
      var res = await Upload.uploadImage('1', file);
      SmartDialog.dismiss();
      return res;
    }
    return ('no image selected');
  }

  static Future<void> syncCookies(String url) async {
    final inAppCookieManager = CookieManager.instance();
    CookieJar cookieJar = Http.cookieManager.cookieJar;
    // var cookies = await inAppCookieManager.getCookies(url: WebUri(url));
    // List<Cookie> jarCookies = [];
    // if (cookies.isNotEmpty) {
    //   for (var i in cookies) {
    //     jarCookies.add(Cookie(i.name, i.value));
    //   }
    // }
    // cookieJar.saveFromResponse(Uri.parse(url), jarCookies);
    // var cookieString = jarCookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');
    // Http.dio.options.headers['cookie'] = cookieString;

    // debugger();
    // 从 Dio 的 CookieJar 获取 Cookie 并设置到 InAppWebView 中
    final dioCookies = await cookieJar.loadForRequest(Uri.parse(url));
    for (var cookie in dioCookies) {
      // final expiresDate = DateTime.now().add(Duration(days: 3)).millisecondsSinceEpoch;
      await inAppCookieManager.setCookie(
        url: WebUri(url),
        name: cookie.name,
        value: cookie.value,
        domain: cookie.domain,
        // path: cookie.path!,
        path: '/',
        // expiresDate: expiresDate,
        expiresDate: cookie.expires != null ? cookie.expires!.millisecondsSinceEpoch : null,
        isSecure: cookie.secure,
        isHttpOnly: cookie.httpOnly,
      );
    }
  }

  static toast(String msg) {
    SmartDialog.showToast(msg);
  }

  static Future<void> copy(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    toast('已复制');
  }

  static Future<void> openBrowser(String url) async {
    final Uri uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  static base64Decode2(String base64String) {
    return utf8.decode(base64Decode(base64String));
  }
}
