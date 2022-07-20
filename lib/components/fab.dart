import 'package:flutter/material.dart';
import 'package:flutter_logger/routes/routing.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class Fab extends StatelessWidget {
  final ValueNotifier<bool> isDialOpen;

  const Fab({Key? key, required this.isDialOpen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      openCloseDial: isDialOpen,
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      overlayColor: Colors.grey,
      overlayOpacity: 0.5,
      spacing: 15,
      spaceBetweenChildren: 10,
      children: [
        SpeedDialChild(
            child: const Icon(Icons.wysiwyg),
            label: 'Log',
            onTap: () {
              handleRouting(context, 'Log');
            }),
        SpeedDialChild(
            child: const Icon(Icons.last_page_outlined),
            label: 'App Log',
            onTap: () {
              handleRouting(context, 'App Log');
            }),
        SpeedDialChild(
            child: const Icon(Icons.public),
            label: 'Client Log',
            onTap: () {
              handleRouting(context, 'Client Log');
            }),
      ],
    );
  }
}
