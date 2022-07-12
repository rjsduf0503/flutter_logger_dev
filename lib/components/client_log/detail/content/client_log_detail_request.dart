import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                      Clipboard.setData(
                          ClipboardData(text: stringfyRequest(request)));
                      _showClipboardAlert(context);
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

  void _showClipboardAlert(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text('Copied to clipboard.'),
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

  String stringfyRequest(request) {
    Object requestObject = {
      'requestTime': DateFormat.Hms().format(request.requestTime),
      'reuqestMethod': request.method,
      'requestUri': request.url,
      'queryParameters': request.queryParameters,
      'requestHeader': request.header,
      'requestBody': request.body,
    };
    return requestObject.toString();
  }
}
