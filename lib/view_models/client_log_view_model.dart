import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_logger/models/rendered_event_model.dart';
import 'package:flutter_logger/models/http_model.dart';
import 'package:dio/dio.dart';

ListQueue<HttpModel> _outputEventBuffer = ListQueue();
bool _initialized = false;
int _bufferSize = 100;

class ClientLogViewModel with ChangeNotifier {
  static final ClientLogViewModel _clientLogConsoleViewModel =
      ClientLogViewModel._internal();
  factory ClientLogViewModel() => _clientLogConsoleViewModel;

  ClientLogViewModel._internal()
      : assert(_initialized,
            "Please call ClientLogViewModel.init() first.") {
    initState();
    didChangeDependencies();
  }

  static void init({int bufferSize = 100}) {
    if (_initialized) return;

    _bufferSize = bufferSize;
    _initialized = true;

    ClientLogEvent.addOutputListener((event) {
      if (_outputEventBuffer.length == bufferSize) {
        _outputEventBuffer.removeFirst();
      }
      _outputEventBuffer.add(event);
    });
  }

  late OutputCallback _callback;

  final ListQueue<RenderedClientLogEventModel> _renderedBuffer = ListQueue();
  List<RenderedClientLogEventModel> filteredBuffer = [];

  var filterController = TextEditingController();

  var _currentId = 0;

  RenderedClientLogEventModel _renderEvent(HttpModel value) {
    return RenderedClientLogEventModel(
      _currentId++,
      value.request,
      value.response,
    );
  }

  List<RenderedClientLogEventModel> getFilteredBuffer(
      ListQueue<RenderedClientLogEventModel> renderedBuffer) {
    return renderedBuffer.where((it) {
      if (filterController.text.isNotEmpty) {
        var filterText = filterController.text.toLowerCase();
        return it.request.url.contains(filterText);
      } else {
        return true;
      }
    }).toList();
  }

  void refreshFilter() {
    filteredBuffer = getFilteredBuffer(_renderedBuffer);
    notifyListeners();
  }

  void initState() {
    _callback = (event) {
      if (_renderedBuffer.length == _bufferSize) {
        _renderedBuffer.removeFirst();
      }
      _renderedBuffer.add(_renderEvent(event));
      refreshFilter();
    };

    ClientLogEvent.addOutputListener(_callback);
    notifyListeners();
  }

  void didChangeDependencies() {
    _renderedBuffer.clear();
    for (var event in _outputEventBuffer) {
      _renderedBuffer.add(_renderEvent(event));
    }

    refreshFilter();
    notifyListeners();
  }

  void dispose() {
    ClientLogEvent.removeOutputListener(_callback);
  }
}

typedef OutputCallback = void Function(HttpModel value);

class ClientLogEvent {
  static final Set<OutputCallback> _outputCallbacks = {};

  static void addOutputListener(OutputCallback callback) {
    _outputCallbacks.add(callback);
  }

  static void removeOutputListener(OutputCallback callback) {
    _outputCallbacks.remove(callback);
  }

  static Set<OutputCallback> get getOutputCallbacks => _outputCallbacks;
}

class ClientLogInterceptorViewModel extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    super.onError(err, handler);
  }
}
