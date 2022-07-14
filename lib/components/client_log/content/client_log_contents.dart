import 'package:flutter/material.dart';
import 'package:flutter_logger/components/client_log/content/client_log_content.dart';

class ClientLogContents extends StatelessWidget {
  final dynamic provider;
  ClientLogContents({Key? key, required this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ClientLogContent(logEntry: provider.filteredBuffer[index]);
        },
        itemCount: provider.filteredBuffer.length,
      ),
    );
  }
}
