import 'package:bookstore/inner_screen/loadding_widget.dart';
import 'package:bookstore/providers/book_provider.dart';
import 'package:bookstore/providers/cart_provider.dart';
import 'package:bookstore/providers/user_provider.dart';
import 'package:bookstore/screens/cart/bottom_checkout.dart';
import 'package:bookstore/screens/cart/cart_widget.dart';
import 'package:bookstore/screens/checkout_screen.dart';
import 'package:bookstore/screens/search_screen.dart';
import 'package:bookstore/services/app_function.dart';
import 'package:bookstore/services/assets_manager.dart';
import 'package:bookstore/widgets/empty_cart.dart';
import 'package:bookstore/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final bookProvider = Provider.of<BookProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
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
            bottomSheet: BottonCheckoutWidget(
              function: () {
                // await placeOrderAdvanced(
                //     cartProvider: cartProvider,
                //     bookProvider: bookProvider,
                //     userProvider: userProvider,
                //     );
                Navigator.pushNamed(context, PlaceOrderScreen.routeName);
              },
            ),
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
                          fct: () async {
                            cartProvider.clearCartFromFirebase();
                            // cartProvider.clearLocalCart()
                          });
                    },
                    icon: const Icon(
                      Icons.delete_sweep_rounded,
                      color: Colors.red,
                    ))
              ],
            ),
            body: LoadingWidget(
              isLoading: isLoading,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartProvider.getCartItems.length,
                      itemBuilder: (context, index) {
                        return ChangeNotifierProvider.value(
                            value: cartProvider.getCartItems.values
                                .toList()[index],
                            child: const CartWidget());
                      },
                    ),
                  ),
                  const SizedBox(
                    height: kBottomNavigationBarHeight + 10,
                  )
                ],
              ),
            ),
          );
  }

//   Future<void> placeOrderAdvanced({
//     required CartProvider cartProvider,
//     required BookProvider bookProvider,
//     required UserProvider userProvider,
//   }) async {
//     final auth = FirebaseAuth.instance;
//     User? user = auth.currentUser;
//     if (user == null) {}
//     final uid = user!.uid;
//     try {
//       setState(() {
//         isLoading = true;
//       });
//       cartProvider.getCartItems.forEach((key, value) async {
//         final getCurrentBook = bookProvider.findBookById(value.bookId);
//         final orderId = Uuid().v4();
//         await FirebaseFirestore.instance
//             .collection("orders")
//             .doc(orderId)
//             .set({
//           "orderId": orderId,
//           "userId": uid,
//           "bookId": value.bookId,
//           "bookTitle": getCurrentBook!.bookTitle,
//           "price": double.parse(getCurrentBook.bookPrice) * value.quantity,
//           "totalPrice": cartProvider.getTotal(bookProvider: bookProvider),
//           "quantity": value.quantity,
//           "imageUrl": getCurrentBook.bookImage,
//           "userName": userProvider.getUserModel!.userName,
//           "orderDate": Timestamp.now(),
//         });
//       });
//       await cartProvider.clearCartFromFirebase();
//       cartProvider.clearLocalCart();
//     } catch (e) {
//       await MyAppFunction.showErrorOrWarningDialog(
//           context: context, subtitle: e.toString(), fct: () {});
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }


}
