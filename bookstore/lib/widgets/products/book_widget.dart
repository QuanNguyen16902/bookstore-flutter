import 'package:bookstore/inner_screen/book_details.dart';
import 'package:bookstore/widgets/products/heart_btn.dart';
import 'package:bookstore/widgets/subtitle_text.dart';
import 'package:bookstore/widgets/title_text.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

class BookWidget extends StatefulWidget {
  const BookWidget({super.key});

  @override
  State<StatefulWidget> createState() => BookWidgetState();
}

class BookWidgetState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: GestureDetector(
        onTap: () async {
          await Navigator.pushNamed(context, BookDetailsScreen.routeName);
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: FancyShimmerImage(
                imageUrl:
                    'https://images.unsplash.com/photo-1465572089651-8fde36c892dd?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
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
                      label: "Title" * 10,
                      maxLines: 2,
                    ),
                  ),
                  const Flexible(
                    flex: 2,
                    child: HeartButtonWidget(),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(
                  flex: 1,
                  child: SubtitleTextWidget(
                    label: "1660.00\$",
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
                      onTap: () {},
                      splashColor: Colors.red,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.add_shopping_cart_outlined,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
