import 'package:flutter/material.dart';
import 'package:flutter_logger/components/fab.dart';
import 'package:flutter_logger/environments.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isDialOpen.value) {
          isDialOpen.value = false;
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Text(
                'Flutter Logger Home',
              ),
            ],
          ),
        ),
        floatingActionButton: CustomFAB(isDialOpen: isDialOpen),
      ),
    );
  }
}
