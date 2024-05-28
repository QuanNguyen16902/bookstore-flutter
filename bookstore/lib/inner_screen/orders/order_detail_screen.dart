import 'package:bookstore/inner_screen/orders/order_status_stepper.dart';
import 'package:bookstore/inner_screen/orders/order_widget/order_item.dart';
import 'package:bookstore/models/orderDetail_model.dart';
import 'package:bookstore/models/order_model.dart';
import 'package:bookstore/providers/order_provider.dart';
import 'package:bookstore/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

class OrderDetailScreen extends StatelessWidget {
  static const routeName = "/OrderDetailScreen";
  const OrderDetailScreen({super.key,  this.orderDetail});
  final OrderDetailModel? orderDetail;
  
  @override
  Widget build(BuildContext context) {
    const steps = OrderStatus.values;
    final orderProviders = Provider.of<OrderProvider>(context);
    // final cartProvider = Provider.of<CartProvider>(context);
    String? orderId = ModalRoute.of(context)!.settings.arguments as String?;
    final getCurrentOrder = orderProviders.findOrderById(orderId!);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
      ),
      body: ListView(
        children: [
          OrderStatusStepper(order: getCurrentOrder!),
          Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            elevation: 0.1,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Order: [#${getCurrentOrder!.orderId.replaceRange(5, null, '')}]",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Chip(
                            shape: const StadiumBorder(),
                            side: BorderSide.none,
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .primaryContainer
                                .withOpacity(0.4),
                            labelPadding: EdgeInsets.zero,
                            avatar: const Icon(Icons.fire_truck),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            label: Text(getCurrentOrder.status.toString().split('.').last),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Delivery Estimate"),
                        Text(
                          getCurrentOrder.shippingDate.formatDate,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "${getCurrentOrder!.name}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        const Icon(IconlyLight.home, size: 15),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(child: Text(getCurrentOrder.address))
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        const Icon(IconlyLight.call, size: 15),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Text(getCurrentOrder.phoneNumber),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Payment Method"),
                        Text(
                          getCurrentOrder.paymentMethod,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ]),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          OrderItem(order: getCurrentOrder),
        ],
      ),
    );
  }
  static Route route(OrderDetailModel orderDetail) {
    return MaterialPageRoute(
      builder: (context) => OrderDetailScreen(orderDetail: orderDetail),
      settings: RouteSettings(name: routeName),
    );
  }
}
