import 'package:get/get.dart';

class Controller extends GetxController {
  var loaded = false.obs;

  toggle() => loaded.value = !loaded.value;
}
