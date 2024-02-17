import 'dart:convert';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:readbook_hr/screens/auth.dart';
import 'package:readbook_hr/screens/select.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // 정보 가져오기
  Future<void> _fetchUserData() async {
    const String apiUrl = 'http://152.69.225.60/myinfo';
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _nameController.text = data['name'];
          _emailController.text = data['email'];
        });
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print(e);
    }
  }

  // 수정 후 저장
  Future<void> _saveProfile() async {
    String apiUrl = 'http://152.69.225.60/updatemyinfo';
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    Map<String, String> requestBody = {
      'name': _nameController.text,
      'email': _emailController.text,
      'password': _newPasswordController.text,
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // 토큰 사용
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        _showSuccessDialog(); // 성공 모달 표시
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile')),
        );
      }
    } catch (e) {
      print('Error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error occurred while updating profile')),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Profile Updated'),
        content: const Text('Your profile has been updated successfully.'),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop(); // 모달 닫기
              _logout(); // 로그아웃 함수 호출
            },
          ),
        ],
      ),
    );
  }

  void _logout() async {
    // SharedPreferences에서 토큰 제거
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    // 로그인 화면으로 이동
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => AuthScreen(
                isLogin: true,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'My Profile',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // SelectScreen으로 이동
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const SelectScreen()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: ListView(
          children: [
            Text('name',
                style: TextStyle(color: Colors.grey[600], fontSize: 16)),
            SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey[200],
                filled: true,
              ),
            ),
            const SizedBox(height: 20),
            Text('email',
                style: TextStyle(color: Colors.grey[600], fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              readOnly: true, // 읽기전용으로 , 수정불가
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                fillColor: Color.fromARGB(255, 206, 206, 206),
                filled: true,
              ),
            ),
            const SizedBox(height: 20),
            Text('new password',
                style: TextStyle(color: Colors.grey[600], fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey[200],
                filled: true,
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            Text('confirm new password',
                style: TextStyle(color: Colors.grey[600], fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _confirmNewPasswordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey[200],
                filled: true,
              ),
              obscureText: true,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _saveProfile, // 프로필 저장 기능 연결
              child: Text('저장', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                onPrimary: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {},
              child: Text('logout', style: TextStyle(fontSize: 16)),
              style: TextButton.styleFrom(
                primary: Colors.red,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const ButtonBar(),
    );
  }
}
