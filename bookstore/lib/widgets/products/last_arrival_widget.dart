import 'package:bookstore/inner_screen/book_details.dart';
import 'package:bookstore/services/assets_manager.dart';
import 'package:bookstore/widgets/products/heart_btn.dart';
import 'package:bookstore/widgets/subtitle_text.dart';
import 'package:flutter/material.dart';

class LastArrivalProductWidget extends StatelessWidget {
  const LastArrivalProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () async {
          await Navigator.pushNamed(context, BookDetailsScreen.routeName);
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
                    AssetManager.book2,
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
                      "Title" * 5,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    FittedBox(
                      child: Row(
                        children: [
                          const HeartButtonWidget(),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.add_shopping_cart)),
                        ],
                      ),
                    ),
                    const FittedBox(
                      alignment: Alignment.bottomRight,
                      child: SubtitleTextWidget(
                        label: "1555.00s",
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
