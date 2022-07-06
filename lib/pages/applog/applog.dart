import 'package:flutter/material.dart';
import '../../components/logger/custom_logcontroller.dart';

CustomLogController customLogController = CustomLogController();

class AppLog extends StatelessWidget {
  AppLog({Key? key}) : super(key: key);
  void testLogging() {
    customLogController.logger.v('verbose test');
    customLogController.logger.e('error test');
    customLogController.logger.d('debug test');
    customLogController.logger.i('info test');
    customLogController.logger.w('warning test');
  }

  var buffer = customLogController.getBuffer();
  @override
  Widget build(BuildContext context) {
    testLogging();
    return ListView(
      children: [
        Column(
          children: buffer.map((element) {
            return Column(
              children: [
                // Text(element.level.name),
                ...element.lines.map((e) {
                  return Text(e);
                }),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
