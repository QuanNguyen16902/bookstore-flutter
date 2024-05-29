import 'package:bookstore_admin/consts/theme_data.dart';
import 'package:bookstore_admin/models/user_provider.dart';
import 'package:bookstore_admin/providers/book_provider.dart';
import 'package:bookstore_admin/providers/order_provider.dart';
import 'package:bookstore_admin/providers/theme_provider.dart';
import 'package:bookstore_admin/screens/add_edit_book_screen.dart';
import 'package:bookstore_admin/screens/dashboard_screen.dart';
import 'package:bookstore_admin/screens/inner_screens/orders/order_manage.dart';
import 'package:bookstore_admin/screens/orderlist_screen.dart';
import 'package:bookstore_admin/screens/search_screen.dart';
import 'package:bookstore_admin/screens/user_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async{
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
     apiKey: "AIzaSyCfYfwM6hb0T3Uh81-VJ6_byCsZ6V6MEk8",
      authDomain: "bookstore1-b8a0c.firebaseapp.com",
      projectId: "bookstore1-b8a0c",
      storageBucket: "bookstore1-b8a0c.appspot.com",
      messagingSenderId: "your_messaging_sender_id",
      appId: "com.example.bookstore",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return FutureBuilder<FirebaseApp>(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: SelectableText(snapshot.error.toString()),
                ),
              ),
            );
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) {
                return ThemeProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return BookProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return OrderProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return UserProvider();
              }),
            ],
            child: Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Viper BookStore Admin',
                  theme: Styles.themeData(
                      isDarkTheme: themeProvider.getIsDarkTheme,
                      context: context),
                  home: const DashboardScreen(),
                  routes: {
                    SearchScreen.routeName: (context) => const SearchScreen(),
                    AddOrEditBookScreen.routeName: (context) =>
                        const AddOrEditBookScreen(),
                    OrderListItem.routeName: (context) => const OrderListItem(),
                    UpdateOrderScreen.routeName: (context) => const UpdateOrderScreen(),
                    UserInfoScreen.routeName:(context) => const UserInfoScreen(),
                  },
                );
              },
            ),
          );
        });
  }
}
