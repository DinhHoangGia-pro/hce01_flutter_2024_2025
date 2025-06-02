import 'package:flutter/material.dart';
import 'models/Product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ProductDetails.dart';
import 'models/Cart.dart';
import 'CartScreen.dart';

class ListProductsFirebase extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TrangthaiListProductFirebase();
  }
}

class TrangthaiListProductFirebase extends State<ListProductsFirebase> {
  late Future<List<Product>> lstproducts;
  /*Khai báo lstproducts sử dụng trong tương lai*/

  Future<List<Product>> LayDssanphamtuBackend() async {
    final response = await http.get(Uri.parse(
        'https://firestore.googleapis.com/v1/projects/hce01-b7830/databases/(default)/documents/products?key=AIzaSyBYJVBy1wbcM0RxOvXLlZE1ESNAEYXuqRk'));

    if (response.statusCode == 200) {
      // Chuyển đổi JSON response thành Map
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Lấy danh sách sản phẩm từ key 'documents'
      List<dynamic> jsonData = jsonResponse['documents'] ?? [];

      // Kiểm tra dữ liệu trước khi ánh xạ
      return jsonData
          .where((item) =>
              item is Map<String, dynamic>) // Đảm bảo đúng kiểu dữ liệu
          .map((item) => Product.fromFireBase(item))
          .toList();
    } else {
      throw Exception('Không đọc được sản phẩm từ backend');
    }
  }

  @override
  void initState() {
    super.initState();
    lstproducts = LayDssanphamtuBackend();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
          title: Text("Danh sách sản phẩm Firebase",
              style: TextStyle(
                  fontFamily: 'Pattaya',
                  color: Colors.deepOrange,
                  fontSize: 20,
                  fontWeight: FontWeight.bold))),
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
            return Container(
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Color(0xffcf83a9),
              ),
              child: GridView.builder(
                  itemCount: lst.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Số cột là 2
                    childAspectRatio: 0.75, // Tỷ lệ chiều cao / chiều rộng
                    crossAxisSpacing: 10.0, // Khoảng cách giữa các cột
                    mainAxisSpacing: 10.0, // Khoảng cách giữa các hàng
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    Product product = lst[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 5.0, // Hiệu ứng đổ bóng cho sản phẩm
                      child: Column(
                        children: [
                          //Vung cua anh
                          //

                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Hero(
                                tag: "${lst[index].id}",
                                child: GestureDetector(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => ProductDetails(
                                                product: lst[index]))),
                                    child: Image.network(
                                      lst[index].image.toString(),
                                      fit: BoxFit
                                          .cover, // Đảm bảo hình ảnh phủ kín vùng
                                    )),
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              lst[index].title.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow
                                  .ellipsis, // Cắt bớt text nếu quá dài
                            ),
                            subtitle: Text(
                              "\$${lst[index].price.toString()}",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.shopping_cart_outlined),
                              onPressed: () {
                                Cart.addToCart(product);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                      '${product.title} đã được thêm vào giỏ hàng'),
                                  duration: Duration(seconds: 2),
                                  action: SnackBarAction(
                                    label: "Xem giỏ hàng",
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => CartScreen(),
                                          ));
                                    },
                                  ),
                                ));
                              },
                            ), // Biểu tượng giỏ hàng
                          ),
                        ],
                      ),
                    );
                  }),
            );
          }
        },
      ),
    );
  }
}
