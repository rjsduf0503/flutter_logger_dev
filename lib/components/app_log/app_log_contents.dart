import 'package:flutter/material.dart';
import 'package:flutter_logger/components/app_log/app_log_copy_button.dart';
import 'package:flutter_logger/components/app_log/app_log_extend_button.dart';

class AppLogContents extends StatelessWidget {
  final bool dark;
  final dynamic provider;

  const AppLogContents({Key? key, required this.dark, this.provider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: dark ? Colors.black : Colors.grey[150],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 50),
        child: ListView.builder(
          shrinkWrap: true,
          controller: provider.scrollController,
          itemBuilder: (context, index) {
            var logEntryWithoutPrefix =
                provider.filteredBufferWithoutPrefix[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: logEntryWithoutPrefix.color,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Center(
                            child: Text(
                              logEntryWithoutPrefix.level
                                  .toString()
                                  .split('.')
                                  .last
                                  .toUpperCase(),
                              style: TextStyle(
                                color: logEntryWithoutPrefix.color,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          provider.extended[index]
                              ? Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      logEntryWithoutPrefix.lowerCaseText,
                                      style: TextStyle(
                                        color: logEntryWithoutPrefix.color,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                      AppLogCopyButton(
                        logEntry: logEntryWithoutPrefix,
                        dark: dark,
                        size: 14,
                      ),
                      AppLogExtendButton(provider: provider, index: index),
                    ],
                  ),
                ),
              ],
            );
          },
          itemCount: provider.filteredBufferWithoutPrefix.length,
        ),
      ),
    );
  }
}
