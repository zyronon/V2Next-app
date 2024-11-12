import 'package:flutter/cupertino.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class BaseButton extends StatelessWidget {
  final TDButtonEvent? onTap;
  final String text;
  final TDButtonTheme? theme;
  final TDButtonSize? size;

  const BaseButton({
    super.key,
    this.onTap,
    this.theme = TDButtonTheme.primary,
    this.size = TDButtonSize.medium,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return TDButton(
      text: text,
      size: TDButtonSize.small,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: theme,
      onTap: onTap,
    );
  }
}
