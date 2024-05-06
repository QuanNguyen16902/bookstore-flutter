import 'package:bookstore/models/viewed_book.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ViewedBookProvider with ChangeNotifier {
  final Map<String, ViewedBookModel> viewedBookItems = {};
  Map<String, ViewedBookModel> get getViewedBookItems {
    return viewedBookItems;
  }

  void addViewedBook({required String bookId}) {

      viewedBookItems.putIfAbsent(
          bookId, () => ViewedBookModel(viewedBookId: const Uuid().v4(), bookId: bookId));

    notifyListeners();
  }

  void clearViewedRecently(){
    viewedBookItems.clear();
    notifyListeners();
  }
 
}
