import 'package:bookstore_admin/models/user_provider.dart';
import 'package:bookstore_admin/models/users_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserInfoScreen extends StatelessWidget {
  static const routeName = "/UserInfoScreen";
  final UserModel? user;

  const UserInfoScreen({this.user});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: FutureBuilder<List<UserModel>>(
        future: userProvider.fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<UserModel> users = snapshot.data ?? [];
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                UserModel user = users[index];
                return ListTile(
                  title: Text('ID: ${user.userId}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: ${user.userEmail} '),
                      Text('Username: ${user.userName} '),
                      Text('UserPoint: ${user.userPoint} '),
                      Text('Yêu thích: ${user.userWishlist.length} '),
                      Text('Created At: ${user.createdAt.toDate()} '),
                    ],
                  ),
                  onTap: () {
                    // Handle tapping on a user to view details
                    // Example: Navigator.pushNamed(context, '/user_details', arguments: user);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
