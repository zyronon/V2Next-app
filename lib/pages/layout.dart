import 'package:flutter/material.dart';
import 'package:v2ex/components/base_slider.dart';
import 'package:v2ex/utils/utils.dart';

class LayoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.appBar(),
      body: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 10),
              Text('字体'),
              Expanded(child: BaseSlider()),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: Row(
                children: [
                  SizedBox(width: 10),
                  Text('间距'),
                  Expanded(child: BaseSlider()),
                ],
              )),
              Expanded(
                  child: Row(
                children: [
                  Text('行距'),
                  Expanded(child: BaseSlider()),
                ],
              ))
            ],
          )
        ],
      ),
    );
  }
}
