import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logger/global_functions.dart';
import 'package:flutter_logger/models/checked_log_entry_model.dart';
import 'package:flutter_logger/models/http_model.dart';
import 'package:flutter_logger/models/http_request_model.dart';
import 'package:flutter_logger/models/rendered_event_model.dart';

ListQueue<HttpModel> _outputEventBuffer = ListQueue();
bool _initialized = false;
int _bufferSize = 100;
var _currentId = 0;

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
  List filteredBuffer = [];
  List refreshedBuffer = [];

  var filterController = TextEditingController();
  bool allChecked = false;

  String copyText = '';
  List<CheckedLogEntryModel> checked = [];

  void initState() {
    _callback = (event) {
      if (_renderedBuffer.length == _bufferSize) {
        _renderedBuffer.removeFirst();
      }
      _renderedBuffer.add(_renderEvent(event));
      refreshFilter();
    };

    ClientLogEvent.addOutputListener(_callback);

    checked = List<CheckedLogEntryModel>.generate(
        _renderedBuffer.length, (index) => CheckedLogEntryModel());
    allChecked = false;

    var temp = 0;
    for (var item in _renderedBuffer) {
      checked[temp++].logEntry = item;
    }
  }

  void didChangeDependencies() {
    _renderedBuffer.clear();

    for (var event in _outputEventBuffer) {
      _renderedBuffer.add(_renderEvent(event));
    }

    checked = List<CheckedLogEntryModel>.generate(
        _renderedBuffer.length, (index) => CheckedLogEntryModel());
    allChecked = false;

    var temp = 0;
    for (var item in _renderedBuffer) {
      checked[temp++].logEntry = item;
    }

    copyText = '';
    filterController.text = '';
    allChecked = false;

    refreshFilter();
  }

  @override
  void dispose() {
    ClientLogEvent.removeOutputListener(_callback);
    super.dispose();
  }

  RenderedClientLogEventModel _renderEvent(HttpModel value) {
    return RenderedClientLogEventModel(
      _currentId++,
      value.request,
      value.response,
      errorType: value.errorType,
    );
  }

  List getFilteredBuffer(List list) {
    return list.where((it) {
      if (filterController.text.isNotEmpty) {
        var filterText = filterController.text.toLowerCase();
        return it.logEntry.request.url.contains(filterText);
      } else {
        return true;
      }
    }).toList();
  }

  void refreshFilter() {
    filteredBuffer = getFilteredBuffer(checked);
    refreshedBuffer = filteredBuffer;
    notifyListeners();
  }

  void filterControl() {
    refreshFilter();
    allChecked = true;
    copyText = '';
    if (refreshedBuffer.isEmpty) {
      allChecked = false;
    } else {
      for (var element in refreshedBuffer) {
        if (element.checked) {
          var stringHttp = stringfyHttp(element.logEntry);
          copyText +=
              refreshedBuffer.last == element ? stringHttp : '$stringHttp\n\n';
        } else {
          allChecked = false;
        }
      }
    }
    notifyListeners();
  }

  void refreshBuffer() {
    refreshedBuffer = [];
    copyText = '';
    _renderedBuffer.clear();
    checked = [];
    allChecked = false;
    notifyListeners();
  }

  void handleCheckboxClick(int index, bool value) {
    refreshedBuffer[index].checked = value;
    allChecked = true;
    copyText = '';

    for (var element in refreshedBuffer) {
      if (element.checked) {
        var stringHttp = stringfyHttp(element.logEntry);
        copyText +=
            refreshedBuffer.last == element ? stringHttp : '$stringHttp\n\n';
      } else {
        allChecked = false;
      }
    }

    notifyListeners();
  }

  void handleAllCheckboxClick() {
    for (var item in refreshedBuffer) {
      item.checked = !allChecked;
    }

    allChecked = !allChecked;

    copyText = '';
    if (allChecked) {
      for (var element in refreshedBuffer) {
        if (element.checked) {
          var stringHttp = stringfyHttp(element.logEntry);
          copyText +=
              refreshedBuffer.last == element ? stringHttp : '$stringHttp\n\n';
        }
      }
    }

    notifyListeners();
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

BaseOptions baseOptions = BaseOptions(
  baseUrl: "https://reqres.in/api",
  connectTimeout: 10000,
  receiveTimeout: 10000,
  followRedirects: false,
  validateStatus: (status) {
    return status! < 600;
  },
);

class ClientLogger {
  void get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    int? timeout,
  }) {
    doDio('GET', url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        timeout: timeout);
  }

  void post(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    doDio('POST', url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
  }

  void put(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    doDio(
      'PUT',
      url,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  void delete(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    doDio(
      'DELETE',
      url,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  void patch(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    doDio(
      'PATCH',
      url,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  void doDio(
    String type,
    String url, {
    Map<String, dynamic>? queryParameters,
    data,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    int? timeout,
  }) async {
    BaseOptions dioOptions = timeout == null
        ? baseOptions.copyWith(
            queryParameters: queryParameters,
            method: type,
          )
        : baseOptions.copyWith(
            queryParameters: queryParameters,
            method: type,
            connectTimeout: timeout,
            receiveTimeout: timeout,
          );
    final dio = Dio(dioOptions)
      ..interceptors.add(
        ClientLogInterceptor(),
      );
    DateTime requestTime = DateTime.now().toLocal();
    var request = HttpRequestModel(
        requestTime,
        dio.options.method,
        dio.options.baseUrl + url,
        dio.options.queryParameters,
        dio.options.headers,
        data);
    try {
      Response response = await dio.request(
        url,
        data: data,
        queryParameters: dio.options.queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      DateTime responseTime = DateTime.now().toLocal();
      response.headers['date']?[0] = responseTime.toString();
      var returnValue = HttpModel(request, response);
      Set<OutputCallback> outputCallbacks = ClientLogEvent.getOutputCallbacks;
      for (var callback in outputCallbacks) {
        callback(returnValue);
      }
    } on DioError catch (error) {
      var returnValue =
          HttpModel(request, error.response, errorType: error.type.name);
      Set<OutputCallback> outputCallbacks = ClientLogEvent.getOutputCallbacks;
      for (var callback in outputCallbacks) {
        callback(returnValue);
      }
    } on Error catch (error) {
      print(error);
    }
  }
}
