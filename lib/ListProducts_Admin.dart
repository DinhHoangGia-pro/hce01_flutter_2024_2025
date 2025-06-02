import 'models/Product.dart';
import 'package:flutter/material.dart';
import 'ProductEdit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Global.dart';

class ListProducts_Admin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Trangthai_ListProducts_Admin();
  }
}

class Trangthai_ListProducts_Admin extends State<ListProducts_Admin> {
  late Future<List<Product>> lstproducts;
  Product newproduct = Product();

  Future<List<Product>> LayDssanphamtuBackend() async {
    final response =
        await http.get(Uri.parse(Global.URL_products + '/products'));

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

  void _confirmDelete(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Xác nhận xóa"),
          content: Text(
              "Bạn có chắc chắn muốn xóa sản phẩm '${product.title}' không?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text("Hủy", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Đóng hộp thoại
                await _deleteProduct(product);
              },
              child: Text("Có", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteProduct(Product product) async {
    print("Đang xóa sản phẩm có ID: ${product.id}");
    final response = await http.delete(
      Uri.parse(Global.URL_products + '/products/' + product.id.toString()),
    );

    print("Mã trạng thái HTTP: ${response.statusCode}");
    print("Phản hồi từ server: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        lstproducts = LayDssanphamtuBackend(); // Cập nhật danh sách sau khi xóa
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đã xóa sản phẩm thành công")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Lỗi khi xóa sản phẩm:" +
                response.statusCode.toString() +
                "," +
                product.id.toString())),
      );
    }
  }

  Future<void> SaveProduct(Product p) async {
    if (p.id == 0) {
      // Trường hợp thêm mới sản phẩm
      final response = await http.post(
        Uri.parse(Global.URL_products + '/products'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(p.toJsonMock()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          lstproducts =
              LayDssanphamtuBackend(); // Cập nhật danh sách sau khi thêm mới
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Thêm sản phẩm thành công")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Lỗi khi thêm sản phẩm: ${response.statusCode}")),
        );
      }
    } else {
      // Trường hợp cập nhật sản phẩm
      final response = await http.put(
        Uri.parse(Global.URL_products + '/products/${p.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(p.toJsonMock()),
      );

      if (response.statusCode == 200) {
        setState(() {
          lstproducts =
              LayDssanphamtuBackend(); // Cập nhật danh sách sau khi chỉnh sửa
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Cập nhật sản phẩm thành công")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text("Lỗi khi cập nhật sản phẩm: ${response.statusCode}")),
        );
      }
    }
  }

  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: AppBar(title: Text("QUẢN TRỊ SẢN PHẨM")),
      body: FutureBuilder<List<Product>>(
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
              return ListView.builder(
                itemCount: lst.length,
                itemBuilder: (context, index) {
                  final product = lst[index];
                  return Card(
                    color: Color(0xfff5f8e7),
                    child: ListTile(
                      leading: Image.network(
                        product.image ?? "",
                        width: 50,
                        height: 50,
                      ),
                      title: Text(
                        Global.vifont(product.title ?? ""),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        (product.price ?? 0).toStringAsFixed(2),
                        style: TextStyle(color: Colors.redAccent),
                      ),
                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductEdit(
                                          product: newproduct,
                                          onSave: SaveProduct,
                                        )),
                              );
                            },
                            icon: Icon(Icons.add)),
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductEdit(
                                          product: product,
                                          onSave: SaveProduct,
                                        )),
                              );
                            },
                            icon: Icon(Icons.edit)),
                        IconButton(
                            onPressed: () {
                              _confirmDelete(context, product);
                            },
                            icon: Icon(Icons.delete))
                      ]),
                    ),
                  );
                },
              );
            }
          }),
    );
  }
}
