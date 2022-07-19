import 'package:flutter/material.dart';
import 'package:flutter_logger/components/log_bar.dart';
import 'package:flutter_logger/components/log_test/elevated_color_button.dart';

class LogFilter extends StatelessWidget {
  final bool dark;
  final dynamic provider;
  const LogFilter({Key? key, required this.dark, required this.provider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color textColor = dark ? Colors.grey.shade100 : Colors.black87;
    Color buttonColor = dark ? Colors.white12 : Colors.grey.shade200;
    return LogBar(
      dark: dark,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          ElevatedColorButton(
            text: 'ALL',
            buttonColor: buttonColor,
            textColor: textColor,
            boxShadow: false,
            pressEvent: () {
              provider.filterController.text = '';
              provider.filterControl();
            },
          ),
          ElevatedColorButton(
            text: 'App Log',
            buttonColor: buttonColor,
            textColor: textColor,
            boxShadow: false,
            pressEvent: () {
              provider.filterController.text = 'RenderedAppLogEventModel';
              provider.filterControl();
            },
          ),
          ElevatedColorButton(
            text: 'Client Log',
            buttonColor: buttonColor,
            textColor: textColor,
            boxShadow: false,
            pressEvent: () {
              provider.filterController.text = 'RenderedClientLogEventModel';
              provider.filterControl();
            },
          ),
        ],
      ),
    );
  }
}
