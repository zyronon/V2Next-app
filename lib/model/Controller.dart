import 'dart:async';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  var loaded = false.obs;

  late final InAppWebViewController wc;

  toggle() => loaded.value = !loaded.value;

  Future callJs(arg) async {
    var res = await wc.callAsyncJavaScript(functionBody: 'return window.jsFunc.${arg['func']}("${arg['val']}")');
    print(res?.value);
    if (res?.error == null) {
      return res?.value;
    }

    // bus.off('onJsBridge');
    // bus.on("onJsBridge", (args) {
    //   print('onJsBridge：${args['type']}：${args?['node'] ?? ''}:${widget.node}');
    //   if (args['type'] == 'list' && args['node'] == widget.node) {
    //     print('onRefresh');
    //     print(args['data'][0]['title']);
    //     setState(() {
    //       list = List<Post>.from(args['data']!.map((x) => Post.fromJson(x)));
    //     });
    //     return completer.complete(true);
    //   }
    // });
    // bus.emit('emitJsBridge', {'func': 'getNodePostList', 'val': widget.node});
  }
}
