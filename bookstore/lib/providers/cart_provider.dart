import 'package:bookstore/models/cart_model.dart';
import 'package:bookstore/providers/book_provider.dart';
import 'package:bookstore/services/app_function.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartModel> cartItems = {};
  Map<String, CartModel> get getCartItems {
    return cartItems;
  }

  final userstDb = FirebaseFirestore.instance.collection("users");
  final auth = FirebaseAuth.instance;
//Firebase
  Future<void> addToCartFirebase({
    required String bookId,
    required int qty,
    required BuildContext context,
  }) async {
    final User? user = auth.currentUser;
    if (user == null) {
      MyAppFunction.showErrorOrWarningDialog(
          context: context, subtitle: "Hãy đăng nhập trước", fct: () {});
      return;
    }
    final uid = user.uid;
    final cartId = const Uuid().v4();
    try {
      await userstDb.doc(user.uid).update({
        'userCart': FieldValue.arrayUnion([
          {
            'cartId': cartId,
            'bookId': bookId,
            'quantity': qty,
          }
        ])
      });
      await fetchCart();
      Fluttertoast.showToast(
          msg: "Đã thêm item", backgroundColor: Colors.green);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchCart() async {
    final User? user = auth.currentUser;
    if (user == null) {
      cartItems.clear();
      return;
    }
    try {
      final userDoc = await userstDb.doc(user.uid).get();
      final data = userDoc.data();
      if (data == null || !data.containsKey('userCart')) {
        return;
      }
      final leng = userDoc.get('userCart').length;
      for (int index = 0; index < leng; index++) {
        cartItems.putIfAbsent(
            userDoc.get('userCart')[index]['bookId'],
            () => CartModel(
                cartId: userDoc.get('userCart')[index]['cartId'],
                bookId: userDoc.get('userCart')[index]['bookId'],
                quantity: userDoc.get('userCart')[index]['quantity']));
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> removeCartItemFromFirestore(
      {required String cartId,
      required String bookId,
      required int qty}) async {
    final User? user = auth.currentUser;
    try {
      await userstDb.doc(user!.uid).update({
        'userCart': FieldValue.arrayRemove([
          {
            'cartId': cartId,
            'bookId': bookId,
            'quantity': qty,
          }
        ])
      });
      // await fetchCart();
      cartItems.remove(bookId);
      Fluttertoast.showToast(
          msg: "Đã xóa item", backgroundColor: Colors.green);
    } catch (e) {
      rethrow;
    }
  }
  Future<void> clearCartFromFirebase() async{
     final User? user = auth.currentUser;
    try {
      await userstDb.doc(user!.uid).update({
        'userCart':  [],
      });
      // await fetchCart();
      cartItems.clear();
      Fluttertoast.showToast(
          msg: "Đã xóa hết item", backgroundColor: Colors.green);
    } catch (e) {
      rethrow;
    }
  }

// local
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
        (cartItem) => CartModel(
            cartId: cartItem.cartId, bookId: bookId, quantity: quantity));

    notifyListeners();
  }

  bool isBookInCart({required String bookId}) {
    return cartItems.containsKey(bookId);
  }

  double getTotal({required BookProvider bookProvider}) {
    double total = 0.0;

    cartItems.forEach((key, value) {
      final getCurrentBook = bookProvider.findBookById(value.bookId);
      if (getCurrentBook == null) {
        total += 0;
      } else {
        total += double.parse(getCurrentBook.bookPrice) * value.quantity;
      }
    });
    return total;
  }

  int getQuantity() {
    int total = 0;
    cartItems.forEach((key, value) {
      total += value.quantity;
    });
    return total;
  }

  void clearLocalCart() {
    cartItems.clear();
    notifyListeners();
  }

  void removeOneItem({required String bookId}) {
    cartItems.remove(bookId);
    notifyListeners();
  }
}
