import 'package:bookstore_admin/models/dashboard_btn_model.dart';
import 'package:bookstore_admin/providers/theme_provider.dart';
import 'package:bookstore_admin/services/assets_manager.dart';
import 'package:bookstore_admin/widget/appname_text.dart';
import 'package:bookstore_admin/widget/dashboard_btns.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = "/DashboardScreen";
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const AppNameTextWidget(
            fontSize: 20,
          ),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "${AssetManager.imagesPath}/book-shop.png",
              width: 40,
              height: 40,
              fit: BoxFit.fill,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                themeProvider.setDarkTheme(
                    themValue: !themeProvider.getIsDarkTheme);
              },
              icon: Icon(themeProvider.getIsDarkTheme
                  ? Icons.light_mode
                  : Icons.dark_mode),
            ),
          ],
        ),
        body: GridView.count(
          crossAxisCount: 2,
          children: List.generate(DashBoardButtonModel.dashboardBtnList(context).length,
              (index) => DashBoardButtonWidget(
                text: DashBoardButtonModel.dashboardBtnList(context)[index].text,
                imagePath: DashBoardButtonModel.dashboardBtnList(context)[index].imagesPath,
                onPressed: DashBoardButtonModel.dashboardBtnList(context)[index].onPressed,)),
        ));
  }
}
