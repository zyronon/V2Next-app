// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:v2ex/components/base_webview.dart';
// import 'package:v2ex/main.dart';
// import 'package:v2ex/model/model.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
//
// class CustomCacheManager extends CacheManager {
//   static const key = "v2next_img_cache";
//
//   CustomCacheManager()
//       : super(
//           Config(
//             key,
//             stalePeriod: const Duration(days: 60), // 设置缓存有效期为 7 天
//             maxNrOfCacheObjects: 500, // 设置缓存最大文件数为 100
//           ),
//         );
// }
//
// class BaseAvatar extends StatelessWidget {
//   final String? src;
//   final String? username;
//   final Member? user;
//   final double diameter;
//   double radius;
//
//   BaseAvatar({super.key, this.src, required this.diameter, this.radius = 6, this.user, this.username});
//
//   Widget _default() {
//     return Container(width: diameter, height: diameter);
//   }
//
//   String get srcLocal {
//     if (user != null) return user!.avatar;
//     return src!;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     IndexController ic = IndexController.to;
//     if (srcLocal != '') {
//       // return TDAvatar(size: TDAvatarSize.small, type: TDAvatarType.normal, shape: TDAvatarShape.square, avatarUrl: src);
//       return InkWell(
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(radius),
//             // child: Image.network(
//             //   srcLocal,
//             //   width: ic.textScaleFactor * diameter,
//             //   height: ic.textScaleFactor * diameter,
//             //   fit: BoxFit.cover,
//             //   loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
//             //     if (loadingProgress == null) {
//             //       return child;
//             //     } else {
//             //       return _default();
//             //     }
//             //   },
//             //   errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
//             //     return _default();
//             //   },
//             // ),
//             child: CachedNetworkImage(
//               cacheManager: CustomCacheManager(), // 使用自定义的缓存管理器
//               imageUrl: srcLocal,
//               width: ic.textScaleFactor * diameter,
//               height: ic.textScaleFactor * diameter,
//               fit: BoxFit.cover,
//               // cacheManager: CustomCacheManager(), // 使用自定义的缓存管理器
//               // placeholder: (context, url) => CircularProgressIndicator(),
//               errorWidget: (context, url, error) => Icon(Icons.error),
//             ),
//           ),
//           onTap: () {
//             if (user == null && username == null) return;
//             Get.to(BaseWebView(url: 'https://www.v2ex.com/member/${user?.username ?? username ?? ''}'), transition: Transition.cupertino);
//           });
//     } else {
//       return _default();
//     }
//   }
// }
