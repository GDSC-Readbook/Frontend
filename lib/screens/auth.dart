import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:readbook_hr/screens/add_story.dart';
import 'package:readbook_hr/screens/password.dart';
import 'package:readbook_hr/screens/profile.dart';
import 'package:readbook_hr/screens/select.dart';
import 'package:readbook_hr/widgets/bottom.dart';

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

  @override
  void initState() {
    super.initState();
    _isLogin = widget.isLogin;
  }

  Future<void> _submit() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      print('Form is not valid');
      return;
    }

    _form.currentState!.save();

    setState(() {
      _isAuthenticating = true;
    });

    try {
      if (_isLogin) {
        print('Attempting to log in');
        final response = await http.post(
          Uri.parse('http://152.69.225.60/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': _enteredEmail,
            'password': _enteredPassword,
          }),
        );

        print('Login response status: ${response.statusCode}');
        if (response.statusCode == 200) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (ctx) => const DefaultTabController(
              length: 3,
              child: Scaffold(
                body: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    SelectScreen(),
                    AddStoryScreen(),
                    MyProfileScreen()
                  ],
                ),
                bottomNavigationBar: Bottom(),
              ),
            ),
          ));
        } else {
          // 로그인 실패 시 알림 표시
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed: ${response.statusCode}')),
          );
        }
      } else {
        print('Attempting to register');
        final response = await http.post(
          Uri.parse('http://152.69.225.60/register'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': _enteredEmail,
            'password': _enteredPassword,
            'name': _enteredUsername,
          }),
        );

        if (response.statusCode == 200) {
          print('Registration successful');
          setState(() {
            _isLogin = true;
          });
        } else {
          print('Registration failed with status code: ${response.statusCode}');
        }
      }
    } catch (error) {
      print('An error occurred: $error');
    } finally {
      setState(() {
        _isAuthenticating = false;
      });
    }
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
              const Text(
                'Readbook',
                style: TextStyle(
                  fontSize: 43,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(52, 168, 83, 1),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Card(
                color: const Color.fromARGB(176, 216, 253, 174),
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
                            autocorrect: false,
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
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              PasswordRecoveryScreen()),
                                    );
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
                                  backgroundColor:
                                      const Color.fromRGBO(52, 168, 83, 1),
                                  fixedSize: const Size(325, 50)),
                              child: Text(
                                _isLogin ? 'Sign In' : 'Create Account',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            ),
                          if (!_isAuthenticating)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Text(
                                _isLogin
                                    ? 'Not A Member? Register Now'
                                    : 'Already have an account? Sign In',
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 104, 104, 104)),
                              ),
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
