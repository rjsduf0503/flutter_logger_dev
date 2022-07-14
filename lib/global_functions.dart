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

String stringfyHttpValue(value, [hms]) {
  if (hms != null) {
    Object responseObject = {
      'responseTime': hms,
      'responseHeader': {value.headers},
      'responseBody': value.data,
    };
    return responseObject.toString();
  } else {
    Object requestObject = {
      'requestTime': DateFormat.Hms().format(value.requestTime),
      'reuqestMethod': value.method,
      'requestUri': value.url,
      'queryParameters': value.queryParameters,
      'requestHeader': value.header,
      'requestBody': value.body,
    };
    return requestObject.toString();
  }
}
