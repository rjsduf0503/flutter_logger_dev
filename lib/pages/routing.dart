import 'package:flutter/material.dart';
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
        return const AppLog();
      case "Client Log":
        return const ClientLog();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        // leading: BackButton(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: Text(item),
      ),
      body: getStackBody(),
    );
  }
}
