import 'package:bookstore/services/assets_manager.dart';
import 'package:bookstore/widgets/empty_cart.dart';
import 'package:bookstore/widgets/products/book_widget.dart';
import 'package:bookstore/widgets/title_text.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';

class ViewedRecentlyScreen extends StatelessWidget {
  const ViewedRecentlyScreen({super.key});
  static const routeName = "/ViewedRecentlyScreen";
  final bool isEmpty = true;
  @override
  Widget build(BuildContext context) {
    return isEmpty
        ? Scaffold(
            body: EmptyCartWidget(
            buttonText: "Go Shopping",
            imagePath: AssetManager.shoppingBasket,
            title: 'Chưa có cuốn sách nào trong wishlist!',
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
              title: const TitleTextWidget(
                label: "Đã xem gần đây (6)",
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
            body: 
            DynamicHeightGridView(
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    builder: (context, index) {
                      return const BookWidget();
                    },
                    itemCount: 10,
                    crossAxisCount: 2),
          );
  }
}
