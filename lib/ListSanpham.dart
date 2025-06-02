import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/Product.dart';
import 'ProductDetails.dart';
import 'models/Cart.dart';
import 'CartScreen.dart';
import 'ProductCard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Global.dart';

class ListSanpham extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Trangthai_ListSanpham();
  }
}

class Trangthai_ListSanpham extends State<ListSanpham> {
  late Future<List<Product>> lstproducts;

  Future<List<Product>> LayDssanphamtuBackend() async {
    final response = await http
        .get(Uri.parse('https://6731c05f7aaf2a9aff11dd05.mockapi.io/products'));

    if (response.statusCode == 200) {
      // Chuyển đổi JSON sang danh sách các đối tượng Product

      List<dynamic> jsonData = json.decode(response.body);

      return jsonData.map((item) => Product.fromJsonMock(item)).toList();
    } else {
      throw Exception('Không đọc được sản phẩm từ backend');
    }
  }

  @override
  void initState() {
    super.initState();
    lstproducts = LayDssanphamtuBackend();
  }

  TextEditingController txttimkiem = TextEditingController();

  void Timkiemsanpham(String chuoitim) {
    setState(() {
      // lstproducts = products
      //     .where((x) =>
      //         x.title?.toLowerCase().contains(chuoitim.toLowerCase()) ?? false)
      //     .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
        future: lstproducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Lỗi:' + snapshot.error.toString()),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('Không có dữ liệu'),
            );
          } else {
            List<Product> lst = snapshot.data!;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: txttimkiem,
                    onChanged: Timkiemsanpham,
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm sản phẩm',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.all(5),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: lst.length,
                    itemBuilder: (context, index) {
                      Product product = lst[index];
                      return ProductCard(product: product);
                    },
                  ),
                ),
              ],
            );
          }
        });
  }
}
