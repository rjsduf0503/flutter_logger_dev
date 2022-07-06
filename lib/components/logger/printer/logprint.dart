import '../logger.dart';

abstract class LogPrinter {
  void init() {}

  List<List<String>> log(LogEvent event);

  void destroy() {}
}
