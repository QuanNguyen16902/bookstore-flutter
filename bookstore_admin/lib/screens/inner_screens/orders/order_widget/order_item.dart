import 'package:bookstore_admin/models/order_model.dart';
import 'package:bookstore_admin/screens/inner_screens/orders/order_widget/order_book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';


class OrderItem extends StatelessWidget {
  const OrderItem({super.key, required this.order, this.visibleItems = 2});

  final OrderModel order;
  final int visibleItems;

  @override
  Widget build(BuildContext context) {
    final totalPrice = order.totalPrice;
    final items = order.items.take(visibleItems).toList();
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      elevation: 0.1,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Order: ${order.getShortOrderId}",
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  "(${order.items.length} Items)",
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(width: 5),
                Text(
                  "\$${totalPrice.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
           const SizedBox(height: 20),
            ...List.generate(items.length, (index) {
              final book = items[index];
              return OrderBook(order: order, book: book);
            }),
            if (order.items.length > 1) const SizedBox(height: 10),
            if (order.items.length > 1)
              Center(
                  child: TextButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    showDragHandle: true,
                    isScrollControlled: true,
                    builder: (context) {
                      return Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.background,
                        ),
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(14),
                          itemCount: order.items.length,
                          itemBuilder: (context, index) {
                            final book = order.items[index];
                            return OrderBook(order: order, book: book);
                          },
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(IconlyBold.arrowRight),
                label: const Text("View all"),
              ))
          ],
        ),
      ),
    );
  }
}