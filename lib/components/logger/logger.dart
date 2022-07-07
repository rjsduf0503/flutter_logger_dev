import 'output/log_output.dart';
import 'output/custom_log_output.dart';
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

@Deprecated('Use a custom LogFilter instead')
typedef LogCallback = void Function(LogEvent event);

// @Deprecated('Use a custom LogOutput instead')
typedef OutputCallback = void Function(OutputEvent event);

class Logger {
  static Level level = Level.verbose;
  static final Set<OutputCallback> _outputCallbacks = Set();
  // final LogFilter _filter;
  final LogPrinter _printer;
  final LogOutput _output;
  bool _active = true;

  Logger({
    // LogFilter? filter,
    LogPrinter? printer,
    LogOutput? output,
    Level? level,
  })  :
        // _filter = filter ?? DevelopmentFilter(),
        _printer = printer ?? CustomLogPrinter(),
        _output = output ?? CustomLogOutput() {
    // _filter.init();
    // _filter.level = level ?? Logger.level;
    _printer.init();
    _output.init();
  }

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
    var logEvent = LogEvent(level, message, error, stackTrace);

    List<String> output = _printer.log(logEvent);

    if (output.isNotEmpty) {
      var outputEvent = OutputEvent(level, output);
      for (var callback in _outputCallbacks) {
        callback(outputEvent);
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
    // _filter.destroy();
    _printer.destroy();
    _output.destroy();
  }

  static void addOutputListener(OutputCallback callback) {
    _outputCallbacks.add(callback);
  }

  static void removeOutputListener(OutputCallback callback) {
    _outputCallbacks.remove(callback);
  }
}
