import 'package:flutter/material.dart';
import 'package:flutter_logger/components/log_test/elevated_color_button.dart';
import 'package:flutter_logger/view_models/app_log_error_view_model.dart';
import 'package:flutter_logger/components/log_test/center_bold_text.dart';
import 'package:flutter_logger/flutter_logger.dart';

class LogTest extends StatelessWidget {
  const LogTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CenterBoldText(text: 'App Log Test'),
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
        const CenterBoldText(text: 'Client Log Test'),
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
                  text: 'Get Success',
                  pressEvent: () {
                    clientLogger.get('/users/2');
                  },
                ),
                ElevatedColorButton(
                  text: 'Get Failed',
                  pressEvent: () {
                    clientLogger.get('/users/23');
                  },
                ),
                ElevatedColorButton(
                  text: 'Post Success',
                  pressEvent: () {
                    clientLogger.post(
                      '/users',
                      data: {"name": "morpheus", "job": "leader"},
                    );
                  },
                ),
                ElevatedColorButton(
                  text: 'Post Failed',
                  pressEvent: () {
                    clientLogger.post(
                      '/register',
                      data: {"email": "sydney@fife"},
                    );
                  },
                ),
                ElevatedColorButton(
                  text: 'Put Success',
                  pressEvent: () {
                    clientLogger.put(
                      '/users/2',
                      data: {"name": "morpheus", "job": "zion resident"},
                    );
                  },
                ),
                ElevatedColorButton(
                  text: 'Put Failed',
                  pressEvent: () {
                    clientLogger.put(
                      'users/2',
                      data: {"name": "morpheus", "job": "zion resident"},
                    );
                  },
                ),
                ElevatedColorButton(
                  text: 'Patch Success',
                  pressEvent: () {
                    clientLogger.patch(
                      '/users/2',
                      data: {"name": "morpheus", "job": "zion resident"},
                    );
                  },
                ),
                ElevatedColorButton(
                  text: 'Patch Failed',
                  pressEvent: () {
                    clientLogger.patch(
                      'users/2',
                      data: {"name": "morpheus", "job": "zion resident"},
                    );
                  },
                ),
                ElevatedColorButton(
                  text: 'Delete Success',
                  pressEvent: () {
                    clientLogger.delete('/users/2');
                  },
                ),
                ElevatedColorButton(
                  text: 'Delete Failed',
                  pressEvent: () {
                    clientLogger.delete('users/2');
                  },
                ),
                ElevatedColorButton(
                  text: 'Time out(Failed)',
                  pressEvent: () {
                    clientLogger.get('/users/2', timeout: 1);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
