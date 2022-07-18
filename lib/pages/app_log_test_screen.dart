import 'package:flutter/material.dart';
import 'package:flutter_logger/app_log_error_functions.dart';
import 'package:flutter_logger/components/custom_material_app.dart';
import 'package:flutter_logger/components/log_header.dart';
import 'package:flutter_logger/flutter_logger.dart';
import 'package:provider/provider.dart';
import 'package:flutter_logger/components/elevated_color_button.dart';

class AppLogTestScreen extends StatelessWidget {
  const AppLogTestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool dark = brightness == Brightness.dark;
    return CustomMaterialApp(
      dark: dark,
      child: Column(
        children: <Widget>[
          LogHeader(
            dark: dark,
            parentContext: context,
            consoleType: 'App Log Test',
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: GridView.count(
                childAspectRatio: 3,
                shrinkWrap: true,
                primary: false,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                crossAxisCount: 2,
                children: [
                  ElevatedColorButton(
                    text: 'App Error Test',
                    pressEvent: () {
                      appLogger.e('error test');
                      appLogger.v('verbose test');
                      appLogger.d('debug test');
                      appLogger.i('info test');
                      appLogger.w('warning test');
                    },
                  ),
                  ElevatedColorButton(
                    text: 'Overflow Error Test',
                    pressEvent: () {
                      overflowError(context);
                    },
                  ),
                  ElevatedColorButton(
                    text: 'IntegerDivisionByZeroException Error Test',
                    pressEvent: () {
                      divideError();
                    },
                  ),
                  ElevatedColorButton(
                    text: 'Range Error Test',
                    pressEvent: () {
                      rangeError();
                    },
                  ),
                  ElevatedColorButton(
                    text: 'Type Error Test',
                    pressEvent: () {
                      typeError();
                    },
                  ),
                  ElevatedColorButton(
                    text: 'Assert Error Test',
                    pressEvent: () {
                      assertError();
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
