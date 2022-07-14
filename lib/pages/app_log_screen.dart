import 'package:flutter/material.dart';
import 'package:flutter_logger/components/app_log/app_log_filter.dart';
import 'package:flutter_logger/components/app_log/app_log_contents.dart';
import 'package:flutter_logger/components/custom_material_app.dart';
import 'package:flutter_logger/components/log_header.dart';
import 'package:flutter_logger/view_models/app_log_view_model.dart';
import 'package:provider/provider.dart';

class AppLogScreen extends StatelessWidget {
  const AppLogScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool dark = brightness == Brightness.dark;

    return Consumer<AppLogViewModel>(
      builder: (context, provider, child) {
        return CustomMaterialApp(
          dark: dark,
          fab: AnimatedOpacity(
            opacity: provider.followBottom ? 0 : 1,
            duration: const Duration(milliseconds: 150),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: FloatingActionButton(
                mini: true,
                clipBehavior: Clip.antiAlias,
                onPressed: provider.scrollToBottom,
                child: Icon(
                  Icons.arrow_downward,
                  color: dark ? Colors.black : Colors.white,
                ),
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              LogHeader(
                parentContext: context,
                dark: dark,
                consoleType: 'App Log',
              ),
              Expanded(
                child: AppLogContents(dark: dark, provider: provider),
              ),
              AppLogFilter(dark: dark, provider: provider),
            ],
          ),
        );
      },
    );
  }
}