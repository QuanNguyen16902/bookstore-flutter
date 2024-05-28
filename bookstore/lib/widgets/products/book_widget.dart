import 'package:bookstore/inner_screen/book_details.dart';
import 'package:bookstore/providers/book_provider.dart';
import 'package:bookstore/providers/cart_provider.dart';
import 'package:bookstore/providers/viewed_book_provider.dart';
import 'package:bookstore/services/app_function.dart';
import 'package:bookstore/widgets/products/heart_btn.dart';
import 'package:bookstore/widgets/subtitle_text.dart';
import 'package:bookstore/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookWidget extends StatefulWidget {
  const BookWidget({
    super.key,
    required this.bookId,
  });
  final String bookId;

  @override
  State<BookWidget> createState() => BookWidgetState();
}

class BookWidgetState extends State<BookWidget> {
  @override
  Widget build(BuildContext context) {
    // final bookModelProvider = Provider.of<BookModel>(context);
    final bookProviders = Provider.of<BookProvider>(context);
    final getCurrentBook = bookProviders.findBookById(widget.bookId);
    final cartProvider = Provider.of<CartProvider>(context);
    final viewedBookProvider = Provider.of<ViewedBookProvider>(context);
    Size size = MediaQuery.of(context).size;
    return getCurrentBook == null
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.all(2.0),
            child: GestureDetector(
              onTap: () async {
                viewedBookProvider.addViewedBook(bookId: getCurrentBook.bookId);
                await Navigator.pushNamed(context, BookDetailsScreen.routeName,
                    arguments: getCurrentBook.bookId);
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      getCurrentBook.bookImage,
                      height: size.height * 0.2,
                      width: double.infinity,
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 5,
                          child: TitleTextWidget(
                            label: getCurrentBook.bookTitle,
                            maxLines: 2,
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: HeartButtonWidget(
                            bookId: getCurrentBook.bookId,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 1,
                          child: SubtitleTextWidget(
                            label: "${getCurrentBook.bookPrice}\$",
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Flexible(
                          child: Material(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.blue,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12.0),
                              onTap: () async {
                                if (cartProvider.isBookInCart(
                                    bookId: getCurrentBook.bookId)) {
                                  return;
                                }
                                // cartProvider.addBookToCart(
                                //     bookId: getCurrentBook.bookId);

                                try {
                                  await cartProvider.addToCartFirebase(
                                      bookId: getCurrentBook.bookId,
                                      qty: 1,
                                      context: context);
                                } catch (e) {
                                  await MyAppFunction.showErrorOrWarningDialog(
                                      context: context,
                                      subtitle: e.toString(),
                                      fct: () {});
                                }
                              },
                              splashColor: Colors.red,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  cartProvider.isBookInCart(
                                          bookId: getCurrentBook.bookId)
                                      ? Icons.check
                                      : Icons.add_shopping_cart_outlined,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
