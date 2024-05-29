import 'package:bookstore/consts/theme_data.dart';
import 'package:bookstore/inner_screen/book_details.dart';
import 'package:bookstore/inner_screen/orders/order_detail_screen.dart';
import 'package:bookstore/inner_screen/orders/order_screen.dart';
import 'package:bookstore/inner_screen/orders/orderlist_screen.dart';
import 'package:bookstore/inner_screen/viewed_recently.dart';
import 'package:bookstore/inner_screen/wishlist.dart';
import 'package:bookstore/providers/book_provider.dart';
import 'package:bookstore/providers/cart_provider.dart';
import 'package:bookstore/providers/order_provider.dart';
import 'package:bookstore/providers/theme_provider.dart';
import 'package:bookstore/providers/user_provider.dart';
import 'package:bookstore/providers/viewed_book_provider.dart';
import 'package:bookstore/providers/wishlist_provider.dart';
import 'package:bookstore/root_screen.dart';
import 'package:bookstore/screens/addAddress_screen.dart';
import 'package:bookstore/screens/address_screen.dart';
import 'package:bookstore/screens/auth/login.dart';
import 'package:bookstore/screens/auth/password/forgot_password.dart';
import 'package:bookstore/screens/auth/register.dart';
import 'package:bookstore/screens/checkout_screen.dart';
import 'package:bookstore/screens/home_screen.dart';
import 'package:bookstore/screens/search_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
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
          if(snapshot.connectionState == ConnectionState.waiting){
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child:  CircularProgressIndicator(),
                ),
              ),
            );
          }
          else if (snapshot.hasError) {
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
                return CartProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return WishlistProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return ViewedBookProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return UserProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return OrderProvider();
              }),
            ],
            child: Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'BookStore',
                theme: Styles.themeData(
                    isDarkTheme: themeProvider.getIsDarkTheme,
                    context: context),
                home: const LoginScreen(),
                routes: {
                  RootScreen.routeName: (context) => const RootScreen(),
                  BookDetailsScreen.routeName: (context) =>
                      const BookDetailsScreen(),
                  WishListScreen.routeName: (context) => const WishListScreen(),
                  ViewedRecentlyScreen.routeName: (context) =>
                      const ViewedRecentlyScreen(),
                  RegisterScreen.routeName: (context) => const RegisterScreen(),
                  ForgotPasswordScreen.routeName: (context) =>
                      const ForgotPasswordScreen(),
                  // PasswordResetPage.routeName: (context) =>
                  //      PasswordResetPage(),
                  OrderScreen.routeName: (context) => const OrderScreen(),
                  SearchScreen.routeName: (context) => const SearchScreen(),
                  LoginScreen.routeName: (context) => const LoginScreen(),
                  HomeScreen.routeName: (context) => const HomeScreen(),
                  PlaceOrderScreen.routeName: (context) => const PlaceOrderScreen(),
                  OrderListItem.routeName: (context) => const OrderListItem(),
                  OrderDetailScreen.routeName: (context) => const OrderDetailScreen(),
                  AddressScreen.routeName: (context) => const AddressScreen(),
                  AddAddressScreen.routeName: (context) => const AddAddressScreen(),
                },
                
              );
            }),
          );
        });
  }
}