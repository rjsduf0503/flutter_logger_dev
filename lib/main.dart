import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_logger/components/client_log/client_log_console.dart';
import 'package:flutter_logger/components/client_log/client_logger.dart';
import 'package:flutter_logger/components/home/home.dart';
import 'package:flutter_logger/environments.dart';
import 'components/logger/log_console.dart';
import 'components/logger/logger.dart';
import 'package:flutter/foundation.dart';

Logger logger = Logger();
ClientLogger clientLogger = ClientLogger();

void main() async {
  runApp(const FlutterLogger());
}

class FlutterLogger extends StatelessWidget {
  const FlutterLogger({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      Environments.setEnvironment(Environment.debug);
    } else if (kProfileMode) {
      Environments.setEnvironment(Environment.profile);
    } else if (kReleaseMode) {
      Environments.setEnvironment(Environment.release);
    }

    LogConsole.init();
    ClientLogConsole.init();

    Timer(Duration(seconds: 0), () {
      logger.e('error test');
      logger.v('verbose test');
      logger.d('debug test');
      logger.i('info test');
      logger.w('warning test');
      logger.e('error test');
      logger.v('verbose test');
      logger.d('debug test');
      logger.i('info test');
      logger.w('warning test');
      clientLogger.get('/users/2');
      clientLogger.get('/unknown/23');
      clientLogger.get('/unknown/23');
      clientLogger.get('/unknown/23');
      clientLogger.get('/unknown/23');
      clientLogger.get('/unknown/23');
      clientLogger.post('/users', data: {"name": "morpheus", "job": "leader"});
      clientLogger.post('/users', data: {"name": "morpheus", "job": "leader"});
      clientLogger.post('/register', queryParameters: {"email": "sydney@fife"});
    });

    return MaterialApp(
      title: 'Flutter Logger',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          brightness: Brightness.light,
          secondary: Colors.black,
        ),
      ),
      home: Home(),
    );
  }
}
