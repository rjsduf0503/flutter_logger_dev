import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_logger/components/app_log/app_log_copy_button.dart';

import '../logger/logger.dart';
import 'ansi_parser.dart';

ListQueue<OutputEvent> _outputEventBuffer = ListQueue();
ListQueue<OutputEvent> _outputEventBufferWithoutPrefix = ListQueue();
int _bufferSize = 100;
bool _initialized = false;

class LogConsole extends StatefulWidget {
  final bool dark;
  final bool showCloseButton;

  LogConsole({this.dark = false, this.showCloseButton = true})
      : assert(_initialized, "Please call LogConsole.init() first.");

  static void init({int bufferSize = 100}) {
    if (_initialized) return;

    _bufferSize = bufferSize;
    _initialized = true;
    Logger.addOutputListener((e) {
      if (_outputEventBuffer.length == bufferSize) {
        _outputEventBuffer.removeFirst();
      }
      _outputEventBuffer.add(e);
    });
    Logger.addOutputListenerWithoutPrefix((e) {
      if (_outputEventBufferWithoutPrefix.length == bufferSize) {
        _outputEventBufferWithoutPrefix.removeFirst();
      }
      _outputEventBufferWithoutPrefix.add(e);
    });
  }

  @override
  _LogConsoleState createState() => _LogConsoleState();
}

class RenderedEvent {
  final int id;
  final Level level;
  final TextSpan span;
  final String lowerCaseText;

  RenderedEvent(this.id, this.level, this.span, this.lowerCaseText);
}

class _LogConsoleState extends State<LogConsole> {
  late OutputCallback _callback;
  late OutputCallbackWithoutPrefix _callbackWithoutPrefix;

  final ListQueue<RenderedEvent> _renderedBuffer = ListQueue();
  final ListQueue<RenderedEvent> _renderedBufferWithoutPrefix = ListQueue();
  List<RenderedEvent> _filteredBuffer = [];
  List<RenderedEvent> _filteredBufferWithoutPrefix = [];

  final _scrollController = ScrollController();
  final _filterController = TextEditingController();

  Level _filterLevel = Level.nothing;
  double _logFontSize = 14;

  var _currentId = 0;
  bool _scrollListenerEnabled = true;
  bool _followBottom = true;

