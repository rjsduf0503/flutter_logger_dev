import 'package:flutter/material.dart';
import 'package:flutter_logger/components/fab.dart';
import 'package:flutter_logger/repositories/client_logger_repository.dart';
import 'package:flutter_logger/repositories/app_logger_repository.dart';

AppLoggerRepository appLogger = AppLoggerRepository();
ClientLoggerRepository clientLogger = ClientLoggerRepository();

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isDialOpen.value) {
          isDialOpen.value = false;
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Flutter Logger Home',
              ),
              TextButton(
                onPressed: () {
                  appLogger.e('error test');
                  appLogger.v('verbose test');
                  appLogger.d('debug test');
                  appLogger.i('info test');
                  appLogger.w('warning test');
                },
                child: Text('App test add'),
              ),
              TextButton(
                onPressed: () {
                  clientLogger.get('/users/2');
                },
                child: Text('Client test add'),
              ),
            ],
          ),
        ),
        floatingActionButton: Fab(isDialOpen: isDialOpen),
      ),
    );
  }
}
