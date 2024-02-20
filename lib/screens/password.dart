import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PasswordRecoveryScreen extends StatefulWidget {
  @override
  _PasswordRecoveryScreenState createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _recoverPassword() async {
    setState(() {
      _isLoading = true;
    });

    final String apiUrl = 'https://152.69.225.60/sendNewPassWord';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': _emailController.text}),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password recovery email sent successfully')),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to recover password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // 앱바 배경색을 하얀색으로 설정

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // 아이콘 색상을 검은색으로 설정
          onPressed: () => Navigator.of(context).pop(),
        ),
        iconTheme:const  IconThemeData(color: Colors.black), // 앱바 아이콘 테마를 검은색으로 설정
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Find Your Password',
              style: TextStyle(
                  color: Colors.black, fontSize: 25), // 제목 텍스트 색상을 검은색으로 설정
            ),
            const SizedBox(height: 30),
            const Text(
              'Enter your email address and we will send you a link to reset your password.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _recoverPassword,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Send your email'),
            ),
          ],
        ),
      ),
    );
  }
}
