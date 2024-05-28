import 'package:bookstore/widgets/subtitle_text.dart';
import 'package:bookstore/widgets/title_text.dart';
import 'package:flutter/material.dart';

class EmptyCartWidget extends StatelessWidget {
  const EmptyCartWidget({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    this.buttonText,
    required this.route,
    
  });

  final String imagePath, title, subtitle, route;
  final String? buttonText;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Image.asset(
            imagePath,
            width: double.infinity,
            height: size.height * 0.35,
            // scale: 10,
          ),
          const SizedBox(
            height: 15,
          ),
          const TitleTextWidget(
            label: "Whoops",
            fontSize: 40,
            color: Colors.red,
          ),
          SubtitleTextWidget(
            label: title,
            fontWeight: FontWeight.w600,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SubtitleTextWidget(
              label: subtitle,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
              onPressed: () {
                Navigator.pushNamed(context, route);
              },
              child: Text(
                buttonText!,
                style: const TextStyle(color: Colors.white),
              ))
        ],
      ),
    );
  }
}
