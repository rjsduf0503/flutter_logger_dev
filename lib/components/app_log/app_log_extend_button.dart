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
      right: 0,
      top: -3,
      child: InkWell(
        onTap: (() {
          provider.handleExtendLogIconClick(index);
        }),
        child: provider.extended[index]
            ? Icon(Icons.remove,
                color: provider.refreshedBuffer[index].color)
            : Icon(Icons.add,
                color: provider.refreshedBuffer[index].color),
      ),
    );
  }
}
