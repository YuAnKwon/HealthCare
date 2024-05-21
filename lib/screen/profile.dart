import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:healthcare/network/ApiResource.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'main_screen.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '사용자 기본 정보 입력',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('사용자 기본 정보 입력'),
          centerTitle: true,
        ),
        body: UserInfoForm(),
      ),
    );
  }
}

class UserInfoForm extends StatefulWidget {
  @override
  _UserInfoFormState createState() => _UserInfoFormState();
}

class _UserInfoFormState extends State<UserInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  Future<void> _saveUserInfo() async {
    if (_formKey.currentState?.validate() == true) {
      final name = _nameController.text;
      final age = int.tryParse(_ageController.text);
      final height = double.tryParse(_heightController.text);
      final weight = double.tryParse(_weightController.text);

      if (age == null || height == null || weight == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('나이, 키, 체중은 숫자여야 합니다.')),
        );
        return;
      }

      try {
        final response = await http.post(
          Uri.parse('${ApiResource.serverUrl}/profile'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': name,
            'age': age,
            'height': height,
            'init_weight': weight,
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('기본정보를 전송했습니다.')),
          );
          // prefs에 기본정보 송신여부 저장.
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('hasProfile', true);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HealthInfoPage()),
          );

        } else {
          print( response.body);
          _showErrorDialog('Error: ${response.statusCode}', response.body);
        }

      } catch (e) {
        _showErrorDialog('Network Error', '서버에 연결할 수 없습니다.');
      }
    }
  }

  void _showErrorDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    return SingleChildScrollView(
      reverse: true,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InputBox(
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: '이름:', border: InputBorder.none),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '이름을 입력해주세요.';
                      }
                      if (double.tryParse(value) != null || int.tryParse(value) != null) {
                        return '이름을 올바르게 입력해주세요.';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                InputBox(
                  child: TextFormField(
                    controller: _ageController,
                    decoration: const InputDecoration(labelText: '나이:', border: InputBorder.none),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '나이를 입력해주세요.';
                      }
                      if (int.tryParse(value) == null) {
                        return '숫자를 입력해주세요.';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                InputBox(
                  child: TextFormField(
                    controller: _heightController,
                    decoration: const InputDecoration(labelText: '키 (cm):', border: InputBorder.none),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '키를 입력해주세요.';
                      }
                      if (double.tryParse(value) == null) {
                        return '숫자를 입력해주세요.';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                InputBox(
                  child: TextFormField(
                    controller: _weightController,
                    decoration: const InputDecoration(labelText: '체중 (kg):', border: InputBorder.none),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '체중을 입력해주세요.';
                      }
                      if (double.tryParse(value) == null) {
                        return '숫자를 입력해주세요.';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _saveUserInfo,
                    child: const Text('저장'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InputBox extends StatelessWidget {
  final Widget child;

  const InputBox({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(5),
      ),
      child: child,
    );
  }
}
