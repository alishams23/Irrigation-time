// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, avoid_print, use_build_context_synchronously, prefer_const_constructors, deprecated_member_use, sort_child_properties_last
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_sort/main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isCodeSent = false;
  bool _isCodeExpired = false;

  String _errorMessage = '';
  Timer? _timer;
  int _start = 120; // 2 minutes timer

  Future<void> _login() async {
    setState(() {
      _errorMessage = '';
    });

    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _isLoading = true;
        });
        final response = await http.post(
          Uri.parse('http://37.152.190.222/api/account/login-sms/'),
          body: {'number': _phoneController.text},
        );

        if (response.statusCode == 200) {
          setState(() {
            _isLoading = false;
            _isCodeSent = true;
          });
          startTimer(); // Start the timer when the code is sent
        } else {
          final responseBody = json.decode(response.body);
          setState(() {
            _errorMessage = responseBody['error'] ?? 'Login failed';
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'An error occurred: $e';
        });
        print(_errorMessage);
      }
    }
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            _isCodeExpired = true;
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void _verifyCode() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse('http://37.152.190.222/api/account/code_check/'),
      body: {
        'number': _phoneController.text,
        'code': _codeController.text,
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      final responseBody = json.decode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print(responseBody);
      await prefs.setString('token', responseBody['token']);
      await prefs.setString('username', responseBody['username']);
      await prefs.setString('status', responseBody['status']);
      // Navigate to HomePage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'کد اشتباه است';
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ورود'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (!_isCodeSent) ...[
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'شماره تلفن',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'لطفا شماره تلفن خود را وارد کنید';
                          } else if (value.length != 11) {
                            return 'شماره تلفن باید 11 رقم باشد';
                          } else if (!value.startsWith('09')) {
                            return 'شماره تلفن باید با ...09 شروع شود';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      _isLoading
                          ? ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Color.fromARGB(255, 121, 91, 2),
                                ),
                                foregroundColor: MaterialStateProperty.all(
                                  Colors.white,
                                ),
                                padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                ),
                              ),
                              onPressed: () {},
                              child: SizedBox(
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                ),
                                height: 15,
                                width: 15,
                              ),
                            )
                          : ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Color.fromARGB(255, 121, 91, 2),
                                ),
                                foregroundColor: MaterialStateProperty.all(
                                  Colors.white,
                                ),
                                padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                ),
                              ),
                              onPressed: () {
                                if (!_isLoading) {
                                  _login();
                                }
                              },
                              child: Text('دریافت کد'),
                            ),
                      if (_errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            _errorMessage,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
              if (_isCodeSent) ...[
                TextField(
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'کد پیامک شده',
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _isCodeSent = false;
                          _isCodeExpired = false;
                          _timer?.cancel();
                          _start = 120; // Reset timer
                        });
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        ),
                        side: MaterialStateProperty.all(
                          BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Text(
                        'برگشت',
                        style: TextStyle(color: Colors.grey.shade300),
                      ),
                    ),
                    SizedBox(width: 10),
                    if (!_isCodeExpired)
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 121, 91, 2),
                          ),
                          foregroundColor: MaterialStateProperty.all(
                            Colors.white,
                          ),
                          padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          ),
                        ),
                        onPressed: _verifyCode,
                        child: Text('تایید کد'),
                      ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  textDirection: TextDirection.rtl,
                  _isCodeExpired ? 'کد منقضی شده است' : '$_start ثانیه باقی مانده ',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
