import 'package:bookstore/inner_screen/book_details.dart';
import 'package:bookstore/models/book_model.dart';
import 'package:bookstore/providers/cart_provider.dart';
import 'package:bookstore/providers/viewed_book_provider.dart';
import 'package:bookstore/providers/wishlist_provider.dart';
import 'package:bookstore/services/assets_manager.dart';
import 'package:bookstore/widgets/products/heart_btn.dart';
import 'package:bookstore/widgets/subtitle_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LastArrivalProductWidget extends StatelessWidget {
  const LastArrivalProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final bookModel = Provider.of<BookModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final viewedBookProvider = Provider.of<ViewedBookProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () async {
          viewedBookProvider.addViewedBook(bookId: bookModel.bookId);
          await Navigator.pushNamed(context, BookDetailsScreen.routeName,
              arguments: bookModel.bookId);
        },
        child: SizedBox(
          width: size.width * 0.45,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.asset(
                    bookModel.bookImage,
                    height: size.width * 0.28,
                    width: size.width * 0.38,
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Flexible(
                child: Column(
                  children: [
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      bookModel.bookTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    FittedBox(
                      child: Row(
                        children: [
                          HeartButtonWidget(
                            bookId: bookModel.bookId,
                          ),
                          IconButton(
                              onPressed: () {
                                if (cartProvider.isBookInCart(
                                    bookId: bookModel.bookId)) {
                                  return;
                                }
                                cartProvider.addBookToCart(
                                    bookId: bookModel.bookId);
                              },
                              icon: Icon(cartProvider.isBookInCart(
                                      bookId: bookModel.bookId)
                                  ? Icons.check
                                  : Icons.add_shopping_cart)),
                        ],
                      ),
                    ),
                    FittedBox(
                      alignment: Alignment.bottomRight,
                      child: SubtitleTextWidget(
                        label: "${bookModel.bookPrice}\$",
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
