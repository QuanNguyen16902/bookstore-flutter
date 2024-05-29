import 'package:bookstore/models/address_model.dart';
import 'package:bookstore/models/order_model.dart';
import 'package:bookstore/providers/book_provider.dart';
import 'package:bookstore/providers/cart_provider.dart';
import 'package:bookstore/providers/user_provider.dart';
import 'package:bookstore/screens/home_screen.dart';
import 'package:bookstore/services/app_function.dart';
import 'package:bookstore/services/assets_manager.dart';
import 'package:bookstore/widgets/appname_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
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
  double _shippingCost = 10.0;
  AddressModel? _selectedAddress;
  List<AddressModel> _addresses = [];

  @override
  void initState() {
    super.initState();
    _fetchAddresses();
  }

  Future<void> _fetchAddresses() async {
    // Get the current user's ID
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      try {
        // Fetch the user document from Firestore
        final userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        final userData = userSnapshot.data();

        if (userData != null && userData['addresses'] != null) {
          final List<dynamic> addressesData = userData['addresses'];
          final List<AddressModel> addresses =
              addressesData.map((data) => AddressModel.fromMap(data)).toList();
          setState(() {
            _addresses = addresses;
          });
        } else {
          print('No addresses found for the user');
        }
      } catch (e) {
        // Handle errors while fetching addresses
        print('Error fetching addresses: $e');
      }
    } else {
      print('No user logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final bookProvider = Provider.of<BookProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final cartItems = cartProvider.getCartItems.values.toList();
    final totalPrice = cartProvider.getTotal(bookProvider: bookProvider);
    final totalCost = totalPrice +
        _shippingCost -
        _getUserDiscount(
            userPoints: userProvider.getUserPoints(),
            cartProvider: cartProvider,
            bookProvider: bookProvider);

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
              physics: const NeverScrollableScrollPhysics(),
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
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.normal),
                    ),
                    Text(
                      '\$${totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Shipping Cost:',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.normal),
                    ),
                    Text(
                      '\$${_shippingCost.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Discount:',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.normal),
                    ),
                    Text(
                      '-\$${_getUserDiscount(
                        cartProvider: cartProvider,
                        bookProvider: bookProvider,
                        userPoints: userProvider.getUserModel!.userPoint,
                      )}',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
            Divider(thickness: 2, height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Cost:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${totalCost.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 4, 7, 4)),
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
                    decoration: const InputDecoration(
                      labelText: 'Tên người nhận',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Hãy nhập tên người nhận';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _name = value!;
                    },
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<AddressModel>(
                    value: _selectedAddress,
                    decoration: InputDecoration(
                      labelText: 'Địa chỉ',
                      border: OutlineInputBorder(),
                    ),
                    items: _addresses.map((address) {
                      return DropdownMenuItem<AddressModel>(
                        value: address,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${address.street}, '),
                            Text('${address.state}, '),
                            Text('${address.city}, '),
                            Text('${address.country}, '),
                            Text('${address.zipCode}, '),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (AddressModel? newValue) {
                      setState(() {
                        _selectedAddress = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Hãy chọn địa chỉ';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _address = _address =
                          '${value!.street}, ${value.city}, ${value.state}, ${value.country}, ${value.zipCode}';
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Số điện thoại',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Hãy nhập Sđt';
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
                              child: Text(method == 'Hỏa tốc'
                                  ? method + '(1 ngày)'
                                  : method + '(3 ngày)'),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _shippingMethod = value!;
                        _shippingCost = value == 'Hỏa tốc' ? 10.0 : 5.0;
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
                     
                    if (_paymentMethod == 'Paypal') {
                       _startPaypalPayment(
                          cartProvider: cartProvider,
                          context: context,
                          bookProvider: bookProvider,
                          userProvider: userProvider);
                    } else {
                      placeOrderAdvanced(
                        cartProvider: cartProvider,
                        bookProvider: bookProvider,
                        userProvider: userProvider,
                      );
                    }
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

  void _startPaypalPayment({
    required BuildContext context,
    required CartProvider cartProvider,
    required BookProvider bookProvider,
    required UserProvider userProvider,
  }) async {
    try {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => UsePaypal(
            sandboxMode: true,
            clientId:
                "AYA40mFYAXr9ZDmnHvMEh6HrCryKVCfaNtqYU7Ybe5WEsuDrcsXHFeXP3woBcbKBqRfU9eNAZBVgRKg9",
            secretKey:
                "EH4-XkpQeBrGJDFkkWwRq5tvFzmEA8q5qTfznwE9RyH5rgm8vBrY7r1YjsJgeeZAPfT__WYwdK1hje3H",
            returnURL: HomeScreen.routeName,
            cancelURL: PlaceOrderScreen.routeName,
            transactions: [
              {
                "amount": {
                  "total": cartProvider.getTotal(bookProvider: bookProvider) +
                      _shippingCost,
                  "currency": "USD",
                  "details": {
                    "subtotal": cartProvider
                        .getTotal(bookProvider: bookProvider)
                        .toStringAsFixed(2),
                    "shipping": _shippingCost.toStringAsFixed(2),
                  },
                },
                "description": "The payment transaction description.",
                "item_list": {
                  "items":
                      cartProvider.getCartItems.values.toList().map((item) {
                    final book = bookProvider.findBookById(item.bookId);
                    return {
                      "name": book?.bookTitle ?? "Unknown",
                      "quantity": item.quantity.toString(),
                      "price": book?.bookPrice ?? "0.00",
                      "currency": "USD",
                    };
                  }).toList(),
                },
              },
            ],
            note: "Contact us for any questions on your order.",
            onSuccess: (Map params) async {
              print("onSuccess: $params");
              placeOrderAdvanced(
                cartProvider: cartProvider,
                bookProvider: bookProvider,
                userProvider: userProvider,
              );
            },
            onError: (error) {
              print("onError: $error");
            },
            onCancel: (params) {
              print('cancelled: $params');
            },
          ),
        ),
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  double _getUserDiscount(
      {required int userPoints,
      required CartProvider cartProvider,
      required BookProvider bookProvider}) {
    double discountRate = 0.0;
    double discountAmount = 0.0;

    // Xác định tỷ lệ giảm giá và số tiền giảm giá dựa trên số điểm của người dùng
    if (userPoints >= 5) {
      discountRate = 0.2;
    } else if (userPoints >= 2) {
      discountRate = 0.1;
    }
 
    discountAmount =
        cartProvider.getTotal(bookProvider: bookProvider) * discountRate;

    // Trả về chuỗi hiển thị discount và số tiền discount
    return discountAmount;
  }

  double calculateTotalBill(double totalPrice, int userPoints) {
    double discount = 0.0;

    // Áp dụng giảm giá nếu người dùng có đủ số điểm
    if (userPoints >= 5) {
      discount = 0.2; // Giảm giá 20% nếu có ít nhất 5 điểm
    } else if (userPoints >= 2) {
      discount = 0.1; // Giảm giá 10% nếu có ít nhất 2 điểm
    }

    // Tính tổng hóa đơn sau khi áp dụng giảm giá
    double discountedPrice = totalPrice - (totalPrice * discount);

    return discountedPrice;
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
        "totalPrice":
            cartProvider.getTotal(bookProvider: bookProvider) + _shippingCost,
        "userName": _name,
        "address": _address,
        "phoneNumber": _phoneNumber,
        "paymentMethod": _paymentMethod,  
        "orderDate": orderDate,
        "shippingMethod":
            _shippingMethod, // You can modify this field as needed
        "shippingCost": _shippingCost, // You can modify this field as needed
        "status": OrderStatus.confirmed.toString().split('.').last,
        "confirmed": false,
      });
     
      await cartProvider.clearCartFromFirebase();
      cartProvider.clearLocalCart();
       final int pointsEarned = 1;
      // final int currentPoints = userProvider.getUserPoints();
      // final int newPoints = currentPoints + pointsEarned;
      await userProvider.updateUserPoints(
          uid, pointsEarned); // Cập nhật số điểm trong cơ sở dữ liệu
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
      userProvider.notifyListeners();
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
