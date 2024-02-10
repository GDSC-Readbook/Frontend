import 'package:readbook_hr/screens/auth.dart';

import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //decoration:
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
                      builder: (ctx) => const LoginSelectScreen(),
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

class LoginSelectScreen extends StatelessWidget {
  const LoginSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: const Color.fromRGBO(52, 168, 83, 1),
        backgroundColor: Colors.white,
      ),
      body: Container(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Text(
                  'WWWAVE',
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(52, 168, 83, 1),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Communicating with the world',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'something something long sentence',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: Color.fromARGB(255, 121, 121, 121),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 80,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => const AuthScreen(isLogin: false),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color.fromRGBO(52, 168, 83, 1), // 배경 색상
                    fixedSize: const Size(147, 73), // 버튼의 너비와 높이
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0), // 모서리의 둥근 정도
                    ),
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 19, fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 255, 255, 255), // 폰트 크기
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => const AuthScreen(
                          isLogin: true,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color.fromARGB(255, 255, 255, 255), // 배경 색상
                    fixedSize: const Size(147, 73), // 버튼의 너비와 높이
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0), // 모서리의 둥근 정도
                    ),
                  ),
                  child: const Text(
                    'Sign in',
                    style: TextStyle(
                      fontSize: 19, fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 0, 0, 0), // 폰트 크기
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
