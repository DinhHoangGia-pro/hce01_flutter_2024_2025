import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Layout.dart';
import 'RegisterScreenFB.dart';
import 'TestHashing.dart';

class LoginScreenFB extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TrangThaiLoginScreenFB();
  }
}

class _TrangThaiLoginScreenFB extends State<LoginScreenFB> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String errorMessage = '';
  bool isLoading = false;

  void dangNhap() async {
    String email = usernameController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = "Vui lòng nhập đầy đủ thông tin đăng nhập";
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Đăng nhập thành công
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Layout()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'user-not-found') {
          errorMessage = 'Người dùng không tồn tại';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Mật khẩu không chính xác';
        } else {
          errorMessage = 'Lỗi: ${e.message}';
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Lỗi không xác định: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "ĐĂNG NHẬP HỆ THỐNG",
            style: TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
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
                decoration: InputDecoration(hintText: "Email đăng nhập"),
                style: TextStyle(fontSize: 20),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(hintText: "Mật khẩu"),
                style: TextStyle(fontSize: 20),
                obscureText: true,
              ),
              if (errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  ),
                ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: isLoading ? null : dangNhap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff9fd59f),
                  padding: const EdgeInsets.all(12),
                  textStyle: TextStyle(fontSize: 20),
                ),
                child: isLoading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text("Đăng nhập"),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreenFB()),
                  );
                },
                child: Text(
                  "Chưa có tài khoản. Hãy đăng ký",
                  style: TextStyle(color: Colors.deepOrange, fontSize: 18),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TestHashing()),
                  );
                },
                child: Text(
                  "Test hàm băm",
                  style: TextStyle(color: Color(0xffd22289), fontSize: 18),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
