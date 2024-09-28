import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furiniture/view_models/product_item.dart';

class Person {
  final String uid;
  final String name;
  final String email;
  final String sellerId;
  final String phone;
  late final List<ProductItem> cart;
  final String address;
  final DateTime createdAt;
  final DateTime updatedAt;

  Person(
      {required this.uid,
      required this.name,
      required this.email,
      required this.sellerId,
      required this.phone,
      required this.cart,
      required this.address,
      required this.createdAt,
      required this.updatedAt});

  // Factory constructor to create a User from a JSON object
  factory Person.fromJson(Map<String, dynamic> json, uid) {
    var productItemsJson = json['cart'] as List;

    List<ProductItem> cart = productItemsJson.map((item) {
      return ProductItem.fromJson(item);
    }).toList();
    return Person(
      uid: uid,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      cart: cart,
      sellerId: json['sellerId'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  // Method to convert a User object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'sellerId': sellerId,
      'cart': [cart.map((item) => item.toJson()).toList()],
      'address': address,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
