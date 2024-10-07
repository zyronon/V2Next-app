// ignore_for_file: avoid_print

import 'dart:convert' show utf8, base64;
import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:v2ex/utils/storage.dart';

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
}
