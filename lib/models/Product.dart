class Product {
  int id;
  String? title;
  String? description;
  String? category;
  String? image;
  double price;
  int? size;

  Product({
    this.id = 0,
    this.title,
    this.description,
    this.category,
    this.image,
    this.price = 0,
    this.size,
  });

  factory Product.fromJsonMock(Map<String, dynamic> json) {
    return Product(
      id: int.tryParse(json['id']?.toString() ?? "0") ?? 0,
      title: json['title'] ?? "",
      description: json['description'] ?? "",
      category: json['category'] ?? "",
      image: json['image'] ?? "",
      price: (json['price'] ?? 0).toDouble(),
      size:
          json['size'] != null ? int.tryParse(json['size'].toString()) ?? 0 : 0,
    );
  }

  Map<String, dynamic> toJsonMock() {
    return {
      'id': id.toString(),
      'title': title,
      'description': description,
      'category': category,
      'image': image,
      'price': price,
      'size': size?.toString() ?? "0",
    };
  }

  //----------------------------
//
  factory Product.fromFireBase(Map<String, dynamic> json) {
    final fields = json['fields'] as Map<String, dynamic>;

    return Product(
      id: int.tryParse(fields['id']?['integerValue']?.toString() ?? '0') ?? 0,
      title: fields['title']?['stringValue'] ?? '',
      description: fields['description']?['stringValue'] ?? '',
      category: fields['category']?['stringValue'] ?? '',
      image: fields['image']?['stringValue'] ?? '',
      price: double.tryParse(fields['price']?['doubleValue']?.toString() ??
              fields['price']?['integerValue']?.toString() ??
              fields['price']?['stringValue']?.toString() ??
              '0') ??
          0.0,
      size: fields['size']?['integerValue'] != null
          ? int.tryParse(fields['size']!['integerValue'].toString()) ?? 0
          : null,
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      "fields": {
        "id": {"integerValue": id},
        "title": {"stringValue": title},
        "description": {"stringValue": description},
        "category": {"stringValue": category ?? ""},
        "image": {"stringValue": image},
        "price": {"stringValue": price.toString()},
        if (size != null) "size": {"integerValue": size},
      }
    };
  }
}

//-------------------
List<Product> products = [
  Product(
    title: "Office Code",
    id: 1,
    price: 234,
    size: 12,
    description: dummyText,
    image:
        "https://viethuongcollectionusa.com/cdn/shop/files/F6131A28-2CE2-4CE9-9135-E839E58EB4B2.jpg?v=1741225567&width=823",
  ),
  Product(
    id: 2,
    title: "Belt Bag",
    price: 234,
    size: 8,
    description: dummyText,
    image:
        "https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg",
  ),
];

String dummyText = "Đây là sản phẩm tuyệt vời. Không thể tin được";
