import 'package:bookstore/models/wishlist_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class WishlistProvider with ChangeNotifier {
  final Map<String, WishlistModel> wishlistItems = {};
  Map<String, WishlistModel> get getWishlistItems {
    return wishlistItems;
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
