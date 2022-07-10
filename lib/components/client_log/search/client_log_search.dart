import 'package:flutter/material.dart';
import 'package:flutter_logger/components/logger/log_console.dart';

class ClientLogSearch extends StatelessWidget {
  dynamic widget;
  ClientLogSearch({Key? key, required this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LogBar(
      dark: widget.dark,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: TextField(
              style: const TextStyle(fontSize: 20),
              onChanged: (s) => {},
              decoration: const InputDecoration(
                labelText: "Filter client log output",
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
