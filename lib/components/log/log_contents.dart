import 'package:flutter/material.dart';
import 'package:flutter_logger/components/client_log/content/client_log_content.dart';
import 'package:flutter_logger/components/log_checkbox.dart';
import 'package:flutter_logger/models/rendered_event_model.dart';

class LogContents extends StatelessWidget {
  final bool dark;
  final dynamic provider;

  const LogContents({Key? key, required this.dark, this.provider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: dark ? Colors.black : Colors.grey[150],
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          var logEntry = provider.refreshedBuffer[index].logEntry;
          if (logEntry.runtimeType == RenderedAppLogEventModel) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: logEntry.color,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Center(
                              child: Text(
                                logEntry.level
                                    .toString()
                                    .split('.')
                                    .last
                                    .toUpperCase(),
                                style: TextStyle(
                                  color: logEntry.color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                logEntry.lowerCaseText,
                                style: TextStyle(
                                  color: logEntry.color,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      LogCheckbox(
                        provider: provider,
                        index: index,
                        position: const [-5, -10],
                        color: logEntry.color,
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return ClientLogContent(
                provider: provider,
                index: index,
                logEntry: provider.refreshedBuffer[index].logEntry);
          }
        },
        itemCount: provider.refreshedBuffer.length,
      ),
    );
  }
}
