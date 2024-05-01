import 'dart:developer';

import 'package:bookstore/services/assets_manager.dart';
import 'package:bookstore/widgets/products/book_widget.dart';
import 'package:bookstore/widgets/title_text.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<StatefulWidget> createState() => SearchScreenState();
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

  @override
  Widget build(BuildContext context) {
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
            title: const TitleTextWidget(label: "Search Books")),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: searchTextController,
                decoration: InputDecoration(
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
                onSubmitted: (value) {
                  log("value of the text is $value");
                },
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: DynamicHeightGridView(
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    builder: (context, index) {
                      return const BookWidget();
                    },
                    itemCount: 10,
                    crossAxisCount: 2),
              )
            ],
          ),
        ),
      ),
    );
  }
}
