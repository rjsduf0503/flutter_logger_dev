import 'package:flutter/material.dart';
import 'package:flutter_logger/components/client_log/client_log_filter.dart';
import 'package:flutter_logger/components/client_log/content/client_log_contents.dart';
import 'package:flutter_logger/components/custom_material_app.dart';
import 'package:flutter_logger/components/log_header.dart';
import 'package:flutter_logger/view_models/client_log_view_model.dart';
import 'package:provider/provider.dart';

class ClientLogScreen extends StatelessWidget {
  const ClientLogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool dark = brightness == Brightness.dark;
    return Consumer<ClientLogViewModel>(
      builder: (context, provider, child) {
        return CustomMaterialApp(
          dark: dark,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              LogHeader(
                parentContext: context,
                dark: dark,
                consoleType: 'Client Log',
              ),
              Expanded(
                child: ClientLogContents(provider: provider),
              ),
              ClientLogFilter(
                dark: dark,
                provider: provider,
              ),
            ],
          ),
        );
      },
    );
  }
}
