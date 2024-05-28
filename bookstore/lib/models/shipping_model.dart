class ShippingModel{
  final String method;
  final double cost;
  ShippingModel({
    required this.method,
    required this.cost,
  });
   static double calculateShippingCost(String method) {
    // Nếu phương thức là 'Hỏa tốc', chi phí là $10, ngược lại là $5
    return method == 'Hỏa tốc' ? 10.0 : 5.0;
  }
}