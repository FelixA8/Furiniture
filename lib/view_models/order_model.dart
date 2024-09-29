import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furiniture/view_models/product_item.dart';

class MyOrder {
  final String orderId;
  final String userId;
  final int totalAmount;
  final List<ProductItem> productItems;
  final DateTime orderDate;
  final String deliveryAddress;
  MyOrder({
    required this.orderId,
    required this.userId,
    required this.totalAmount,
    required this.productItems,
    required this.orderDate,
    required this.deliveryAddress,
  });

  // Factory method to create an MyOrder object from JSON
  factory MyOrder.fromJson(Map<String, dynamic> json, orderId) {
    var productItemsJson = json['orderItems'] as List;
    List<ProductItem> productItems =
        productItemsJson.map((item) => ProductItem.fromJson(item)).toList();
    return MyOrder(
      orderId: orderId,
      userId: json['userId'],
      totalAmount: json['totalAmount'],
      productItems: productItems,
      orderDate: (json['orderDate'] as Timestamp).toDate(),
      deliveryAddress: json['deliveryAddress'],
    );
  }

  // Convert MyOrder object to JSON
  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'userId': userId,
      'totalAmount': totalAmount,
      'productItems': productItems.map((item) => item.toJson()).toList(),
      'orderDate': orderDate,
      'deliveryAddress': deliveryAddress,
    };
  }
}
