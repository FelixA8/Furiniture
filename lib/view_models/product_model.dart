import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String productId;
  final String name;
  final String description;
  final int price;
  final String categoryId;
  final String shopId;
  final int stock;
  final String image;
  final String augmentedObject;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product(
      {required this.productId,
      required this.name,
      required this.description,
      required this.price,
      required this.categoryId,
      required this.shopId,
      required this.stock,
      required this.image,
      required this.augmentedObject,
      required this.createdAt,
      required this.updatedAt});

  // Factory method to create an Order object from JSON
  factory Product.fromJson(Map<String, dynamic> json, productId) {
    return Product(
      productId: productId,
      name: json['name'],
      description: json['description'],
      price: int.parse(json['price'].toString()),
      categoryId: json['category'],
      shopId: json['sellerId'],
      stock: int.parse(json['stock'].toString()),
      image: json['imageURL'],
      augmentedObject: json['augmentedURL'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  // Convert Order object to JSON
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': name,
      'description': description,
      'price': price,
      'categoryId': categoryId,
      'shopId': shopId,
      'stock': stock,
      'images': image,
      'augmentedObject': augmentedObject,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
