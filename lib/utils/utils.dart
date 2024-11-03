// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:html/parser.dart';
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
import 'package:v2ex/utils/api.dart';
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

  static checkPhotoLink2Img(Element dom) {
    // bool replaceImgur = window.config['replaceImgur'];
    bool replaceImgur = true;
    String prefixImg = replaceImgur ? "https://img.noobzone.ru/getimg.php?url=" : '';

    List<Element> imgList = dom.querySelectorAll('img');
    imgList.forEach((Element a) {
      String href = a.attributes['src']!;
      if (href.contains('imgur.com')) {
        a.attributes['originUrl'] = a.attributes['src']!;
        a.attributes['notice'] = '此img标签由V2Next脚本解析';
        if (!['.png', '.jpg', '.jpeg', '.gif', '.PNG', '.JPG', '.JPEG', '.GIF'].any((ext) => href.contains(ext))) {
          href += '.png';
        }
        a.attributes['src'] = prefixImg + href;
      }
    });

    List<Element> aList = dom.querySelectorAll('a');
    aList.forEach((Element a) {
      String href = a.attributes['href']!;
      if (a.children.isEmpty && a.text == href) {
        if (['.png', '.jpg', '.jpeg', '.gif', '.PNG', '.JPG', '.JPEG', '.GIF'].any((ext) => href.contains(ext))) {
          Element img = Element.tag('img');
          img.attributes['originUrl'] = a.attributes['href']!;
          img.attributes['notice'] = '此img标签由V2Next脚本解析';

          if (href.contains('imgur.com')) {
            img.attributes['src'] = prefixImg + href;
          } else {
            img.attributes['src'] = href;
          }
          a.text = '';
          a.append(img);
        }
      }
    });
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
        countEl = aNode.querySelector('.count_orange');
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

  // 从 Dio 的 CookieJar 获取 Cookie 并设置到 InAppWebView 中
  static Future<void> dioSyncCookie2InApp(String url) async {
    final inAppCookieManager = CookieManager.instance();
    CookieJar cookieJar = Http.cookieManager.cookieJar;
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


  static inAppSyncCookie2Dio(List cookiesList, String url) async {
    // 接收 flutter_inappwebview Cookie List
    // domain url
    List<Cookie> jarCookies = [];
    if (cookiesList.isNotEmpty) {
      for (var i in cookiesList) {
        Cookie jarCookie = Cookie(i.name, i.value);
        jarCookies.add(jarCookie);
      }
    }
    await Http.cookieManager.cookieJar.saveFromResponse(Uri.parse("https://www.v2ex.com/"), jarCookies);
    var cookieString = jarCookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');
    Http.dio.options.headers['cookie'] = cookieString;
    return true;
  }

  static toast({String msg = '', int duration = 3}) {
    SmartDialog.showToast(msg, displayTime: Duration(seconds: duration));
  }

  static Future<void> copy(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    toast(msg: '已复制');
  }

  static Future<void> openBrowser(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      toast(msg: '无法打开链接 $url');
    }
  }

  static base64Decode2(String base64String) {
    return utf8.decode(base64Decode(base64String));
  }

  static bool checkIsLogin() {
    BaseController bc = Get.find();
    if (!bc.isLogin) {
      Get.toNamed('/login');
      return false;
    }
    return true;
  }

  static resolveNode(response, type) {
    List<Map<dynamic, dynamic>> nodesList = [];
    var document = parse(response.data);
    var nodesBox;
    // 【设置】中可能关闭【首页显示节点导航】
    if (document.querySelector('#Main')!.children.length >= 4) {
      nodesBox = document.querySelector('#Main')!.children.last;
    } else {
      document = parse('''
        <div class="box">
    <div class="cell"><div class="fr"><a href="/planes">浏览全部节点</a></div><span class="fade"><strong>V2EX</strong> / 节点导航</span></div>
    <div class="cell"><table cellpadding="0" cellspacing="0" border="0"><tbody><tr><td align="right" width="80"><span class="fade">分享与探索</span></td><td style="line-height: 200%; padding-left: 10px; word-break: keep-all;"><a href="/go/qna" style="font-size: 14px;">问与答</a>&nbsp; &nbsp; <a href="/go/share" style="font-size: 14px;">分享发现</a>&nbsp; &nbsp; <a href="/go/create" style="font-size: 14px;">分享创造</a>&nbsp; &nbsp; <a href="/go/ideas" style="font-size: 14px;">奇思妙想</a>&nbsp; &nbsp; <a href="/go/in" style="font-size: 14px;">分享邀请码</a>&nbsp; &nbsp; <a href="/go/autistic" style="font-size: 14px;">自言自语</a>&nbsp; &nbsp; <a href="/go/design" style="font-size: 14px;">设计</a>&nbsp; &nbsp; <a href="/go/blog" style="font-size: 14px;">Blog</a>&nbsp; &nbsp; </td></tr></tbody></table></div><div class="cell"><table cellpadding="0" cellspacing="0" border="0"><tbody><tr><td align="right" width="80"><span class="fade">V2EX</span></td><td style="line-height: 200%; padding-left: 10px; word-break: keep-all;"><a href="/go/v2ex" style="font-size: 14px;">V2EX</a>&nbsp; &nbsp; <a href="/go/feedback" style="font-size: 14px;">反馈</a>&nbsp; &nbsp; <a href="/go/guide" style="font-size: 14px;">使用指南</a>&nbsp; &nbsp; </td></tr></tbody></table></div><div class="cell"><table cellpadding="0" cellspacing="0" border="0"><tbody><tr><td align="right" width="80"><span class="fade">Apple</span></td><td style="line-height: 200%; padding-left: 10px; word-break: keep-all;"><a href="/go/apple" style="font-size: 14px;">Apple</a>&nbsp; &nbsp; <a href="/go/macos" style="font-size: 14px;">macOS</a>&nbsp; &nbsp; <a href="/go/iphone" style="font-size: 14px;">iPhone</a>&nbsp; &nbsp; <a href="/go/mbp" style="font-size: 14px;">MacBook Pro</a>&nbsp; &nbsp; <a href="/go/ios" style="font-size: 14px;">iOS</a>&nbsp; &nbsp; <a href="/go/ipad" style="font-size: 14px;">iPad</a>&nbsp; &nbsp; <a href="/go/watch" style="font-size: 14px;"> WATCH</a>&nbsp; &nbsp; <a href="/go/macbook" style="font-size: 14px;">MacBook</a>&nbsp; &nbsp; <a href="/go/accessory" style="font-size: 14px;">配件</a>&nbsp; &nbsp; <a href="/go/mba" style="font-size: 14px;">MacBook Air</a>&nbsp; &nbsp; <a href="/go/macmini" style="font-size: 14px;">Mac mini</a>&nbsp; &nbsp; <a href="/go/imac" style="font-size: 14px;">iMac</a>&nbsp; &nbsp; <a href="/go/xcode" style="font-size: 14px;">Xcode</a>&nbsp; &nbsp; <a href="/go/airpods" style="font-size: 14px;">AirPods</a>&nbsp; &nbsp; <a href="/go/macpro" style="font-size: 14px;">Mac Pro</a>&nbsp; &nbsp; <a href="/go/wwdc" style="font-size: 14px;">WWDC</a>&nbsp; &nbsp; <a href="/go/ipod" style="font-size: 14px;">iPod</a>&nbsp; &nbsp; <a href="/go/macstudio" style="font-size: 14px;">Mac Studio</a>&nbsp; &nbsp; <a href="/go/homekit" style="font-size: 14px;">HomeKit</a>&nbsp; &nbsp; <a href="/go/iwork" style="font-size: 14px;">iWork</a>&nbsp; &nbsp; <a href="/go/mobileme" style="font-size: 14px;">MobileMe</a>&nbsp; &nbsp; <a href="/go/ilife" style="font-size: 14px;">iLife</a>&nbsp; &nbsp; <a href="/go/garageband" style="font-size: 14px;">GarageBand</a>&nbsp; &nbsp; <a href="/go/macos9" style="font-size: 14px;">Mac OS 9</a>&nbsp; &nbsp; <a href="/go/freeform" style="font-size: 14px;">Freeform</a>&nbsp; &nbsp; <a href="/go/macgaming" style="font-size: 14px;">Mac 游戏</a>&nbsp; &nbsp; <a href="/go/imovie" style="font-size: 14px;">iMovie</a>&nbsp; &nbsp; </td></tr></tbody></table></div><div class="cell"><table cellpadding="0" cellspacing="0" border="0"><tbody><tr><td align="right" width="80"><span class="fade">前端开发</span></td><td style="line-height: 200%; padding-left: 10px; word-break: keep-all;"><a href="/go/wechat" style="font-size: 14px;">微信</a>&nbsp; &nbsp; <a href="/go/fe" style="font-size: 14px;">前端开发</a>&nbsp; &nbsp; <a href="/go/chrome" style="font-size: 14px;">Chrome</a>&nbsp; &nbsp; <a href="/go/vue" style="font-size: 14px;">Vue.js</a>&nbsp; &nbsp; <a href="/go/browsers" style="font-size: 14px;">浏览器</a>&nbsp; &nbsp; <a href="/go/react" style="font-size: 14px;">React</a>&nbsp; &nbsp; <a href="/go/css" style="font-size: 14px;">CSS</a>&nbsp; &nbsp; <a href="/go/firefox" style="font-size: 14px;">Firefox</a>&nbsp; &nbsp; <a href="/go/flutter" style="font-size: 14px;">Flutter</a>&nbsp; &nbsp; <a href="/go/edge" style="font-size: 14px;">Edge</a>&nbsp; &nbsp; <a href="/go/angular" style="font-size: 14px;">Angular</a>&nbsp; &nbsp; <a href="/go/electron" style="font-size: 14px;">Electron</a>&nbsp; &nbsp; <a href="/go/webdev" style="font-size: 14px;">Web Dev</a>&nbsp; &nbsp; <a href="/go/nextjs" style="font-size: 14px;">Next.js</a>&nbsp; &nbsp; <a href="/go/vite" style="font-size: 14px;">Vite</a>&nbsp; &nbsp; <a href="/go/ionic" style="font-size: 14px;">Ionic</a>&nbsp; &nbsp; <a href="/go/nuxtjs" style="font-size: 14px;">Nuxt.js</a>&nbsp; &nbsp; </td></tr></tbody></table></div><div class="cell"><table cellpadding="0" cellspacing="0" border="0"><tbody><tr><td align="right" width="80"><span class="fade">编程语言</span></td><td style="line-height: 200%; padding-left: 10px; word-break: keep-all;"><a href="/go/python" style="font-size: 14px;">Python</a>&nbsp; &nbsp; <a href="/go/java" style="font-size: 14px;">Java</a>&nbsp; &nbsp; <a href="/go/php" style="font-size: 14px;">PHP</a>&nbsp; &nbsp; <a href="/go/go" style="font-size: 14px;">Go 编程语言</a>&nbsp; &nbsp; <a href="/go/js" style="font-size: 14px;">JavaScript</a>&nbsp; &nbsp; <a href="/go/nodejs" style="font-size: 14px;">Node.js</a>&nbsp; &nbsp; <a href="/go/cpp" style="font-size: 14px;">C++</a>&nbsp; &nbsp; <a href="/go/swift" style="font-size: 14px;">Swift</a>&nbsp; &nbsp; <a href="/go/rust" style="font-size: 14px;">Rust</a>&nbsp; &nbsp; <a href="/go/html" style="font-size: 14px;">HTML</a>&nbsp; &nbsp; <a href="/go/dotnet" style="font-size: 14px;">.NET</a>&nbsp; &nbsp; <a href="/go/csharp" style="font-size: 14px;">C#</a>&nbsp; &nbsp; <a href="/go/ror" style="font-size: 14px;">Ruby on Rails</a>&nbsp; &nbsp; <a href="/go/typescript" style="font-size: 14px;">TypeScript</a>&nbsp; &nbsp; <a href="/go/ruby" style="font-size: 14px;">Ruby</a>&nbsp; &nbsp; <a href="/go/kotlin" style="font-size: 14px;">Kotlin</a>&nbsp; &nbsp; <a href="/go/lua" style="font-size: 14px;">Lua</a>&nbsp; &nbsp; </td></tr></tbody></table></div><div class="cell"><table cellpadding="0" cellspacing="0" border="0"><tbody><tr><td align="right" width="80"><span class="fade">后端架构</span></td><td style="line-height: 200%; padding-left: 10px; word-break: keep-all;"><a href="/go/cloud" style="font-size: 14px;">云计算</a>&nbsp; &nbsp; <a href="/go/server" style="font-size: 14px;">服务器</a>&nbsp; &nbsp; <a href="/go/dns" style="font-size: 14px;">DNS</a>&nbsp; &nbsp; <a href="/go/mysql" style="font-size: 14px;">MySQL</a>&nbsp; &nbsp; <a href="/go/nginx" style="font-size: 14px;">NGINX</a>&nbsp; &nbsp; <a href="/go/docker" style="font-size: 14px;">Docker</a>&nbsp; &nbsp; <a href="/go/db" style="font-size: 14px;">数据库</a>&nbsp; &nbsp; <a href="/go/k8s" style="font-size: 14px;">Kubernetes</a>&nbsp; &nbsp; <a href="/go/ubuntu" style="font-size: 14px;">Ubuntu</a>&nbsp; &nbsp; <a href="/go/aws" style="font-size: 14px;">Amazon Web Services</a>&nbsp; &nbsp; <a href="/go/django" style="font-size: 14px;">Django</a>&nbsp; &nbsp; <a href="/go/redis" style="font-size: 14px;">Redis</a>&nbsp; &nbsp; <a href="/go/mongodb" style="font-size: 14px;">MongoDB</a>&nbsp; &nbsp; <a href="/go/devops" style="font-size: 14px;">DevOps</a>&nbsp; &nbsp; <a href="/go/cloudflare" style="font-size: 14px;">Cloudflare</a>&nbsp; &nbsp; <a href="/go/elasticsearch" style="font-size: 14px;">Elasticsearch</a>&nbsp; &nbsp; <a href="/go/flask" style="font-size: 14px;">Flask</a>&nbsp; &nbsp; <a href="/go/tornado" style="font-size: 14px;">Tornado</a>&nbsp; &nbsp; <a href="/go/api" style="font-size: 14px;">API</a>&nbsp; &nbsp; <a href="/go/leancloud" style="font-size: 14px;">LeanCloud</a>&nbsp; &nbsp; <a href="/go/timescale" style="font-size: 14px;">Timescale</a>&nbsp; &nbsp; </td></tr></tbody></table></div><div class="cell"><table cellpadding="0" cellspacing="0" border="0"><tbody><tr><td align="right" width="80"><span class="fade">Crypto</span></td><td style="line-height: 200%; padding-left: 10px; word-break: keep-all;"><a href="/go/bitcoin" style="font-size: 14px;">Bitcoin</a>&nbsp; &nbsp; <a href="/go/crypto" style="font-size: 14px;">加密货币</a>&nbsp; &nbsp; <a href="/go/ripple" style="font-size: 14px;">Ripple</a>&nbsp; &nbsp; <a href="/go/ethereum" style="font-size: 14px;">以太坊</a>&nbsp; &nbsp; <a href="/go/solidity" style="font-size: 14px;">Solidity</a>&nbsp; &nbsp; <a href="/go/solana" style="font-size: 14px;">Solana</a>&nbsp; &nbsp; <a href="/go/metamask" style="font-size: 14px;">MetaMask</a>&nbsp; &nbsp; <a href="/go/ton" style="font-size: 14px;">TON</a>&nbsp; &nbsp; </td></tr></tbody></table></div><div class="cell"><table cellpadding="0" cellspacing="0" border="0"><tbody><tr><td align="right" width="80"><span class="fade">机器学习</span></td><td style="line-height: 200%; padding-left: 10px; word-break: keep-all;"><a href="/go/ml" style="font-size: 14px;">机器学习</a>&nbsp; &nbsp; <a href="/go/math" style="font-size: 14px;">数学</a>&nbsp; &nbsp; <a href="/go/tensorflow" style="font-size: 14px;">TensorFlow</a>&nbsp; &nbsp; <a href="/go/nlp" style="font-size: 14px;">自然语言处理</a>&nbsp; &nbsp; <a href="/go/cuda" style="font-size: 14px;">CUDA</a>&nbsp; &nbsp; <a href="/go/torch" style="font-size: 14px;">Torch</a>&nbsp; &nbsp; <a href="/go/keras" style="font-size: 14px;">Keras</a>&nbsp; &nbsp; <a href="/go/coreml" style="font-size: 14px;">Core ML</a>&nbsp; &nbsp; </td></tr></tbody></table></div><div class="cell"><table cellpadding="0" cellspacing="0" border="0"><tbody><tr><td align="right" width="80"><span class="fade">iOS</span></td><td style="line-height: 200%; padding-left: 10px; word-break: keep-all;"><a href="/go/idev" style="font-size: 14px;">iDev</a>&nbsp; &nbsp; <a href="/go/icode" style="font-size: 14px;">iCode</a>&nbsp; &nbsp; <a href="/go/imarketing" style="font-size: 14px;">iMarketing</a>&nbsp; &nbsp; <a href="/go/iad" style="font-size: 14px;">iAd</a>&nbsp; &nbsp; </td></tr></tbody></table></div><div class="cell"><table cellpadding="0" cellspacing="0" border="0"><tbody><tr><td align="right" width="80"><span class="fade">Geek</span></td><td style="line-height: 200%; padding-left: 10px; word-break: keep-all;"><a href="/go/programmer" style="font-size: 14px;">程序员</a>&nbsp; &nbsp; <a href="/go/bb" style="font-size: 14px;">宽带症候群</a>&nbsp; &nbsp; <a href="/go/android" style="font-size: 14px;">Android</a>&nbsp; &nbsp; <a href="/go/linux" style="font-size: 14px;">Linux</a>&nbsp; &nbsp; <a href="/go/outsourcing" style="font-size: 14px;">外包</a>&nbsp; &nbsp; <a href="/go/hardware" style="font-size: 14px;">硬件</a>&nbsp; &nbsp; <a href="/go/windows" style="font-size: 14px;">Windows</a>&nbsp; &nbsp; <a href="/go/openai" style="font-size: 14px;">OpenAI</a>&nbsp; &nbsp; <a href="/go/car" style="font-size: 14px;">汽车</a>&nbsp; &nbsp; <a href="/go/router" style="font-size: 14px;">路由器</a>&nbsp; &nbsp; <a href="/go/webmaster" style="font-size: 14px;">站长</a>&nbsp; &nbsp; <a href="/go/openwrt" style="font-size: 14px;">OpenWrt</a>&nbsp; &nbsp; <a href="/go/programming" style="font-size: 14px;">编程</a>&nbsp; &nbsp; <a href="/go/github" style="font-size: 14px;">GitHub</a>&nbsp; &nbsp; <a href="/go/vscode" style="font-size: 14px;">Visual Studio Code</a>&nbsp; &nbsp; <a href="/go/blockchain" style="font-size: 14px;">区块链</a>&nbsp; &nbsp; <a href="/go/markdown" style="font-size: 14px;">Markdown</a>&nbsp; &nbsp; <a href="/go/designer" style="font-size: 14px;">设计师</a>&nbsp; &nbsp; <a href="/go/kindle" style="font-size: 14px;">Kindle</a>&nbsp; &nbsp; <a href="/go/gamedev" style="font-size: 14px;">游戏开发</a>&nbsp; &nbsp; <a href="/go/pi" style="font-size: 14px;">Raspberry Pi</a>&nbsp; &nbsp; <a href="/go/business" style="font-size: 14px;">商业模式</a>&nbsp; &nbsp; <a href="/go/typography" style="font-size: 14px;">字体排印</a>&nbsp; &nbsp; <a href="/go/vxna" style="font-size: 14px;">VXNA</a>&nbsp; &nbsp; <a href="/go/ifix" style="font-size: 14px;">云修电脑</a>&nbsp; &nbsp; <a href="/go/atom" style="font-size: 14px;">Atom</a>&nbsp; &nbsp; <a href="/go/ev" style="font-size: 14px;">电动汽车</a>&nbsp; &nbsp; <a href="/go/copilot" style="font-size: 14px;">GitHub Copilot</a>&nbsp; &nbsp; <a href="/go/sony" style="font-size: 14px;">SONY</a>&nbsp; &nbsp; <a href="/go/rss" style="font-size: 14px;">RSS</a>&nbsp; &nbsp; <a href="/go/leetcode" style="font-size: 14px;">LeetCode</a>&nbsp; &nbsp; <a href="/go/photoshop" style="font-size: 14px;">Photoshop</a>&nbsp; &nbsp; <a href="/go/amazon" style="font-size: 14px;">Amazon</a>&nbsp; &nbsp; <a href="/go/serverless" style="font-size: 14px;">Serverless</a>&nbsp; &nbsp; <a href="/go/gitlab" style="font-size: 14px;">GitLab</a>&nbsp; &nbsp; <a href="/go/ipfs" style="font-size: 14px;">IPFS</a>&nbsp; &nbsp; <a href="/go/lego" style="font-size: 14px;">LEGO</a>&nbsp; &nbsp; <a href="/go/dji" style="font-size: 14px;">DJI</a>&nbsp; &nbsp; <a href="/go/blender" style="font-size: 14px;">Blender</a>&nbsp; &nbsp; <a href="/go/logseq" style="font-size: 14px;">Logseq</a>&nbsp; &nbsp; <a href="/go/dos" style="font-size: 14px;">DOS</a>&nbsp; &nbsp; <a href="/go/gamedb" style="font-size: 14px;">GameDB</a>&nbsp; &nbsp; </td></tr></tbody></table></div><div class="cell"><table cellpadding="0" cellspacing="0" border="0"><tbody><tr><td align="right" width="80"><span class="fade">游戏</span></td><td style="line-height: 200%; padding-left: 10px; word-break: keep-all;"><a href="/go/games" style="font-size: 14px;">游戏</a>&nbsp; &nbsp; <a href="/go/steam" style="font-size: 14px;">Steam</a>&nbsp; &nbsp; <a href="/go/switch" style="font-size: 14px;">Nintendo Switch</a>&nbsp; &nbsp; <a href="/go/minecraft" style="font-size: 14px;">Minecraft</a>&nbsp; &nbsp; <a href="/go/ps4" style="font-size: 14px;">PlayStation 4</a>&nbsp; &nbsp; <a href="/go/igame" style="font-size: 14px;">iGame</a>&nbsp; &nbsp; <a href="/go/sc2" style="font-size: 14px;">StarCraft 2</a>&nbsp; &nbsp; <a href="/go/bf3" style="font-size: 14px;">Battlefield 3</a>&nbsp; &nbsp; <a href="/go/wow" style="font-size: 14px;">World of Warcraft</a>&nbsp; &nbsp; <a href="/go/retro" style="font-size: 14px;">怀旧游戏</a>&nbsp; &nbsp; <a href="/go/ps5" style="font-size: 14px;">PlayStation 5</a>&nbsp; &nbsp; <a href="/go/eve" style="font-size: 14px;">EVE</a>&nbsp; &nbsp; <a href="/go/pokemon" style="font-size: 14px;">精灵宝可梦</a>&nbsp; &nbsp; <a href="/go/3ds" style="font-size: 14px;">3DS</a>&nbsp; &nbsp; <a href="/go/gt" style="font-size: 14px;">Gran Turismo</a>&nbsp; &nbsp; <a href="/go/bf4" style="font-size: 14px;">Battlefield 4</a>&nbsp; &nbsp; <a href="/go/wiiu" style="font-size: 14px;">Wii U</a>&nbsp; &nbsp; <a href="/go/bfv" style="font-size: 14px;">Battlefield V</a>&nbsp; &nbsp; <a href="/go/handheld" style="font-size: 14px;">掌机</a>&nbsp; &nbsp; </td></tr></tbody></table></div><div class="cell"><table cellpadding="0" cellspacing="0" border="0"><tbody><tr><td align="right" width="80"><span class="fade">生活</span></td><td style="line-height: 200%; padding-left: 10px; word-break: keep-all;"><a href="/go/all4all" style="font-size: 14px;">二手交易</a>&nbsp; &nbsp; <a href="/go/jobs" style="font-size: 14px;">酷工作</a>&nbsp; &nbsp; <a href="/go/career" style="font-size: 14px;">职场话题</a>&nbsp; &nbsp; <a href="/go/cv" style="font-size: 14px;">求职</a>&nbsp; &nbsp; <a href="/go/afterdark" style="font-size: 14px;">天黑以后</a>&nbsp; &nbsp; <a href="/go/free" style="font-size: 14px;">免费赠送</a>&nbsp; &nbsp; <a href="/go/invest" style="font-size: 14px;">投资</a>&nbsp; &nbsp; <a href="/go/music" style="font-size: 14px;">音乐</a>&nbsp; &nbsp; <a href="/go/tuan" style="font-size: 14px;">团购</a>&nbsp; &nbsp; <a href="/go/movie" style="font-size: 14px;">电影</a>&nbsp; &nbsp; <a href="/go/exchange" style="font-size: 14px;">物物交换</a>&nbsp; &nbsp; <a href="/go/travel" style="font-size: 14px;">旅行</a>&nbsp; &nbsp; <a href="/go/tv" style="font-size: 14px;">剧集</a>&nbsp; &nbsp; <a href="/go/creditcard" style="font-size: 14px;">信用卡</a>&nbsp; &nbsp; <a href="/go/taste" style="font-size: 14px;">美酒与美食</a>&nbsp; &nbsp; <a href="/go/reading" style="font-size: 14px;">阅读</a>&nbsp; &nbsp; <a href="/go/photograph" style="font-size: 14px;">摄影</a>&nbsp; &nbsp; <a href="/go/pet" style="font-size: 14px;">宠物</a>&nbsp; &nbsp; <a href="/go/baby" style="font-size: 14px;">Baby</a>&nbsp; &nbsp; <a href="/go/coffee" style="font-size: 14px;">咖啡</a>&nbsp; &nbsp; <a href="/go/soccer" style="font-size: 14px;">绿茵场</a>&nbsp; &nbsp; <a href="/go/bike" style="font-size: 14px;">骑行</a>&nbsp; &nbsp; <a href="/go/diary" style="font-size: 14px;">日记</a>&nbsp; &nbsp; <a href="/go/plant" style="font-size: 14px;">植物</a>&nbsp; &nbsp; <a href="/go/mushroom" style="font-size: 14px;">蘑菇</a>&nbsp; &nbsp; <a href="/go/mileage" style="font-size: 14px;">行程控</a>&nbsp; &nbsp; </td></tr></tbody></table></div><div class="cell"><table cellpadding="0" cellspacing="0" border="0"><tbody><tr><td align="right" width="80"><span class="fade">Internet</span></td><td style="line-height: 200%; padding-left: 10px; word-break: keep-all;"><a href="/go/google" style="font-size: 14px;">Google</a>&nbsp; &nbsp; <a href="/go/youtube" style="font-size: 14px;">YouTube</a>&nbsp; &nbsp; <a href="/go/twitter" style="font-size: 14px;">Twitter</a>&nbsp; &nbsp; <a href="/go/bilibili" style="font-size: 14px;">哔哩哔哩</a>&nbsp; &nbsp; <a href="/go/notion" style="font-size: 14px;">Notion</a>&nbsp; &nbsp; <a href="/go/reddit" style="font-size: 14px;">Reddit</a>&nbsp; &nbsp; <a href="/go/discord" style="font-size: 14px;">Discord</a>&nbsp; &nbsp; </td></tr></tbody></table></div><div class="inner"><table cellpadding="0" cellspacing="0" border="0"><tbody><tr><td align="right" width="80"><span class="fade">城市</span></td><td style="line-height: 200%; padding-left: 10px; word-break: keep-all;"><a href="/go/beijing" style="font-size: 14px;">北京</a>&nbsp; &nbsp; <a href="/go/shanghai" style="font-size: 14px;">上海</a>&nbsp; &nbsp; <a href="/go/shenzhen" style="font-size: 14px;">深圳</a>&nbsp; &nbsp; <a href="/go/hangzhou" style="font-size: 14px;">杭州</a>&nbsp; &nbsp; <a href="/go/chengdu" style="font-size: 14px;">成都</a>&nbsp; &nbsp; <a href="/go/guangzhou" style="font-size: 14px;">广州</a>&nbsp; &nbsp; <a href="/go/wuhan" style="font-size: 14px;">武汉</a>&nbsp; &nbsp; <a href="/go/nanjing" style="font-size: 14px;">南京</a>&nbsp; &nbsp; <a href="/go/hongkong" style="font-size: 14px;">香港</a>&nbsp; &nbsp; <a href="/go/xian" style="font-size: 14px;">西安</a>&nbsp; &nbsp; <a href="/go/changsha" style="font-size: 14px;">长沙</a>&nbsp; &nbsp; <a href="/go/chongqing" style="font-size: 14px;">重庆</a>&nbsp; &nbsp; <a href="/go/suzhou" style="font-size: 14px;">苏州</a>&nbsp; &nbsp; <a href="/go/kunming" style="font-size: 14px;">昆明</a>&nbsp; &nbsp; <a href="/go/xiamen" style="font-size: 14px;">厦门</a>&nbsp; &nbsp; <a href="/go/tianjin" style="font-size: 14px;">天津</a>&nbsp; &nbsp; <a href="/go/qingdao" style="font-size: 14px;">青岛</a>&nbsp; &nbsp; <a href="/go/nyc" style="font-size: 14px;">New York</a>&nbsp; &nbsp; <a href="/go/sanfrancisco" style="font-size: 14px;">San Francisco</a>&nbsp; &nbsp; <a href="/go/tokyo" style="font-size: 14px;">东京</a>&nbsp; &nbsp; <a href="/go/singapore" style="font-size: 14px;">Singapore</a>&nbsp; &nbsp; <a href="/go/guiyang" style="font-size: 14px;">贵阳</a>&nbsp; &nbsp; <a href="/go/la" style="font-size: 14px;">Los Angeles</a>&nbsp; &nbsp; </td></tr></tbody></table></div>
</div>
        ''');
      nodesBox = document.querySelector('.box');
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
      GStorage().setNodes(nodesList);
      return nodesList;
    }
  }

  static PreferredSizeWidget appBar() {
    return AppBar(elevation: 0, toolbarHeight: 0);
  }

  static twoFADialog({VoidCallback? onSuccess}) async {
    String _currentPage = Get.currentRoute;
    print('_currentPage: $_currentPage');
    var twoFACode = '';
    return SmartDialog.show(
      useSystem: true,
      animationType: SmartAnimationType.centerFade_otherSlide,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('2FA 验证'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('你的 V2EX 账号已经开启了两步验证，请输入验证码继续'),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: '验证码',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0)),
                ),
                onChanged: (e) {
                  twoFACode = e;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  SmartDialog.dismiss();
                  await Api.logout();
                  if (_currentPage == '/login' || _currentPage == '/post_detail') {
                    Get.back(result: false);
                  }
                },
                child: const Text('取消')),
            TextButton(
                onPressed: () async {
                  if (twoFACode.length == 6) {
                    var res = await Api.twoFALOgin(twoFACode);
                    if (res == 'true') {
                      Api.getUserInfo();
                      SmartDialog.showToast('登录成功', displayTime: const Duration(milliseconds: 500)).then((res) {
                        SmartDialog.dismiss();
                        if (_currentPage == '/login') {
                          print('😊😊 - 登录成功');
                          Get.back(result: true);
                        }
                      });
                    } else {
                      twoFACode = '';
                    }
                  } else {
                    SmartDialog.showToast('验证码有误', displayTime: const Duration(milliseconds: 500));
                  }
                },
                child: const Text('登录'))
          ],
        );
      },
    );
  }

}
