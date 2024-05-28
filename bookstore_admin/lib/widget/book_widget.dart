import 'package:bookstore_admin/providers/book_provider.dart';
import 'package:bookstore_admin/screens/add_edit_book_screen.dart';
import 'package:bookstore_admin/widget/subtitle_text.dart';
import 'package:bookstore_admin/widget/title_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
    Size size = MediaQuery.of(context).size;
    return getCurrentBook == null
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.all(2.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return AddOrEditBookScreen(
                        bookModel: getCurrentBook,
                      );
                    },
                  ),
                );
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
                        const SizedBox(
                          height: 12.0,
                        ),
                        IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              final bool confirm = await showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('Confirm Delete'),
                                  content: Text(
                                      'Are you sure you want to delete this book?'),
                                  actions: [
                                    TextButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(ctx).pop(false);
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Delete'),
                                      onPressed: () {
                                        Navigator.of(ctx).pop(true);
                                      },
                                    ),
                                  ],
                                ),
                              );

                              if (confirm) {
                                try {
                                  await bookProviders
                                      .deleteBook(getCurrentBook.bookId);
                                  Fluttertoast.showToast(
                                    msg: 'Book deleted successfully',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER_LEFT,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                  );
                                } catch (error) {
                                  Fluttertoast.showToast(
                                    msg: 'Failed to delete book: $error',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                  );
                                }
                              }
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
