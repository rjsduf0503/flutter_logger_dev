import 'package:flutter/material.dart';
import 'package:flutter_logger/components/client_log/content/response_type.dart';
import 'package:flutter_logger/global_functions.dart';

class CardHeader extends StatelessWidget {
  final String requestTime;
  final dynamic responseType;
  String requestMethod;
  final dynamic timeDifference;
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
    return Expanded(
      child: Row(
        children: [
          Text(requestTime),
          const SizedBox(width: 5),
          ResponseType(responseType: responseType),
          const SizedBox(width: 5),
          Text(requestMethod),
          const SizedBox(width: 5),
          Text(stringTimeDifference),
        ],
      ),
    );
  }
}
