import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../../routes/routing.dart' as routing;

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
            child: const Icon(Icons.last_page_outlined),
            label: 'App Log',
            onTap: () {
              routing.handleRouting(context, 'App Log');
              print('App Log Tapped');
            }),
        SpeedDialChild(
            child: const Icon(Icons.public),
            label: 'Client Log',
            onTap: () {
              routing.handleRouting(context, 'Client Log');
              print('Client Log Tapped');
            }),
      ],
    );
  }
}
