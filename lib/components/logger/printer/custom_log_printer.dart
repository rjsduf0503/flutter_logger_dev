import 'dart:convert';

import '../logger.dart';
import 'log_printer.dart';
import '../colorizing.dart';

class CustomLogPrinter extends LogPrinter {
  static final levelPrefixes = {
    Level.verbose: '[Verbose]',
    Level.debug: '[Debug]',
    Level.info: '[Info]',
    Level.warning: '[Warning]',
    Level.error: '[Error]',
  };

  static const topLeftCorner = '┌';
  static const topRightCorner = '┐';
  static const bottomLeftCorner = '└';
  static const bottomRightCorner = '┘';
  static const middleCorner = '├';
  static const verticalLine = '│';
  static const doubleDivider = '─';
  static const singleDivider = '┄';

  static final levelColors = {
    Level.verbose: AnsiColor.fg(AnsiColor.grey(0.5)),
    Level.debug: AnsiColor.fg(190),
    Level.info: AnsiColor.fg(12),
    Level.warning: AnsiColor.fg(208),
    Level.error: AnsiColor.fg(196),
  };

  static final levelEmojis = {
    Level.verbose: '',
    Level.debug: '🐛 ',
    Level.info: '❗️ ',
    Level.warning: '🚨 ',
    Level.error: '⛔ ',
  };

  static final _deviceStackTraceRegex =
      RegExp(r'#[0-9]+[\s]+(.+) \(([^\s]+)\)');

  static final _webStackTraceRegex =
      RegExp(r'^((packages|dart-sdk)\/[^\s]+\/)');

  static final _browserStackTraceRegex =
      RegExp(r'^(?:package:)?(dart:[^\s]+|[^\s]+)');

  static DateTime? _startTime;

  final int stackTraceBeginIndex;
  final int methodCount;
  final int errorMethodCount;
  final int lineLength;
  final bool colors;
  final bool printEmojis;
  final bool printTime;

  final Map<Level, bool> excludeBox;

  final bool noBoxingByDefault;

  late final Map<Level, bool> includeBox;

  String _topBorder = '';
  String _middleBorder = '';
  String _bottomBorder = '';

  CustomLogPrinter({
    this.stackTraceBeginIndex = 0,
    this.methodCount = 2,
    this.errorMethodCount = 8,
    this.lineLength = 110,
    this.colors = true,
    this.printEmojis = true,
    this.printTime = false,
    this.excludeBox = const {},
    this.noBoxingByDefault = false,
  }) {
    _startTime ??= DateTime.now();

    var doubleDividerLine = StringBuffer();
    var singleDividerLine = StringBuffer();
    for (var i = 0; i < lineLength - 1; i++) {
      doubleDividerLine.write(doubleDivider);
      singleDividerLine.write(singleDivider);
    }

    _topBorder = '$topLeftCorner$doubleDividerLine$topRightCorner';
    _middleBorder = '$middleCorner$singleDividerLine';
    _bottomBorder = '$bottomLeftCorner$doubleDividerLine$bottomRightCorner';

    includeBox = {};
    Level.values.forEach((l) => includeBox[l] = !noBoxingByDefault);
    excludeBox.forEach((k, v) => includeBox[k] = !v);
  }

  @override
  List<String> log(LogEvent event, bool isWithoutPrefix) {
    var messageStr = stringifyMessage(event.message);

    String? stackTraceStr;
    if (event.stackTrace == null) {
      if (methodCount > 0) {
        stackTraceStr = formatStackTrace(StackTrace.current, methodCount);
      }
    } else if (errorMethodCount > 0) {
      stackTraceStr = formatStackTrace(event.stackTrace, errorMethodCount);
    }

    var errorStr = event.error?.toString();

    String? timeStr;
    if (printTime) {
      timeStr = getTime();
    }

    List<String> logForDebugConsole = _formatAndPrint(
      event.level,
      messageStr,
      isWithoutPrefix,
      timeStr,
      errorStr,
      stackTraceStr,
    );

    return logForDebugConsole;
  }

