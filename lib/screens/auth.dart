import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:readbook_hr/screens/select.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.isLogin});
  final bool isLogin;

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  late bool _isLogin;
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _isAuthenticating = false;
  var _enteredUsername = '';

  Future<void> _submit() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return; // 유효성 검사 실패 시 리턴
    }

    _form.currentState!.save();

    setState(() {
      _isAuthenticating = true;
    });

    try {
      if (_isLogin) {
        // 로그인 로직
        final response = await http.post(
          Uri.parse('http://152.69.225.60/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': _enteredEmail,
            'password': _enteredPassword,
          }),
        );

        // 서버 응답 처리
        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          // 토큰 저장
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', responseData['token']);

          // 로그인 성공 로직 처리
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (ctx) => const SelectScreen()));
        } else {
          // 오류 처리: 서버에서 반환된 오류 메시지를 표시
          final responseData = json.decode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'] ?? 'Login failed')),
          );
        }
      } else {
        // 회원가입 로직
        final response = await http.post(
          Uri.parse('http://152.69.225.60/register'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': _enteredEmail,
            'password': _enteredPassword,
            'name':
                _enteredUsername, // User 클래스에 name 필드가 있으므로 username을 name으로 변경
          }),
        );

        // 서버 응답 처리
        if (response.statusCode == 200) {
          // 회원가입 성공 시
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration successful! Please log in.')),
          );
          setState(() {
            _isLogin = true; // 로그인 화면으로 전환
          });
        } else {
          // 회원가입 실패 시
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to register. Please try again.')),
          );
        }
      }
    } catch (error) {
      // 네트워크 오류 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again later.')),
      );
    } finally {
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _isLogin = widget.isLogin; // 여기에서 widget.isLogin 값을 _isLogin에 할당합니다.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _form,
                      child: Column(
                        //메인 축 크기 최소화 -> 기둥공간 최대 차지.
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Email Address'),
                            keyboardType: TextInputType.emailAddress,
                            //자동보정 끄기. 이메일 주소가 자동으로 수정되는 것을 막는다.
                            autocorrect: false,
                            //첫 글자가 대문자로 되는 것을 막는다. 최고의 코드.
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredEmail = value!;
                            },
                          ),
                          if (!_isLogin)
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Username'),
                              enableSuggestions: false,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().length < 4) {
                                  return 'Please enter at least 4 characters';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredUsername = value!;
                              },
                            ),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                            obscureText: true, //입력 시 문자열 자동 숨김 기능.
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'Password must be at least 6 characters long.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredPassword = value!;
                            },
                          ),

                          if (_isLogin)
                            const SizedBox(
                              height: 20,
                            ),
                          if (_isLogin)
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    // RecoveryScreen으로 넘어가는 로직을 여기에 추가하세요.
                                  },
                                  child: const Text('Recovery Password'),
                                ),
                              ],
                            ),
                          if (!_isLogin)
                            const SizedBox(
                              height: 20,
                            ),
                          if (_isAuthenticating)
                            const CircularProgressIndicator(),
                          if (!_isAuthenticating)
                            ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  fixedSize: const Size(325, 50)),
                              child: Text(
                                _isLogin ? 'Sign In' : 'Create Account',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                            ),
                          if (!_isAuthenticating)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Text(_isLogin
                                  ? 'Not A Member? Register Now'
                                  : 'Already have an account? Sign In'),
                            ),
                          //if (!_isAuthenticating && _isLogin)
                          //  TextButton(
                          //    onPressed: () {},
                          //    child: const Text(
                          //        'Are you lost your password? find password'),
                          //  ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 40),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Divider(thickness: 1),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text('Or'),
                                ),
                                Expanded(
                                  child: Divider(thickness: 1),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Image.asset('assets/images/googlelogo.png'),
                            iconSize: 30,
                            onPressed: () {
                              // 구글 로그인 로직을 여기에 추가하세요.
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
