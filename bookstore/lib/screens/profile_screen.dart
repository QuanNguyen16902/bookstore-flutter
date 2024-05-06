import 'package:bookstore/inner_screen/orders/order_screen.dart';
import 'package:bookstore/inner_screen/viewed_recently.dart';
import 'package:bookstore/inner_screen/wishlist.dart';
import 'package:bookstore/providers/theme_provider.dart';
import 'package:bookstore/services/app_function.dart';
import 'package:bookstore/services/assets_manager.dart';
import 'package:bookstore/widgets/appname_text.dart';
import 'package:bookstore/widgets/subtitle_text.dart';
import 'package:bookstore/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Visibility(
            visible: false,
            child: Padding(
              padding: EdgeInsets.all(18.0),
              child: TitleTextWidget(
                  label: "Ban hay dang nhap de truy cap thong tin"),
            ),
          ),
          Visibility(
            visible: true,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).cardColor,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.background,
                        width: 3,
                      ),
                      image: const DecorationImage(
                        image: AssetImage("images/avatar.jpg"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleTextWidget(label: "Manh Quan"),
                      SizedBox(
                        height: 3,
                      ),
                      SubtitleTextWidget(
                        label: "Quannguyen169@gmail.com",
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  thickness: 1,
                ),
                const SizedBox(
                  height: 10,
                ),
                const TitleTextWidget(label: "General"),
                const SizedBox(
                  height: 10,
                ),
                CustomListTile(
                    imagePath: AssetManager.orders,
                    text: "Đơn hàng",
                    function: () {
                      Navigator.of(context).pushNamed(OrderScreen.routeName);
                    }),
                CustomListTile(
                    imagePath: AssetManager.wishlist,
                    text: "Yêu thích",
                    function: () {
                      Navigator.pushNamed(context, WishListScreen.routeName);
                    }),
                CustomListTile(
                    imagePath: AssetManager.viewed,
                    text: "Đã xem gần đây",
                    function: () {
                      Navigator.pushNamed(
                          context, ViewedRecentlyScreen.routeName);
                    }),
                CustomListTile(
                    imagePath: AssetManager.address,
                    text: "Địa chỉ",
                    function: () {}),
                const Divider(
                  thickness: 1,
                ),
                const SizedBox(
                  height: 10,
                ),
                const TitleTextWidget(label: "Settings"),
                const SizedBox(
                  height: 10,
                ),
                SwitchListTile(
                    secondary: Image.asset(
                      AssetManager.darkLightMode,
                      height: 34,
                    ),
                    title: Text(themeProvider.getIsDarkTheme
                        ? "Dark Mode"
                        : "Light Mode"),
                    value: themeProvider.getIsDarkTheme,
                    onChanged: (value) {
                      themeProvider.setDarkTheme(themValue: value);
                    }),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  thickness: 1,
                ),
                const TitleTextWidget(label: "Others"),
                CustomListTile(
                  imagePath: AssetManager.address,
                  text: 'Privacy and policy',
                  function: () {},
                ),
              ],
            ),
          ),
          Center(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0))),
              icon: const Icon(Icons.login),
              label: const Text(
                "Đăng nhập",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                await MyAppFunction.showErrorOrWarningDialog(
                    context: context,
                    subtitle: "Bạn có muốn đăng xuất? ",
                    fct: () {},
                    isError: false);
              },
            ),
          ),
        ]),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.imagePath,
    required this.text,
    required this.function,
  });
  final String imagePath, text;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        function();
      },
      title: SubtitleTextWidget(label: text),
      leading: Image.asset(
        imagePath,
        height: 30,
      ),
      trailing: const Icon(IconlyLight.arrowRight2),
    );
  }
}
