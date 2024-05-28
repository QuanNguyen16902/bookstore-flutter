import 'package:flutter/material.dart';

class CartModel with ChangeNotifier{
  final String cartId;
  final String bookId;
  final int quantity;

  CartModel(
    {
    required this.cartId,
    required this.bookId,
    required this.quantity,
  });
}