import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:readbook_hr/screens/select.dart';
import 'package:http/http.dart' as http;

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

// 정보 가져오기
  Future<void> _fetchUserData() async {
    const String apiUrl = 'http://152.69.225.60/myinfo';
    try {
      final userId = 1;
      final response = await http.get(Uri.parse(apiUrl), headers: {
        "Content-Type": "application/json",
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
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

//수정 후 저장
  Future<void> _saveProfile() async {
    String apiUrl =
        'http://152.69.225.60/updateNick'; // Replace with your API URL

    Map<String, String> requestBody = {
      'email': _emailController.text,
      'password': _passwordController.text,
      'name': _nameController.text,
    };

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      // Handle success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('수정완료하였습니다.')),
      );
    } else {
      // Handle failure
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('실패하였습니다.')),
      );
    }
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
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
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
            Text('password',
                style: TextStyle(color: Colors.grey[600], fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
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
              onPressed: () {
                // Implement save functionality
              },
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
