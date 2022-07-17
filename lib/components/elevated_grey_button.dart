import 'package:flutter/material.dart';

class ElevatedGreyButton extends StatelessWidget {
  final String text;
  final Function pressEvent;
  const ElevatedGreyButton(
      {Key? key, required this.text, required this.pressEvent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(40),
          primary: Colors.grey.shade600,
          onPrimary: Colors.white,
        ),
        onPressed: () {
          pressEvent();
        },
        child: Text(text),
      ),
    );
  }
}
