import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class Controller extends GetxController {
  List<String> items = List.generate(20, (int i) => '$i');
}

class TabNodePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, toolbarHeight: 0),
      body: GetX<Controller>(
          init: Controller(),
          builder: (_) {
            return Container(
              color: Colors.grey[300],
              child: Column(
                children: [
                  TDNavBar(
                    height: 48,
                    screenAdaptation: false,
                    useDefaultBack: true,
                  ),
                  SizedBox(height: 20.w),
                  Expanded(
                      child: ReorderableListView(
                    children: <Widget>[
                      for (String item in _.items)
                        Container(
                          key: ValueKey(item),
                          height: 30,
                          margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                          decoration: BoxDecoration(color: Colors.primaries[int.parse(item) % Colors.primaries.length], borderRadius: BorderRadius.circular(10)),
                        )
                    ],
                    onReorder: (int oldIndex, int newIndex) {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      var child = _.items.removeAt(oldIndex);
                      _.items.insert(newIndex, child);
                    },
                  ))
                ],
              ),
            );
          }),
    );
  }
}
