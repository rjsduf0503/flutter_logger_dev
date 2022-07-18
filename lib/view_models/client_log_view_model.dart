import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_logger/global_functions.dart';
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
      : assert(_initialized, "Please call ClientLogViewModel.init() first.");

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

  late List<bool> checked = [];
  List<RenderedClientLogEventModel> checkedBuffer = [];
  String copyText = '';

  RenderedClientLogEventModel _renderEvent(HttpModel value) {
    return RenderedClientLogEventModel(
      _currentId++,
      value.request,
      value.response,
      errorType: value.errorType,
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

    checked = List<bool>.filled(_renderedBuffer.length, false);
  }

  void didChangeDependencies() {
    _renderedBuffer.clear();
    for (var event in _outputEventBuffer) {
      _renderedBuffer.add(_renderEvent(event));
    }

    checked = List<bool>.filled(_renderedBuffer.length, false);

    refreshFilter();
  }

  void handleCheckboxClick(int index) {
    checked[index] = !checked[index];
    if (checked[index]) {
      checkedBuffer.add(filteredBuffer[index]);
    } else {
      checkedBuffer.removeWhere((element) => element == filteredBuffer[index]);
    }
    checkedBuffer.sort((a, b) => a.id.compareTo(b.id));

    copyText = '';
    if (checkedBuffer.isNotEmpty) {
      for (var element in checkedBuffer) {
        var stringHttp = stringfyHttp(element);
        copyText +=
            checkedBuffer.last == element ? stringHttp : '$stringHttp\n\n';
      }
    }

    notifyListeners();
  }

  void handleAllCheckboxClick() {
    bool allChecked = !checked.contains(false);
    checked.fillRange(0, checked.length, !allChecked);

    checkedBuffer = [];
    copyText = '';
    if (!allChecked) {
      checkedBuffer.addAll(filteredBuffer);
      if (checkedBuffer.isNotEmpty) {
        for (var element in checkedBuffer) {
          var stringHttp = stringfyHttp(element);
          copyText +=
              checkedBuffer.last == element ? stringHttp : '$stringHttp\n\n';
        }
      }
    }

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

class ClientLogInterceptor extends Interceptor {
  var debugPrint = (String? message,
          {int? wrapWidth, String? currentState, dynamic time}) =>
      debugPrintSynchronouslyWithText(
        message!,
        wrapWidth: wrapWidth,
        currentState: currentState,
        time: time,
      );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    requestTime = DateTime.now().toLocal();
    // debugPrint('     ===== Dio Error [Start] =====',
    //     currentState: 'Error', time: reqTime);
    // debugPrint('     method => ${options.method}',
    //     currentState: 'Error', time: reqTime);
    // debugPrint('     uri => ${options.uri}',
    //     currentState: 'Error', time: reqTime);
    // debugPrint('     requestHeader => ${options.headers}',
    //     currentState: 'Error', time: reqTime);
    // debugPrint('     requestBody => ${options.data}',
    //     currentState: 'Error', time: reqTime);
    reqOptions = options;
    return super.onRequest(options, handler);
  }

  late DateTime requestTime;
  late RequestOptions reqOptions;

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    var status = response.statusMessage;
    debugPrint('     ===== Dio $status [Start] =====',
        currentState: status, time: requestTime);
    debugPrint('     method => ${reqOptions.method}',
        currentState: status, time: requestTime);
    debugPrint('     uri => ${reqOptions.uri}',
        currentState: status, time: requestTime);
    debugPrint('     requestHeader => ${reqOptions.headers}',
        currentState: status, time: requestTime);
    debugPrint('     requestBody => ${reqOptions.data}',
        currentState: status, time: requestTime);

    DateTime responseTime = DateTime.now().toLocal();
    debugPrint('     responseStatus => ${response.statusCode.toString()}',
        currentState: status, time: responseTime);
    debugPrint(
        '     responseCorrelationId => a7aa5198-8bb3-40f3-aa30-0c0889a02222',
        currentState: status,
        time: responseTime);
    debugPrint('     responseBody => ${response.data}',
        currentState: status, time: responseTime);
    debugPrint('     ===== Dio $status [End] =====',
        currentState: status, time: responseTime);
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    var status = err.type.name;
    debugPrint('     ===== Dio $status [Start] =====',
        currentState: status, time: requestTime);
    debugPrint('     method => ${reqOptions.method}',
        currentState: status, time: requestTime);
    debugPrint('     uri => ${reqOptions.uri}',
        currentState: status, time: requestTime);
    debugPrint('     requestHeader => ${reqOptions.headers}',
        currentState: status, time: requestTime);
    debugPrint('     requestBody => ${reqOptions.data}',
        currentState: status, time: requestTime);
    debugPrint('     ===== Dio $status [End] =====',
        currentState: status, time: requestTime);
    return super.onError(err, handler);
  }
}
