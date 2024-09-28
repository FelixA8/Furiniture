import 'package:flutter/material.dart';
import 'package:furiniture/global/global_data.dart';
import 'package:furiniture/view_models/product_item.dart';
import 'package:furiniture/view_models/product_model.dart';

class CartModel extends ChangeNotifier {
  final List<ProductItem> _cartList = [];

  List<ProductItem> get cartList => _cartList;

  // Method to calculate total price
  int get totalPrice {
    int total = 0;
    for (var item in _cartList) {
      // Lookup the product price using productId from the item
      Product? product = globalListProduct.firstWhere(
        (product) => product.productId == item.productId,
        orElse: () => Product(
          productId: "",
          name: "",
          description: "",
          price: 0,
          categoryId: "",
          shopId: "",
          stock: 0,
          image: "",
          augmentedObject: "",
          createdAt: DateTime(2024),
          updatedAt: DateTime(2024), // Handle case where product is not found
        ),
      );

      if (product.name != "") {
        total += product.price *
            item.quantity; // Use product price and item quantity
      }
    }
    return total;
  }

  void addItem(ProductItem item) {
    _cartList.add(item);
    notifyListeners();
  }

  void removeItem(ProductItem item) {
    _cartList.remove(item);
    notifyListeners();
  }

  void updateItemQuantity(ProductItem item, int quantity) {
    // Update item logic here
    notifyListeners();
  }
}
