import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logger/components/client_log/client_logger.dart';
import 'package:flutter_logger/components/client_log/content/client_log_contents.dart';
import 'package:flutter_logger/components/client_log/header/client_log_header.dart';
import 'package:flutter_logger/components/client_log/search/client_log_search.dart';
import 'package:intl/intl.dart';

ListQueue<ReturnValue> _outputEventBuffer = ListQueue();
int _bufferSize = 100;
bool _initialized = false;

class ClientLogConsole extends StatefulWidget {
  final bool dark;
  final bool showCloseButton;

  ClientLogConsole({this.dark = false, this.showCloseButton = true})
      : assert(_initialized, "Please call ClientLogConsole.init() first.");

  static void init({int bufferSize = 100}) {
    if (_initialized) return;

    _bufferSize = bufferSize;
    _initialized = true;

    ClientLogger.addOutputListener((event) {
      if (_outputEventBuffer.length == bufferSize) {
        _outputEventBuffer.removeFirst();
      }
      _outputEventBuffer.add(event);
    });
  }

  @override
  _ClientLogConsoleState createState() => _ClientLogConsoleState();
}

class RenderedEvent {
  final int id;
  final Request request;
  final Response response;

  RenderedEvent(this.id, this.request, this.response);
}

class _ClientLogConsoleState extends State<ClientLogConsole> {
  late OutputCallback _callback;

  final ListQueue<RenderedEvent> _renderedBuffer = ListQueue();
  List<RenderedEvent> _filteredBuffer = [];

  var _currentId = 0;

  RenderedEvent _renderEvent(ReturnValue value) {
    return RenderedEvent(
      _currentId++,
      value.request,
      value.response,
    );
  }

  void _refreshFilter() {
    var newFilteredBuffer = getFilteredBuffer(_renderedBuffer);
    setState(() {
      _filteredBuffer = newFilteredBuffer;
    });
  }

  List<RenderedEvent> getFilteredBuffer(
      ListQueue<RenderedEvent> renderedBuffer) {
    return renderedBuffer.toList();
  }

  @override
  void initState() {
    super.initState();

    _callback = (event) {
      if (_renderedBuffer.length == _bufferSize) {
        _renderedBuffer.removeFirst();
      }

      _renderedBuffer.add(_renderEvent(event));
      _refreshFilter();
    };

    ClientLogger.addOutputListener(_callback);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _renderedBuffer.clear();
    for (var event in _outputEventBuffer) {
      _renderedBuffer.add(_renderEvent(event));
    }

    _refreshFilter();
  }

  @override
  void dispose() {
    ClientLogger.removeOutputListener(_callback);
    super.dispose();
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
              ClientLogHeader(widget: widget),
              Expanded(
                child: ClientLogContents(filteredBuffer: _filteredBuffer),
              ),
              ClientLogSearch(widget: widget),
            ],
          ),
        ),
      ),
    );
  }
}
