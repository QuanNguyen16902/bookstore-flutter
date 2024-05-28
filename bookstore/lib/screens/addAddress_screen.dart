import 'package:bookstore/models/address_model.dart';
import 'package:bookstore/models/users_model.dart';
import 'package:bookstore/providers/user_provider.dart';
import 'package:bookstore/widgets/title_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddAddressScreen extends StatefulWidget {
  static const routeName = '/AddAddressScreen';
  final UserModel? user;
 

  const AddAddressScreen({this.user});

  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();
  final _zipCodeController = TextEditingController();

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  Future<void> _saveAddress({required UserProvider userProvider,}) async {
    if (_formKey.currentState!.validate()) {
      final newAddress = AddressModel(
        addressId: Uuid().v4(),
        street: _streetController.text,
        city: _cityController.text,
        state: _stateController.text,
        country: _countryController.text,
        zipCode: _zipCodeController.text,
      );

      if (currentUser != null) {
        try {
          // Add new address to Firestore
           final userDocRef = FirebaseFirestore.instance.collection('users').doc(currentUser!.uid);
          final userDoc = await userDocRef.get();
           final addresses = List.from(userDoc.get('addresses') ?? []);
          addresses.add(newAddress.toMap());
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser!.uid)
              .set({
            'addresses': addresses,
            'createdAt': userProvider.userModel!.createdAt,
            'userId': currentUser!.uid,
            'userEmail': userProvider.userModel!.userEmail,
            'userCart': userProvider.userModel!.userCart,
            'userImage': userProvider.userModel!.userImage,
            'userWishlist': userProvider.userModel!.userWishlist,
            'userName': userProvider.userModel!.userName,
         
          });
          userProvider.notifyListeners();
          Navigator.of(context).pop(newAddress);
        } catch (e) {
          print('Failed to add address: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add address')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User is not logged in')),
        );
      }
      
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: TitleTextWidget(label: 'Thêm địa chỉ mới'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _streetController,
                decoration: InputDecoration(labelText: 'Đường'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên đường';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(labelText: 'Thành phố'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập thành phố';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 5,),
              TextFormField(
                controller: _stateController,
                decoration: InputDecoration(labelText: 'Quận'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập quận';
                  }
                  return null;
                },
              ),
               const SizedBox(height: 5,),
              TextFormField(
                controller: _countryController,
                decoration: InputDecoration(labelText: 'Quốc gia'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập quốc gia';
                  }
                  return null;
                },
              ),
               const SizedBox(height: 5,),
              TextFormField(
                controller: _zipCodeController,
                decoration: InputDecoration(labelText: 'Zip Code'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mã bưu điện';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed:(){ _saveAddress(userProvider: userProvider);},
                child: Text('Lưu địa chỉ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
