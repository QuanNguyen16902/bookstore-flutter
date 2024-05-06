import 'package:flutter/material.dart';

class ViewedBookModel with ChangeNotifier {
  final String viewedBookId;
  final String bookId;

  ViewedBookModel({
    required this.viewedBookId,
    required this.bookId,
  });
}
