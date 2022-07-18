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
