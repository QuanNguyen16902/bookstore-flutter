import 'package:bookstore/models/cart_model.dart';
import 'package:bookstore/providers/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartModel> cartItems = {};
  Map<String, CartModel> get getCartItems {
    return cartItems;
  }

  void addBookToCart({required String bookId}) {
    cartItems.putIfAbsent(
        bookId,
        () =>
            CartModel(cartId: const Uuid().v4(), bookId: bookId, quantity: 1));

    notifyListeners();
  }
  void updateQuantity({required String bookId, required int quantity}) {
    cartItems.update(
        bookId,
        (cartItem) =>
            CartModel(cartId: cartItem.cartId, bookId: bookId, quantity: quantity));

    notifyListeners();
  }

  bool isBookInCart({required String bookId}) {
    return cartItems.containsKey(bookId);
  }

  double getTotal({required BookProvider bookProvider}){
    double total = 0.0;
    
    cartItems.forEach((key, value) {
      final getCurrentBook = bookProvider.findBookById(value.bookId);
      if(getCurrentBook == null){
        total += 0;
      }else{
        total += double.parse(getCurrentBook.bookPrice) * value.quantity;
      }
    });
    return total;
  } 

  int getQuantity(){
    int total = 0;
    cartItems.forEach((key, value) {
      total += value.quantity;
    });
    return total;
  }

  void clearLocalCart(){
    cartItems.clear();
    notifyListeners();
  }

  void removeOneItem({required String bookId}){
    cartItems.remove(bookId);
    notifyListeners();
  }
}
