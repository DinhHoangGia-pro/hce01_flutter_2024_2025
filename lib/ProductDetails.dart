import 'package:flutter/material.dart';
import 'models/Product.dart';
import 'Global.dart';

class ProductDetails extends StatefulWidget {
  Product product;

  ProductDetails({Key? key, required this.product}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Trangthai_ProductDetails();
  }
}

class Trangthai_ProductDetails extends State<ProductDetails> {
  Product product1 = Product(image: '', title: "", description: '', size: 0);

  @override
  void initState() {
    super.initState();
    product1 = widget.product;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
          title: Text(product1.title ?? "Không có tiêu đề",
              style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 22,
                  fontFamily: 'Pattaya',
                  fontWeight: FontWeight.bold))),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Image.network(
                product1.image ?? "",
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(product1.title ?? "",
                  style: TextStyle(
                      fontFamily: 'Pattaya',
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
            ),
            Text(
              product1.description ?? "",
              style: TextStyle(fontFamily: 'Satisfy', fontSize: 18),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }
}
