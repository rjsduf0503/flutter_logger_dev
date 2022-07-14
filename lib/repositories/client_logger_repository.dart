import 'package:dio/dio.dart';
import 'package:flutter_logger/models/http_request_model.dart';
import 'package:flutter_logger/models/http_model.dart';
import 'package:flutter_logger/view_models/client_log_view_model.dart';

BaseOptions baseOptions = BaseOptions(
  baseUrl: "https://reqres.in/api",
  connectTimeout: 10000,
  receiveTimeout: 10000,
  followRedirects: false,
  validateStatus: (status) {
    return status! < 600;
  },
);

class ClientLoggerRepository {
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
        ClientLogInterceptorViewModel(),
      );
    try {
      DateTime requestTime = DateTime.now().toLocal();
      var request = HttpRequestModel(
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
      var returnValue = HttpModel(request, response);
      Set<OutputCallback> outputCallbacks =
          ClientLogEvent.getOutputCallbacks;
      for (var callback in outputCallbacks) {
        callback(returnValue);
      }
    } catch (e) {
      print("Exception: $e");
    }
  }
}
