import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_logger/global_functions.dart';
import 'package:intl/intl.dart';

class RequestCard extends StatelessWidget {
  final dynamic request;
  RequestCard({Key? key, this.request}) : super(key: key);

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
                      Clipboard.setData(
                          ClipboardData(text: stringfyHttpValue(request)));
                      showClipboardAlert(context);
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
        const SizedBox(width: 5),
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
