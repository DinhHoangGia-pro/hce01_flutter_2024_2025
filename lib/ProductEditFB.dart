import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/Product.dart';

class ProductEditFB extends StatefulWidget {
  final Product product;
  final String docId;

  const ProductEditFB({super.key, required this.product, required this.docId});

  @override
  State<ProductEditFB> createState() => _ProductEditFBState();
}

class _ProductEditFBState extends State<ProductEditFB> {
  late TextEditingController titleCtrl;
  late TextEditingController priceCtrl;
  late TextEditingController imageCtrl;
  late TextEditingController descCtrl;
  late TextEditingController sizeCtrl;
  late TextEditingController categoryCtrl;

  final String baseUrl =
      "https://firestore.googleapis.com/v1/projects/hce01-b7830/databases/(default)/documents/products";
  final String apiKey = "AIzaSyBYJVBy1wbcM0RxOvXLlZE1ESNAEYXuqRk";

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.product.title);
    priceCtrl = TextEditingController(text: widget.product.price.toString());
    imageCtrl = TextEditingController(text: widget.product.image);
    descCtrl = TextEditingController(text: widget.product.description);
    sizeCtrl =
        TextEditingController(text: widget.product.size?.toString() ?? "");
    categoryCtrl = TextEditingController(text: widget.product.category ?? "");
  }

  Future<void> updateProduct() async {
    final updatedProduct = Product(
      id: widget.product.id,
      title: titleCtrl.text,
      description: descCtrl.text,
      category: categoryCtrl.text,
      image: imageCtrl.text,
      price: double.tryParse(priceCtrl.text) ?? 0.0,
      size: int.tryParse(sizeCtrl.text),
    );

    final url = Uri.parse('$baseUrl/${widget.docId}?key=$apiKey');

    final response = await http.patch(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(updatedProduct.toFirebase()),
    );

    if (response.statusCode == 200) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Đã cập nhật sản phẩm")));
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Lỗi cập nhật: ${response.body}")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chỉnh sửa sản phẩm")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView(
          children: [
            TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: "Tên sản phẩm")),
            TextField(
                controller: priceCtrl,
                decoration: const InputDecoration(labelText: "Giá"),
                keyboardType: TextInputType.number),
            TextField(
                controller: imageCtrl,
                decoration: const InputDecoration(labelText: "URL hình ảnh")),
            TextField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: "Mô tả")),
            TextField(
                controller: sizeCtrl,
                decoration: const InputDecoration(labelText: "Kích thước")),
            TextField(
                controller: categoryCtrl,
                decoration: const InputDecoration(labelText: "Danh mục")),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: updateProduct, child: const Text("Lưu thay đổi")),
          ],
        ),
      ),
    );
  }
}
