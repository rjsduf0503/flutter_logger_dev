import 'package:flutter/material.dart';
import 'package:flutter_logger/components/client_log/content/response_type.dart';

class CardHeader extends StatelessWidget {
  const CardHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('시간 '),
        ResponseType(responseType: '200'),
        const Text(' method'),
        const Text(' 요청시간'),
      ],
    );
  }
}