  String? formatStackTrace(StackTrace? stackTrace, int methodCount) {
    var lines = stackTrace.toString().split('\n');
    if (stackTraceBeginIndex > 0 && stackTraceBeginIndex < lines.length - 1) {
      lines = lines.sublist(stackTraceBeginIndex);
    }
    var formatted = <String>[];
    var count = 0;
    for (var line in lines) {
      if (_discardDeviceStacktraceLine(line) ||
          _discardWebStacktraceLine(line) ||
          _discardBrowserStacktraceLine(line) ||
          line.isEmpty) {
        continue;
      }
      formatted.add('#$count   ${line.replaceFirst(RegExp(r'#\d+\s+'), '')}');
      if (++count == methodCount) {
        break;
      }
    }

    if (formatted.isEmpty) {
      return null;
    } else {
      return formatted.join('\n');
    }
  }

  bool _discardDeviceStacktraceLine(String line) {
    var match = _deviceStackTraceRegex.matchAsPrefix(line);
    if (match == null) {
      return false;
    }
    return match.group(2)!.startsWith('package:logger');
  }

  bool _discardWebStacktraceLine(String line) {
    var match = _webStackTraceRegex.matchAsPrefix(line);
    if (match == null) {
      return false;
    }
    return match.group(1)!.startsWith('packages/logger') ||
        match.group(1)!.startsWith('dart-sdk/lib');
  }

  bool _discardBrowserStacktraceLine(String line) {
    var match = _browserStackTraceRegex.matchAsPrefix(line);
    if (match == null) {
      return false;
    }
    return match.group(1)!.startsWith('package:logger') ||
        match.group(1)!.startsWith('dart:');
  }

  String getTime() {
    String _threeDigits(int n) {
      if (n >= 100) return '$n';
      if (n >= 10) return '0$n';
      return '00$n';
    }

    String _twoDigits(int n) {
      if (n >= 10) return '$n';
      return '0$n';
    }

    var now = DateTime.now();
    var h = _twoDigits(now.hour);
    var min = _twoDigits(now.minute);
    var sec = _twoDigits(now.second);
    var ms = _threeDigits(now.millisecond);
    var timeSinceStart = now.difference(_startTime!).toString();
    return '$h:$min:$sec.$ms (+$timeSinceStart)';
  }

  Object toEncodableFallback(dynamic object) {
    return object.toString();
  }

  String stringifyMessage(dynamic message) {
    final finalMessage = message is Function ? message() : message;
    if (finalMessage is Map || finalMessage is Iterable) {
      var encoder = JsonEncoder.withIndent('  ', toEncodableFallback);
      return encoder.convert(finalMessage);
    } else {
      return finalMessage.toString();
    }
  }

  AnsiColor _getLevelColor(Level level, bool isWithoutPrefix) {
    if (isWithoutPrefix) {
      return AnsiColor.none();
    } else {
      if (colors) {
        return levelColors[level]!;
      } else {
        return AnsiColor.none();
      }
    }
  }

  AnsiColor _getErrorColor(Level level, bool isWithoutPrefix) {
    if (isWithoutPrefix) {
      return AnsiColor.none();
    } else {
      if (colors) {
        return levelColors[Level.error]!.toBg();
      } else {
        return AnsiColor.none();
      }
    }
  }

  String _getEmoji(Level level) {
    if (printEmojis) {
      return levelEmojis[level]!;
    } else {
      return '';
    }
  }

  List<String> _formatAndPrint(
    Level level,
    String message,
    bool isWithoutPrefix,
    String? time,
    String? error,
    String? stacktrace,
  ) {
    List<String> buffer = [];
    var verticalLineAtLevel = (includeBox[level]!) ? (verticalLine + ' ') : '';
    var color = _getLevelColor(level, isWithoutPrefix);
    if (includeBox[level]!) buffer.add(color(_topBorder));

    if (error != null) {
      var errorColor = _getErrorColor(level, isWithoutPrefix);
      for (var line in error.split('\n')) {
        buffer.add(
          color(verticalLineAtLevel) +
              errorColor.resetForeground +
              errorColor(line) +
              errorColor.resetBackground,
        );
      }
      if (includeBox[level]!) buffer.add(color(_middleBorder));
    }

    if (stacktrace != null) {
      for (var line in stacktrace.split('\n')) {
        buffer.add(color('$verticalLineAtLevel$line'));
      }
      if (includeBox[level]!) buffer.add(color(_middleBorder));
    }

    if (time != null) {
      buffer.add(color('$verticalLineAtLevel$time'));
      if (includeBox[level]!) buffer.add(color(_middleBorder));
    }

    var emoji = _getEmoji(level);
    for (var line in message.split('\n')) {
      buffer.add(color('$verticalLineAtLevel$emoji$line'));
    }
    if (includeBox[level]!) buffer.add(color(_bottomBorder));

    return buffer;
  }

  List<String> _formatAndPrintWithoutPrefix(
    Level level,
    String message,
    String? time,
    String? error,
    String? stacktrace,
  ) {
    List<String> buffer = [];
    var verticalLineAtLevel = (includeBox[level]!) ? (verticalLine + ' ') : '';
    if (includeBox[level]!) buffer.add(_topBorder);

    if (error != null) {
      for (var line in error.split('\n')) {
        buffer.add(verticalLineAtLevel + line);
      }
      if (includeBox[level]!) buffer.add(_middleBorder);
    }

    if (stacktrace != null) {
      for (var line in stacktrace.split('\n')) {
        buffer.add('$verticalLineAtLevel$line');
      }
      if (includeBox[level]!) buffer.add(_middleBorder);
    }

    if (time != null) {
      buffer.add('$verticalLineAtLevel$time');
      if (includeBox[level]!) buffer.add(_middleBorder);
    }

    var emoji = _getEmoji(level);
    for (var line in message.split('\n')) {
      buffer.add('$verticalLineAtLevel$emoji$line');
    }
    if (includeBox[level]!) buffer.add(_bottomBorder);

    return buffer;
  }
}
