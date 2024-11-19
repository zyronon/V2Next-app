import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:v2next/utils/const_val.dart';

class BaseButton extends StatelessWidget {
  final TDButtonEvent? onTap;
  final String text;
  final TDButtonTheme theme;
  final TDButtonSize size;
  final bool disabled;
  double? width;

  BaseButton({
    super.key,
    this.onTap,
    this.theme = TDButtonTheme.primary,
    this.size = TDButtonSize.medium,
    this.disabled = false,
    this.width,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return TDButton(
      text: text,
      size: size,
      width: width,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      // theme: theme,
      onTap: onTap,
      disabled: disabled,
      style: TDButtonStyle(backgroundColor: Const.primaryColor, textColor: Colors.white),
    );
  }
}
