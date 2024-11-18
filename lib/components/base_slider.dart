import 'package:flutter/material.dart';

class BaseSlider extends StatelessWidget {
  double value = 18;
  double min = 18;
  double max = 18;
  int divisions = 18;
  ValueChanged<double> onChanged;

  BaseSlider({required this.value, required this.min, required this.max, required this.onChanged, required this.divisions});

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: Colors.grey[400],
        inactiveTrackColor: Colors.grey[300],
        trackHeight: 24,
        thumbColor: Colors.grey[100],
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 13),
        overlayColor: Colors.grey.withOpacity(0.2),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
        valueIndicatorColor: Colors.grey[700],
        valueIndicatorTextStyle: TextStyle(color: Colors.white),
        showValueIndicator: ShowValueIndicator.always,
      ),
      child: Slider(
        min: min,
        max: max,
        value: value,
        divisions: divisions,
        label: value.toString(),
        onChanged: onChanged,
      ),
    );
  }
}
