import 'package:furiniture/view_models/product_item.dart';

class Order {
  final String orderId;
  final String customerId;
  final String sellerId;
  final String orderStatus;
  final int totalAmount;
  final List<ProductItem> productItems;
  final DateTime orderDate;
  final DateTime deliveryDate;
  final String deliveryAddress;
  final String paymentMethod;

  Order(
      {required this.orderId,
      required this.customerId,
      required this.sellerId,
      required this.orderStatus,
      required this.totalAmount,
      required this.productItems,
      required this.orderDate,
      required this.deliveryDate,
      required this.deliveryAddress,
      required this.paymentMethod});

  // Factory method to create an Order object from JSON
  factory Order.fromJson(Map<String, dynamic> json) {
    var productItemsJson = json['productItems'] as List;
    List<ProductItem> productItems =
        productItemsJson.map((item) => ProductItem.fromJson(item)).toList();
    return Order(
      orderId: json['orderId'],
      customerId: json['customerId'],
      sellerId: json['sellerId'],
      orderStatus: json['orderStatus'],
      totalAmount: json['totalAmount'],
      productItems: productItems,
      orderDate: json['orderDate'],
      deliveryDate: json['deliveryDate'],
      deliveryAddress: json['deliveryAddress'],
      paymentMethod: json['paymentMethod'],
    );
  }

  // Convert Order object to JSON
  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'customerId': customerId,
      'sellerId': sellerId,
      'orderStatus': orderStatus,
      'totalAmount': totalAmount,
      'productItems': productItems.map((item) => item.toJson()).toList(),
      'orderDate': orderDate.toIso8601String(),
      'deliveryDate': deliveryDate.toIso8601String(),
      'deliveryAddress': deliveryAddress,
      'paymentMethod': paymentMethod
    };
  }
}
