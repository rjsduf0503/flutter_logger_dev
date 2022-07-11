import 'package:flutter/material.dart';

class ClientLogDetailRequest extends StatelessWidget {
  const ClientLogDetailRequest({Key? key}) : super(key: key);

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
    return Row(
      children: const [
        Text('시간 '),
        Text('method '),
        Text('URI'),
      ],
    );
  }

  Widget _buildCardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('쿼리 파라미터: '),
        Text('요청 헤더: '),
        Text('요청 본문: '),
      ],
    );
  }

  Widget _buildCopyButton() {
    return Row(
      children: const [Text('Copy '), Icon(Icons.copy)],
    );
  }
}
