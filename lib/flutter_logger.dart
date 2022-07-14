import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logger/models/environments_model.dart';
import 'package:flutter_logger/models/enums/enums.dart';
import 'package:flutter_logger/pages/home_screen.dart';
import 'package:flutter_logger/view_models/app_log_view_model.dart';
import 'package:flutter_logger/view_models/client_log_view_model.dart';
import 'package:provider/provider.dart';

class FlutterLogger extends StatelessWidget {
  const FlutterLogger({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      EnvironmentsModel.setEnvironment(Environment.debug);
    } else if (kProfileMode) {
      EnvironmentsModel.setEnvironment(Environment.profile);
    } else if (kReleaseMode) {
      EnvironmentsModel.setEnvironment(Environment.release);
    }

    AppLogViewModel.init();
    ClientLogViewModel.init();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppLogViewModel>(
          create: (_) => AppLogViewModel(),
        ),
        ChangeNotifierProvider<ClientLogViewModel>(
          create: (_) => ClientLogViewModel(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Logger',
        theme: ThemeData(
          colorScheme: const ColorScheme.light(
            brightness: Brightness.light,
            secondary: Colors.black,
          ),
        ),
        home: HomeScreen(),
      ),
    );
  }
}
