import 'dart:io';

import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gal/gal.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:v2next/utils/utils.dart';

typedef DoubleClickAnimationListener = void Function();

enum SampleItem { share, save, browser }

//TODO 加载有点慢了，还需要网络请求一次，保存和分享都需要请求网络，太抽象了
class ImagePreview extends StatefulWidget {
  const ImagePreview({Key? key}) : super(key: key);

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> with TickerProviderStateMixin {
  int initialPage = 0;
  List imgList = [];

  // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  late AnimationController animationController;
  late AnimationController _doubleClickAnimationController;
  Animation<double>? _doubleClickAnimation;
  late DoubleClickAnimationListener _doubleClickAnimationListener;
  List<double> doubleTapScales = <double>[1.0, 2.0];

  bool storage = true;
  bool videos = true;
  bool photos = true;
  bool visiable = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _requestPermission();
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    if (Get.arguments != null) {
      initialPage = Get.arguments['initialPage']!;
      imgList = Get.arguments['imgList'];
    }
    _doubleClickAnimationController = AnimationController(duration: const Duration(milliseconds: 250), vsync: this);
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].toString();
    // final photosInfo = statuses[Permission.photos].toString();

    print('授权状态：$info');
  }

  void onSaveImg() async {
    final hasAccess = await Gal.hasAccess(toAlbum: true);
    if (!hasAccess) {
      await Gal.requestAccess(toAlbum: true);
    }
    SmartDialog.showLoading(msg: '保存中');
    final temp = await getTemporaryDirectory();
    String imgName = "pic_vvex${DateTime.now().toString().split('-').join()}.jpg";
    var imagePath = '${temp.path}/$imgName';
    await Dio().download(imgList[initialPage], imagePath);
    SmartDialog.dismiss();
    try {
      await Gal.putImage(imagePath);
      Utils.toast(msg: '已保存到相册');
    } on GalException catch (e) {
      Utils.toast(msg: e.type.message);
    }
  }

  void onShareImg() async {
    _requestPermission();
    // final Uri imgUrl = Uri.parse(imgList[initialPage]) ;
    var response = await Dio().get(imgList[initialPage], options: Options(responseType: ResponseType.bytes));
    final temp = await getTemporaryDirectory();
    String imgName = "pic_vvex${DateTime.now().toString().split('-').join()}.jpg";
    var path = '${temp.path}/$imgName';
    File(path).writeAsBytesSync(response.data);
    Share.shareXFiles([XFile(path)], subject: imgList[initialPage]);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    _doubleClickAnimationController.dispose();
    clearGestureDetailsCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: Get.back,
          ),
          actions: [
            PopupMenuButton<SampleItem>(
              icon: const Icon(Icons.more_vert),
              tooltip: 'action',
              itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
                PopupMenuItem<SampleItem>(
                  value: SampleItem.share,
                  onTap: onShareImg,
                  child: const Text('分享'),
                ),
                PopupMenuItem<SampleItem>(
                  value: SampleItem.save,
                  onTap: onSaveImg,
                  child: const Text('保存'),
                ),
                PopupMenuItem<SampleItem>(
                  value: SampleItem.browser,
                  onTap: () => Utils.openBrowser(imgList[initialPage]),
                  child: const Text('浏览器中查看'),
                ),
              ],
            ),
          ],
        ),
        body: GestureDetector(
          onTap: () {
            setState(() {
              visiable = !visiable;
            });
          },
          child: ExtendedImageGesturePageView.builder(
            controller: ExtendedPageController(
              initialPage: initialPage,
              pageSpacing: 0,
            ),
            onPageChanged: (int index) => {
              setState(() {
                initialPage = index;
              })
            },
            canScrollPage: (GestureDetails? gestureDetails) => gestureDetails!.totalScale! <= 1.0,
            itemCount: imgList.length,
            itemBuilder: (BuildContext context, int index) {
              return ExtendedImage.network(
                imgList[index],
                fit: BoxFit.contain,
                mode: ExtendedImageMode.gesture,
                onDoubleTap: (ExtendedImageGestureState state) {
                  ///you can use define pointerDownPosition as you can,
                  ///default value is double tap pointer down postion.
                  final Offset? pointerDownPosition = state.pointerDownPosition;
                  final double? begin = state.gestureDetails!.totalScale;
                  double end;

                  //remove old
                  _doubleClickAnimation?.removeListener(_doubleClickAnimationListener);

                  //stop pre
                  _doubleClickAnimationController.stop();

                  //reset to use
                  _doubleClickAnimationController.reset();

                  if (begin == doubleTapScales[0]) {
                    end = doubleTapScales[1];
                  } else {
                    end = doubleTapScales[0];
                  }

                  _doubleClickAnimationListener = () {
                    //print(_animation.value);
                    state.handleDoubleTap(scale: _doubleClickAnimation!.value, doubleTapPosition: pointerDownPosition);
                  };
                  _doubleClickAnimation = _doubleClickAnimationController.drive(Tween<double>(begin: begin, end: end));

                  _doubleClickAnimation!.addListener(_doubleClickAnimationListener);

                  _doubleClickAnimationController.forward();
                },
                loadStateChanged: (ExtendedImageState state) {
                  if (state.extendedImageLoadState == LoadState.loading) {
                    final ImageChunkEvent? loadingProgress = state.loadingProgress;
                    final double? progress = loadingProgress?.expectedTotalBytes != null ? loadingProgress!.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null;
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 150.0,
                            child: LinearProgressIndicator(value: progress),
                          ),
                          const SizedBox(height: 10.0),
                          Text('${((progress ?? 0.0) * 100).toInt()}%'),
                        ],
                      ),
                    );
                  }
                  return null;
                },
                initGestureConfigHandler: (ExtendedImageState state) {
                  return GestureConfig(
                    //you must set inPageView true if you want to use ExtendedImageGesturePageView
                    inPageView: true,
                    initialScale: 1.0,
                    maxScale: 5.0,
                    animationMaxScale: 6.0,
                    initialAlignment: InitialAlignment.center,
                  );
                },
              );
            },
          ),
        ));
  }
}
