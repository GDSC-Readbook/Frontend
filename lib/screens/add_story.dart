import 'package:flutter/material.dart';

class FiltersScreen extends StatelessWidget {
  const FiltersScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //상태가 바뀔 때마다 실행하므로 read대신 watch사용.

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Filters',
        ),
      ),
      body: const Column(
        children: [
          //필터링을 위한 여러 스위치 추가. 렌더링에 편리한 위젯.
          Text('sdf'),
        ],
      ),
    );
  }
}
