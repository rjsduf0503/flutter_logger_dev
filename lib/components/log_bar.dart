import 'package:flutter/material.dart';

class LogBar extends StatelessWidget {
  final bool dark;
  final Widget child;

  LogBar({required this.dark, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            if (!dark)
              const BoxShadow(
                color: Colors.grey,
                blurRadius: 1.5,
              ),
          ],
        ),
        child: Material(
          color: dark ? Colors.blueGrey[900] : Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
            child: child,
          ),
        ),
      ),
    );
  }
}
