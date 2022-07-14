import 'package:flutter_logger/models/environments_model.dart';
import 'package:flutter_logger/models/enums/enums.dart';
import 'package:flutter_logger/models/log_event_model.dart';
import 'package:flutter_logger/models/output_event_model.dart';
import 'package:flutter_logger/view_models/app_log_view_model.dart';

import '../models/log_printer_model.dart';
import 'dart:developer' as developer;

class AppLoggerRepository {
  static Level level = Level.nothing;
  final LogPrinterModel _printer;
  bool _active = true;

  AppLoggerRepository({
    LogPrinterModel? printer,
    Level? level,
  }) : _printer = printer ?? LogPrinter();

  /// Log a message at level [Level.verbose].
  void v(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    log(Level.verbose, message, error, stackTrace);
  }

  /// Log a message at level [Level.debug].
  void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    log(Level.debug, message, error, stackTrace);
  }

  /// Log a message at level [Level.info].
  void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    log(Level.info, message, error, stackTrace);
  }

  /// Log a message at level [Level.warning].
  void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    log(Level.warning, message, error, stackTrace);
  }

  /// Log a message at level [Level.error].
  void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    log(Level.error, message, error, stackTrace);
  }

  /// Log a message with [level].
  void log(Level level, dynamic message,
      [dynamic error, StackTrace? stackTrace]) {
    if (!_active) {
      throw ArgumentError('Logger has already been closed.');
    } else if (error != null && error is StackTrace) {
      throw ArgumentError('Error parameter cannot take a StackTrace!');
    } else if (level == Level.nothing) {
      throw ArgumentError('Log events cannot have Level.nothing');
    }
    if (level.index > EnvironmentsModel.getMaxDisplayLevel.index) return;
    var logEvent = LogEventModel(level, message, error, stackTrace);
    List<String> output = _printer.log(logEvent, false);
    List<String> outputWithoutPrefix = _printer.log(logEvent, true);
    Set<OutputCallback> outputCallbacks = AppLogEvent.getOutputCallbacks;
    Set<OutputCallbackWithoutPrefix> outputCallbackWithoutPrefix =
        AppLogEvent.getOutputCallbacksWithoutPrefix;

    if (output.isNotEmpty) {
      var outputEvent = OutputEventModel(level, output);
      var outputEventWithoutPrefix =
          OutputEventModel(level, outputWithoutPrefix);
      for (var callback in outputCallbacks) {
        callback(outputEvent);
      }
      for (var callback in outputCallbackWithoutPrefix) {
        callback(outputEventWithoutPrefix);
      }
      try {
        for (var item in output) {
          developer.log(item);
        }
      } catch (e, s) {
        print(e);
        print(s);
      }
    }
  }

  void close() {
    _active = false;
    _printer.destroy();
  }
}
