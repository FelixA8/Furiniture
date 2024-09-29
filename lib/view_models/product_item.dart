class ProductItem {
  final String productId;
  late final int quantity;
  late final String orderStatus;

  ProductItem({
    required this.productId,
    required this.quantity,
    required this.orderStatus,
  });

// Convert ProductItem object to JSON
  Map<String, dynamic> toJson() {
    return {
      'productID': productId,
      'quantity': quantity,
      'orderStatus': orderStatus,
    };
  }

  // Add copyWith method
  ProductItem copyWith({
    String? productId,
    int? quantity,
    String? orderStatus,
  }) {
    return ProductItem(
        productId: productId ?? this.productId,
        quantity: quantity ?? this.quantity,
        orderStatus: orderStatus ?? this.orderStatus);
  }

  // Factory method to create a ProductItem object from JSON
  factory ProductItem.fromJson(Map<String, dynamic> json) {

    return ProductItem(
        productId: json['productID'],
        quantity: json['quantity'],
        orderStatus: json['orderStatus']);
  }
}
