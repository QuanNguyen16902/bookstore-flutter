// ignore_for_file: prefer_const_constructors

import 'package:bookstore/consts/app_constant.dart';
import 'package:bookstore/providers/book_provider.dart';
import 'package:bookstore/services/assets_manager.dart';
import 'package:bookstore/widgets/appname_text.dart';
import 'package:bookstore/widgets/products/category_widget.dart';
import 'package:bookstore/widgets/products/last_arrival_widget.dart';
import 'package:bookstore/widgets/title_text.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static List<String> bannerImages = [
    AssetManager.banner1,
    AssetManager.banner2,
    AssetManager.banner3,
    AssetManager.banner4
  ];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final bookProvider = Provider.of<BookProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset(
            "${AssetManager.imagesPath}/book-shop.png",
            width: 40,
            height: 40,
            fit: BoxFit.fill,
          ),
        ),
        title: const AppNameTextWidget(
          fontSize: 20,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.25,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      return Image.asset(
                        bannerImages[index],
                        fit: BoxFit.fill,
                      );
                    },
                    itemCount: bannerImages.length,
                    pagination: SwiperPagination(
                        //  alignment: Alignment.center
                        builder: DotSwiperPaginationBuilder(
                            activeColor: Colors.red, color: Colors.white)),
                    // control: SwiperControl(),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TitleTextWidget(label: "Xem gần nhất"),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: size.height * 0.2,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: bookProvider.getBooks.length,
                  itemBuilder: (context, index) {
                    return ChangeNotifierProvider.value(value: bookProvider.getBooks[index],
                    child: LastArrivalProductWidget());
                  },
                ),
              ),
              const TitleTextWidget(label: "Categories"),
              const SizedBox(
                height: 15,
              ),
              GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  children:
                      List.generate(AppConstant.categoryList.length, (index) {
                    return CategoryWidget(
                        name: AppConstant.categoryList[index].name,
                        image: AppConstant.categoryList[index].image);
                  }))
            ],
          ),
        ),
      ),
    );
  }
}
