import 'package:bookstore/models/address_model.dart';
import 'package:bookstore/models/users_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserProvider with ChangeNotifier {
  UserModel? userModel;
  UserModel? get getUserModel {
    return userModel;
  }
 Future<void> findUserById(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
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
  
  Future<UserModel?> fetchUserInfo() async {
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user == null) {
      return null;
    }

    String uid = user.uid;
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      final userDocDict = userDoc.data() as Map<String, dynamic>;
      userModel = UserModel(
        userId: userDoc.get("userId"),
        userEmail: userDoc.get("userEmail"),
        userName: userDoc.get("userName"),
        userImage: userDoc.get("userImage"),
        userCart:
            userDocDict.containsKey("userCart") ? userDoc.get("userCart") : [],
        userWishlist: userDocDict.containsKey("userWishlist")
            ? userDoc.get("userWishlist")
            : [],
        createdAt: userDoc.get("createdAt"),
        addresses: (userDoc.get('addresses') as List<dynamic>)
            .map((item) => AddressModel.fromMap(item))
            .toList(), 
        userPoint: userDoc.get('userPoint'),
      );
      return userModel;
    } on FirebaseException catch (error) {
      rethrow;
    } catch (error) {
      rethrow;
    }
  }

  // int _userPoints = 0; 

  int getUserPoints() {
    return getUserModel!.userPoint;
  }

  Future<void> updateUserPoints(String userId, int points) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'userPoint': FieldValue.increment(points),
    });
    notifyListeners();
  }

  void setUserPoints(int points) {
    getUserModel!.userPoint = points;
    notifyListeners();
  }
  
  Future<void> removeAddressFromFirestore ({
    required userstDb,
    required User currentUser,
    required String addressId,
    required String street,
    required String city,
    required String state,
    required String zipCode,
    required String country,
  }) async {
    try {
      
      await userstDb.doc(currentUser!.uid).update({
        'addresses': FieldValue.arrayRemove([
          {
            'addressId': addressId,
            'street': street,
            'city': city,
            'state': state,
            'zipCode': zipCode,
            'country': country,
          }
        ])
        
      });
      
      // await fetchCart();
      userModel!.addresses.remove(addressId);
      notifyListeners();
      Fluttertoast.showToast(
          msg: "Đã xóa address", backgroundColor: Colors.green);
    } catch (e) {
      rethrow;
    }
  }
}
