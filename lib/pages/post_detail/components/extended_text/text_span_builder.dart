import 'package:flutter/material.dart';
import 'package:extended_text_library/extended_text_library.dart';
import 'package:v2next/pages/post_detail/components/extended_text/at_text.dart';
import 'package:v2next/pages/post_detail/components/extended_text/emoji_text.dart';
import 'package:v2next/pages/post_detail/components/extended_text/image_text.dart';

class MySpecialTextSpanBuilder extends SpecialTextSpanBuilder {
  MySpecialTextSpanBuilder({
    this.showAtBackground = false,
    this.controller,
  });

  /// whether show background for @somebody
  final bool showAtBackground;
  final TextEditingController? controller;

  @override
  SpecialText? createSpecialText(String flag, {TextStyle? textStyle, SpecialTextGestureTapCallback? onTap, int? index}) {
    if (flag == '') {
      return null;
    }

    ///index is end index of start flag, so text start index should be index-(flag.length-1)
    if (isStart(flag, AtText.flag)) {
      return AtText(
        textStyle,
        onTap,
        start: index! - (AtText.flag.length - 1),
        showAtBackground: showAtBackground,
        controller: controller,
      );
    } else if (isStart(flag, EmojiText.flag)) {
      return EmojiText(textStyle, start: index! - (EmojiText.flag.length - 1));
    } else if (isStart(flag, ImageText.flag)) {
      return ImageText(textStyle, start: index! - (ImageText.flag.length - 1), onTap: onTap);
    } else{
      return null;
    }
  }
}
