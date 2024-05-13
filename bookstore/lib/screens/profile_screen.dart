import 'package:bookstore/inner_screen/loadding_widget.dart';
import 'package:bookstore/inner_screen/orders/order_screen.dart';
import 'package:bookstore/inner_screen/viewed_recently.dart';
import 'package:bookstore/inner_screen/wishlist.dart';
import 'package:bookstore/models/users_model.dart';
import 'package:bookstore/providers/theme_provider.dart';
import 'package:bookstore/providers/user_provider.dart';
import 'package:bookstore/screens/auth/login.dart';
import 'package:bookstore/services/app_function.dart';
import 'package:bookstore/services/assets_manager.dart';
import 'package:bookstore/widgets/appname_text.dart';
import 'package:bookstore/widgets/subtitle_text.dart';
import 'package:bookstore/widgets/title_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  User? user = FirebaseAuth.instance.currentUser;
  UserModel? userModel;
  bool isLoading = true;
  Future<void> fetchUserInfo() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      setState(() {
        isLoading = true;
      });
      userModel = await userProvider.fetchUserInfo();
    } catch (error) {
      await MyAppFunction.showErrorOrWarningDialog(
          context: context,
          subtitle: error.toString(),
          fct: () {});
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
      body: LoadingWidget(
        isLoading: isLoading, 
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
             Visibility(
              visible: user == null ? true : false ,
              child: const Padding(
                padding: EdgeInsets.all(18.0),
                child: TitleTextWidget(
                    label: "Ban hay dang nhap de truy cap thong tin"),
              ),
            ),
            userModel == null ? const SizedBox.shrink() : Padding(
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
                      image:  DecorationImage(
                        image: NetworkImage(userModel!.userImage),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleTextWidget(label: userModel!.userName),
                      const SizedBox(
                        height: 3,
                      ),
                      SubtitleTextWidget(
                        label:  userModel!.userEmail,
                      )
                    ],
                  ),
                ],
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
                  Visibility(
                      visible: userModel == null ? false : true,
                    child: CustomListTile(
                        imagePath: AssetManager.orders,
                        text: "Đơn hàng",
                        function: () {
                          Navigator.of(context).pushNamed(OrderScreen.routeName);
                        }),
                  ),
                  Visibility(
                    visible: userModel == null ? false : true,
                    child: CustomListTile(
                        imagePath: AssetManager.wishlist,
                        text: "Yêu thích",
                        function: () {
                          Navigator.pushNamed(context, WishListScreen.routeName);
                        }),
                  ),
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
                icon: Icon(user == null ? Icons.login : Icons.logout),
                label: Text(
                  user == null ? "Login" : "Logout",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (user == null) {
                    Navigator.pushNamed(context, LoginScreen.routeName);
                  } else {
                    await MyAppFunction.showErrorOrWarningDialog(
                        context: context,
                        subtitle: "Bạn có muốn đăng xuất? ",
                        fct: () async {
                          await FirebaseAuth.instance.signOut();
                          if (!mounted) return;
                          Navigator.pushReplacementNamed(
                              context, LoginScreen.routeName);
                        },
                        isError: false);
                  }
                },
              ),
            ),
          ]),
        ),
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
