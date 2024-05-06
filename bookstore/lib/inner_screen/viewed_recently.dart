import 'package:bookstore/providers/viewed_book_provider.dart';
import 'package:bookstore/services/app_function.dart';
import 'package:bookstore/services/assets_manager.dart';
import 'package:bookstore/widgets/empty_cart.dart';
import 'package:bookstore/widgets/products/book_widget.dart';
import 'package:bookstore/widgets/title_text.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewedRecentlyScreen extends StatelessWidget {
  const ViewedRecentlyScreen({super.key});
  static const routeName = "/ViewedRecentlyScreen";
  final bool isEmpty = true;
  @override
  Widget build(BuildContext context) {
    final viewedBookProvider = Provider.of<ViewedBookProvider>(context);
    return viewedBookProvider.getViewedBookItems.isEmpty
        ? Scaffold(
            body: EmptyCartWidget(
            buttonText: "Go Shopping",
            imagePath: AssetManager.shoppingBasket,
            title: 'Chưa có cuốn sách nào trong mục đã xem!',
            subtitle: '',
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
                label:
                    "Đã xem gần đây (${viewedBookProvider.getViewedBookItems.length})",
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      MyAppFunction.showErrorOrWarningDialog(context: context,
                      isError: false,
                       subtitle: "Clear Viewed recently", 
                       fct: (){
                        viewedBookProvider.clearViewedRecently();
                       });
                    },
                    icon: const Icon(
                      Icons.delete_sweep_rounded,
                      color: Colors.red,
                    ))
              ],
            ),
            body: DynamicHeightGridView(
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                builder: (context, index) {
                  return BookWidget(
                    bookId: viewedBookProvider.getViewedBookItems.values
                        .toList()[index]
                        .bookId,
                  );
                },
                itemCount: viewedBookProvider.getViewedBookItems.length,
                crossAxisCount: 2),
          );
  }
}
