import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logger/models/enums.dart';
import 'package:flutter_logger/models/http_request_model.dart';

class RenderedClientLogEventModel {
  final int id;
  final HttpRequestModel request;
  final Response? response;
  final String? errorType;

  RenderedClientLogEventModel(this.id, this.request, this.response,
      {this.errorType});
}

class RenderedAppLogEventModel {
  final int id;
  final Level level;
  final Color color;
  final String lowerCaseText;

  RenderedAppLogEventModel(this.id, this.level, this.color, this.lowerCaseText);
}
