import 'package:cloud_firestore/cloud_firestore.dart';

class Seller {
  final String sellerId;
  final String storeName;
  final String address;
  final String email;
  final String phoneNumber;
  final String logoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Seller(
      {required this.sellerId,
      required this.storeName,
      required this.address,
      required this.email,
      required this.phoneNumber,
      required this.logoUrl,
      required this.createdAt,
      required this.updatedAt});

  // Factory constructor to create a User from a JSON object
  factory Seller.fromJson(Map<String, dynamic> json, String uid) {
    return Seller(
      sellerId: uid,
      storeName: json['storeName'] as String,
      address: json['address'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      logoUrl: json['logoUrl'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  // Method to convert a User object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'sellerId': sellerId,
      'storeName': storeName,
      'address': address,
      'email': email,
      'phoneNumber': phoneNumber,
      'logoUrl': logoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
