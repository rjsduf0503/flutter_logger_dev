import 'package:flutter/material.dart';
import 'package:flutter_logger/components/log_bar.dart';

class LogFilter extends StatelessWidget {
  final bool dark;
  final dynamic provider;
  final Widget padding;
  final Widget levelFiltering;
  final String logType;

  const LogFilter({
    Key? key,
    required this.dark,
    required this.provider,
    this.padding = const SizedBox.shrink(),
    this.levelFiltering = const SizedBox.shrink(),
    required this.logType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LogBar(
      dark: dark,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: TextField(
              style: const TextStyle(fontSize: 20),
              controller: provider.filterController,
              onChanged: (s) => provider.refreshFilter(),
              decoration: InputDecoration(
                labelText: "Filter $logType output",
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          padding,
          levelFiltering,
        ],
      ),
    );
  }
}
