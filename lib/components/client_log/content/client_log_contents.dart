import 'package:flutter/material.dart';
import 'package:flutter_logger/components/client_log/client_log_console.dart';
import 'package:flutter_logger/components/client_log/content/client_log_content.dart';

class ClientLogContents extends StatelessWidget {
  List<RenderedEvent> filteredBuffer;
  ClientLogContents({Key? key, required this.filteredBuffer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          var logEntry = filteredBuffer[index];
          var responseTime = logEntry.response.headers['date']?.first;
          print(logEntry.request.requestTime); //DateTime
          print(logEntry.request.requestTime.runtimeType);
          print(responseTime); // String
          print(responseTime.runtimeType);
          return ClientLogContent();
        },
        itemCount: filteredBuffer.length,
      ),
    );
  }
}
