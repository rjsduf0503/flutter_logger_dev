import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

String getTimeDifference(time) {
  if (time == '') return time;
  List timeList = time.toString().split('.');
  List hms = timeList[0].split(':');
  String ms = timeList[1];

  return '${int.parse(hms[0]) * 3600000 + int.parse(hms[1]) * 60000 + int.parse(hms[2]) * 1000 + int.parse(ms.substring(0, 3))} ms';
}

void showClipboardAlert(context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: const Text('Copied to clipboard.'),
        actions: <Widget>[
          TextButton(
            child: const Text("Close"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

String stringfyHttp(value, {errorType}) {
  List<String> str = [];
  var requestTime = value.request.requestTime.toString().split('.')[0];
  var statusMessage =
      value.response != null ? value.response.statusMessage : errorType;
  var requestPrefix = '[$statusMessage] - [$requestTime]:     ';

  str.add('$requestPrefix ===== Dio $statusMessage [Start] =====');
  str.add('$requestPrefix method => ${value.request.method}');
  str.add('$requestPrefix uri => ${value.request.url}');
  str.add('$requestPrefix requestHeader => ${value.request.header}');
  str.add('$requestPrefix requestBody => ${value.request.body}');

  if (value.response != null) {
    var stringResponseTime = value.response.headers['date']?.first;
    DateTime respTime = DateTime.parse(stringResponseTime);
    var responseTime = respTime.toString().split('.')[0];
    var responsePrefix = '[$statusMessage] - [$responseTime]:     ';
    str.add(
        '$responsePrefix responseStatus => ${value.response.statusCode.toString()}');
    str.add(
        '$responsePrefix responseCorrelationId => a7aa5198-8bb3-40f3-aa30-0c0889a02222');
    str.add('$responsePrefix responseBody => ${value.response.data}');
    str.add('$responsePrefix ===== Dio $statusMessage [End] =====');
  } else {
    str.add('$requestPrefix ===== Dio $statusMessage [End] =====');
  }

  return str.join('\n');
}

void debugPrintSynchronouslyWithText(String message,
    {int? wrapWidth, String? currentState, dynamic time}) {
  time = time.toString().split('.')[0];
  message = "[$currentState] - [$time]: $message";
  debugPrintSynchronously(message, wrapWidth: wrapWidth);
}

bool isInt(String str) {
  if (str == null) {
    return false;
  }
  return int.tryParse(str) != null;
}
