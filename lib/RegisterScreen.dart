import 'package:flutter/material.dart';
import 'models/User.dart';
import 'models/MyCrypto.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'LoginScreen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = '';

  Future<void> register() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = 'Vui lòng điền đầy đủ thông tin';
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://6731c05f7aaf2a9aff11dd05.mockapi.io/users'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': MyCrypto.hashText(password),
        }),
      );

      if (response.statusCode == 201) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        setState(() {
          errorMessage = 'Đăng ký thất bại. Vui lòng thử lại!';
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Lỗi kết nối. Vui lòng kiểm tra lại mạng!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(
        child: Text('ĐĂNG KÝ',
            style: TextStyle(
                color: Colors.deepOrange, fontWeight: FontWeight.bold)),
      )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(
                "https://atpsoftware.vn/wp-content/uploads/2020/02/Nh%E1%BA%ADn-bi%E1%BA%BFt-Register-l%C3%A0-g%C3%AC.jpg",
                width: 200),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Tên'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            if (errorMessage.isNotEmpty)
              Text(errorMessage, style: TextStyle(color: Colors.red)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: register,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text('Đăng ký'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffd5b79f),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
