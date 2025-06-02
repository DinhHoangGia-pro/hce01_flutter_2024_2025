import 'dart:convert';
import 'package:demo_hce1/AddProductFB.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/Product.dart';
import 'ProductEditFB.dart';
import 'AddProductFB.dart';

class ListProducts_AdminFB extends StatefulWidget {
  const ListProducts_AdminFB({super.key});

  @override
  State<ListProducts_AdminFB> createState() => _ListProducts_AdminFBState();
}

class _ListProducts_AdminFBState extends State<ListProducts_AdminFB> {
  List<Product> productList = [];
  List<String> docIds = [];

  final String baseUrl =
      "https://firestore.googleapis.com/v1/projects/hce01-b7830/databases/(default)/documents/products";
  final String apiKey = "AIzaSyBYJVBy1wbcM0RxOvXLlZE1ESNAEYXuqRk";

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final url = Uri.parse("$baseUrl?key=$apiKey");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final documents = data['documents'] as List<dynamic>;

      final loadedProducts = <Product>[];
      final loadedDocIds = <String>[];

      for (var doc in documents) {
        final fields = doc['fields'] as Map<String, dynamic>;
        final name = doc['name'] as String;
        final docId = name.split('/').last;

        loadedProducts.add(Product.fromFireBase({'fields': fields}));
        loadedDocIds.add(docId);
      }

      setState(() {
        productList = loadedProducts;
        docIds = loadedDocIds;
      });
    } else {
      print(
          "❌ Lỗi khi tải sản phẩm: ${response.statusCode} - ${response.body}");
    }
  }

  Future<void> deleteProduct(int index) async {
    final docId = docIds[index];
    final url = Uri.parse("$baseUrl/$docId?key=$apiKey");

    final response = await http.delete(url);

    if (response.statusCode == 200) {
      setState(() {
        productList.removeAt(index);
        docIds.removeAt(index);
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("🗑️ Đã xóa sản phẩm")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Lỗi xóa sản phẩm: ${response.body}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Danh sách sản phẩm (Firebase REST)")),
      body: ListView.builder(
        itemCount: productList.length,
        itemBuilder: (context, index) {
          final product = productList[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: Image.network(product.image ?? "",
                  width: 60,
                  height: 60,
                  errorBuilder: (_, __, ___) => const Icon(Icons.image)),
              title: Text(product.title ?? ""),
              subtitle: Text(
                  "Giá: ${product.price.toString()}đ\nSize: ${product.size ?? 'N/A'}"),
              isThreeLine: true,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductEditFB(
                            product: product,
                            docId: docIds[index],
                          ),
                        ),
                      );
                      fetchProducts(); // Tải lại sau khi chỉnh sửa
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteProduct(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductFB()),
          );
          fetchProducts(); // Tải lại danh sách sau khi thêm
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
