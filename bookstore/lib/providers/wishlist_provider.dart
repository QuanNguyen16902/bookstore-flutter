import 'package:bookstore/models/wishlist_model.dart';
import 'package:bookstore/services/app_function.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class WishlistProvider with ChangeNotifier {
  final Map<String, WishlistModel> wishlistItems = {};
  Map<String, WishlistModel> get getWishlistItems {
    return wishlistItems;
  }

  final userstDb = FirebaseFirestore.instance.collection("users");
  final auth = FirebaseAuth.instance;
//Firebase
  Future<void> addToWishlistFirebase({
    required String bookId,
    required BuildContext context,
  }) async {
    final User? user = auth.currentUser;
    if (user == null) {
      MyAppFunction.showErrorOrWarningDialog(
          context: context, subtitle: "Hãy đăng nhập trước", fct: () {});
      return;
    }
    final uid = user.uid;
    final wishlistId = const Uuid().v4();
    try {
      await userstDb.doc(user.uid).update({
        'userWishlist': FieldValue.arrayUnion([
          {
            'wishlistId': wishlistId,
            'bookId': bookId,
          }
        ])
      });

      Fluttertoast.showToast(
          msg: "Đã thêm item", backgroundColor: Colors.green);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchWishlist() async {
    final User? user = auth.currentUser;
    if (user == null) {
      wishlistItems.clear();
      return;
    }
    try {
      final userDoc = await userstDb.doc(user.uid).get();
      final data = userDoc.data();
      if (data == null || !data.containsKey('userWishlist')) {
        return;
      }
      final leng = userDoc.get('userWishlist').length;
      for (int index = 0; index < leng; index++) {
        wishlistItems.putIfAbsent(
            userDoc.get('userWishlist')[index]['bookId'],
            () => WishlistModel(
                  wishlistId: userDoc.get('userWishlist')[index]['wishlistId'],
                  bookId: userDoc.get('userWishlist')[index]['bookId'],
                ));
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> removeWishlistItemFromFirestore(
      {required String wishlistId,
      required String bookId,}) async {
    final User? user = auth.currentUser;
    try {
      await userstDb.doc(user!.uid).update({
        'userWishlist': FieldValue.arrayRemove([
          {
            'wishlistId': wishlistId,
            'bookId': bookId,
          }
        ])
      });
      wishlistItems.remove(bookId);
      Fluttertoast.showToast(msg: "Đã xóa item", backgroundColor: Colors.green);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clearWishlistFromFirebase() async {
    final User? user = auth.currentUser;
    try {
      await userstDb.doc(user!.uid).update({
        'userWishlist': [],
      });
      wishlistItems.clear();
      Fluttertoast.showToast(
          msg: "Đã xóa hết item", backgroundColor: Colors.green);
    } catch (e) {
      rethrow;
    }
  }

  void addOrRemoveFromWishlist({required String bookId}) {
    if (wishlistItems.containsKey(bookId)) {
      wishlistItems.remove(bookId);
    } else {
      wishlistItems.putIfAbsent(
          bookId, () => WishlistModel(wishlistId: Uuid().v4(), bookId: bookId));
    }

    notifyListeners();
  }

  bool isBookInWishlist({required String bookId}) {
    return wishlistItems.containsKey(bookId);
  }

  void clearWishlist() {
    wishlistItems.clear();
    notifyListeners();
  }
}
