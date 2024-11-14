import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v2ex/components/base_webview.dart';
import 'package:v2ex/main.dart';
import 'package:v2ex/model/model.dart';

class BaseAvatar extends StatelessWidget {
  final String? src;
  final String? username;
  final Member? user;
  final double diameter;
  double radius;

  BaseAvatar({super.key, this.src, required this.diameter, this.radius = 6, this.user, this.username});

  Widget _default() {
    return Container(width: diameter, height: diameter);
  }

  String get srcLocal {
    if (user != null) return user!.avatar;
    return src!;
  }

  @override
  Widget build(BuildContext context) {
    IndexController ic = IndexController.to;
    if (srcLocal != '') {
      // return TDAvatar(size: TDAvatarSize.small, type: TDAvatarType.normal, shape: TDAvatarShape.square, avatarUrl: src);
      return InkWell(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Image.network(
              srcLocal,
              width: ic.textScaleFactor * diameter,
              height: ic.textScaleFactor * diameter,
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
            ),

          ),
          onTap: () {
            if (user == null && username == null) return;
            Get.to(BaseWebView(url: 'https://www.v2ex.com/member/${user?.username ?? username ?? ''}'), transition: Transition.cupertino);
          });
    } else {
      return _default();
    }
  }
}
