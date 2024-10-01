import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furiniture/services/person_firebase.dart';
import 'package:furiniture/services/product_firebase.dart';
import 'package:furiniture/view_models/product_item.dart';
import 'package:furiniture/view_models/order_model.dart';

Future<void> createOrder(
    {userId,
    totalAmount,
    required List<ProductItem> orderItems,
    address}) async {
  try {
    // Create a timestamp
    Timestamp timestamp = Timestamp.now();
    List<Map<String, dynamic>> orderItemsMap =
        orderItems.map((item) => item.toJson()).toList();

    // Add user data to Firestore
    await FirebaseFirestore.instance.collection('orders').doc().set({
      'userId': userId,
      'totalAmount': totalAmount,
      'orderItems': orderItemsMap,
      'orderDate': timestamp,
      'deliveryAddress': address,
    });

    //remove user Cart
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'cart': [],
    });
    for (ProductItem item in orderItems) {
      await changeProductStock(productItem: item, operation: "sub");
    }

    print('Order has been made and added to Firestore!');
  } catch (e) {
    throw Exception(e);
  }
}

Future<List<MyOrder>> getOrderFromUser({required String userID}) async {
  List<MyOrder> resultList = [];
  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('orders')
        .where("userId", isEqualTo: userID)
        .get();
    for (var doc in querySnapshot.docs) {
      var order = MyOrder.fromJson(doc.data(), doc.id);
      resultList.add(order);
    }

    return resultList;
  } catch (e) {
    throw Exception(e);
  }
}
