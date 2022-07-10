import 'package:flutter/material.dart';
import 'package:flutter_logger/components/client_log/content/card_header.dart';
import 'package:flutter_logger/components/client_log/content/detail_button.dart';
import '../../../pages/routing.dart' as routing;

class ClientLogContent extends StatelessWidget {
  const ClientLogContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12.0),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CardHeader(),
                GestureDetector(
                    onTap: () {
                      routing.handleRouting(context, 'Client Log Detail');
                    },
                    child: DetailButton()),
              ],
            ),
            const SizedBox(height: 12.0),
            const Text("URI"),
          ],
        ),
      ),
    );
  }
}

// onTap: () {
//               routing.handleRouting(context, 'App Log');
//               print('App Log Tapped');
//             }