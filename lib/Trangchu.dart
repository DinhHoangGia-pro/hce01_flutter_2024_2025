import 'package:flutter/material.dart';
import 'ListSanpham.dart';

class Trangchu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Trangthai_trangchu();
  }
}

class Trangthai_trangchu extends State<Trangchu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Trang chủ")),
      body: Column(
        children: [
          Text("Trình bày slide sản phẩm dạng hình ảnh chạy"),
          Text("Trình bày category"),
          Expanded(
              child:
                  ListSanpham()), // Đặt vào Expanded để tránh lỗi tràn màn hình
        ],
      ),
    );
  }
}
