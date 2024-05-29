import 'package:bookstore/models/address_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  final String userId, userName, userImage, userEmail;
  final Timestamp createdAt;
  final List userCart, userWishlist;
  final List<AddressModel> addresses;
  late final int userPoint;
  UserModel({
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.userEmail,
    required this.createdAt,
    required this.userCart,
    required this.userWishlist,
    required this.addresses,
    required this.userPoint, 
  });
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'userEmail': userEmail,
      'createdAt': createdAt,
      'userCart': userCart,
      'userWishlist': userWishlist,
      'addresses': addresses.map((address) => address.toMap()).toList(),
    };
  }
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userImage: data['userImage'] ?? '',
      userEmail: data['userEmail'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      userCart: data['userCart'] ?? [],
      userWishlist: data['userWishlist'] ?? [],
      addresses: (data['addresses'] as List<dynamic>)
          .map((item) => AddressModel.fromMap(item))
          .toList(),
      userPoint: data['userPoint'] ?? 0,
    );
  }
}
