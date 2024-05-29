import 'package:bookstore/models/orderDetail_model.dart';
import 'package:bookstore/models/shipping_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum OrderStatus {
  confirmed,
  processing,
  picking,
  shipping,
  delivered,
}

class OrderModel with ChangeNotifier {
  final String orderId;
  final List<OrderDetailModel> items;
  final double totalPrice;
  final String name;
  final String address;
  final String phoneNumber;
  final String paymentMethod;
  final Timestamp orderDate;
  final ShippingModel shipping;
  final String userId;
  late final Timestamp shippingDate;
  OrderStatus status;
  bool confirmed = false;

  OrderModel({
    required this.orderId,
    required this.items,
    required this.totalPrice,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.paymentMethod,
    required this.orderDate,
    required this.shipping,
    required this.userId,
    required this.status,// Default status
    required this.confirmed,
  }) {
    shippingDate = _calculateShippingDate();
  }

  Timestamp _calculateShippingDate() {
    final orderDateTime = orderDate.toDate();
    if (shipping.method == 'Hỏa tốc') {
      return Timestamp.fromDate(orderDateTime.add(Duration(days: 1)));
    } else {
      return Timestamp.fromDate(orderDateTime.add(Duration(days: 3)));
    }
  }

  String getFormattedShippingDate() {
    final dateFormat = DateFormat('dd-MM-yyyy');
    return dateFormat.format(shippingDate.toDate());
  }

  // Method to update the status and notify listeners
  void updateStatus(OrderStatus newStatus) {
    status = newStatus;
    notifyListeners();
  }

OrderStatus stepIndexToStatus(int index) {
 
  switch (index) {
    case 0:
      return OrderStatus.processing;
    case 1:
      return OrderStatus.picking;
    case 2:
      return OrderStatus.shipping;
    case 3:
      return OrderStatus.delivered;
    default:
      return OrderStatus.confirmed;
  }
}

  void updateStatusByStepIndex(int stepIndex) {
    status = stepIndexToStatus(stepIndex);
    notifyListeners();
  }

  String get getShortOrderId{
    return orderId.replaceRange(5, null, '');
  }
}
