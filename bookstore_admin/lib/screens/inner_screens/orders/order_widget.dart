
import 'package:bookstore_admin/services/assets_manager.dart';
import 'package:bookstore_admin/widget/subtitle_text.dart';
import 'package:bookstore_admin/widget/title_text.dart';
import 'package:flutter/material.dart';

class OrderWidgetFree extends StatefulWidget {
  const OrderWidgetFree({super.key});

  @override
  State<OrderWidgetFree> createState() => _OrderWidgetFreeState();
}

class _OrderWidgetFreeState extends State<OrderWidgetFree> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              AssetManager.maid_by_stepanie_land,
              height: size.height * 0.15,
              width: size.height * 0.15,
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                        child: TitleTextWidget(
                          label: "Book Title",
                          maxLines: 2,
                          fontSize: 15,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.red,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                  const Row(
                    children: [
                      TitleTextWidget(
                        label: "Price: ",
                        fontSize: 15,
                      ),
                      Flexible(
                        child: SubtitleTextWidget(
                          label: "11.9",
                          fontSize: 15,
                          color: Colors.blue,
                        
                        ),
                      
                      )
                    ],
                  ),
                  const SizedBox(height: 5,),
                  const SubtitleTextWidget(label: "Qty: 5", fontSize: 15,)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
