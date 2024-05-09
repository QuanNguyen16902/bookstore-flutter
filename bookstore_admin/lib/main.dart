import 'package:bookstore_admin/consts/theme_data.dart';
import 'package:bookstore_admin/providers/book_provider.dart';
import 'package:bookstore_admin/providers/theme_provider.dart';
import 'package:bookstore_admin/screens/add_edit_book_screen.dart';
import 'package:bookstore_admin/screens/dashboard_screen.dart';
import 'package:bookstore_admin/screens/inner_screens/orders/order_screen.dart';
import 'package:bookstore_admin/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_){
          return ThemeProvider();
        }),
        ChangeNotifierProvider(create: (_){
          return BookProvider();
        }),
      ],
      child: Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Viper BookStore Admin',
          theme: Styles.themeData(
              isDarkTheme: themeProvider.getIsDarkTheme, context: context),
          home: const DashboardScreen(),
          routes: {
            OrderScreen.routeName: (context) => const OrderScreen(),
            SearchScreen.routeName: (context) => const SearchScreen(),
            AddOrEditBookScreen.routeName: (context) => const AddOrEditBookScreen(),
          },
        );
      }),
    );
  }
}