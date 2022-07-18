import 'package:flutter/material.dart';
import 'package:flutter_logger/components/client_log/detail/request_card.dart';
import 'package:flutter_logger/components/client_log/detail/response_card.dart';
import 'package:flutter_logger/components/custom_material_app.dart';
import 'package:flutter_logger/components/log_header.dart';
import 'package:flutter_logger/global_functions.dart';

class ClientLogDetailScreen extends StatelessWidget {
  final dynamic logEntry;

  ClientLogDetailScreen({Key? key, required this.logEntry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool dark = brightness == Brightness.dark;
    String stringHttp = stringfyHttp(logEntry, errorType: logEntry.errorType);
    return CustomMaterialApp(
      dark: dark,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          LogHeader(
            dark: dark,
            parentContext: context,
            consoleType: 'Client Log Detail',
            stringHttp: stringHttp,
          ),
          RequestCard(request: logEntry.request),
          logEntry.response != null
              ? ResponseCard(response: logEntry.response)
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
