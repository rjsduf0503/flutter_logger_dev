import 'package:flutter/material.dart';
import 'package:flutter_logger/components/logger/log_console.dart';

class ClientLogSearch extends StatelessWidget {
  dynamic widget;
  var filterController;
  var refreshFilter;
  ClientLogSearch({
    Key? key,
    required this.widget,
    required this.filterController,
    required this.refreshFilter,
  }) : super(key: key);

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
              controller: filterController,
              onChanged: (s) => refreshFilter(),
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
