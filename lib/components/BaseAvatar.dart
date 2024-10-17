import 'package:flutter/material.dart';

class BaseAvatar extends StatelessWidget {
  final String src;
  final double diameter;
  final double radius;

  const BaseAvatar({super.key, required this.src, required this.diameter, required this.radius});

  Widget _default(){
    return Container(width: diameter, height: diameter);
  }
  @override
  Widget build(BuildContext context) {
    if (src != '') {
      // return TDAvatar(size: TDAvatarSize.small, type: TDAvatarType.normal, shape: TDAvatarShape.square, avatarUrl: src);
      return ClipRRect(
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
          ));
    } else {
      return _default();
    }
  }
}
