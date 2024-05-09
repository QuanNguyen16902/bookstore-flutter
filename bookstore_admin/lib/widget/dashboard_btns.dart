import 'package:bookstore_admin/services/assets_manager.dart';
import 'package:bookstore_admin/widget/subtitle_text.dart';
import 'package:flutter/material.dart';

class DashBoardButtonWidget extends StatelessWidget {
  const DashBoardButtonWidget(
      {super.key, this.text, this.imagePath, required this.onPressed});
  final text, imagePath;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Card(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(
              imagePath,
              height: 65,
              width: 65,
            ),
            const SizedBox(
              height: 10,
            ),
            SubtitleTextWidget(label: text),
          ]),
        ),
      ),
    );
  }
}
