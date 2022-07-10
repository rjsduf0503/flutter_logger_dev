import 'package:flutter/material.dart';
import 'package:flutter_logger/components/logger/log_console.dart';

class ClientLogHeader extends StatelessWidget {
  dynamic widget;
  var parentContext;
  ClientLogHeader({Key? key, required this.widget, required this.parentContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LogBar(
      dark: widget.dark,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const Text(
            "Client Log Console",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
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
