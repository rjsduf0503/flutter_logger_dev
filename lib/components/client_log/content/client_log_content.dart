import 'package:flutter/material.dart';
import 'package:flutter_logger/components/log_checkbox.dart';
import 'package:flutter_logger/components/client_log/content/card_header.dart';
import 'package:flutter_logger/components/client_log/content/detail_button.dart';
import 'package:flutter_logger/routes/routing.dart';
import 'package:intl/intl.dart';

class ClientLogContent extends StatelessWidget {
  final dynamic logEntry;
  final dynamic provider;
  final int index;
  ClientLogContent(
      {Key? key,
      required this.logEntry,
      required this.provider,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    dynamic stringResponseTime = logEntry.response.headers['date']?.first;
    DateTime responseTime = DateTime.parse(stringResponseTime);
    String requestTime = DateFormat.Hms().format(logEntry.request.requestTime);
    dynamic responseType = logEntry.response.statusCode;
    dynamic requestMethod = logEntry.request.method;
    Duration timeDifference =
        responseTime.difference(logEntry.request.requestTime);
    return Card(
      margin: const EdgeInsets.all(12.0),
      elevation: 4.0,
      child: Stack(
        children: [
          LogCheckbox(
            provider: provider,
            index: index,
            position: const [6, 18],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(64, 16, 16, 16),
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
                      timeDifference: timeDifference,
                    ),
                    GestureDetector(
                        onTap: () {
                          handleRouting(context, 'Client Log Detail',
                              logEntry: logEntry);
                        },
                        child: const DetailButton()),
                  ],
                ),
                const SizedBox(height: 12.0),
                Text(logEntry.request.url),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
