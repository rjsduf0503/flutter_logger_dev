import 'package:flutter/material.dart';
import 'components/fab.dart' as fab;

void main() async {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Logger',
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        colorScheme: const ColorScheme.light(
          brightness: Brightness.light,
          secondary: Colors.black,
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        floatingActionButton: fab.CustomFAB(isDialOpen: isDialOpen),
      ),
    );
  }
}
