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
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          if (identical(consoleType, 'App Log') ||
              identical(consoleType, 'Client Log'))
            Transform.scale(
              scale: 1.2,
              child: Checkbox(
                checkColor: dark ? Colors.black : Colors.white,
                activeColor: dark ? Colors.white : Colors.black,
                side: MaterialStateBorderSide.resolveWith(
                  (states) => BorderSide(
                    width: 2,
                    color: dark ? Colors.white : Colors.black,
                  ),
                ),
                splashRadius: 15,
                value: !provider.checked.contains(false) &&
                    provider.checked.isNotEmpty,
                onChanged: (value) {
                  provider.handleAllCheckboxClick();
                },
              ),
            ),
          if (identical(consoleType, 'App Log') ||
              identical(consoleType, 'Client Log'))
            IconButton(
              splashRadius: 20,
              icon: const Icon(Icons.delete_outline, size: 32),
              onPressed: () {
                provider.refreshBuffer();
              },
            ),
          IconButton(
            splashRadius: 20,
            icon: const Icon(Icons.copy, size: 26),
            onPressed: () {
              if (identical(consoleType, 'Client Log Detail')) {
                Clipboard.setData(ClipboardData(text: stringHttp));
                showClipboardAlert(context);
              } else if (provider.copyText != '') {
                Clipboard.setData(ClipboardData(text: provider.copyText));
                showClipboardAlert(context);
              }
            },
          ),
          IconButton(
            splashRadius: 20,
            icon: const Icon(Icons.close, size: 32),
            onPressed: () {
              Navigator.pop(parentContext);
            },
          ),
        ],
      ),
    );
  }
}
