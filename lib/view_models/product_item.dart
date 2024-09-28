class ProductItem {
  final String productId;
  late final int quantity;

  ProductItem({
    required this.productId,
    required this.quantity,
  });

// Convert ProductItem object to JSON
  Map<String, dynamic> toJson() {
    return {
      'productID': productId,
      'quantity': quantity,
    };
  }

  // Add copyWith method
  ProductItem copyWith({
    String? productId,
    int? quantity,
  }) {
    return ProductItem(
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
    );
  }

  // Factory method to create a ProductItem object from JSON
  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      productId: json['productID'],
      quantity: json['quantity'],
    );
  }
}
