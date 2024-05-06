import 'package:flutter/material.dart';

class WishlistModel with ChangeNotifier {
  final String wishlistId;
  final String bookId;

  WishlistModel({
    required this.wishlistId,
    required this.bookId,
  });
}
