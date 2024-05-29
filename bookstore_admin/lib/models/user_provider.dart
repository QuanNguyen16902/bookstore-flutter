import 'package:bookstore_admin/models/users_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  UserModel? userModel;
  UserModel? get getUserModel {
    return userModel;
  }

  Future<void> findUserById(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        userModel = UserModel.fromFirestore(userDoc);
        notifyListeners();
      } else {
        userModel = null;
      }
    } catch (e) {
      print('Error finding user: $e');
      userModel = null;
    }
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<UserModel>> fetchUsers() async {
    try {
       QuerySnapshot<Map<String, dynamic>> usersSnapshot =
          await _firestore.collection('users').get();

    
         List<UserModel> users = usersSnapshot.docs.map((doc) {
        Map<String, dynamic> userData = doc.data();
        return UserModel(
           userId: userData['userId'] ?? '',
          userName: userData['userName'] ?? '',
          userPoint: userData['userPoint'] ?? 0,
          userImage: userData['userImage'] ?? '',
          userEmail: userData['userEmail'] ?? '',
          createdAt: userData['createdAt'],
          userCart: userData['userCart'] ?? [],
          userWishlist: userData['userWishlist'] ?? [],
        );
      }).toList();

      return users;
    } catch (e) {
      print('Error fetching user data: $e');
      return [];
    }
  }
}
