import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderDetailModel with ChangeNotifier{
  final String bookId;
  final String bookTitle;
  final String bookAuthor;
  final String bookImage;
  final double bookPrice;
  final int quantity;

  OrderDetailModel({
    required this.bookId,
    required this.bookTitle,
    required this.bookAuthor,
    required this.bookImage,
    required this.bookPrice,
    required this.quantity,
  });
  factory OrderDetailModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return OrderDetailModel(
      bookId: data["bookId"],
      bookImage: data["bookImage"],
      bookPrice: data["bookPrice"],
      quantity: data["quantity"],
      bookTitle: data["bookTitle"],
      bookAuthor: data["bookAuthor"],
    );
  }
  factory OrderDetailModel.fromMap(DocumentSnapshot doc) {
     Map map = doc.data() as Map<String, dynamic>;
    return OrderDetailModel(
      bookId: map['bookId'] ?? '',
      bookTitle: map['bookTitle'] ?? '',
      bookAuthor: map['bookAuthor'] ?? '',
      bookPrice: map['bookPrice'] ?? 0.0,
      bookImage: map['bookImage'] ?? '',
      quantity: map['quantity'] ?? 0,
    );
  }

  // Add toMap method
  Map<String, dynamic> toMap() {
    return {
      'bookId': bookId,
      'bookTitle': bookTitle,
      'bookAuthor': bookAuthor,
      'bookPrice': bookPrice,
      'bookImage': bookImage,
      'quantity': quantity,
    };
  }
}

