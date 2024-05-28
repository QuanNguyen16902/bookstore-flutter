// import 'package:bookstore/inner_screen/orders/order_widget.dart';
// import 'package:bookstore/models/order_model.dart';
// import 'package:bookstore/providers/order_provider.dart';
// import 'package:bookstore/services/assets_manager.dart';
// import 'package:bookstore/widgets/empty_cart.dart';
// import 'package:bookstore/widgets/title_text.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class OrderScreen extends StatefulWidget {
//   static const routeName = "/OrderScreen";
//   const OrderScreen({super.key});

//   @override
//   State<OrderScreen> createState() => _OrderScreenState();
// }

// class _OrderScreenState extends State<OrderScreen> {
//   final bool isEmptyOrders = false;
//   @override
//   Widget build(BuildContext context) {
//     final orderProvider = Provider.of<OrderProvider>(context);
//     return Scaffold(
//         appBar: AppBar(
//           title: const TitleTextWidget(
//             label: 'Place orders',
//           ),
//         ),
//         body: FutureBuilder<List<OrderModel>>(
//           future: orderProvider.fetchOrder(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else if (snapshot.hasError) {
//               return Center(
//                 child: SelectableText(snapshot.error.toString()),
//               );
//             } else if (!snapshot.hasData || orderProvider.getOrders.isEmpty) {
//               return EmptyCartWidget(
//                   imagePath: AssetManager.shoppingBasket,
//                   title: "Chưa có đơn hàng nào",
//                   subtitle: "",
//                   buttonText: "Mua sách",
//                   route: "");
//             }return ListView.separated(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (ctx, index){
//                 return  Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
//                   child: OrderWidgetFree(orderModelAdvanced: orderProvider.getOrders[index],),
//                 );
//               },
//               separatorBuilder: (BuildContext context, int index){
//                 return const Divider();
//               } ,
//             );
//           },
//         ));
//   }
// }
//  isEmptyOrders
//             ? EmptyCartWidget(
//                 imagePath: AssetManager.bagimagesPath,
//                 title: "Giỏ hàng trống",
//                 subtitle: "Chưa có sách trong giỏ hàng",
//                 buttonText: "Whoops", route: SearchScreen.routeName,)
//             :
//               ListView.separated(
//               itemCount: 15,
//               itemBuilder: (context, index) {
//                 return const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 2, vertical: 6),
//                   child: OrderWidgetFree(),
//                 );
//               }, separatorBuilder: (BuildContext context, int index) { 
//                 return const Divider(
//                   thickness: 1,
//                   color: Colors.brown,
//                 );
//                },
//             ),

import 'package:bookstore/inner_screen/orders/order_widget.dart';
import 'package:bookstore/models/order_model.dart';
import 'package:bookstore/providers/order_provider.dart';
import 'package:bookstore/services/assets_manager.dart';
import 'package:bookstore/widgets/empty_cart.dart';
import 'package:bookstore/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = "/OrderScreen";

  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  // bool isEmptyOrders = false; // Remove this line

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const TitleTextWidget(
          label: 'Place orders',
        ),
      ),
      body: 
      FutureBuilder<List<OrderModel>>(
        future: orderProvider.fetchOrder(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: SelectableText(snapshot.error.toString()),
            );
          } else if (!snapshot.hasData || orderProvider.getOrders.isEmpty) {
            return EmptyCartWidget(
              imagePath: AssetManager.shoppingBasket,
              title: "Chưa có đơn hàng nào",
              subtitle: "",
              buttonText: "Mua sách",
              route: "",
            );
          }
          return ListView.separated(
            itemCount: snapshot.data!.length,
            itemBuilder: (ctx, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                child: OrderWidgetFree(orderModel: snapshot.data![index]), // Change here
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
          );
        },
      ),
    );
  }
}
