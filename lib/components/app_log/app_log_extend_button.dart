import 'package:flutter/material.dart';

class AppLogExtendButton extends StatelessWidget {
  final dynamic provider;
  final int index;

  const AppLogExtendButton(
      {Key? key, required this.provider, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 2,
      top: -1,
      child: InkWell(
        onTap: (() {
          provider.handleExtendLogIconClick(index);
        }),
        child: provider.refreshedBuffer[index].extended
            ? Icon(Icons.remove,
                color: provider.refreshedBuffer[index].logEntry.color, size: 32)
            : Icon(Icons.add,
                color: provider.refreshedBuffer[index].logEntry.color,
                size: 32),
      ),
    );
  }
}
