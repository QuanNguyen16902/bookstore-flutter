import 'package:bookstore/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppNameTextWidget extends StatelessWidget {
  const AppNameTextWidget({super.key, this.fontSize = 25});
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        period: const Duration(seconds: 12),
        baseColor: Colors.brown,
        highlightColor: Colors.red,
        child: TitleTextWidget(
          label: "Viper BookStore",
          fontSize: fontSize,
        ));
  }
}
