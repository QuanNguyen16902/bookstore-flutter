import 'package:bookstore/providers/cart_provider.dart';
import 'package:bookstore/screens/cart/bottom_checkout.dart';
import 'package:bookstore/screens/cart/cart_widget.dart';
import 'package:bookstore/screens/search_screen.dart';
import 'package:bookstore/services/app_function.dart';
import 'package:bookstore/services/assets_manager.dart';
import 'package:bookstore/widgets/empty_cart.dart';
import 'package:bookstore/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  final bool isEmpty = false;
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return cartProvider.getCartItems.isEmpty
        ? Scaffold(
            body: EmptyCartWidget(
            buttonText: "Go Shopping",
            imagePath: AssetManager.shoppingBasket,
            title: 'Giỏ hàng trống',
            subtitle: 'Giỏ hàng của bạn đang trống! Hãy thêm sản phẩm',
            route: SearchScreen.routeName,
          ))
        : Scaffold(
            bottomSheet: const BottonCheckoutWidget(),
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              leading: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  width: 40,
                  height: 40,
                  fit: BoxFit.fill,
                  '${AssetManager.imagesPath}/book-shop.png',
                ),
              ),
              title: TitleTextWidget(
                label: "Cart (${cartProvider.getCartItems.length})",
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      MyAppFunction.showErrorOrWarningDialog(
                          isError: false,
                          context: context,
                          subtitle: "Xóa giỏ hàng",
                          fct: () {
                            cartProvider.clearLocalCart();
                          });
                    },
                    icon: const Icon(
                      Icons.delete_sweep_rounded,
                      color: Colors.red,
                    ))
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartProvider.getCartItems.length,
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider.value(
                          value:
                              cartProvider.getCartItems.values.toList()[index],
                          child: const CartWidget());
                    },
                  ),
                ),
                const SizedBox(
                  height: kBottomNavigationBarHeight + 10,
                )
              ],
            ),
          );
  }
}
