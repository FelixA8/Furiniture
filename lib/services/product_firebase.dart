import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furiniture/services/seller_firebase.dart';
import 'package:furiniture/view_models/product_item.dart';
import 'package:furiniture/view_models/product_model.dart';

Future<List<Product>> getSellerProduct({sellerID}) async {
  List<Product> resultList = [];
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('products') // Replace with your collection name
      .where('sellerId', isEqualTo: sellerID)
      .get();
  // Iterate through each document and add its data to the resultList
  for (var doc in querySnapshot.docs) {
    resultList
        .add(Product.fromJson(doc.data() as Map<String, dynamic>, doc.id));
  }
  return resultList;
}

Future<bool> createProduct(
    {name,
    description,
    price,
    category,
    sellerId,
    stock,
    image,
    augmentedURL}) async {
  try {
    //validate storeId if store id is present and valid.

    // Create a timestamp
    Timestamp timestamp = Timestamp.now();

    //save data to firebase
    var downloadUrl = await saveImageToFirebase(image, "products");
    if (downloadUrl == "") {
      return false;
    }

    // Add user data to Firestore
    await FirebaseFirestore.instance.collection('products').doc().set({
      'name': name,
      'description': description,
      'price': int.parse(stock),
      'category': category,
      'sellerId': sellerId,
      'stock': int.parse(stock),
      'imageURL': downloadUrl,
      'augmentedURL': augmentedURL,
      'createdAt': timestamp,
      'updatedAt': timestamp,
    });
    print('Product registered and data added to Firestore!');
    return true;
  } catch (e) {
    print('Error: $e');
    return false;
  }
}

Future<List<Product>> fetchAllProduct() async {
  List<Product> resultList = [];
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('products').get();
  for (var doc in querySnapshot.docs) {
    var product = Product.fromJson(doc.data() as Map<String, dynamic>, doc.id);
    resultList.add(product);
  }
  return resultList;
}

Future<List<Product>> getRandomTop5Products(List<Product> resultList) async {
  resultList.shuffle();
  List<Product> top5Products = resultList.take(5).toList();
  return top5Products;
}

Future<void> changeProductStock(
    {required ProductItem productItem, operation}) async {
  try {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('products')
        .doc(productItem.productId)
        .get();

    var product =
        Product.fromJson(userDoc.data() as Map<String, dynamic>, userDoc.id);
    var amount = product.stock;
    if (operation == "add") {
      amount += productItem.quantity;
    } else if (operation == "sub") {
      amount -= productItem.quantity;
    }

    await FirebaseFirestore.instance
        .collection('products')
        .doc(productItem.productId)
        .update({"stock": amount});
  } catch (e) {
    throw Exception(e);
  }
}
