import 'package:bookstore/widgets/subtitle_text.dart';
import 'package:bookstore/widgets/title_text.dart';
import 'package:flutter/material.dart';

class BottonCheckoutWidget extends StatelessWidget {
  const BottonCheckoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: const Border(
              top: BorderSide(
            width: 1,
            color: Colors.grey,
          ))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                        child: TitleTextWidget(
                            label: "Total (6 products/ 9 items)")),
                    SubtitleTextWidget(
                      label: "16.0\$",
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text("Checkout"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
