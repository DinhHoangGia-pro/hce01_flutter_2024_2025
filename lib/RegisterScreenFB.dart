import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'LoginScreenFB.dart';

class RegisterScreenFB extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TrangThaiRegisterScreenFB();
  }
}

class _TrangThaiRegisterScreenFB extends State<RegisterScreenFB> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String errorMessage = '';
  bool isLoading = false;

  void dangKy() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        errorMessage = "Vui lòng nhập đầy đủ thông tin";
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        errorMessage = "Mật khẩu không khớp";
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Đăng ký thành công → quay về màn hình đăng nhập
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreenFB()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'email-already-in-use') {
          errorMessage = 'Email đã được sử dụng';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'Email không hợp lệ';
        } else if (e.code == 'weak-password') {
          errorMessage = 'Mật khẩu quá yếu (ít nhất 6 ký tự)';
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
            "ĐĂNG KÝ TÀI KHOẢN",
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
              Icon(Icons.person_add_alt_1, size: 120, color: Colors.deepOrange),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(hintText: "Email"),
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
              SizedBox(height: 20),
              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(hintText: "Nhập lại mật khẩu"),
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
                onPressed: isLoading ? null : dangKy,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff9fd59f),
                  padding: const EdgeInsets.all(12),
                  textStyle: TextStyle(fontSize: 20),
                ),
                child: isLoading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text("Đăng ký"),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreenFB()),
                  );
                },
                child: Text(
                  "Đã có tài khoản? Đăng nhập",
                  style: TextStyle(color: Colors.deepOrange, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
