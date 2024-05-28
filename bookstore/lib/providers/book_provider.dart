import 'package:bookstore/models/book_model.dart';
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
  Future<List<BookModel>> fetchBooks() async {
    try{
      await bookDb.get().then((bookSnapshot) {
      books.clear();
          for(var element in bookSnapshot.docs){
            books.insert(0, BookModel.fromFirestore(element));
          }

      },);
      notifyListeners();
      return books;
    }catch(e){
      rethrow;
    }
  }

  // static List<BookModel> books = [
  //   BookModel(
  //       bookId: "1",
  //       bookTitle: "Maid by Stepanie Land",
  //       bookAuthor: "Stepanie Land",
  //       bookCategory: "Tri thức",
  //       bookDescription: "Kể về câu chuyện tình stepanie land",
  //       bookImage: AssetManager.maid_by_stepanie_land,
  //       bookQuantity: "3",
  //       bookPrice: "12.00"),
  //   BookModel(
  //       bookId: "2",
  //       bookTitle: "The Age of light",
  //       bookAuthor: "Whitney Scharer",
  //       bookCategory: "Văn hóa",
  //       bookDescription: "Kể về câu chuyện của whitney Scharer",
  //       bookImage: AssetManager.the_age_of_light_by_whitney_scharer,
  //       bookQuantity: "3",
  //       bookPrice: "255.00"),
  //   BookModel(
  //       bookId: const Uuid().v4(),
  //       bookTitle: "The last romantics",
  //       bookAuthor: "Tara Conklin",
  //       bookCategory: "Tri thức",
  //       bookDescription: "Kể về câu chuyện tình Tara Conklin",
  //       bookImage: AssetManager.the_last_romantics_by_tara_conklin,
  //       bookQuantity: "123",
  //       bookPrice: "120.00"),
  //   BookModel(
  //       bookId: const Uuid().v4(),
  //       bookTitle: "The last romantics",
  //       bookAuthor: "Tara Conklin",
  //       bookCategory: "Tri thức",
  //       bookDescription: "Kể về câu chuyện tình Tara Conklin",
  //       bookImage: AssetManager.the_last_romantics_by_tara_conklin,
  //       bookQuantity: "123",
  //       bookPrice: "12.00"),
  //   BookModel(
  //       bookId: const Uuid().v4(),
  //       bookTitle: "The nama",
  //       bookAuthor: "Tara Conklin",
  //       bookCategory: "Tri thức",
  //       bookDescription: "Kể về câu chuyện tình Tara Conklin",
  //       bookImage: AssetManager.the_last_romantics_by_tara_conklin,
  //       bookQuantity: "123",
  //       bookPrice: "1298.00"),
  //   BookModel(
  //       bookId: const Uuid().v4(),
  //       bookTitle: "The Canada",
  //       bookAuthor: "Tara Conklin",
  //       bookCategory: "Tri thức",
  //       bookDescription: "Kể về câu chuyện tình Tara Conklin",
  //       bookImage: AssetManager.the_last_romantics_by_tara_conklin,
  //       bookQuantity: "123",
  //       bookPrice: "131.00"),
  // ];
}
