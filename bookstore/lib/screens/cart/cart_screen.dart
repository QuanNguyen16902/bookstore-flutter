import 'package:bookstore/screens/cart/bottom_checkout.dart';
import 'package:bookstore/screens/cart/cart_widget.dart';
import 'package:bookstore/services/assets_manager.dart';
import 'package:bookstore/widgets/empty_cart.dart';
import 'package:bookstore/widgets/title_text.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  final bool isEmpty = false;
  @override
  Widget build(BuildContext context) {
    return isEmpty
        ? Scaffold(
            body: EmptyCartWidget(
            buttonText: "Go Shopping",
            imagePath: AssetManager.shoppingBasket,
            title: 'Giỏ hàng trống',
            subtitle: 'Giỏ hàng của bạn đang trống! Hãy thêm sản phẩm',
          ))
        : Scaffold(
            bottomSheet: const BottonCheckoutWidget(),
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              leading: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  "${AssetManager.imagesPath}/book-shop.png",
                  width: 40,
                  height: 40,
                  fit: BoxFit.fill,
                ),
              ),
              title: const TitleTextWidget(
                label: "Cart (6)",
              ),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.delete_sweep_rounded,
                      color: Colors.red,
                    ))
              ],
            ),
            body: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return const CartWidget();
              },
            ),
          );
  }
}
