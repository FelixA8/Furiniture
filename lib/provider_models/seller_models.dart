import 'package:flutter/material.dart';
import 'package:furiniture/view_models/seller_model.dart';

class SellerModel extends ChangeNotifier {
  final List<Seller> _sellerList = [];

  List<Seller> get sellerList => _sellerList;

  void addSeller(Seller seller) {
    _sellerList.add(seller);
    notifyListeners();
  }

  void removeSeller(Seller seller) {
    _sellerList.remove(seller);
    notifyListeners();
  }

  void removeAllSeller() {
    _sellerList.clear();
    notifyListeners();
  }

  void updateItemQuantity(Seller seller, int quantity) {
    // Update item logic here
    notifyListeners();
  }
}
