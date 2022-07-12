import 'package:flutter/material.dart';
import 'package:flutter_logger/components/client_log/detail/client_log_detail_screen.dart';

class ClientLogDetail extends StatelessWidget {
  var logEntry;
  ClientLogDetail({Key? key, required this.logEntry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClientLogDetailScreen(logEntry: logEntry);
  }
}
