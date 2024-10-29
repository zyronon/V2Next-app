import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:v2ex/components/base_appbar.dart';
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
              Expanded(child: CustomSlider()),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: Row(
                children: [
                  SizedBox(width: 10),
                  Text('间距'),
                  Expanded(child: CustomSlider()),
                ],
              )),
              Expanded(
                  child: Row(
                children: [
                  Text('行距'),
                  Expanded(child: CustomSlider()),
                ],
              ))
            ],
          )
        ],
      ),
    );
  }
}

class CustomSlider extends StatefulWidget {
  @override
  _CustomSliderState createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  double _sliderValue = 18;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: Colors.grey[500],
        inactiveTrackColor: Colors.grey[600],
        trackHeight: 24,
        thumbColor: Colors.grey[200],
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 13),
        overlayColor: Colors.grey.withOpacity(0.2),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
        valueIndicatorColor: Colors.grey[700],
        valueIndicatorTextStyle: TextStyle(color: Colors.white),
        showValueIndicator: ShowValueIndicator.always,
      ),
      child: Slider(
        min: 0,
        max: 100,
        value: _sliderValue,
        divisions: 100,
        label: _sliderValue.round().toString(),
        onChanged: (value) {
          setState(() {
            _sliderValue = value;
          });
        },
      ),
    );
  }
}
