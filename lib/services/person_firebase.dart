//Any Firebase "USER" Related (LOGIN, REGISTER, ACCOUNT INFORMATION) WILL BE ADDED HERE
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:furiniture/global/global_data.dart';
import 'package:furiniture/view_models/order_model.dart';
import 'package:furiniture/view_models/person_model.dart';
import 'package:furiniture/view_models/product_item.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> createUser({name, email, password, phone, address}) async {
  try {
    // Create user in Firebase Auth
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password, // Make sure to use a strong password
    );

    // Get user ID
    String userId = userCredential.user!.uid;

    // Create a timestamp
    Timestamp timestamp = Timestamp.now();

    // Add user data to Firestore
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'sellerId': "",
      'cart': [],
      'createdAt': timestamp,
      'updatedAt': timestamp,
    });
    print('User registered and data added to Firestore!');
  } catch (e) {
    print('Error: $e');
  }
}

Future<UserCredential> signInUser({email, password}) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential;
  } catch (e) {
    throw Exception('An error occurred during sign-in: ${e}');
  }
}

Future<void> saveUserData({email, uid}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Save user's email and UID to shared preferences
  await prefs.setString('userEmail', email!);
  await prefs.setString('userUid', uid);
}

Future<Person> getUserDataFromId(String documentId) async {
  try {
    DocumentReference document =
        FirebaseFirestore.instance.collection('users').doc(documentId);

    DocumentSnapshot docSnapshot = await document.get();
    late Person data;
    if (docSnapshot.exists) {
      data = Person.fromJson(
          docSnapshot.data() as Map<String, dynamic>, documentId);

      globalUserData = data;
      return data;
    }
  } catch (e) {
    throw Exception('An error occurred during sign-in: ${e}');
  }
  return Person(
      uid: "",
      name: "",
      email: "",
      phone: "",
      sellerId: "",
      cart: [],
      address: "",
      createdAt: DateTime(2024),
      updatedAt: DateTime(2024));
}

Future<void> logout(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Save user's email and UID to shared preferences
  try {
    await prefs.clear();
    await FirebaseAuth.instance.signOut();
    GoRouter.of(context).go("/");
  } catch (e) {
    throw Exception(e);
  }
}

Future<bool> addProductToCart({productID, amount, orderStatus}) async {
  try {
    // Reference the user's document
    DocumentReference userDoc =
        FirebaseFirestore.instance.collection('users').doc(userID);

    // Retrieve the current cart
    DocumentSnapshot userSnapshot = await userDoc.get();
    List<dynamic> cart = userSnapshot.get('cart');

    // Check if the product already exists in the cart
    bool productExists = cart.any((item) => item['productID'] == productID);

    if (productExists) {
      // If the product is already in the cart, return false
      return false;
    }
    // Create a new product object to add to the cart
    Map<String, dynamic> product = {
      'productID': productID,
      'quantity': amount,
      'orderStatus': orderStatus,
    };
    await FirebaseFirestore.instance.collection('users').doc(userID).update({
      'cart': FieldValue.arrayUnion([product]),
    }); //new cart added with the object productID, amount
    
    return true;
  } catch (e) {
    throw Exception(e);
  }
}

Future<bool> changeCartProductItemValue(
    {required String productID,
    required int prevAmount,
    required String operation}) async {
  try {
    // Reference the user's document
    DocumentReference userDoc =
        FirebaseFirestore.instance.collection('users').doc(userID);

    // Retrieve the current cart from Firestore (as List of Maps)
    DocumentSnapshot userSnapshot = await userDoc.get();
    List<dynamic> cartData = userSnapshot.get('cart');

    // Convert the cart data to List<ProductItem>
    List<ProductItem> cart = cartData.map((item) {
      return ProductItem(
          productId: item['productID'],
          quantity: item['quantity'],
          orderStatus: "waiting");
    }).toList();

    // Check if the product exists in the cart
    bool productExists = cart.any((item) => item.productId == productID);

    if (productExists) {
      // Find the product in the cart and update its quantity
      int index = cart.indexWhere((item) => item.productId == productID);

      if (operation == "add") {
        cart[index] = ProductItem(
            productId: cart[index].productId,
            quantity: cart[index].quantity + 1,
            orderStatus: "waiting");
      } else if (operation == "sub" && cart[index].quantity > 1) {
        cart[index] = ProductItem(
            productId: cart[index].productId,
            quantity: cart[index].quantity - 1,
            orderStatus: "waiting");
      }

      // Convert back to List of Maps to update Firestore
      List<Map<String, dynamic>> updatedCart = cart.map((item) {
        return {
          'productID': item.productId,
          'quantity': item.quantity,
        };
      }).toList();

      // Update the cart in Firestore
      await userDoc.update({'cart': updatedCart});

      return true;
    } else {
      return false;
    }
  } catch (e) {
    throw Exception(e);
  }
}

Future<bool> deleteItem({productID}) async {
  try {
    // Reference the user's document
    DocumentReference userDoc =
        FirebaseFirestore.instance.collection('users').doc(userID);
    DocumentSnapshot userSnapshot = await userDoc.get();
    List<dynamic> cartData = userSnapshot.get('cart');
    // Convert the cart data to List<ProductItem>
    List<ProductItem> cart = cartData.map((item) {
      return ProductItem(
          productId: item['productID'],
          quantity: item['quantity'],
          orderStatus: "waiting");
    }).toList();

    // Check if the product exists in the cart
    bool productExists = cart.any((item) => item.productId == productID);
    if (productExists) {
      // Find the product in the cart and update its quantity
      int index = cart.indexWhere((item) => item.productId == productID);
      cart.removeAt(index);
      // Convert back to List of Maps to update Firestore
      List<Map<String, dynamic>> updatedCart = cart.map((item) {
        return {
          'productID': item.productId,
          'quantity': item.quantity,
        };
      }).toList();
      // Update the cart in Firestore
      await userDoc.update({'cart': updatedCart});

      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}
