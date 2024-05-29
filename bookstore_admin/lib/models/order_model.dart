import 'package:bookstore_admin/models/orderDetail_model.dart';
import 'package:bookstore_admin/models/shipping_model.dart';
import 'package:bookstore_admin/utils/date.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

enum OrderStatus {confirmed, processing, picking, shipping, delivered }

class OrderModel with ChangeNotifier {
  final String orderId;
  final List<OrderDetailModel> items;
  late final double totalPrice;
  late final String name;
  late final String address;
  late final String phoneNumber;
  late final String paymentMethod;
  final Timestamp orderDate;
  final ShippingModel shipping;
  final String userId;
  final int userPoints;
  late final Timestamp shippingDate;
  OrderStatus status;
  bool confirmed;

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
    required this.userPoints,
    required this.status , // Default status
    this.confirmed = false,
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
  
  String getShortOrderId(){
    return orderId.toString().replaceRange(5, null, '');
  }
   
  void updateStatus(OrderStatus newStatus) {
    status = newStatus;
    notifyListeners();
  }
   void confirmOrder() {
    confirmed = true;
    notifyListeners();
  }
Map<String, dynamic> toFirestore() {
    return {
      'orderId': orderId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalPrice': totalPrice,
      'userName': name,
      'address': address,
      'phoneNumber': phoneNumber,
      'paymentMethod': paymentMethod,
      'orderDate': orderDate,
      'shipping': shipping.toMap(),
      'userId': userId,
      'shippingDate': shippingDate,
      'userPoints': userPoints,
      'confirmed': confirmed,
    };
    }

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      orderId: data['orderId'] ?? '',
      items: (data['items'] as List<dynamic>)
          .map((item) => OrderDetailModel.fromMap(item as DocumentSnapshot<Object?>))
          .toList(),
      totalPrice: (data['totalPrice'] ?? 0).toDouble(),
      name: data['userName'] ?? '',
      address: data['address'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      paymentMethod: data['paymentMethod'] ?? '',
      orderDate: data['orderDate'] ?? Timestamp.now().formatDate,
      shipping: ShippingModel.fromMap(data['shipping'] ?? {}),
      userId: data['userId'] ?? '',
      userPoints: data['userPoints'] ?? 0, 
      status: OrderStatus.values.firstWhere((e) => e.toString().split('.').last == data['status']),
      confirmed: data['confirmed'] ?? false,
      // shippingDate: data['shippingDate'] ?? Timestamp.now().formatDate,
    );
    
  }
  //  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
  //   Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  //   return OrderModel(
  //     orderId: data['orderId'],
  //     items: (data['items'] as List<dynamic>)
  //         .map((item) => OrderDetailModel.fromMap(item))
  //         .toList(),
  //     totalPrice: data['totalPrice'],
  //     name: data['name'],
  //     address: data['address'],
  //     phoneNumber: data['phoneNumber'],
  //     paymentMethod: data['paymentMethod'],
  //     orderDate: data['orderDate'],
  //     shipping: ShippingModel.fromMap(data['shipping']),
  //     userId: data['userId'],
  //     userPoints: data['userPoints'],
  //   );

  // }
  
}

