import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../logger/log_console.dart';

class AppLogCopyButton extends StatelessWidget {
  RenderedEvent logEntry;
  final bool dark;
  final double size;
  AppLogCopyButton(
      {Key? key,
      required this.logEntry,
      required this.dark,
      required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 10,
      top: 10,
      child: Container(
        decoration: BoxDecoration(color: dark ? Colors.black : Colors.white),
        child: InkWell(
          onTap: (() {
            Clipboard.setData(ClipboardData(text: logEntry.lowerCaseText));
            _showClipboardAlert(context);
          }),
          child: Icon(Icons.copy,
              color: dark ? Colors.white : Colors.black, size: size * 2),
        ),
      ),
    );
  }
}

void _showClipboardAlert(context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: const Text('Copied to clipboard.'),
        actions: <Widget>[
          TextButton(
            child: const Text("Close"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
