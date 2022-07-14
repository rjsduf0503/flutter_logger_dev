import 'package:flutter/material.dart';

class CustomMaterialApp extends StatelessWidget {
  final bool dark;
  final Widget child;
  final Widget? fab;

  CustomMaterialApp({
    Key? key,
    required this.dark,
    required this.child,
    this.fab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: dark
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
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: child,
        ),
        floatingActionButton: fab,
      ),
    );
  }
}