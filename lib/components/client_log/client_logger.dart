import 'package:dio/dio.dart';

import 'custom_log_interceptor.dart';

BaseOptions baseOptions = BaseOptions(
  baseUrl: "https://reqres.in/api",
  connectTimeout: 3000,
  receiveTimeout: 3000,
  followRedirects: false,
  validateStatus: (status) {
    return status! < 600;
  },
);

typedef OutputCallback = void Function(ReturnValue value);

class Request {
  final dynamic requestTime;
  final String method;
  final String url;
  final Map<String, dynamic>? queryParameters;
  final Map<String, dynamic>? header;
  final dynamic body;

  Request(this.requestTime, this.method, this.url, this.queryParameters,
      this.header, this.body);
}

class ReturnValue {
  final Request request;
  final Response response;

  ReturnValue(this.request, this.response);
}

class ClientLogger {
  static final Set<OutputCallback> _outputCallbacks = {};

  void get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    doDio('GET', url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress);
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
  }) async {
    BaseOptions dioOptions =
        baseOptions.copyWith(queryParameters: queryParameters, method: type);
    final dio = Dio(dioOptions)
      ..interceptors.add(
        CustomLogInterceptor(),
      );
    try {
      DateTime requestTime = DateTime.now().toLocal();
      var request = Request(
          requestTime,
          dio.options.method,
          dio.options.baseUrl + url,
          dio.options.queryParameters,
          dio.options.headers,
          data);
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
      var returnValue = ReturnValue(request, response);
      for (var callback in _outputCallbacks) {
        callback(returnValue);
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  static void addOutputListener(OutputCallback callback) {
    _outputCallbacks.add(callback);
  }

  static void removeOutputListener(OutputCallback callback) {
    _outputCallbacks.remove(callback);
  }
}
