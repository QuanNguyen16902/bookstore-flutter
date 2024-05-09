import 'package:flutter/material.dart';

class CategoryModel with ChangeNotifier{
  final String id, name, image;

  CategoryModel({required this.id, required this.name, required this.image});
}
