import 'package:bookstore/models/orderDetail_model.dart';
import 'package:bookstore/models/order_model.dart';
import 'package:bookstore/models/shipping_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderProvider with ChangeNotifier {
  final List<OrderModel> orders = [];
  List<OrderModel> get getOrders => orders;

  OrderModel? findOrderById(String orderId) {
    if (orders.where((element) => element.orderId == orderId).isEmpty) {
      return null;
    }
    return orders.firstWhere((element) => element.orderId == orderId);
  }
  Future<List<OrderModel>> fetchOrder() async {
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    var uid = user!.uid;
    try {
      QuerySnapshot orderSnapshot = await FirebaseFirestore.instance
          .collection("orders")
          .where('userId', isEqualTo: uid)
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
            
           status: OrderStatus.values.firstWhere((e) => e.toString().split('.').last == element.get('status')), 
           confirmed: element.get('confirmed'),
    
          ),
        );
      }
      return orders;
    } catch (e) {
      rethrow;
    }
  }
}
