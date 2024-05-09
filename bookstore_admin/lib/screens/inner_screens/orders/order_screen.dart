
import 'package:bookstore_admin/screens/inner_screens/orders/order_widget.dart';
import 'package:bookstore_admin/services/assets_manager.dart';
import 'package:bookstore_admin/widget/empty_cart.dart';
import 'package:bookstore_admin/widget/title_text.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = "/OrderScreen";
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final bool isEmptyOrders = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const TitleTextWidget(
            label: 'Place orders',
          ),
        ),
        body: isEmptyOrders
            ? EmptyCartWidget(
                imagePath: AssetManager.bagimagesPath,
                title: "Giỏ hàng trống",
                subtitle: "Chưa có sách trong giỏ hàng",
                buttonText: "Whoops")
            :
              ListView.separated(
              itemCount: 15,
              itemBuilder: (context, index) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                  child: OrderWidgetFree(),
                );
              }, separatorBuilder: (BuildContext context, int index) { 
                return const Divider(
                  thickness: 1,
                  color: Colors.brown,
                );
               },
            ),
            );
  }
}
