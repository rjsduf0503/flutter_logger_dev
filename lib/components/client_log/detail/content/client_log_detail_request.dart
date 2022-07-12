import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClientLogDetailRequest extends StatelessWidget {
  var request;
  ClientLogDetailRequest({Key? key, this.request}) : super(key: key);

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
                _buildCardHeader(),
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

  Widget _buildCardHeader() {
    var requestTime = DateFormat.Hms().format(request.requestTime);
    return Row(
      children: [
        Text(requestTime),
        SizedBox(width: 5),
        Text(request.method),
      ],
    );
  }

  Widget _buildCardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('주소: ${request.url}'),
        Text('쿼리 파라미터: ${request.queryParameters}'),
        Text('요청 헤더: ${request.header}'),
        Text('요청 본문: ${request.body}'),
      ],
    );
  }

  Widget _buildCopyButton() {
    return Row(
      children: const [Text('Copy '), Icon(Icons.copy)],
    );
  }
}
