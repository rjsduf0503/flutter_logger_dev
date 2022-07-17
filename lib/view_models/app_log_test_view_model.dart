import 'package:flutter/material.dart';

class AppLogTestViewModel with ChangeNotifier {
  List<Widget> appLogWidgets = [];

  void addOverflow() {
    appLogWidgets.add(
      Padding(
        padding: EdgeInsets.only(bottom: 30.0),
        child: Row(
          children: [
            Text(
              'Explore the restaurant\'s delicious menu items below!',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ),
    );
    notifyListeners();
  }

  void addUnboundedHeight() {
    // appLogWidgets.add();
    notifyListeners();
  }
}
