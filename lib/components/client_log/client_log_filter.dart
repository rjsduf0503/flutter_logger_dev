import 'package:flutter/material.dart';
import 'package:flutter_logger/components/log_filter.dart';

class ClientLogFilter extends StatelessWidget {
  final bool dark;
  final dynamic provider;
  ClientLogFilter({
    Key? key,
    required this.dark,
    required this.provider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LogFilter(
      dark: dark,
      provider: provider,
      logType: 'client log',
    );
  }
}
