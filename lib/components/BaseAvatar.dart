import 'package:flutter/material.dart';

class BaseAvatar extends StatelessWidget {
  final String src;
  final double diameter;
  double radius;
  GestureTapCallback? onTap;

  BaseAvatar({super.key, required this.src, required this.diameter, this.radius = 6, this.onTap});

  Widget _default() {
    return Container(width: diameter, height: diameter);
  }

  @override
  Widget build(BuildContext context) {
    if (src != '') {
      // return TDAvatar(size: TDAvatarSize.small, type: TDAvatarType.normal, shape: TDAvatarShape.square, avatarUrl: src);
      return InkWell(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Image.network(
                src,
                width: diameter,
                height: diameter,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return _default();
                  }
                },
                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                  return _default();
                },
              )),
          onTap: onTap);
    } else {
      return _default();
    }
  }
}
