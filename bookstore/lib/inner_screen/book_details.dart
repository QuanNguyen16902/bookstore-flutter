import 'package:bookstore/widgets/appname_text.dart';
import 'package:bookstore/widgets/products/heart_btn.dart';
import 'package:bookstore/widgets/subtitle_text.dart';
import 'package:bookstore/widgets/title_text.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

class BookDetailsScreen extends StatefulWidget {
  static const routeName = "/BookDetailsScreen";
  @override
  const BookDetailsScreen({super.key});

  @override
  State<StatefulWidget> createState() => BookDetaisScreenState();
}

class BookDetaisScreenState extends State<BookDetailsScreen> {
  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Column(children: [
          FancyShimmerImage(
            imageUrl:
                'https://images.unsplash.com/photo-1465572089651-8fde36c892dd?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
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
                  children: [
                    Flexible(
                      child: Text(
                        "Title" * 20,
                        softWrap: true,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const SubtitleTextWidget(
                      label: "1500\$",
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ],
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
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: kBottomNavigationBarHeight - 10,
                          child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.black,
                              ),
                              onPressed: () {},
                              icon: const Icon(
                                Icons.add_shopping_cart,
                                color: Colors.white,
                                size: 20,
                              ),
                              label: const Text(
                                "Thêm vào giỏ hàng",
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TitleTextWidget(label: "Chi tiết về sách"),
                    // SubtitleTextWidget(label: "This book"),
                  ],
                ),
                SubtitleTextWidget(label: "Description" * 15),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
