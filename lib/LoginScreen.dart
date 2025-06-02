import 'Layout.dart';
import 'package:flutter/material.dart';
import 'TestHashing.dart';
import 'package:http/http.dart' as http;
import 'models/User.dart';
import 'models/MyCrypto.dart';
import 'dart:convert';
import 'RegisterScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Trangthai_LoginScreen();
  }
}

class Trangthai_LoginScreen extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String errorMessage = '';

  late Future<List<User>> lstusers;

  Future<List<User>> LayDsUsertuBackend() async {
    final response = await http
        .get(Uri.parse('https://6731c05f7aaf2a9aff11dd05.mockapi.io/users'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => User.fromJsonMock(item)).toList();
    } else {
      throw Exception('Không đọc được danh sách người dùng từ backend');
    }
  }

  @override
  void initState() {
    super.initState();
    lstusers = LayDsUsertuBackend();
  }

  void Dangnhap() async {
    String username = usernameController.text.trim();
    String password = MyCrypto.hashText(passwordController.text.trim());

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = "Vui lòng nhập đầy đủ thông tin đăng nhập";
      });
      return;
    }

    try {
      List<User> users = await lstusers;
      User? foundUser = users.firstWhere(
        (user) => user.name == username && user.password == password,
        orElse: () => User(name: "", password: ""),
      );

      if (foundUser.name.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Layout()),
        );
      } else {
        setState(() {
          errorMessage = "Tên đăng nhập hoặc mật khẩu không chính xác";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Lỗi kết nối đến máy chủ. Vui lòng thử lại sau";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
          title: Center(
        child: Text("ĐĂNG NHẬP HỆ THỐNG",
            style: TextStyle(
                color: Colors.deepOrange, fontWeight: FontWeight.bold)),
      )),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              "https://cdn.pixabay.com/photo/2019/08/30/15/48/lock-4441691_1280.png",
              width: 180,
            ),
            SizedBox(height: 20),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(hintText: "Tên đăng nhập"),
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(hintText: "Mật khẩu"),
              style: TextStyle(fontSize: 20),
              obscureText: true,
            ),
            if (errorMessage.isNotEmpty)
              Text(errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: 18)),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: Dangnhap,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Đăng nhập", style: TextStyle(fontSize: 20)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff9fd59f),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: Text("Chưa có tài khoản. Hãy đăng ký",
                    style: TextStyle(color: Colors.deepOrange, fontSize: 18))),
            SizedBox(height: 20),
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TestHashing()),
                  );
                },
                child: Text("Test hàm băm",
                    style: TextStyle(color: Color(0xffd22289), fontSize: 18)))
          ],
        ),
      ),
    );
  }
}
