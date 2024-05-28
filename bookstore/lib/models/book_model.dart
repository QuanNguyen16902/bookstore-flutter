import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookModel with ChangeNotifier {
  final String bookId,
      bookTitle,
      bookAuthor,
      bookCategory,
      bookDescription,
      bookImage,
      bookQuantity,
      bookPrice;
  Timestamp? createdAt;
  BookModel(
      {required this.bookId,
      required this.bookTitle,
      required this.bookAuthor,
      required this.bookCategory,
      required this.bookDescription,
      required this.bookImage,
      required this.bookQuantity,
      required this.bookPrice,
      this.createdAt});

  factory BookModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return BookModel(
      bookCategory: data["bookCategory"],
      bookDescription: data["bookDescription"],
      bookId: data["bookId"],
      bookImage: data["bookImage"],
      bookPrice: data["bookPrice"],
      bookQuantity: data["bookQuantity"],
      bookTitle: data["bookTitle"],
      bookAuthor: data["bookAuthor"],
      createdAt: data["createdAt"],
    );
  }
  // Stream<List<BookModel>> fetchBooksStream(){
  //   try{
  //     bookDb
  //   }
  // }
}
