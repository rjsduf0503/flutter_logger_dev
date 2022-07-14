import 'package:flutter/material.dart';
import 'package:flutter_logger/components/log_bar.dart';

class LogHeader extends StatelessWidget {
  final bool dark;
  final dynamic parentContext;
  final String consoleType;

  const LogHeader(
      {Key? key,
      this.dark = false,
      required this.parentContext,
      required this.consoleType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LogBar(
      dark: dark,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            consoleType,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          // todo: 복사 버튼
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(parentContext);
            },
          ),
        ],
      ),
    );
  }
}
