import 'package:flutter/material.dart';
import '../logger/log_console.dart';

// 앱 로그 페이지 화면
class AppLogScreen extends StatelessWidget {
  const AppLogScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    return LogConsole(dark: isDarkMode);
  }
}
