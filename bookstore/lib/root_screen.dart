import 'dart:developer';

import 'package:bookstore/providers/book_provider.dart';
import 'package:bookstore/providers/cart_provider.dart';
import 'package:bookstore/providers/user_provider.dart';
import 'package:bookstore/providers/wishlist_provider.dart';
import 'package:bookstore/screens/cart/cart_screen.dart';
import 'package:bookstore/screens/home_screen.dart';
import 'package:bookstore/screens/profile_screen.dart';
import 'package:bookstore/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});
  static const routeName = "/RootScreen";
  
  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  late List<Widget> screens;
  int currentScreen = 0;
  late PageController controller;
  bool isLoadingBook = true;

  @override
  void initState() {
    super.initState();
    screens = const [
      HomeScreen(),
      SearchScreen(),
      CartScreen(),
      ProfileScreen()
    ];
    controller = PageController(initialPage: currentScreen);
  }

  Future<void> fetchFunct() async {
    final booksProvider = Provider.of<BookProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      Future.wait({
        booksProvider.fetchBooks(),
        userProvider.fetchUserInfo(),
      });
      Future.wait({
        cartProvider.fetchCart(),
      });
      Future.wait({
        wishlistProvider.fetchWishlist(),
      });
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void didChangeDependencies() {
    if (isLoadingBook) {
      fetchFunct();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentScreen,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 10,
        height: kBottomNavigationBarHeight,
        onDestinationSelected: (index) {
          setState(() {
            currentScreen = index;
          });
          controller.jumpToPage(currentScreen);
        },
        destinations: [
          const NavigationDestination(
              selectedIcon: Icon(IconlyBold.home),
              icon: Icon(IconlyLight.home),
              label: "Home"),
          const NavigationDestination(
              selectedIcon: Icon(IconlyBold.search),
              icon: Icon(IconlyLight.search),
              label: "Search"),
          NavigationDestination(
              selectedIcon: Icon(IconlyBold.bag2),
              icon: Badge(
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                  label: Text(cartProvider.getCartItems.length.toString()),
                  child: const Icon(IconlyLight.bag2)),
              label: "Cart"),
          const NavigationDestination(
              selectedIcon: Icon(IconlyBold.profile),
              icon: Icon(IconlyLight.profile),
              label: "Profile"),
        ],
      ),
    );
  }
}
