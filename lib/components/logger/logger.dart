// import 'output/log_output.dart';
// import 'output/custom_log_output.dart';
import 'package:flutter_logger/environments.dart';

import 'printer/log_printer.dart';
import 'printer/custom_log_printer.dart';
import 'dart:developer' as developer;

enum Level {
  verbose,
  debug,
  info,
  warning,
  error,
  nothing,
}

class LogEvent {
  final Level level;
  final dynamic message;
  final dynamic error;
  final StackTrace? stackTrace;

  LogEvent(this.level, this.message, this.error, this.stackTrace);
}

class OutputEvent {
  final Level level;
  final List<String> lines;

  OutputEvent(this.level, this.lines);
}

typedef OutputCallback = void Function(OutputEvent event);
typedef OutputCallbackWithoutPrefix = void Function(OutputEvent event);

class Logger {
  static Level level = Level.nothing;
  static final Set<OutputCallback> _outputCallbacks = {};
  static final Set<OutputCallbackWithoutPrefix> _outputCallbacksWithoutPrefix =
      {};
  final LogPrinter _printer;
  bool _active = true;

  Logger({
    LogPrinter? printer,
    Level? level,
  }) : _printer = printer ?? CustomLogPrinter();

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
    if (level.index > Environments.getMaxDisplayLevel.index) return;

    var logEvent = LogEvent(level, message, error, stackTrace);
    List<String> output = _printer.log(logEvent, false);
    List<String> outputWithoutPrefix = _printer.log(logEvent, true);

    if (output.isNotEmpty) {
      var outputEvent = OutputEvent(level, output);
      var outputEventWithoutPrefix = OutputEvent(level, outputWithoutPrefix);
      for (var callback in _outputCallbacks) {
        callback(outputEvent);
      }
      for (var callback in _outputCallbacksWithoutPrefix) {
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

  static void addOutputListener(OutputCallback callback) {
    _outputCallbacks.add(callback);
  }

  static void removeOutputListener(OutputCallback callback) {
    _outputCallbacks.remove(callback);
  }

  static void addOutputListenerWithoutPrefix(
      OutputCallbackWithoutPrefix callback) {
    _outputCallbacksWithoutPrefix.add(callback);
  }

  static void removeOutputListenerWithoutPrefix(
      OutputCallbackWithoutPrefix callback) {
    _outputCallbacksWithoutPrefix.remove(callback);
  }
}
