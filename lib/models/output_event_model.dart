import 'package:flutter_logger/models/enums.dart';

class OutputEventModel {
  final Level level;
  final List<String> lines;

  OutputEventModel(this.level, this.lines);
}
