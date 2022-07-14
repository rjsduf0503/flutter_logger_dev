import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logger/models/enums/enums.dart';
import 'package:flutter_logger/models/http_request_model.dart';

class RenderedClientLogEventModel {
  final int id;
  final HttpRequestModel request;
  final Response response;

  RenderedClientLogEventModel(this.id, this.request, this.response);
}

class RenderedAppLogEventModel {
  final int id;
  final Level level;
  final TextSpan span;
  final String lowerCaseText;

  RenderedAppLogEventModel(this.id, this.level, this.span, this.lowerCaseText);
}

