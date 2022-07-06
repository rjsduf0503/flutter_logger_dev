import 'dart:collection';

import '../logger.dart';
import './logoutput.dart';

class CustomOutput extends LogOutput {
  final int bufferSize;

  final LogOutput? secondOutput;

  final ListQueue<OutputEvent> buffer;

  CustomOutput({this.bufferSize = 100, this.secondOutput})
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
