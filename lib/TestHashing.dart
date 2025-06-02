import 'package:flutter/material.dart';
import 'models/MyCrypto.dart';

class TestHashing extends StatelessWidget {
  TextEditingController txt1 = TextEditingController();
  TextEditingController txt2 = TextEditingController();

  void HashingString() {
    String str = txt1.text;
    String hash_string = MyCrypto.hashText(str);
    txt2.text = hash_string;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
          title: Center(
        child: Text("TEST HÀM BĂM",
            style: TextStyle(
                color: Colors.deepOrange, fontWeight: FontWeight.bold)),
      )),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0lXN5gLRidvkY6r1H4osOSjjY0lz8AnTTtJK41tC9d1_HCKzzZefElAS1Xd9YXj1BjkU&usqp=CAU",
              width: 150,
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: txt1,
              decoration: InputDecoration(hintText: "Nhập chuỗi để băm"),
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: txt2,
              decoration: InputDecoration(hintText: "Giá trị băm"),
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: HashingString,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Hàm băm", style: TextStyle(fontSize: 20)),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            )
          ],
        ),
      ),
    );
  }
}
