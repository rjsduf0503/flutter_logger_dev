import 'package:flutter/material.dart';
import 'package:flutter_logger/components/custom_material_app.dart';
import 'package:flutter_logger/components/log_header.dart';
import 'package:flutter_logger/components/elevated_color_button.dart';
import 'package:flutter_logger/repositories/client_logger_repository.dart';

ClientLoggerRepository clientLogger = ClientLoggerRepository();

class ClientLogTestScreen extends StatelessWidget {
  const ClientLogTestScreen({Key? key}) : super(key: key);

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
            consoleType: 'Client Log Test',
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
