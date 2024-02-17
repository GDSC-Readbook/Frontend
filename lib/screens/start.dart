import 'package:readbook_hr/screens/auth.dart';

import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 50), // 하단바가 있을 공간 만들기
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Column(
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                    'Readbook',
                    style: TextStyle(
                      fontSize: 43,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(52, 168, 83, 1),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
              const SizedBox(
                height: 200,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => const AuthScreen(
                        isLogin: false,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color.fromRGBO(52, 168, 83, 1), // 배경 색상
                  fixedSize: const Size(320, 74), // 버튼의 너비와 높이
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0), // 모서리의 둥근 정도
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w700,
                    color: Color.fromARGB(255, 255, 255, 255), // 폰트 크기
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
