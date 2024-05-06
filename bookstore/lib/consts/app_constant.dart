import 'package:bookstore/models/category_model.dart';
import 'package:bookstore/services/assets_manager.dart';

class AppConstant {
  static List<CategoryModel> categoryList = [
    CategoryModel(
      id: AssetManager.book1,
      name: 'Văn hóa',
      image: AssetManager.book1,
    ),
    CategoryModel(
      id: AssetManager.book3,
      name: 'Tri thức',
      image: AssetManager.book3,
    ),
    CategoryModel(
      id: AssetManager.book2,
      name: 'AI',
      image: AssetManager.book2,
    ),
    CategoryModel(
      id: AssetManager.book1,
      name: 'Computing',
      image: AssetManager.book1,
    ),
    CategoryModel(
      id: AssetManager.book3,
      name: 'Math',
      image: AssetManager.book3,
    ),
    CategoryModel(
      id: AssetManager.book2,
      name: 'AI',
      image: AssetManager.book2,
    ),
  ];
}
