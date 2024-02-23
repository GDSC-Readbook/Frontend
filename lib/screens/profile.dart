import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  String? _email; // Nullable이 아닌 필드로 변경

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // 정보 가져오기
  Future<void> _fetchUserData() async {
    const String apiUrl = 'https://152.69.225.60/myinfo';
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
        if (data.containsKey('email') && data['email'] is String) {
          _email = data['email'];
        } else {
          _email = ''; // 기본값 설정
        }
        setState(() {
          _nameController.text = data['name'] ?? '';
        });
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print(e);
      _showErrorDialog('Failed to fetch user data.');
    }
  }

  // 수정 후 저장
  Future<void> _saveProfile() async {
    if (_newPasswordController.text.isNotEmpty &&
        _newPasswordController.text != _confirmNewPasswordController.text) {
      _showErrorDialog('The new passwords do not match.');
      return;
    }

    String apiUrl = 'https://152.69.225.60/updatemyinfo';
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    Map<String, String> requestBody = {
      'email': _email ?? '', // Null일 경우 빈 문자열 전달
      'name': _nameController.text,
      'password': _newPasswordController.text,
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        _showSuccessDialog(); // 성공 모달 표시
      } else {
        _showErrorDialog(
            'Failed to update profile. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
      _showErrorDialog('Error occurred while updating profile.');
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
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              readOnly: true,
              initialValue: _email ?? '', // Nullable 아닌 필드이므로 null 체크 없이 사용 가능
              decoration: InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _newPasswordController,
              decoration: InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _confirmNewPasswordController,
              decoration: InputDecoration(labelText: 'Confirm New Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile, // 프로필 저장 기능 연결
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
