import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class Me extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CupertinoButton(
            child: Text('登录'),
            onPressed: () {
              Get.toNamed('/login');
            })
      ],
    );
  }
}
