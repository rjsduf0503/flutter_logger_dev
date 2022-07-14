import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_logger/models/enums/enums.dart';
import 'package:flutter_logger/models/log_printer_model.dart';
import 'package:flutter_logger/models/output_event_model.dart';
import 'package:flutter_logger/models/rendered_event_model.dart';
import 'dart:convert';
import 'package:flutter_logger/models/log_event_model.dart';

ListQueue<OutputEventModel> _outputEventBuffer = ListQueue();
ListQueue<OutputEventModel> _outputEventBufferWithoutPrefix = ListQueue();
int _bufferSize = 100;
bool _initialized = false;

class AppLogViewModel with ChangeNotifier {
  static final AppLogViewModel _appLogConsoleViewModel =
      AppLogViewModel._internal();
  factory AppLogViewModel() => _appLogConsoleViewModel;

  AppLogViewModel._internal()
      : assert(
            _initialized, "Please call AppLogViewModel.init() first.") {
    initState();
    didChangeDependencies();
  }

  static void init({int bufferSize = 100}) {
    if (_initialized) return;

    _bufferSize = bufferSize;
    _initialized = true;
    AppLogEvent.addOutputListener((event) {
      if (_outputEventBuffer.length == bufferSize) {
        _outputEventBuffer.removeFirst();
      }
      _outputEventBuffer.add(event);
    });
    AppLogEvent.addOutputListenerWithoutPrefix((event) {
      if (_outputEventBufferWithoutPrefix.length == bufferSize) {
        _outputEventBufferWithoutPrefix.removeFirst();
      }
      _outputEventBufferWithoutPrefix.add(event);
    });
  }

  late OutputCallback _callback;
  late OutputCallbackWithoutPrefix _callbackWithoutPrefix;

  final ListQueue<RenderedAppLogEventModel> _renderedBuffer = ListQueue();
  final ListQueue<RenderedAppLogEventModel> _renderedBufferWithoutPrefix =
      ListQueue();
  List<RenderedAppLogEventModel> filteredBuffer = [];
  List<RenderedAppLogEventModel> filteredBufferWithoutPrefix = [];

  final scrollController = ScrollController();
  final filterController = TextEditingController();

  Level filterLevel = Level.nothing;

  var _currentId = 0;
  bool _scrollListenerEnabled = true;
  bool followBottom = true;

  void initState() {
    _callback = (e) {
      if (_renderedBuffer.length == _bufferSize) {
        _renderedBuffer.removeFirst();
      }

      _renderedBuffer.add(_renderEvent(e));
      refreshFilter();
    };

    _callbackWithoutPrefix = (e) {
      if (_renderedBufferWithoutPrefix.length == _bufferSize) {
        _renderedBufferWithoutPrefix.removeFirst();
      }

      _renderedBufferWithoutPrefix.add(_renderEvent(e));
      refreshFilter();
    };

    AppLogEvent.addOutputListener(_callback);
    AppLogEvent.addOutputListener(_callbackWithoutPrefix);

    scrollController.addListener(() {
      if (!_scrollListenerEnabled) return;
      var scrolledToBottom =
          scrollController.offset >= scrollController.position.maxScrollExtent;

      followBottom = scrolledToBottom;
    });
    notifyListeners();
  }

  void didChangeDependencies() {
    _renderedBuffer.clear();
    for (var event in _outputEventBuffer) {
      _renderedBuffer.add(_renderEvent(event));
    }
    _renderedBufferWithoutPrefix.clear();
    for (var event in _outputEventBufferWithoutPrefix) {
      _renderedBufferWithoutPrefix.add(_renderEvent(event));
    }
    refreshFilter();
    notifyListeners();
  }

