import 'package:bookstore/consts/validator.dart';
import 'package:bookstore/services/assets_manager.dart';
import 'package:bookstore/widgets/appname_text.dart';
import 'package:bookstore/widgets/subtitle_text.dart';
import 'package:bookstore/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = "/ForgotPasswordScreen";
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final TextEditingController emailController;
  late final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      emailController.dispose();
    }
    super.dispose();
  }

  Future<void> forgetPasswordFunct() async {
    final isValid = formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {}
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const AppNameTextWidget(
            fontSize: 22,
          )),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
            child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(
              height: 10,
            ),
            Image.asset(
              AssetManager.forgot_password,
              height: size.width * 0.7,
              width: size.width * 0.7,
            ),
            const SizedBox(
              height: 20,
            ),
            const TitleTextWidget(
              label: "Quên mật khẩu",
              fontSize: 22,
            ),
            const SubtitleTextWidget(
                label: "Nhập email của bạn để reset mật khẩu"),
            const SizedBox(
              height: 30,
            ),
            Form(
              key: formKey,
              child: Column(children: [
                TextFormField(
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "yourgmail@gmail.com",
                    prefixIcon: Container(
                      padding: const EdgeInsets.all(12),
                      child: const Icon(
                        IconlyLight.message,
                      ),
                    ),
                    filled: true,
                  ),
                  validator: (value) {
                    return MyValidator.emailValidator(value!);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                      onPressed: () async{
                        await forgetPasswordFunct();
                      },
                      icon: const Icon(IconlyBold.send), 
                      label:  const Text(
                          "Request Link",
                        style: TextStyle( fontSize: 22),
                      ),
                    ),
                )
              ]),
            )
          ],
        )),
      ),
    );
  }
}
