import 'package:flutter/material.dart';
import 'package:flutter_logger/components/client_log/content/card_header.dart';
import 'package:flutter_logger/components/client_log/content/detail_button.dart';
import 'package:intl/intl.dart';
import '../../../pages/routing.dart' as routing;

class ClientLogContent extends StatelessWidget {
  var logEntry;
  ClientLogContent({Key? key, required this.logEntry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var stringResponseTime = logEntry.response.headers['date']?.first;
    DateTime responseTime = DateTime.parse(stringResponseTime);
    var requestTime = DateFormat.Hms().format(logEntry.request.requestTime);
    var responseType = logEntry.response.statusCode;
    var requestMethod = logEntry.request.method;
    var timeDifference = responseTime.difference(logEntry.request.requestTime);
    return Card(
      margin: const EdgeInsets.all(12.0),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CardHeader(
                    requestTime: requestTime,
                    responseType: responseType,
                    requestMethod: requestMethod,
                    timeDifference: timeDifference),
                GestureDetector(
                    onTap: () {
                      routing.handleRouting(context, 'Client Log Detail', logEntry: logEntry);
                    },
                    child: DetailButton()),
              ],
            ),
            const SizedBox(height: 12.0),
            Text(logEntry.request.url),
          ],
        ),
      ),
    );
  }
}
