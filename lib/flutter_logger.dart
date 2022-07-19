import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logger/models/environments_model.dart';
import 'package:flutter_logger/models/enums/enums.dart';
import 'package:flutter_logger/pages/home_screen.dart';
import 'package:flutter_logger/view_models/app_log_view_model.dart';
import 'package:flutter_logger/view_models/client_log_view_model.dart';
import 'package:flutter_logger/view_models/log_view_model.dart';
import 'package:provider/provider.dart';

AppLogger appLogger = AppLogger();
ClientLogger clientLogger = ClientLogger();

class FlutterLogger extends StatelessWidget {
  const FlutterLogger({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlutterError.onError = (FlutterErrorDetails details) {
      final dynamic exception = details.exception;

      // todo: AssertionError vs _AssertionError
      if (exception.runtimeType.toString() == '_AssertionError') {
        appLogger.d(exception);
        return;
      }
      switch (exception.runtimeType) {
        case IntegerDivisionByZeroException:
        case RangeError:
        case ArgumentError:
        case NullThrownError:
        case OutOfMemoryError:
        case StackOverflowError:
        case StateError:
          appLogger.e(exception);
          break;
        case NoSuchMethodError:
        case FallThroughError:
        case CyclicInitializationError:
        case ConcurrentModificationError:
        case FormatException:
        case TypeError:
        case UnimplementedError:
        case UnsupportedError:
          appLogger.w(exception);
          break;
        case FlutterError:
          appLogger.i(exception);
          break;
        case AssertionError:
        case Error:
        case Exception:
          appLogger.d(exception);
          break;
        default:
          appLogger.v(exception);
          break;
      }
    };

    if (kDebugMode) {
      EnvironmentsModel.setEnvironment(Environment.debug);
    } else if (kProfileMode) {
      EnvironmentsModel.setEnvironment(Environment.profile);
    } else if (kReleaseMode) {
      EnvironmentsModel.setEnvironment(Environment.release);
    }

    AppLogViewModel.init();
    ClientLogViewModel.init();
    LogViewModel.init();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppLogViewModel>(
          create: (_) => AppLogViewModel(),
        ),
        ChangeNotifierProvider<ClientLogViewModel>(
          create: (_) => ClientLogViewModel(),
        ),
        ChangeNotifierProvider<LogViewModel>(
          create: (_) => LogViewModel(),
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
