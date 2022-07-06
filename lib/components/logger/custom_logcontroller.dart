import 'dart:collection';

import '../../components/logger/logger.dart';
import '../../components/logger/output/custom_logoutput.dart';

final CustomOutput customOutput = CustomOutput();

class CustomLogController {
  final Logger logger = Logger(output: customOutput);

  ListQueue<OutputEvent> getBuffer() {
    ListQueue<OutputEvent> buffer = customOutput.getBuffer();
    return buffer;
  }
}
