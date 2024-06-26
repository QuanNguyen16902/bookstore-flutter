import 'package:bookstore/providers/book_provider.dart';
import 'package:bookstore/providers/cart_provider.dart';
import 'package:bookstore/services/app_function.dart';
import 'package:bookstore/widgets/appname_text.dart';
import 'package:bookstore/widgets/products/heart_btn.dart';
import 'package:bookstore/widgets/subtitle_text.dart';
import 'package:bookstore/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookDetailsScreen extends StatefulWidget {
  @override
  const BookDetailsScreen({super.key});
  static const routeName = "/BookDetailsScreen";

  @override
  State<BookDetailsScreen> createState() => BookDetaisScreenState();
}

class BookDetaisScreenState extends State<BookDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final bookProviders = Provider.of<BookProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    String? bookId = ModalRoute.of(context)!.settings.arguments as String?;
    final getCurrentBook = bookProviders.findBookById(bookId!);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            // Navigator.canPop(context) ? Navigator.pop(context) : null;
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
        ),
        title: const AppNameTextWidget(
          fontSize: 20,
        ),
      ),
      body: getCurrentBook == null
          ? const SizedBox.shrink()
          : SingleChildScrollView(
              child: Column(children: [
                Image.network(
                  getCurrentBook.bookImage,
                  height: size.height * 0.38,
                  width: double.infinity,
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              getCurrentBook.bookTitle,
                              softWrap: true,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                          SubtitleTextWidget(
                            label: "${getCurrentBook.bookPrice}\$",
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                "By ${getCurrentBook.bookAuthor}",
                                softWrap: true,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            HeartButtonWidget(
                              bgColor: Colors.blue.shade200,
                              bookId: getCurrentBook.bookId,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: SizedBox(
                                height: kBottomNavigationBarHeight - 10,
                                child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          cartProvider.isBookInCart(
                                                  bookId: getCurrentBook.bookId)
                                              ? Colors.green
                                              : Colors.red,
                                    ),
                                    onPressed: () async {
                                      if (cartProvider.isBookInCart(
                                          bookId: getCurrentBook.bookId)) {
                                        return;
                                      }
                                      try {
                                        await cartProvider.addToCartFirebase(
                                            bookId: getCurrentBook.bookId,
                                            qty: 1,
                                            context: context);
                                      } catch (e) {
                                        await MyAppFunction
                                            .showErrorOrWarningDialog(
                                          context: context,
                                          subtitle: e.toString(),
                                          fct: () {},
                                        );
                                      }
                                    },
                                    icon: Icon(
                                      cartProvider.isBookInCart(
                                              bookId: getCurrentBook.bookId)
                                          ? Icons.check
                                          : Icons.add_shopping_cart,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    label: Text(
                                      cartProvider.isBookInCart(
                                              bookId: getCurrentBook.bookId)
                                          ? "Đã thêm vào giỏ hàng"
                                          : "Thêm vào giỏ hàng",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const TitleTextWidget(label: "Chi tiết về sách"),
                          SubtitleTextWidget(
                              label: "Thể loại ${getCurrentBook.bookCategory}"),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SubtitleTextWidget(label: getCurrentBook.bookDescription),
                    ],
                  ),
                )
              ]),
            ),
    );
  }
}
