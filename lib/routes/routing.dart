import 'package:flutter/material.dart';
import 'package:flutter_logger/pages/app_log_screen.dart';
import 'package:flutter_logger/pages/client_log/client_log_detail_screen.dart';
import 'package:flutter_logger/pages/client_log/client_log_screen.dart';

void handleRouting(context, item, {logEntry}) {
  Navigator.of(context).push(PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        Routing(item, logEntry),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = const Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;
      var curveTween = CurveTween(curve: curve);

      var tween = Tween(begin: begin, end: end).chain(curveTween);

      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  ));
}

class Routing extends StatelessWidget {
  final String item;
  final dynamic logEntry;

  Routing(this.item, this.logEntry, {Key? key}) : super(key: key);

  Widget getStackBody() {
    switch (item) {
      case "App Log":
        return const AppLogScreen();
      case "Client Log":
        return const ClientLogScreen();
      case "Client Log Detail":
        return ClientLogDetailScreen(logEntry: logEntry);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getStackBody(),
    );
  }
}
