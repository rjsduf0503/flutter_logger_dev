import 'package:flutter/material.dart';

class AppLogExtendButton extends StatelessWidget {
  final dynamic provider;
  final int index;

  const AppLogExtendButton({Key? key, this.provider, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      top: -3,
      child: InkWell(
        onTap: (() {
          provider.handleExtendLogIcon(index);
          // });
        }),
        child: provider.extended[index]
            ? Icon(Icons.remove,
                color: provider.filteredBufferWithoutPrefix[index].color)
            : Icon(Icons.add,
                color: provider.filteredBufferWithoutPrefix[index].color),
      ),
    );
  }
}
