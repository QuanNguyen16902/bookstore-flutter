import 'package:bookstore_admin/models/book_model.dart';
import 'package:bookstore_admin/providers/book_provider.dart';
import 'package:bookstore_admin/widget/book_widget.dart';
import 'package:bookstore_admin/widget/title_text.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = "/SearchScreen";
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchTextController;
  @override
  void initState() {
    searchTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  List<BookModel> bookListSearch = [];
  @override
  Widget build(BuildContext context) {
    final booksProvider = Provider.of<BookProvider>(context);
    String? selectedCategory =
        ModalRoute.of(context)!.settings.arguments as String?;
    List<BookModel> bookList = selectedCategory == null
        ? booksProvider.getBooks
        : booksProvider.findByCategory(categoryName: selectedCategory);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
         
            title: TitleTextWidget(label: selectedCategory ?? "Search Books")),
        body: StreamBuilder<List<BookModel>>(
            stream: booksProvider.fetchBooksStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return  const Center(
                    child: CircularProgressIndicator(),
                  );
             
              } else if (snapshot.hasError) {
                return Center(child: SelectableText(snapshot.error.toString()));
              } else if (snapshot.data == null) {
                return const Center(
                  child: SelectableText("Không có sách nào được thêm"),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: searchTextController,
                      decoration: InputDecoration(
                        hintText: "Tìm kiếm",
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            // setState(() {
                            FocusScope.of(context).unfocus();
                            searchTextController.clear();
                            // } );
                          },
                          child: const Icon(Icons.clear),
                        ),
                      ),
                      // onChanged: (value) {
                      //   setState(() {
                      //     bookListSearch = booksProvider.searchByTitle(
                      //         searchText: searchTextController.text);
                      //   });
                      // },
                      onSubmitted: (value) {
                        bookListSearch = booksProvider.searchByTitle(
                            searchText: searchTextController.text);
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    if (searchTextController.text.isNotEmpty &&
                        bookListSearch.isEmpty) ...[
                      const Center(
                          child: TitleTextWidget(
                              label: "Không tìm thấy sách nào")),
                    ],
                    Expanded(
                      child: DynamicHeightGridView(
                        itemCount: searchTextController.text.isNotEmpty
                            ? bookListSearch.length
                            : bookList.length,
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        builder: (context, index) {
                          return BookWidget(
                            bookId: searchTextController.text.isNotEmpty
                                ? bookListSearch[index].bookId
                                : bookList[index].bookId,
                          );
                        },
                      ),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
