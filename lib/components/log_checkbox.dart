import 'package:flutter/material.dart';

class LogCheckbox extends StatelessWidget {
  final dynamic provider;
  final int index;
  final List<double> position;

  const LogCheckbox(
      {Key? key,
      required this.provider,
      required this.index,
      required this.position})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position[0],
      top: position[1],
      child: Checkbox(
          value: provider.checked[index],
          onChanged: (value) {
            provider.handleCheckboxClick(index);
          }),
    );
  }
}
