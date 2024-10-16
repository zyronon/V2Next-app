import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Node;
import 'package:v2ex/model/Post2.dart';

class TabChildNodes extends StatelessWidget {
  final List<V2Node> list;
  const TabChildNodes({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var line = Expanded(
        child: Divider(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
        ));

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                line,
                const SizedBox(width: 8),
                Text('相关节点', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(width: 8),
                line
              ],
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            children: [
              for (var i in list)
                TextButton(
                    onPressed: () async {
                      await Future.delayed(const Duration(milliseconds: 200));
                      Get.toNamed('/node',arguments: i);
                    },
                    child: Text(i.cnName))
            ],
          ),
        ],
      ),
    );
  }
}
