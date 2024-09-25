import 'package:get/get.dart';

class Controller extends GetxController {
  var loaded = false.obs;

  // late final WebViewController wc;

  toggle() => loaded.value = !loaded.value;

  callJs(arg) {
    // final completer = Completer();
    // return wc.runJavaScriptReturningResult('window.jsBridge("${arg['func']}","${arg['val']}")');
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
    // return completer.future;
  }
}
