// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/material.dart' hide Element;
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' hide Cookie;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' hide Text;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:v2next/http/api.dart';
import 'package:v2next/http/login_api.dart';
import 'package:v2next/http/login_dio.dart';
import 'package:v2next/http/request.dart';
import 'package:v2next/model/base_controller.dart';
import 'package:v2next/model/model.dart';
import 'package:v2next/utils/const_val.dart';
import 'package:v2next/utils/event_bus.dart';
import 'package:v2next/utils/storage.dart';
import 'package:v2next/utils/upload.dart';
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

  static Post buildList(Post post, List<Reply> replyList) {
    post.replyList = clone(replyList);
    post.replyCount = post.replyList.length;
    post.allReplyUsers = post.replyList.map((v) => v.username).toList().toSet().toList();

    post.hotReplyList = clone(replyList);
    post.hotReplyList.sort((a, b) => b.thankCount.compareTo(a.thankCount));

    post.newReplyList = clone(replyList);
    post.newReplyList.sort((a, b) => b.floor.compareTo(a.floor));

    post.topReplyList = clone(post.replyList).where((v) {
      return v.thankCount >= 3;
    }).toList();
    post.topReplyList.sort((a, b) => b.thankCount.compareTo(a.thankCount));
    post.topReplyList = post.topReplyList.sublist(0, post.topReplyList.length > 5 ? 5 : post.topReplyList.length);

    post.nestedReplies = createNestedList(list: clone(replyList), topReplyList: post.topReplyList);
    return post;
  }

  static List<Reply> clone(List<Reply> val) {
    return val.map((v) => Reply.fromJson(v.toJson())).toList();
  }

  static checkPhotoLink2Img(Element dom) {
    bool replaceImgur = BaseController.to.currentConfig.replaceImgur;
    String prefixImg = replaceImgur ? Const.imgurProxy : '';

    List<Element> imgList = dom.querySelectorAll('img');
    imgList.forEach((Element img) {
      String href = img.attributes['src']!;
      if (href.contains('imgur.com')) {
        img.attributes['originUrl'] = img.attributes['src']!;
        img.attributes['notice'] = '此img标签由V2Next脚本解析';
        if (!['.png', '.jpg', '.jpeg', '.gif', '.PNG', '.JPG', '.JPEG', '.GIF'].any((ext) => href.contains(ext))) {
          href += '.png';
        }
        img.attributes['src'] = prefixImg + href;
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

  static List<Post> parsePagePostList(List<Element> list) {
    List<Post> topicList = [];
    if (list.isNotEmpty) {
      for (Element aNode in list) {
        Post item = Post();
        Element? titleInfo = aNode.querySelector(".topic-link");
        if (titleInfo != null) {
          item.title = titleInfo.text;
          String? href = titleInfo.attributes['href'];
          var match = RegExp(r'(\d+)').allMatches(href!);
          var result = match.map((m) => m.group(0)).toList();
          item.postId = int.parse(result[0]!);
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
          item.node.title = nodeEl.text;
          item.node.name = nodeEl.attributes['href']!.replaceFirst('/go/', '');
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

  static String _twoDigits(int n) {
    return n >= 10 ? "$n" : "0$n";
  }

  static String timeAgo(String dateTime) {
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

  static Future<Result?> uploadImage() async {
    final List<AssetEntity>? assets = await AssetPicker.pickAssets(
      Get.context!,
      pickerConfig: const AssetPickerConfig(maxAssets: 1, requestType: RequestType.image),
    );
    if (assets != null && assets.isNotEmpty) {
      AssetEntity? file = assets[0];
      Result res = await Upload.uploadImage(file);
      return res;
    }
    return null;
  }

  // 从 Dio 的 CookieJar 获取 Cookie 并设置到 InAppWebView 中
  static Future<void> dioSyncCookie2InApp(String url) async {
    final inAppCookieManager = CookieManager.instance();
    CookieJar cookieJar = Http.cookieManager!.cookieJar;
    CookieJar cookieJar2 = LoginDio.cookieManager.cookieJar;
    List<Cookie> dioCookies = await cookieJar.loadForRequest(Uri.parse(url));
    List<Cookie> dioCookies2 = await cookieJar2.loadForRequest(Uri.parse(url));
    dioCookies.addAll(dioCookies2);
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

  static Future inAppSyncCookie2Dio(List cookiesList, String url) async {
    // 接收 flutter_inappwebview Cookie List
    // domain url
    List<Cookie> jarCookies = [];
    if (cookiesList.isNotEmpty) {
      for (var i in cookiesList) {
        Cookie jarCookie = Cookie(i.name, i.value);
        jarCookies.add(jarCookie);
      }
    }
    var cookieString = jarCookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');
    await Http.cookieManager!.cookieJar.saveFromResponse(Uri.parse("https://www.v2ex.com/"), jarCookies);
    Http.dio.options.headers['cookie'] = cookieString;
    await LoginDio.cookieManager.cookieJar.saveFromResponse(Uri.parse("https://www.v2ex.com/"), jarCookies);
    LoginDio.dio.options.headers['cookie'] = cookieString;
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
                  await LoginApi.logout();
                  if (_currentPage == '/login' || _currentPage == '/post_detail') {
                    Get.back(result: false);
                  }
                },
                child: const Text('取消')),
            TextButton(
                onPressed: () async {
                  if (twoFACode.length == 6) {
                    var res = await LoginApi.twoFALOgin(twoFACode);
                    if (res == 'true') {
                      LoginApi.getUserInfo();
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

  static formatCommentDisplayType(CommentDisplayType val) {
    switch (val) {
      case CommentDisplayType.Nest:
        return '楼中楼';
      case CommentDisplayType.NestAndCall:
        return '楼中楼(@)';
      case CommentDisplayType.Hot:
        return '最热';
      case CommentDisplayType.Origin:
        return 'V2原版';
      case CommentDisplayType.Op:
        return '只看楼主';
      case CommentDisplayType.New:
        return '最新';
      default:
        return '楼中楼';
    }
  }

  static Future<int> getOnce(Document document) async {
    var menuBodyNode = document.querySelector("#Top .tools");
    var loginOutNode = menuBodyNode!.querySelectorAll('a').last;
    var loginOutHref = loginOutNode.attributes['onclick']!;
    RegExp regExp = RegExp(r'\d{3,}');
    Iterable<Match> matches = regExp.allMatches(loginOutHref);
    if (matches.length == 0) {
      var r = await Api.pullOnce();
      if (r.success) return r.data;
    } else {
      var once = 0;
      for (Match m in matches) {
        once = int.parse(m.group(0)!);
        print('getOnce${once}');
        GStorage().setOnce(once);
      }
      return once;
    }
    return 0;
  }

  static MemberNoticeItem parseNoticeItem(Element aNode) {
    MemberNoticeItem item = MemberNoticeItem();
    item.member.avatar = aNode.querySelector('tr>td>a>img')!.attributes['src']!;
    item.member.username = aNode.querySelector('tr>td>a>img')!.attributes['alt']!;

    var td2Node = aNode.querySelectorAll('tr>td')[1];

    item.postId = int.parse(td2Node.querySelectorAll('span.fade>a')[1].attributes['href']!.split('/')[2].split('#')[0]);
    item.postTitle = td2Node.querySelectorAll('span.fade>a')[1].text;
    var noticeTypeStr = td2Node.querySelector('span.fade')!.nodes[1];

    if (noticeTypeStr.text!.contains('在回复')) {
      item.noticeType = NoticeType.reply;
    }
    if (noticeTypeStr.text!.contains('回复了你')) {
      item.noticeType = NoticeType.reply;
    }
    if (noticeTypeStr.text!.contains('收藏了你发布的主题')) {
      item.noticeType = NoticeType.favTopic;
    }
    if (noticeTypeStr.text!.contains('感谢了你发布的主题')) {
      // item.noticeType = NoticeType.thanksTopic;
      item.noticeType = NoticeType.thanks;
    }
    if (noticeTypeStr.text!.contains('感谢了你在主题')) {
      // item.noticeType = NoticeType.thanksReply;
      item.noticeType = NoticeType.thanks;
    }

    if (td2Node.querySelector('div.payload') != null) {
      item.replyContentHtml = td2Node.querySelector('div.payload')!.innerHtml;
    } else {
      item.replyContentHtml = '';
    }

    item.replyDate = td2Node.querySelector('span.snow')!.text.replaceAll('+08:00', '');
    var delNum = td2Node.querySelector('a.node')!.attributes['onclick']!.replaceAll(RegExp(r"[deleteNotification( | )]"), '');
    item.delIdOne = delNum.split(',')[0];
    item.delIdTwo = delNum.split(',')[1];
    return item;
  }

  static int parseUnRead(Document doc) {
    var noticeEl = doc.querySelector('a[href="/notifications"]');
    if (noticeEl != null) {
      var unRead = int.parse(noticeEl.text.replaceAll(RegExp(r'\D'), ''));
      print('$unRead条未读消息');
      EventBus().emit('setUnread', unRead);
      return unRead;
    }
    return -1;
  }

  // 版本比较
  static bool needUpdate(localVersion, _emoteVersion) {
    List<String> localVersionList = localVersion.split('v')[1].split('.');
    List<String> remoteVersionList = _emoteVersion.split('v')[1].split('.');
    for (int i = 0; i < localVersionList.length; i++) {
      int localVersion = int.parse(localVersionList[i]);
      int remoteVersion = int.parse(remoteVersionList[i]);
      if (remoteVersion > localVersion) {
        return true;
      } else if (remoteVersion < localVersion) {
        return false;
      }
    }
    return false;
  }
}
