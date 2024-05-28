// import 'package:bookstore/models/order_model.dart';
// import 'package:bookstore/widgets/subtitle_text.dart';
// import 'package:bookstore/widgets/title_text.dart';
// import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
// import 'package:flutter/material.dart';

// class OrderWidgetFree extends StatefulWidget {
//   const OrderWidgetFree({super.key, required this.orderModelAdvanced});
//   final OrderModelAdvanced orderModelAdvanced;

//   @override
//   State<OrderWidgetFree> createState() => _OrderWidgetFreeState();
// }

// class _OrderWidgetFreeState extends State<OrderWidgetFree> {
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(8.0),
//             child: FancyShimmerImage(
//               imageUrl: widget.orderModelAdvanced.imageUrl,
//               height: size.height * 0.15,
//               width: size.height * 0.15,
//             ),
//           ),
//           Flexible(
//             child: Padding(
//               padding: const EdgeInsets.all(1.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                        Flexible(
//                         child: TitleTextWidget(
//                           label: widget.orderModelAdvanced.bookTitle,
//                           maxLines: 2,
//                           fontSize: 15,
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: () {},
//                         icon: const Icon(
//                           Icons.clear,
//                           color: Colors.red,
//                           size: 22,
//                         ),
//                       ),
//                     ],
//                   ),
//                    Row(
//                     children: [
//                       const TitleTextWidget(
//                         label: "Price: ",
//                         fontSize: 15,
//                       ),
//                       Flexible(
//                         child: SubtitleTextWidget(
//                           label: "${widget.orderModelAdvanced.price} \$",
//                           fontSize: 15,
//                           color: Colors.blue,
                        
//                         ),
                      
//                       )
//                     ],
//                   ),
//                   const SizedBox(height: 5,),
//                    SubtitleTextWidget(label: "Qty: ${widget.orderModelAdvanced.quantity}", fontSize: 15,)
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

import 'package:bookstore/models/order_model.dart';
import 'package:bookstore/widgets/subtitle_text.dart';
import 'package:bookstore/widgets/title_text.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

class OrderWidgetFree extends StatefulWidget {
  const OrderWidgetFree({Key? key, required this.orderModel}) : super(key: key);
  final OrderModel orderModel;

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
            child: FancyShimmerImage(
              imageUrl: widget.orderModel.items.first.bookImage,
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
                      Flexible(
                        child: TitleTextWidget(
                          label: widget.orderModel.items.first.bookTitle,
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
                  Row(
                    children: [
                      const TitleTextWidget(
                        label: "Price: ",
                        fontSize: 15,
                      ),
                      Flexible(
                        child: SubtitleTextWidget(
                          label:
                              "\$${widget.orderModel.totalPrice.toStringAsFixed(2)}",
                          fontSize: 15,
                          color: Colors.blue,
                          
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  SubtitleTextWidget(
                    label: "Qty: ${widget.orderModel.items.length}",
                    fontSize: 15,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
