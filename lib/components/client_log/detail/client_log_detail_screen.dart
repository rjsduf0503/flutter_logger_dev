import 'package:flutter/material.dart';
import 'package:flutter_logger/components/client_log/detail/content/client_log_detail_request.dart';
import 'package:flutter_logger/components/client_log/detail/content/client_log_detail_response.dart';
import 'package:flutter_logger/components/client_log/detail/header/client_log_detail_header.dart';

class ClientLogDetailScreen extends StatelessWidget {
  const ClientLogDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return MaterialApp(
      theme: isDarkMode
          ? ThemeData(
              brightness: Brightness.dark,
              // colorScheme:
              //     ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
              accentColor: Colors.white,
            )
          : ThemeData(
              brightness: Brightness.light,
              // colorScheme:
              // ColorScheme.fromSwatch().copyWith(secondary: Colors.black),
              accentColor: Colors.black,
            ),
      home: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ClientLogDetailHeader(
                dark: isDarkMode,
                parentContext: context,
              ),
              ClientLogDetailRequest(),
              ClientLogDetailResponse(),
              // ClientLogSearch(widget: widget),
            ],
          ),
        ),
      ),
    );
  }
}
