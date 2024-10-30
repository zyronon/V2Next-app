
import 'package:flutter/material.dart';

class BaseSlider extends StatefulWidget {
  @override
  _BaseSliderState createState() => _BaseSliderState();
}

class _BaseSliderState extends State<BaseSlider> {
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
