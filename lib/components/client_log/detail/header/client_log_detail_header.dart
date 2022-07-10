import 'package:flutter/material.dart';
import 'package:flutter_logger/components/logger/log_console.dart';

class ClientLogDetailHeader extends StatelessWidget {
  bool dark;
  BuildContext parentContext;
  ClientLogDetailHeader({Key? key, required this.dark, required this.parentContext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LogBar(
      dark: dark,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const Text(
            "Client Log Detail",
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
