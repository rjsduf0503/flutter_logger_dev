import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_logger/components/log_bar.dart';
import 'package:flutter_logger/global_functions.dart';

class LogHeader extends StatelessWidget {
  final bool dark;
  final dynamic parentContext;
  final String consoleType;
  final dynamic provider;
  final dynamic stringHttp;

  const LogHeader({
    Key? key,
    this.dark = false,
    required this.parentContext,
    required this.consoleType,
    this.provider,
    this.stringHttp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LogBar(
      dark: dark,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            consoleType,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          identical(consoleType, 'Client Log') ||
                  identical(consoleType, 'App Log')
              ? Checkbox(
                  value: !provider.checked.contains(false) &&
                      provider.checked.isNotEmpty,
                  onChanged: (value) {
                    provider.handleAllCheckboxClick();
                  },
                )
              : const SizedBox.shrink(),
          !consoleType.contains('Test')
              ? IconButton(
                  icon: const Icon(Icons.copy, size: 22),
                  onPressed: () {
                    if (consoleType == 'Client Log Detail') {
                      Clipboard.setData(ClipboardData(text: stringHttp));
                      showClipboardAlert(context);
                    } else if (provider.copyText != '') {
                      Clipboard.setData(ClipboardData(text: provider.copyText));
                      showClipboardAlert(context);
                    }
                  },
                )
              : const SizedBox.shrink(),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(parentContext);
            },
          ),
        ],
      ),
    );
  }
}
