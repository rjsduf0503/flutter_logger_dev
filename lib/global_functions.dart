import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

int getTimeDifference(time) {
  List timeList = time.toString().split('.');
  List hms = timeList[0].split(':');
  String ms = timeList[1];

  return int.parse(hms[0]) * 3600000 +
      int.parse(hms[1]) * 60000 +
      int.parse(hms[2]) * 1000 +
      int.parse(ms.substring(0, 3));
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

String stringfyHttp(value) {
  var stringResponseTime = value.response.headers['date']?.first;
  DateTime responseTime = DateTime.parse(stringResponseTime);
  var hms = DateFormat.Hms().format(responseTime);

  Object requestObject = {
    'requestTime': DateFormat.Hms().format(value.request.requestTime),
    'reuqestMethod': value.request.method,
    'requestUri': value.request.url,
    'queryParameters': value.request.queryParameters,
    'requestHeader': value.request.header,
    'requestBody': value.request.body,
  };
  Object responseObject = {
    'responseTime': hms,
    'responseHeader': {value.response.headers},
    'responseBody': value.response.data,
  };

  return '${requestObject.toString()} \n ${responseObject.toString()}';
}

void debugPrintSynchronouslyWithText(String message, {int? wrapWidth}) {
  message = "[${DateTime.now()}]: $message";
  debugPrintSynchronously(message, wrapWidth: wrapWidth);
}

