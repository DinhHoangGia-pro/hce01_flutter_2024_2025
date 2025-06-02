import 'package:flutter/material.dart';
import 'models/Product.dart';
import 'ProductDetails.dart';
import 'models/Cart.dart';
import 'CartScreen.dart';
import 'Global.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xfff1cee6),
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetails(product: product),
                    ));
              },
              child: Image.network(
                product.image ?? "",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error, color: Colors.red);
                },
              ),
            ),
          ),
          ListTile(
            title: Center(
              child: Text(
                Global.vifont(product.title ?? ""),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            subtitle: Center(
              child: Text(
                (product.price ?? 0.0).toStringAsFixed(2),
                style: TextStyle(color: Colors.red),
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart_outlined),
              onPressed: () {
                Cart.addToCart(product);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('${product.title} đã được thêm vào giỏ hàng'),
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
            ),
          )
        ],
      ),
    );
  }
}
