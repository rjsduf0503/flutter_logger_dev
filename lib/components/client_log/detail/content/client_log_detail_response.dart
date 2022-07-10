import 'package:flutter/material.dart';

class ClientLogDetailResponse extends StatelessWidget {
  const ClientLogDetailResponse({Key? key}) : super(key: key);

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
                Text('시간 '),
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
      children: const [
        Text('응답 헤더: '),
        Text('응답 본문: '),
      ],
    );
  }

  Widget _buildCopyButton() {
    return Row(
      children: const [Text('Copy '), Icon(Icons.copy)],
    );
  }
}
