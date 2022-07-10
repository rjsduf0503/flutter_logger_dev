import 'package:flutter/material.dart';

List<Color> _statusCodeColor = [
  Colors.white,
  Colors.blue.shade300,
  Colors.green.shade300,
  Colors.yellow.shade300,
  Colors.red.shade300,
  Colors.red,
];

class ResponseType extends StatelessWidget {
  String responseType;

  ResponseType({Key? key, required this.responseType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int responseTypeColorIndex = int.parse(responseType.substring(0, 1));
    Color responseTypeColor = _statusCodeColor[responseTypeColorIndex];
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: responseTypeColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(
          responseType,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
