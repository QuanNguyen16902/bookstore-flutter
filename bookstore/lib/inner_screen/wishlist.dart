import 'package:bookstore/providers/wishlist_provider.dart';
import 'package:bookstore/services/app_function.dart';
import 'package:bookstore/services/assets_manager.dart';
import 'package:bookstore/widgets/empty_cart.dart';
import 'package:bookstore/widgets/products/book_widget.dart';
import 'package:bookstore/widgets/title_text.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishListScreen extends StatelessWidget {
  const WishListScreen({super.key});
  static const routeName = "/WishListScreen";
  final bool isEmpty = true;
  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    return wishlistProvider.getWishlistItems.isEmpty
        ? Scaffold(
            body: EmptyCartWidget(
            buttonText: "Go Shopping",
            imagePath: AssetManager.wishlist,
            title: 'Chưa có cuốn sách nào!',
            subtitle: 'Giỏ hàng của bạn đang trống! Hãy thêm sản phẩm',
          ))
        : Scaffold(
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
              title: TitleTextWidget(
                label: "Yêu thích (${wishlistProvider.getWishlistItems.length})",
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      MyAppFunction.showErrorOrWarningDialog(
                      isError: false,
                      context: context, 
                      subtitle: "Clear wishlist", 
                      fct: (){
                          wishlistProvider.clearWishlist();
                      }
                      );
                    },
                    icon: const Icon(
                      Icons.delete_sweep_rounded,
                      color: Colors.red,
                    ))
              ],
            ),
            body: 
            DynamicHeightGridView(
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    builder: (context, index) {
                      return  Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BookWidget(bookId: wishlistProvider.getWishlistItems.values.toList()[index].bookId,),
                      );
                    },
                    itemCount: wishlistProvider.getWishlistItems.length,
                    crossAxisCount: 2),
          );
  }
}
