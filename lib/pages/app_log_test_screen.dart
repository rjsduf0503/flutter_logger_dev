import 'package:flutter/material.dart';
import 'package:flutter_logger/app_log_error_functions.dart';
import 'package:flutter_logger/components/custom_material_app.dart';
import 'package:flutter_logger/components/log_header.dart';
import 'package:flutter_logger/flutter_logger.dart';
import 'package:flutter_logger/view_models/app_log_test_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_logger/components/elevated_grey_button.dart';

class AppLogTestScreen extends StatelessWidget {
  const AppLogTestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool dark = brightness == Brightness.dark;
    return Consumer<AppLogTestViewModel>(
      builder: (context, provider, child) {
        return CustomMaterialApp(
          dark: dark,
          child: Column(
            children: <Widget>[
              LogHeader(
                dark: dark,
                parentContext: context,
                consoleType: 'App Log Test',
              ),
              Column(
                children: [
                  ElevatedGreyButton(
                    text: 'App test add',
                    pressEvent: () {
                      appLogger.e('error test');
                      appLogger.v('verbose test');
                      appLogger.d('debug test');
                      appLogger.i('info test');
                      appLogger.w('warning test');
                    },
                  ),
                  ElevatedGreyButton(
                    text: 'Overflow test',
                    pressEvent: () {
                      overflowError(context);
                    },
                  ),
                  ElevatedGreyButton(
                    text: 'IntegerDivisionByZeroException test',
                    pressEvent: () {
                      divideError();
                    },
                  ),
                  ElevatedGreyButton(
                    text: 'RangeError test',
                    pressEvent: () {
                      rangeError();
                    },
                  ),
                  ElevatedGreyButton(
                    text: 'TypeError test',
                    pressEvent: () {
                      typeError();
                    },
                  ),
                  ElevatedGreyButton(
                    text: 'AssertError test',
                    pressEvent: () {
                      assertError();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
