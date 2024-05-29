import 'package:bookstore_admin/models/orderDetail_model.dart';
import 'package:bookstore_admin/models/order_model.dart';
import 'package:bookstore_admin/models/shipping_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderProvider with ChangeNotifier {
  List<OrderModel> orders = [];
  List<OrderModel> get getOrders => orders;

  List<OrderModel> searchByUserId({required String searchText}) {
    List<OrderModel> searchList = orders
        .where((element) =>
            element.userId.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    return searchList;
  }
  OrderModel? findOrderById(String orderId) {
    if (orders.where((element) => element.orderId == orderId).isEmpty) {
      return null;
    }
    return orders.firstWhere((element) => element.orderId == orderId);
  }
  Future<List<OrderModel>> fetchOrder() async {
    try {
      QuerySnapshot orderSnapshot = await FirebaseFirestore.instance
          .collection("orders")
          .get();

      orders.clear();
      for (var element in orderSnapshot.docs) {
        List<OrderDetailModel> items = [];
        var orderDetails = element.get("items");
        for (var detail in orderDetails) {
          items.add(
            OrderDetailModel(
              bookId: detail["bookId"],
              bookTitle: detail["bookTitle"],
              bookAuthor: detail["bookAuthor"],
              bookImage: detail["bookImage"],
              bookPrice: double.parse(detail["bookPrice"]),
              quantity: detail["quantity"],
            ),
          );
        }
        orders.add(
          OrderModel(
            orderId: element.get("orderId"),
            userId: element.get("userId"),
            items: items,
            totalPrice: double.parse(element.get("totalPrice").toString()),
            name: element.get("userName"),
            address: element.get("address"),
            phoneNumber: element.get("phoneNumber"),
            paymentMethod: element.get("paymentMethod"),
            orderDate: element.get("orderDate"),
            shipping: ShippingModel(
              method: element.get("shippingMethod"),
              cost: double.parse(element.get("shippingCost").toString()),
            ), 
            userPoints: 1, 
            confirmed: element.get('confirmed'),
            status: OrderStatus.values.firstWhere((e) => e.toString().split('.').last == element.get('status'))
            
          ),
        );
      }
      return orders;
    } catch (e) {
      rethrow;
    }
  }
  // final orderDb = FirebaseFirestore.instance.collection("orders");
  // Stream<List<OrderModel>> fetchOrdersStream() {
  //   try {
  //     return orderDb.snapshots().map((snapshot){
  //         orders.clear();
  //         for(var element in snapshot.docs){
  //              orders.insert(0, OrderModel.fromFirestore(element));
  //         }
  //     return orders;
  //     });
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
