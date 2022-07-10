import 'package:flutter/material.dart';
import 'package:flutter_logger/components/client_log/content/response_type.dart';

class CardHeader extends StatelessWidget {
  var requestTime;
  var responseType;
  String requestMethod;
  var timeDifference;
  CardHeader(
      {Key? key,
      required this.requestTime,
      required this.responseType,
      required this.requestMethod,
      required this.timeDifference})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String stringTimeDifference = getTimeDifference(timeDifference).toString();
    return Row(
      children: [
        Text(requestTime),
        SizedBox(width: 5),
        ResponseType(responseType: responseType),
        SizedBox(width: 5),
        Text(requestMethod),
        SizedBox(width: 5),
        Text(stringTimeDifference + 'ms'),
      ],
    );
  }
}

int getTimeDifference(time) {
  List timeList = time.toString().split('.');
  List hms = timeList[0].split(':');
  String ms = timeList[1];
  String hour = hms[0];
  String min = hms[1];
  String sec = hms[2];
  return int.parse(hms[0]) * 3600000 +
      int.parse(hms[1]) * 60000 +
      int.parse(hms[2]) * 1000 +
      int.parse(ms.substring(0, 3));
}
