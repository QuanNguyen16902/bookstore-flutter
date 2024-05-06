import 'package:bookstore/providers/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

class HeartButtonWidget extends StatefulWidget {
  const HeartButtonWidget({
    super.key,
    this.bgColor = Colors.transparent,
    this.size = 20,
    required this.bookId,
    // this.isBookInWishlist = false
  });
  final Color bgColor;
  final double size;
  final String bookId;
  // final bool? isBookInWishlist;

  @override
  State<HeartButtonWidget> createState() => HeartButtonState();
}

class HeartButtonState extends State<HeartButtonWidget> {
  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    return Container(
      decoration: BoxDecoration(color: widget.bgColor, shape: BoxShape.circle),
      child: IconButton(
          style: IconButton.styleFrom(elevation: 10),
          onPressed: () {
            wishlistProvider.addOrRemoveFromWishlist(bookId: widget.bookId);
          },
          icon: Icon(
            wishlistProvider.isBookInWishlist(bookId: widget.bookId)
                ? IconlyBold.heart
                : IconlyLight.heart,
            size: widget.size,
            color: wishlistProvider.isBookInWishlist(bookId: widget.bookId)
                ? Colors.red
                : Colors.grey,
          )),
    );
  }
}
