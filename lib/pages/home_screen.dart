import 'package:flutter/material.dart';
import 'package:flutter_logger/components/fab.dart';


class HomeScreen extends StatelessWidget {
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  HomeScreen({Key? key}) : super(key: key);

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
            children: const [
              Text(
                'Flutter Logger Home',
              ),
            ],
          ),
        ),
        floatingActionButton: Fab(isDialOpen: isDialOpen),
      ),
    );
  }
}
