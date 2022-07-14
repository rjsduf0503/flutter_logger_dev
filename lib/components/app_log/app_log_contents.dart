import 'package:flutter/material.dart';
import 'package:flutter_logger/components/app_log/app_log_copy_button.dart';

class AppLogContents extends StatelessWidget {
  final bool dark;
  final dynamic provider;
  AppLogContents({Key? key, required this.dark, required this.provider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: dark ? Colors.black : Colors.grey[150],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 5,
          child: ListView.builder(
            shrinkWrap: true,
            controller: provider.scrollController,
            itemBuilder: (context, index) {
              var logEntry = provider.filteredBuffer[index];
              var logEntryWithoutPrefix =
                  provider.filteredBufferWithoutPrefix[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Text.rich(
                        logEntry.span,
                        key: Key(logEntry.id.toString()),
                        style: const TextStyle(fontSize: 14),
                      ),
                      AppLogCopyButton(
                          logEntry: logEntryWithoutPrefix,
                          dark: dark,
                          size: 14),
                    ],
                  ),
                ],
              );
            },
            itemCount: provider.filteredBuffer.length,
          ),
        ),
      ),
    );
  }
}