  List<RenderedAppLogEventModel> getFilteredBuffer(
      ListQueue<RenderedAppLogEventModel> renderedBuffer) {
    return renderedBuffer.where((it) {
      var logLevelMatches = filterLevel.name == 'nothing'
          ? it.level.index <= filterLevel.index
          : it.level.index == filterLevel.index;
      if (!logLevelMatches) {
        return false;
      } else if (filterController.text.isNotEmpty) {
        var filterText = filterController.text.toLowerCase();
        return it.lowerCaseText.contains(filterText);
      } else {
        return true;
      }
    }).toList();
  }

  void refreshFilter() {
    var newFilteredBuffer = getFilteredBuffer(_renderedBuffer);
    var newFilteredBufferWithoutPrefix =
        getFilteredBuffer(_renderedBufferWithoutPrefix);

    filteredBuffer = newFilteredBuffer;
    filteredBufferWithoutPrefix = newFilteredBufferWithoutPrefix;

    if (followBottom) {
      Future.delayed(Duration.zero, scrollToBottom);
    }
    notifyListeners();
  }

  void scrollToBottom() async {
    _scrollListenerEnabled = false;

    followBottom = true;

    var scrollPosition = scrollController.position;
    await scrollController.animateTo(
      scrollPosition.maxScrollExtent,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );

    _scrollListenerEnabled = true;
    notifyListeners();
  }

  RenderedAppLogEventModel _renderEvent(OutputEventModel event) {
    var parser = AnsiParser(
        dark: WidgetsBinding.instance.window.platformBrightness ==
            Brightness.dark);
    var text = event.lines.join('\n');
    parser.parse(text);
    return RenderedAppLogEventModel(
      _currentId++,
      event.level,
      TextSpan(children: parser.spans),
      text.toLowerCase(),
    );
  }

  @override
  void dispose() {
    AppLogEvent.removeOutputListener(_callback);
    AppLogEvent.removeOutputListener(_callbackWithoutPrefix);
    super.dispose();
  }
}

typedef OutputCallback = void Function(OutputEventModel event);
typedef OutputCallbackWithoutPrefix = void Function(OutputEventModel event);

class AppLogEvent {
  static final Set<OutputCallback> _outputCallbacks = {};
  static final Set<OutputCallbackWithoutPrefix> _outputCallbacksWithoutPrefix =
      {};

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

  static Set<OutputCallback> get getOutputCallbacks => _outputCallbacks;
  static Set<OutputCallbackWithoutPrefix> get getOutputCallbacksWithoutPrefix =>
      _outputCallbacksWithoutPrefix;
}

class AnsiParser {
  static const TEXT = 0, BRACKET = 1, CODE = 2;

  final bool dark;

  AnsiParser({required this.dark});

  Color? foreground;
  Color? background;
  List<TextSpan>? spans;

  void parse(String s) {
    spans = [];
    var state = TEXT;
    late StringBuffer buffer;
    var text = StringBuffer();
    var code = 0;
    List<int> codes = [];

    for (var i = 0, n = s.length; i < n; i++) {
      var c = s[i];

      switch (state) {
        case TEXT:
          if (c == '\u001b') {
            state = BRACKET;
            buffer = StringBuffer(c);
            code = 0;
            codes = [];
          } else {
            text.write(c);
          }
          break;

        case BRACKET:
          buffer.write(c);
          if (c == '[') {
            state = CODE;
          } else {
            state = TEXT;
            text.write(buffer);
          }
          break;

        case CODE:
          buffer.write(c);
          var codeUnit = c.codeUnitAt(0);
          if (codeUnit >= 48 && codeUnit <= 57) {
            code = code * 10 + codeUnit - 48;
            continue;
          } else if (c == ';') {
            codes.add(code);
            code = 0;
            continue;
          } else {
            if (text.isNotEmpty) {
              spans?.add(createSpan(text.toString()));
              text.clear();
            }
            state = TEXT;
            if (c == 'm') {
              codes.add(code);
              handleCodes(codes);
            } else {
              text.write(buffer);
            }
          }

          break;
      }
    }

    spans?.add(createSpan(text.toString()));
  }

