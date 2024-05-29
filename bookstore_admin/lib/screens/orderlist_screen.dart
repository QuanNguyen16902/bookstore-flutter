import 'package:bookstore_admin/models/order_model.dart';
import 'package:bookstore_admin/providers/order_provider.dart';
import 'package:bookstore_admin/screens/inner_screens/orders/order_manage.dart';
import 'package:bookstore_admin/services/assets_manager.dart';
import 'package:bookstore_admin/utils/date.dart';
import 'package:bookstore_admin/widget/appname_text.dart';
import 'package:bookstore_admin/widget/empty_cart.dart';
import 'package:bookstore_admin/widget/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderListItem extends StatefulWidget {
  @override
  const OrderListItem({super.key});
  static const routeName = "/OrderListItem";

  @override
  State<OrderListItem> createState() => _OrderListItemState();
}

class _OrderListItemState extends State<OrderListItem> {
  late TextEditingController searchTextController;
  @override
  void initState() {
    searchTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  List<OrderModel> orderListSearch = [];
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const AppNameTextWidget(
            fontSize: 20,
          ),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "${AssetManager.imagesPath}/book-shop.png",
              width: 40,
              height: 40,
              fit: BoxFit.fill,
            ),
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
              );
            }
            return Column(
              children: [
              TextField(
                controller: searchTextController,
                decoration: InputDecoration(
                  hintText: "Tìm kiếm",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      // setState(() {
                      FocusScope.of(context).unfocus();
                      searchTextController.clear();
                      // } );
                    },
                    child: const Icon(Icons.clear),
                  ),
                ),
                 onChanged: (value) {
                          setState(() {
                            orderListSearch = orderProvider.searchByUserId(
                                searchText: searchTextController.text);
                          });
                        },
                // onSubmitted: (value) {
                //   orderListSearch = orderProvider.searchByUserId(
                //       searchText: searchTextController.text);
                // },
              ),
              const SizedBox(
                height: 15,
              ),
              if (searchTextController.text.isNotEmpty &&
                  orderListSearch.isEmpty) ...[
                const Center(
                    child: TitleTextWidget(label: "Không tìm thấy sách nào")),
              ],
              Expanded(
                child: ListView.separated(
                  itemCount: searchTextController.text.isNotEmpty
                              ? orderListSearch.length
                              : orderProvider.getOrders.length,
                  separatorBuilder: (BuildContext context, index) {
                    return const Divider(
                      thickness: 1,
                      color: Colors.brown,
                    );
                  },
                
                  itemBuilder: (context, index) {
                    return searchTextController.text.isNotEmpty ? 
                   
                    Padding(
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
                                      orderListSearch[index].status
                                          .toString()
                                          .split('.')
                                          .last
                                          .toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .apply(
                                              color: Colors.blue,
                                              fontWeightDelta: 1),
                                    ),
                                    Text(
                                      (orderListSearch[index].orderDate.formatDate),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ("Order of ${orderListSearch[index].userId.toString().replaceRange(5, null, '')}"),
                                    style: Theme.of(context).textTheme.labelSmall,
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return UpdateOrderScreen(
                                          orderModel:
                                              orderListSearch[index],
                                        );
                                      },
                                    ),
                                  );
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Order",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium,
                                          ),
                                          Text(
                                            '[#${orderListSearch[index].orderId.toString().replaceRange(5, null, '')}]',
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Shipping Date",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium,
                                          ),
                                          Text(
                                            // '03 Feb 2024',
                                            orderListSearch[index]
                                                .shippingDate.formatDate,
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
                    )
                    :
                    Padding(
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
                                      orderProvider.getOrders[index].status
                                          .toString()
                                          .split('.')
                                          .last
                                          .toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .apply(
                                              color: Colors.blue,
                                              fontWeightDelta: 1),
                                    ),
                                    Text(
                                      (orderProvider
                                          .getOrders[index].orderDate.formatDate),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ("Order of ${orderProvider.getOrders[index].userId.toString().replaceRange(5, null, '')}"),
                                    style: Theme.of(context).textTheme.labelSmall,
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return UpdateOrderScreen(
                                          orderModel:
                                              orderProvider.getOrders[index],
                                        );
                                      },
                                    ),
                                  );
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Order",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium,
                                          ),
                                          Text(
                                            '[#${orderProvider.getOrders[index].orderId.toString().replaceRange(5, null, '')}]',
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Shipping Date",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium,
                                          ),
                                          Text(
                                            // '03 Feb 2024',
                                            orderProvider.getOrders[index]
                                                .shippingDate.formatDate,
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
                    )
                    ;
                  },
                ),
              )
            ]);
          },
        ),
      ),
    );
  }
}
