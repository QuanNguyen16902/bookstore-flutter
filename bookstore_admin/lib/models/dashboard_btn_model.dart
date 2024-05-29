import 'package:bookstore_admin/screens/add_edit_book_screen.dart';
import 'package:bookstore_admin/screens/orderlist_screen.dart';
import 'package:bookstore_admin/screens/search_screen.dart';
import 'package:bookstore_admin/screens/user_screen.dart';
import 'package:bookstore_admin/services/assets_manager.dart';
import 'package:flutter/material.dart';

class DashBoardButtonModel{
  final String text, imagesPath;
  final Function onPressed;

  DashBoardButtonModel({
    required this.text,
    required this.imagesPath, 
    required this.onPressed,
  });

  static List<DashBoardButtonModel> dashboardBtnList(context) => [
    DashBoardButtonModel(
      text: "Thêm sách mới",  
      imagesPath: AssetManager.add_new_book, 
      onPressed: (){
        Navigator.pushNamed(context, AddOrEditBookScreen.routeName);
      },
      ),
    DashBoardButtonModel(
      text: "Kiểm tra tất cả sách",  
      imagesPath: AssetManager.show_books, 
      onPressed: (){
        Navigator.pushNamed(context, SearchScreen.routeName);
      }
      ),
   
    DashBoardButtonModel(
      text: "Thông tin người dùng",  
      imagesPath: AssetManager.consumer, 
      onPressed: (){
        Navigator.pushNamed(context, UserInfoScreen.routeName);
      }
      ),
   
    DashBoardButtonModel(
      text: "Danh sách đơn hàng",  
      imagesPath: AssetManager.view_orders, 
      onPressed: (){
        Navigator.pushNamed(context, OrderListItem.routeName);
      }
      ),
  ];
}