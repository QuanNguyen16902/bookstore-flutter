import 'package:bookstore/models/order_model.dart';
import 'package:bookstore/providers/book_provider.dart';
import 'package:bookstore/providers/cart_provider.dart';
import 'package:bookstore/providers/user_provider.dart';
import 'package:bookstore/services/app_function.dart';
import 'package:bookstore/services/assets_manager.dart';
import 'package:bookstore/widgets/appname_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class PlaceOrderScreen extends StatefulWidget {
  static const routeName = "/PlaceOrderScreen";

  const PlaceOrderScreen({Key? key}) : super(key: key);

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _address = '';
  String _phoneNumber = '';
  String _paymentMethod = 'Tiền mặt';
  String _shippingMethod = 'Hỏa tốc';
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final bookProvider = Provider.of<BookProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final cartItems = cartProvider.getCartItems.values.toList();
    final totalPrice = cartProvider.getTotal(bookProvider: bookProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              "${AssetManager.imagesPath}/book-shop.png",
              width: 40,
              height: 40,
              fit: BoxFit.fill,
            ),
          ),
        ),
        title: const AppNameTextWidget(
          fontSize: 20,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                final book = bookProvider.findBookById(item.bookId);

                if (book == null) {
                  print(
                      'Không tìm thấy book với ID: ${item.bookId}'); // Debug print
                  return SizedBox.shrink();
                }

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    leading: SizedBox(
                      width: 50,
                      height: 50,
                      child: Image.network(
                        book.bookImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      book.bookTitle,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('by ${book.bookAuthor}'),
                    trailing: Text(
                      '\$${(double.parse(book.bookPrice) * item.quantity).toStringAsFixed(2)}/ ${item.quantity} items',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                );
              },
            ),
            Divider(thickness: 2, height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Shipping Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _name = value!;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _address = value!;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _phoneNumber = value!;
                    },
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Shipping Method',
                      border: OutlineInputBorder(),
                    ),
                    value: _shippingMethod,
                    items: ['Hỏa tốc', 'Thường']
                        .map((method) => DropdownMenuItem(
                              value: method,
                              child: Text(method == 'Hỏa tốc' ? method + '(1 ngày)': method + '(3 ngày)') ,
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _shippingMethod = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Phương thức thanh toán',
                      border: OutlineInputBorder(),
                    ),
                    value: _paymentMethod,
                    items: ['Tiền mặt', 'Credit Card', 'Paypal']
                        .map((method) => DropdownMenuItem(
                              value: method,
                              child: Text(method),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _paymentMethod = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    placeOrderAdvanced(
                      cartProvider: cartProvider,
                      bookProvider: bookProvider,
                      userProvider: userProvider,
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Text(
                    'Place Order',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  
 
  Future<void> placeOrderAdvanced({
    required CartProvider cartProvider,
    required BookProvider bookProvider,
    required UserProvider userProvider,
  }) async {
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user == null) {
      return;
    }
    final uid = user.uid;
    try {
      setState(() {
        isLoading = true;
      });

      final orderDetails = cartProvider.getCartItems.values.toList();
      final orderId = Uuid().v4();
      final orderDate = Timestamp.now();

      List<Map<String, dynamic>> items = []; // Create a list to store items

      for (var detail in orderDetails) {
        final getCurrentBook = bookProvider.findBookById(detail.bookId);

        items.add({
          "bookId": detail.bookId,
          "bookTitle": getCurrentBook!.bookTitle,
          "bookAuthor": getCurrentBook.bookAuthor,
          "bookImage": getCurrentBook.bookImage,
          "bookPrice": getCurrentBook.bookPrice,
          "quantity": detail.quantity,
        });
      }

      await FirebaseFirestore.instance.collection("orders").doc(orderId).set({
        "orderId": orderId,
        "userId": uid,
        "items": items, // Add items list to the order
        "totalPrice": cartProvider.getTotal(bookProvider: bookProvider),
        "userName": _name,
        "address": _address,
        "phoneNumber": _phoneNumber,
        "paymentMethod": "Credit Card", // You can modify this field as needed
        "orderDate": orderDate,
        "shippingMethod": _shippingMethod, // You can modify this field as needed
        "shippingCost": 0, // You can modify this field as needed
        "status" : OrderStatus.confirmed.toString().split('.').last,
        "confirmed" : false,
      });

      await cartProvider.clearCartFromFirebase();
      cartProvider.clearLocalCart();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Order Placed'),
          content: const Text('Thank you for your purchase!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Go back to the previous screen
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      await MyAppFunction.showErrorOrWarningDialog(
        context: context,
        subtitle: e.toString(),
        fct: () {},
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}