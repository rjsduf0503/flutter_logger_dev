import 'dart:collection';

import '../logger.dart';
import 'log_output.dart';

class CustomLogOutput extends LogOutput {
  final int bufferSize;

  final LogOutput? secondOutput;

  final ListQueue<OutputEvent> buffer;

  CustomLogOutput({this.bufferSize = 100, this.secondOutput})
      : buffer = ListQueue(bufferSize);

  @override
  void output(OutputEvent event) {
    if (buffer.length == bufferSize) {
      buffer.removeFirst();
    }

    buffer.add(event);
    secondOutput?.output(event);
  }

  ListQueue<OutputEvent> getBuffer() {
    return buffer;
  }
}