  void handleCodes(List<int> codes) {
    if (codes.isEmpty) {
      codes.add(0);
    }

    switch (codes[0]) {
      case 0:
        foreground = getColor(0, true);
        background = getColor(0, false);
        break;
      case 38:
        foreground = getColor(codes[2], true);
        break;
      case 39:
        foreground = getColor(0, true);
        break;
      case 48:
        background = getColor(codes[2], false);
        break;
      case 49:
        background = getColor(0, false);
    }
  }

  Color? getColor(int colorCode, bool foreground) {
    switch (colorCode) {
      case 0:
        return foreground ? Colors.black : Colors.transparent;
      case 12: //info
        return dark ? Colors.lightBlue[300] : Colors.indigo[700];
      case 208: //warning
        return dark ? Colors.orange[300] : Colors.orange[700];
      case 196: //error
        return dark ? Colors.red[300] : Colors.red[700];
      case 190: //debug
        return dark ? Colors.lightGreen[300] : Colors.lightGreen[700];
      case 244: //verbose
        return dark ? Colors.grey[600] : Colors.grey[700];
    }
    return foreground ? Colors.black : Colors.transparent;
  }

  TextSpan createSpan(String text) {
    return TextSpan(
      text: text,
      style: TextStyle(
        color: foreground,
        backgroundColor: background,
      ),
    );
  }
}

class LogPrinter extends LogPrinterModel {
  static const topLeftCorner = '┌';
  static const topRightCorner = '┐';
  static const bottomLeftCorner = '└';
  static const bottomRightCorner = '┘';
  static const middleCorner = '├';
  static const verticalLine = '│';
  static const doubleDivider = '─';
  static const singleDivider = '┄';

  static final levelColors = {
    Level.verbose: Colorizing.fg(Colorizing.grey(0.5)),
    Level.debug: Colorizing.fg(190),
    Level.info: Colorizing.fg(12),
    Level.warning: Colorizing.fg(208),
    Level.error: Colorizing.fg(196),
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

  LogPrinter({
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
    for (var l in Level.values) {
      includeBox[l] = !noBoxingByDefault;
    }
    excludeBox.forEach((k, v) => includeBox[k] = !v);
  }

  @override
  List<String> log(LogEventModel event, bool isWithoutPrefix) {
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

  Colorizing _getLevelColor(Level level, bool isWithoutPrefix) {
    if (isWithoutPrefix) {
      return Colorizing.none();
    } else {
      if (colors) {
        return levelColors[level]!;
      } else {
        return Colorizing.none();
      }
    }
  }

  Colorizing _getErrorColor(Level level, bool isWithoutPrefix) {
    if (isWithoutPrefix) {
      return Colorizing.none();
    } else {
      if (colors) {
        return levelColors[Level.error]!.toBg();
      } else {
        return Colorizing.none();
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
    var verticalLineAtLevel = (includeBox[level]!) ? ('$verticalLine ') : '';
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
}

class Colorizing {
  static const ansiEsc = '\x1B[';

  static const ansiDefault = '${ansiEsc}0m';

  final int? fg;
  final int? bg;
  final bool color;

  Colorizing.none()
      : fg = null,
        bg = null,
        color = false;

  Colorizing.fg(this.fg)
      : bg = null,
        color = true;

  Colorizing.bg(this.bg)
      : fg = null,
        color = true;

  @override
  String toString() {
    if (fg != null) {
      return '${ansiEsc}38;5;${fg}m';
    } else if (bg != null) {
      return '${ansiEsc}48;5;${bg}m';
    } else {
      return '';
    }
  }

  String call(String msg) {
    if (color) {
      return '${this}$msg$ansiDefault';
    } else {
      return msg;
    }
  }

  Colorizing toFg() => Colorizing.fg(bg);

  Colorizing toBg() => Colorizing.bg(fg);

  String get resetForeground => color ? '${ansiEsc}39m' : '';

  String get resetBackground => color ? '${ansiEsc}49m' : '';

  static int grey(double level) => 232 + (level.clamp(0.0, 1.0) * 23).round();
}
