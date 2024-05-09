import 'package:flutter/material.dart';

class AppConstant {
  static List<String> categoryList = [
    "Văn hóa",
    "Tri thức",
    "AI",
    "Math",
    "IT",
  ];

  static List<DropdownMenuItem<String>>? get categoriesDropDownList {
    List<DropdownMenuItem<String>>? menuItem =
        List<DropdownMenuItem<String>>.generate(
            categoryList.length,
            (index) => DropdownMenuItem(
              value: categoryList[index],
                  child: Text(categoryList[index]),
                ));

            return menuItem;
  }
}
