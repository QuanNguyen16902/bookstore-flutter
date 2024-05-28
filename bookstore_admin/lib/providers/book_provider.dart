import 'package:bookstore_admin/models/book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookProvider with ChangeNotifier {
  List<BookModel> books = [];
  List<BookModel> get getBooks {
    return books;
  }

  BookModel? findBookById(String bookId) {
    if (books.where((element) => element.bookId == bookId).isEmpty) {
      return null;
    }
    return books.firstWhere((element) => element.bookId == bookId);
  }

  List<BookModel> findByCategory({required String categoryName}) {
    List<BookModel> categoryList = books
        .where((element) => element.bookCategory
            .toLowerCase()
            .contains(categoryName.toLowerCase()))
        .toList();
    return categoryList;
  }

  List<BookModel> searchByTitle({required String searchText}) {
    List<BookModel> searchList = books
        .where((element) =>
            element.bookTitle.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    return searchList;
  }

  final bookDb = FirebaseFirestore.instance.collection("books");
  // Future<List<BookModel>> fetchBooks() async {
  //   try{
  //     await bookDb.get().then((bookSnapshot) {
  //         for(var element in bookSnapshot.docs){
  //           books.insert(0, BookModel.fromFirestore(element));
  //         }

  //     },);
  //     notifyListeners();
  //     return books;
  //   }catch(e){
  //     rethrow;
  //   }
  // }

  Stream<List<BookModel>> fetchBooksStream() {
    try {
      return bookDb.snapshots().map((snapshot){
          books.clear();
          for(var element in snapshot.docs){
               books.insert(0, BookModel.fromFirestore(element));
          }
      return books;
      });
    } catch (e) {
      rethrow;
    }
  }

 Future<void> deleteBook(String bookId) async {
    try {
      await FirebaseFirestore.instance.collection('books').doc(bookId).delete();
      books.removeWhere((book) => book.bookId == bookId);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
 
}