  @override
  void initState() {
    super.initState();

    _callback = (e) {
      if (_renderedBuffer.length == _bufferSize) {
        _renderedBuffer.removeFirst();
      }

      _renderedBuffer.add(_renderEvent(e));
      _refreshFilter();
    };

    _callbackWithoutPrefix = (e) {
      if (_renderedBufferWithoutPrefix.length == _bufferSize) {
        _renderedBufferWithoutPrefix.removeFirst();
      }

      _renderedBufferWithoutPrefix.add(_renderEvent(e));
      _refreshFilter();
    };

    Logger.addOutputListener(_callback);
    Logger.addOutputListener(_callbackWithoutPrefix);

    _scrollController.addListener(() {
      if (!_scrollListenerEnabled) return;
      var scrolledToBottom = _scrollController.offset >=
          _scrollController.position.maxScrollExtent;
      setState(() {
        _followBottom = scrolledToBottom;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _renderedBuffer.clear();
    for (var event in _outputEventBuffer) {
      _renderedBuffer.add(_renderEvent(event));
    }
    _renderedBufferWithoutPrefix.clear();
    for (var event in _outputEventBufferWithoutPrefix) {
      _renderedBufferWithoutPrefix.add(_renderEvent(event));
    }
    _refreshFilter();
  }

  List<RenderedEvent> getFilteredBuffer(
      ListQueue<RenderedEvent> renderedBuffer) {
    return renderedBuffer.where((it) {
      var logLevelMatches = _filterLevel.name == 'nothing'
          ? it.level.index <= _filterLevel.index
          : it.level.index == _filterLevel.index;
      if (!logLevelMatches) {
        return false;
      } else if (_filterController.text.isNotEmpty) {
        var filterText = _filterController.text.toLowerCase();
        return it.lowerCaseText.contains(filterText);
      } else {
        return true;
      }
    }).toList();
  }

  void _refreshFilter() {
    var newFilteredBuffer = getFilteredBuffer(_renderedBuffer);
    var newFilteredBufferWithoutPrefix =
        getFilteredBuffer(_renderedBufferWithoutPrefix);
    setState(() {
      _filteredBuffer = newFilteredBuffer;
      _filteredBufferWithoutPrefix = newFilteredBufferWithoutPrefix;
    });

    if (_followBottom) {
      Future.delayed(Duration.zero, _scrollToBottom);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: widget.dark
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
              _buildTopBar(),
              Expanded(
                child: _buildLogContent(),
              ),
              _buildBottomBar(),
            ],
          ),
        ),
        floatingActionButton: AnimatedOpacity(
          opacity: _followBottom ? 0 : 1,
          duration: const Duration(milliseconds: 150),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: FloatingActionButton(
              mini: true,
              clipBehavior: Clip.antiAlias,
              onPressed: _scrollToBottom,
              child: Icon(
                Icons.arrow_downward,
                color: widget.dark ? Colors.black : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogContent() {
    return Container(
      decoration: BoxDecoration(
        color: widget.dark ? Colors.black : Colors.grey[150],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 5,
          child: ListView.builder(
            shrinkWrap: true,
            controller: _scrollController,
            itemBuilder: (context, index) {
              var logEntry = _filteredBuffer[index];
              var logEntryWithoutPrefix = _filteredBufferWithoutPrefix[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Text.rich(
                        logEntry.span,
                        key: Key(logEntry.id.toString()),
                        style: TextStyle(fontSize: _logFontSize),
                      ),
                      AppLogCopyButton(
                          logEntry: logEntryWithoutPrefix, dark: widget.dark, size: _logFontSize),
                    ],
                  ),
                ],
              );
            },
            itemCount: _filteredBuffer.length,
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return LogBar(
      dark: widget.dark,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const Text(
            "Log Console",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              setState(() {
                _logFontSize++;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              setState(() {
                _logFontSize--;
              });
            },
          ),
          if (widget.showCloseButton)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return LogBar(
      dark: widget.dark,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: TextField(
              style: const TextStyle(fontSize: 20),
              controller: _filterController,
              onChanged: (s) => _refreshFilter(),
              decoration: const InputDecoration(
                labelText: "Filter log output",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 20),
          DropdownButton(
            value: _filterLevel,
            items: const [
              DropdownMenuItem(
                value: Level.nothing,
                child: Text("ALL"),
              ),
              DropdownMenuItem(
                value: Level.verbose,
                child: Text("VERBOSE"),
              ),
              DropdownMenuItem(
                value: Level.debug,
                child: Text("DEBUG"),
              ),
              DropdownMenuItem(
                value: Level.error,
                child: Text("ERROR"),
              ),
              DropdownMenuItem(
                value: Level.warning,
                child: Text("WARNING"),
              ),
              DropdownMenuItem(
                value: Level.info,
                child: Text("INFO"),
              ),
            ],
            onChanged: (value) {
              _filterLevel = value as Level;
              _refreshFilter();
            },
          )
        ],
      ),
    );
  }

  void _scrollToBottom() async {
    _scrollListenerEnabled = false;

    setState(() {
      _followBottom = true;
    });

    var scrollPosition = _scrollController.position;
    await _scrollController.animateTo(
      scrollPosition.maxScrollExtent,
      duration: new Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );

    _scrollListenerEnabled = true;
  }

  RenderedEvent _renderEvent(OutputEvent event) {
    var parser = AnsiParser(widget.dark);
    var text = event.lines.join('\n');
    parser.parse(text);
    return RenderedEvent(
      _currentId++,
      event.level,
      TextSpan(children: parser.spans),
      text.toLowerCase(),
    );
  }

  @override
  void dispose() {
    Logger.removeOutputListener(_callback);
    Logger.removeOutputListener(_callbackWithoutPrefix);
    super.dispose();
  }
}

class LogBar extends StatelessWidget {
  final bool dark;
  final Widget child;

  LogBar({required this.dark, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            if (!dark)
              const BoxShadow(
                color: Colors.grey,
                blurRadius: 1.5,
              ),
          ],
        ),
        child: Material(
          color: dark ? Colors.blueGrey[900] : Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
            child: child,
          ),
        ),
      ),
    );
  }
}
