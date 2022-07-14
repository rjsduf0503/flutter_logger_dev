import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_logger/global_functions.dart';
import 'package:flutter_logger/models/rendered_event_model.dart';

class AppLogCopyButton extends StatelessWidget {
  RenderedAppLogEventModel logEntry;
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
            showClipboardAlert(context);
          }),
          child: Icon(Icons.copy,
              color: dark ? Colors.white : Colors.black, size: size * 2),
        ),
      ),
    );
  }
}
