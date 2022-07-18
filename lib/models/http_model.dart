import 'package:dio/dio.dart';
import 'package:flutter_logger/models/http_request_model.dart';

class HttpModel {
  final HttpRequestModel request;
  final Response? response;
  final String? errorType;

  HttpModel(this.request, this.response, {this.errorType});
}
