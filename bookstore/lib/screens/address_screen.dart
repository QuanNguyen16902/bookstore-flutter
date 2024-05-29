import 'package:bookstore/models/users_model.dart';
import 'package:bookstore/providers/user_provider.dart';
import 'package:bookstore/screens/addAddress_screen.dart';
import 'package:bookstore/widgets/title_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  static const routeName = '/AddressScreen';
  final UserModel? user;
  const AddressScreen({this.user});

  @override
  _AddressScreenState createState() => _AddressScreenState();
}
 
class _AddressScreenState extends State<AddressScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final userstDb = FirebaseFirestore.instance.collection("users");
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: TitleTextWidget(
          label: 'Địa chỉ của tôi',
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const AddAddressScreen()),
              );
            },
          ),
        ],
      ),
      body: userProvider.getUserModel!.addresses.isEmpty
          ? Center(
              child: TitleTextWidget(
              label: 'Chưa có address',
            ))
          : ListView.builder(
              itemCount: userProvider.getUserModel!.addresses.length,
              itemBuilder: (context, index) {
                // userProvider.notifyListeners();
                final address = userProvider.getUserModel!.addresses[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text('${address.street}, ${address.state}'),
                          subtitle: Text(
                              '${address.city}, ${address.country}, ${address.zipCode}'),
                        ),
                        IconButton(
                          onPressed: () async {
                            userProvider.removeAddressFromFirestore(
                                addressId: address.addressId,
                                street: address.street,
                                city: address.city,
                                state: address.state,
                                zipCode: address.zipCode,
                                country: address.country,
                                userstDb: userstDb,
                                currentUser: currentUser!);
                          },
                          icon: const Icon(
                            IconlyLight.delete,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
