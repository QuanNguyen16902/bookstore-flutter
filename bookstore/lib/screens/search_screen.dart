import 'package:bookstore/models/book_model.dart';
import 'package:bookstore/providers/book_provider.dart';
import 'package:bookstore/services/assets_manager.dart';
import 'package:bookstore/widgets/products/book_widget.dart';
import 'package:bookstore/widgets/title_text.dart';
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
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "${AssetManager.imagesPath}/book-shop.png",
              ),
            ),
            title: TitleTextWidget(label: selectedCategory ?? "Search Books")),
        body: bookList.isEmpty
            ? const Center(
                child: TitleTextWidget(
                  label: 'Không tìm thấy sách nào',
                ),
              )
            : Padding(
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
                      onChanged: (value) {
                        setState(() {
                          bookListSearch = booksProvider.searchByTitle(
                              searchText: searchTextController.text);
                        });
                      },
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
              ),
      ),
    );
  }
}
