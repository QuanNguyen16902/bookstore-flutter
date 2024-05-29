
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  final String userId, userName, userImage, userEmail;
  final Timestamp createdAt;
  final List userCart, userWishlist;
 
  late final int userPoint;
  UserModel({
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.userEmail,
    required this.createdAt,
    required this.userCart,
    required this.userWishlist,
 
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
   
      userPoint: data['userPoint'] ?? 0,
    );
  }
}
