import 'package:cloud_firestore/cloud_firestore.dart';

class ShippingModel{
  final String method;
  final double cost;
  ShippingModel({
    required this.method,
    required this.cost,
  });
  factory ShippingModel.fromMap(DocumentSnapshot doc) {
     Map map = doc.data() as Map<String, dynamic>;
    return ShippingModel(
      method: map['method'] ?? '',
      cost: map['cost'] ?? 0.0,
    );
  }

  // Add toMap method
  Map<String, dynamic> toMap() {
    return {
      'method': method,
      'cost': cost,
    };
  }
}