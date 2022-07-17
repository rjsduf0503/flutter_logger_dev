import 'package:flutter/material.dart';
import 'package:flutter_logger/components/fab.dart';
import 'package:flutter_logger/repositories/client_logger_repository.dart';
import 'package:flutter_logger/repositories/app_logger_repository.dart';

ClientLoggerRepository clientLogger = ClientLoggerRepository();

class HomeScreen extends StatelessWidget {
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  HomeScreen({Key? key}) : super(key: key);

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
