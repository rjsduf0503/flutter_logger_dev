import 'package:flutter/material.dart';
import 'package:flutter_logger/components/client_log/client_log_console.dart';

class ClientLog extends StatelessWidget {
  const ClientLog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return ClientLogConsole(dark: isDarkMode);
  }
}
