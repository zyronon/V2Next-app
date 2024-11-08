import 'package:extended_text_library/extended_text_library.dart';
import 'package:flutter/material.dart';
import 'package:v2ex/utils/const_val.dart';
import 'package:v2ex/utils/string.dart';

///emoji/image text
class EmojiText extends SpecialText {
  EmojiText(TextStyle? textStyle, {this.start}) : super(EmojiText.flag, ']', textStyle);
  static const String flag = '[';
  final int? start;

  @override
  InlineSpan finishText() {
    final String key = toString();

    if (EmojiUtil.instance.highEmojiMap.containsKey(key)) {
      double size = 22;

      // final TextStyle ts = textStyle!;
      // if (ts.fontSize != null) {
      //   size = ts.fontSize! * 1.15;
      // }

      return ImageSpan(
          // NetworkImage(EmojiUtil.instance.highEmojiMap[key]!),
          AssetImage(EmojiUtil.instance.highEmojiMap[key]!),
          actualText: key,
          imageWidth: size,
          imageHeight: size,
          start: start!,
          //fit: BoxFit.fill,
          margin: const EdgeInsets.all(1));
    }

    return TextSpan(text: toString(), style: textStyle);
  }
}

class EmojiUtil {
  EmojiUtil._() {
    Const.classicsEmoticons.forEach((v) {
      _highEmojiMap['[${v['name']!}]'] = 'assets/emoji/${v['name']!}.png';
      _lowEmojiMap['[${v['name']!}]'] = v['low']!;
    });
  }

  final Map<String, String> _highEmojiMap = <String, String>{};
  final Map<String, String> _lowEmojiMap = <String, String>{};

  Map<String, String> get highEmojiMap => _highEmojiMap;

  Map<String, String> get lowEmojiMap => _lowEmojiMap;

  static EmojiUtil? _instance;

  static EmojiUtil get instance => _instance ??= EmojiUtil._();
}
