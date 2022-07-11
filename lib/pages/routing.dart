import 'package:flutter/material.dart';
import 'package:flutter_logger/pages/clientlog/client_log_detail.dart';
import './applog/applog.dart';
import './clientlog/clientlog.dart';

void handleRouting(context, item) {
  Navigator.of(context).push(PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Routing(item),
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

  const Routing(this.item, {Key? key}) : super(key: key);

  Widget getStackBody() {
    switch (item) {
      case "App Log":
        return AppLog();
      case "Client Log":
        return const ClientLog();
      case "Client Log Detail":
        return ClientLogDetail();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody: true,
      body: getStackBody(),
    );
  }
}
