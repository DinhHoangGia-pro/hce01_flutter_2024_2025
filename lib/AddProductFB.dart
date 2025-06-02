import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/Product.dart';

class AddProductFB extends StatefulWidget {
  const AddProductFB({super.key});

  @override
  State<AddProductFB> createState() => _AddProductFBState();
}

class _AddProductFBState extends State<AddProductFB> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageController = TextEditingController();
  final _priceController = TextEditingController();
  final _sizeController = TextEditingController();

  final String baseUrl =
      "https://firestore.googleapis.com/v1/projects/hce01-b7830/databases/(default)/documents/products";
  final String apiKey = "AIzaSyBYJVBy1wbcM0RxOvXLlZE1ESNAEYXuqRk";

  Future<void> addProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final product = Product(
      title: _titleController.text,
      description: _descriptionController.text,
      image: _imageController.text,
      price: double.tryParse(_priceController.text) ?? 0,
      size: int.tryParse(_sizeController.text),
      id: DateTime.now().millisecondsSinceEpoch,
    );

    final response = await http.post(
      Uri.parse("$baseUrl?key=$apiKey"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(product.toFirebase()),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("✅ Đã thêm sản phẩm")));
      Navigator.pop(context);
    } else {
      print("❌ Lỗi khi thêm sản phẩm: ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("❌ Thêm sản phẩm thất bại: ${response.body}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thêm sản phẩm mới")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Tên sản phẩm"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Nhập tên sản phẩm" : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Mô tả"),
              ),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: "URL hình ảnh"),
              ),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Giá"),
              ),
              TextFormField(
                controller: _sizeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Size"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: addProduct,
                child: const Text("➕ Thêm sản phẩm"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
