import 'package:get/get.dart';
import 'package:v2ex/model/Controller.dart';
import 'package:v2ex/model/Post.dart';

class TabPageController extends GetxController {
  bool isLoading = true;
  List<Post> postList = [];
  final Controller home = Get.find();

  @override
  void onInit() {
    super.onInit();
  }

  getList(String node) {
    home.callJs({'func': 'getNodePostList', 'val': node}).then((res) {
      print('object-----------------------');
      if (!res['error']) {
        postList = List<Post>.from(res['data']!.map((x) => Post.fromJson(x)));
        update();
      }
    });
  }
}
