import 'package:flutter/material.dart';

class ElevatedColorButton extends StatelessWidget {
  final String text;
  final Function pressEvent;
  const ElevatedColorButton(
      {Key? key, required this.text, required this.pressEvent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: text.contains("Failed") || text.contains('Error')
            ? Colors.red
            : Colors.green,
        onPrimary: Colors.white,
      ),
      onPressed: () {
        pressEvent();
      },
      child: Text(text),
    );
  }
}
