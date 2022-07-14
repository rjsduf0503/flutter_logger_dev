import 'package:flutter/material.dart';
import 'package:flutter_logger/components/client_log/detail/request_card.dart';
import 'package:flutter_logger/components/client_log/detail/response_card.dart';
import 'package:flutter_logger/components/custom_material_app.dart';
import 'package:flutter_logger/components/log_header.dart';

class ClientLogDetailScreen extends StatelessWidget {
  final dynamic logEntry;
  ClientLogDetailScreen({Key? key, required this.logEntry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool dark = brightness == Brightness.dark;
    return CustomMaterialApp(
      dark: dark,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          LogHeader(
            dark: dark,
            parentContext: context,
            consoleType: 'Client Log Detail',
          ),
          RequestCard(request: logEntry.request),
          ResponseCard(response: logEntry.response),
        ],
      ),
    );
  }
}
