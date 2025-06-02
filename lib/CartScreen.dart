import 'package:flutter/material.dart';
import 'models/Product.dart';
import 'models/CartItem.dart';
import 'models/Cart.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giỏ của bạn'),
      ),
      body: Cart.giohang.isEmpty
          ? Center(
              child: Text('Giỏ hàng của bạn trống'),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: Cart.giohang.length,
                    itemBuilder: (context, index) {
                      CartItem item = Cart.giohang[index];
                      Product product = item.product;

                      return ListTile(
                        leading: Image.network(
                          product.image ?? 'assets/default_image.png',
                          width: 50,
                          height: 50,
                        ),
                        title: Text(product.title ?? 'No Title'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("\$${product.price}"),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                    setState(() {
                                      if (item.soluong > 1) {
                                        item.soluong--;
                                      } else {
                                        Cart.removeFromCart(product.id);
                                      }
                                    });
                                  },
                                ),
                                Text('${item.soluong}'), // Hiển thị số lượng
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    setState(() {
                                      item.soluong++;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              Cart.removeFromCart(product.id);
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('${product.title} Đã Xóa Khỏi Giỏ'),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: \$${Cart.Tongtien().toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Xử lý khi nhấn nút thanh toán
                          print("Thanh Toán Thành Công");
                        },
                        child: Text('Thanh toán'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
