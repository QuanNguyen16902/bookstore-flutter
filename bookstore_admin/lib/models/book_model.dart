import 'package:flutter/material.dart';

class BookModel with ChangeNotifier{
  final String bookId,
      bookTitle,
      bookAuthor,
      bookCategory,
      bookDescription,
      bookImage,
      bookQuantity,
      bookPrice;

  BookModel(
      {required this.bookId,
      required this.bookTitle,
      required this.bookAuthor,
      required this.bookCategory,
      required this.bookDescription,
      required this.bookImage,
      required this.bookQuantity,
      required this.bookPrice});

    
}
