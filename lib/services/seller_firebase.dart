//Any Firebase "SELLER" Related (LOGIN, REGISTER, ACCOUNT INFORMATION) WILL BE ADDED HERE
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:furiniture/global/global_data.dart';
import 'package:furiniture/view_models/seller_model.dart';
import 'package:path/path.dart';

Future<String> createSeller(
    {uid, storeName, address, email, phoneNumber, image}) async {
  try {
    var downloadUrl = await saveImageToFirebase(image, "storeImage");
    if (downloadUrl == "") {
      return "";
    }
    // Create a timestamp
    Timestamp timestamp = Timestamp.now();

    // Add seller data to Firestore
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('sellers').doc();
    await docRef.set({
      'storeName': storeName,
      'address': address,
      'email': email,
      'phoneNumber': phoneNumber,
      'logoUrl': downloadUrl,
      'createdAt': timestamp,
      'updatedAt': timestamp
    });
    String documentId = docRef.id;
    sellerID = documentId;
    // Update user value for seller type
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'sellerId': documentId});
    print('Seller registered and data added to Firestore!');
    return documentId;
  } catch (e) {
    print('Error: $e');
    return "";
  }
}

Future<String> saveImageToFirebase(image, path) async {
  if (image == null) return "";
  String downloadURL = "";
  String fileName = basename(image!.path);
  Reference firebaseStorageRef =
      FirebaseStorage.instance.ref().child('uploads/$path/$fileName');
  UploadTask uploadTask = firebaseStorageRef.putFile(image!);
  await uploadTask.whenComplete(() async {
    downloadURL = await firebaseStorageRef.getDownloadURL();
  });
  return downloadURL;
}

Future<Seller> getSellerDataFromId(String documentId) async {
  try {
    DocumentReference document =
        FirebaseFirestore.instance.collection('sellers').doc(documentId);

    DocumentSnapshot docSnapshot = await document.get();
    late Seller data;
    if (docSnapshot.exists) {
      data = Seller.fromJson(
          docSnapshot.data() as Map<String, dynamic>, documentId);
      return data;
    }
  } catch (e) {
    throw Exception('An error occurred during sign-in: ${e}');
  }
  return Seller(
    address: "",
    email: "",
    logoUrl: "",
    phoneNumber: "",
    sellerId: "",
    storeName: "",
    createdAt: DateTime(2024),
    updatedAt: DateTime(2024),
  );
}
