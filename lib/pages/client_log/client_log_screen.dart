import 'package:flutter/material.dart';
import 'package:flutter_logger/components/client_log/client_log_filter.dart';
import 'package:flutter_logger/components/client_log/content/client_log_contents.dart';
import 'package:flutter_logger/components/custom_material_app.dart';
import 'package:flutter_logger/components/log_header.dart';
import 'package:flutter_logger/view_models/client_log_view_model.dart';
import 'package:provider/provider.dart';

class ClientLogScreen extends StatefulWidget {
  const ClientLogScreen({Key? key}) : super(key: key);

  @override
  ClientLogScreenState createState() => ClientLogScreenState();
}

class ClientLogScreenState extends State<ClientLogScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    ClientLogViewModel().initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ClientLogViewModel().didChangeDependencies();
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    bool dark = MediaQuery.of(context).platformBrightness == Brightness.dark;
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
                provider: provider,
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
