import 'package:bookstore/inner_screen/orders/order_detail_screen.dart';
import 'package:bookstore/models/order_model.dart';
import 'package:bookstore/providers/order_provider.dart';
import 'package:bookstore/providers/theme_provider.dart';
import 'package:bookstore/services/assets_manager.dart';
import 'package:bookstore/utils/date.dart';
import 'package:bookstore/widgets/empty_cart.dart';
import 'package:bookstore/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderListItem extends StatefulWidget {
  static const routeName = "/OrderListItem";
  const OrderListItem({super.key});

  @override
  State<OrderListItem> createState() => _OrderListItemState();
}

class _OrderListItemState extends State<OrderListItem> {
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: TitleTextWidget(
          label: 'Đơn hàng (${orderProvider.getOrders.length})',
        ),
         
      ),
      body: FutureBuilder<List<OrderModel>>(
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
            itemCount: orderProvider.getOrders.length,
            separatorBuilder: (BuildContext context, index) {
              return const Divider(
                thickness: 1,
                color: Colors.brown,
              );
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.delivery_dining_outlined),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                orderProvider.getOrders[index].status.toString().split('.').last,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .apply(
                                        color: Colors.blue, fontWeightDelta: 1),
                              ),
                              Text(
                                orderProvider.getOrders[index].orderDate.formatDate,
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, OrderDetailScreen.routeName,
                                arguments:
                                    orderProvider.getOrders[index].orderId);
                          },
                          icon: const Icon(
                            Icons.arrow_right,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(Icons.tag),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Order",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium,
                                    ),
                                    Text(
                                      '[#${orderProvider.getOrders[index].getShortOrderId}]',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_month),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Shipping Date",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium,
                                    ),
                                    Text(
                                      // '03 Feb 2024',
                                      orderProvider.getOrders[index].shippingDate.formatDate,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
