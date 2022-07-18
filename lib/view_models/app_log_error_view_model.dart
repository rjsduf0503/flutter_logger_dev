import 'package:flutter/material.dart';

divideError() {
  try {
    return throw 1 ~/ 0;
  } catch (error) {
    FlutterError.reportError(FlutterErrorDetails(
      exception: error,
    ));
  }
}

rangeError() {
  List<int> fixedList = List<int>.filled(5, 0);
  try {
    return throw fixedList[6];
  } on RangeError catch (error) {
    FlutterError.reportError(FlutterErrorDetails(
      exception: error,
    ));
  }
}

// for not debug mode
typeError() {
  try {
    throw NoSuchMethodError.withInvocation;
  } catch (error) {
    FlutterError.reportError(FlutterErrorDetails(
      exception: error,
    ));
  }
}

assertError() {
  int number = 200;
  try {
    assert(number < 100);
  } catch (error) {
    FlutterError.reportError(FlutterErrorDetails(
      exception: error,
    ));
  }
}

void overflowError(context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: Row(
            children: const [
              Text(
                '-------------- Overflow Error Test --------------',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("Close"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
