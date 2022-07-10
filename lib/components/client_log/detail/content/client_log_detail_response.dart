import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClientLogDetailResponse extends StatelessWidget {
  var response;
  ClientLogDetailResponse({Key? key, required this.response}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var stringResponseTime = response.headers['date']?.first;
    DateTime responseTime = DateTime.parse(stringResponseTime);
    var hms = DateFormat.Hms().format(responseTime);
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
                Text(hms),
                GestureDetector(
                    onTap: () {
                      // todo: 클립보드에 복사
                    },
                    child: _buildCopyButton()),
              ],
            ),
            _buildCardContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildCardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('응답 헤더: ${response.headers}'),
        Text('응답 본문: ${response.data}'),
      ],
    );
  }

  Widget _buildCopyButton() {
    return Row(
      children: const [Text('Copy '), Icon(Icons.copy)],
    );
  }
}
