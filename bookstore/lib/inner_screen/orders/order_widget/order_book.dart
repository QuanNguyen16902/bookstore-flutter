import 'package:bookstore/inner_screen/orders/order_detail_screen.dart';
import 'package:bookstore/models/orderDetail_model.dart';
import 'package:bookstore/models/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderBook extends StatelessWidget {
  const OrderBook({
    super.key,
    required this.order,
    required this.book,
  });

  final OrderModel order;
  final OrderDetailModel book;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        _navigateToOrderDetailScreen(context, order.orderId);
      },
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 90,
            width: 90,
            margin: const EdgeInsets.only(right: 10, bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(book.bookImage),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.bookTitle,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  book.bookAuthor,
                  style: Theme.of(context).textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${book.bookPrice}",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text("Qty: ${book.quantity}")
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _navigateToOrderDetailScreen(BuildContext context, String orderId) async {
    OrderDetailModel? orderDetail = await _fetchOrderDetail(orderId);
    if (orderDetail != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => OrderDetailScreen(orderDetail: orderDetail),
        ),
      );
    } else {
      Text( "order detail not found");
    }
  }

  Future<OrderDetailModel?> _fetchOrderDetail(String orderId) async {
    try {
      final orderDetailSnapshot = await FirebaseFirestore.instance
          .collection('orderDetails')
          .where('orderId', isEqualTo: orderId)
          .get();

      if (orderDetailSnapshot.docs.isNotEmpty) {
        return OrderDetailModel.fromFirestore(orderDetailSnapshot.docs.first);
      }
    } catch (e) {
      print("Error fetching order details: $e");
    }
    return null;
  }
}
