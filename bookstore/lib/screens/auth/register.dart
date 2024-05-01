import 'package:bookstore/consts/validator.dart';
import 'package:bookstore/services/app_function.dart';
import 'package:bookstore/widgets/appname_text.dart';
import 'package:bookstore/widgets/subtitle_text.dart';
import 'package:bookstore/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:ionicons/ionicons.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static const routeName = "/RegisterScreen";
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool hidePassword = true;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController repeatPasswordController;
  late final TextEditingController nameController;

  late final FocusNode emailFocusNode;
  late final FocusNode passwordFocusNode;
  late final FocusNode repeatPasswordFocusNode;
  late final FocusNode nameFocusNode;

  final formkey = GlobalKey<FormState>();

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    repeatPasswordController = TextEditingController();
    nameController = TextEditingController();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    repeatPasswordFocusNode = FocusNode();
    nameFocusNode = FocusNode();
    super.initState();
  }

  @override
  void disposed() {
    if (mounted) {
      emailController.dispose();
      passwordController.dispose();
      nameController.dispose();

      emailFocusNode.dispose();
      passwordFocusNode.dispose();
      nameFocusNode.dispose;
    }
    super.dispose();
  }

  Future<void> registerFunction() async {
    final isValid = formkey.currentState!.validate();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 60,
                ),
                const AppNameTextWidget(
                  fontSize: 30,
                ),
                const SizedBox(
                  height: 16,
                ),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: TitleTextWidget(label: "welcome back!")),
                const SizedBox(
                  height: 16,
                ),
                Form(
                    key: formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: nameController,
                          focusNode: nameFocusNode,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            hintText: "Username",
                            prefixIcon: Icon(
                              Icons.person,
                            ),
                          ),
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus(emailFocusNode);
                          },
                          validator: (value) {
                            return MyValidator.displayNameValidator(value!);
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: emailController,
                          focusNode: emailFocusNode,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: "Email address",
                            prefixIcon: Icon(
                              IconlyLight.message,
                            ),
                          ),
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(passwordFocusNode);
                          },
                          validator: (value) {
                            return MyValidator.emailValidator(value!);
                          },
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        TextFormField(
                          controller: passwordController,
                          focusNode: passwordFocusNode,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: hidePassword,
                          decoration: InputDecoration(
                              hintText: "*********",
                              prefixIcon: const Icon(
                                Ionicons.key,
                              ),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      hidePassword= !hidePassword;
                                    });
                                  },
                                  icon: Icon(hidePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off))),
                          validator: (value) {
                            return MyValidator.passwordValidator(value!);
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: repeatPasswordController,
                          focusNode: repeatPasswordFocusNode,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: hidePassword,
                          decoration: InputDecoration(
                              hintText: "Repeat Password",
                              prefixIcon: const Icon(
                                Ionicons.key,
                              ),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      hidePassword= !hidePassword;
                                    });
                                  },
                                  icon: Icon(hidePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off))),
                          validator: (value) {
                            return MyValidator.repeatPasswordValidator(
                                value!, passwordController.text);
                          },
                          onFieldSubmitted: (value) async {
                            await registerFunction();
                          },
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(12.0),
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                )),
                            icon: const Icon(IconlyLight.addUser),
                            label: const Text(
                              "Đăng ký",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal),
                            ),
                            onPressed: () async {
                              await registerFunction();
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton.icon(
                            icon: const BackButton(color: Colors.red,),
                            label: const Text(
                              "Back to Login",
                            ),
                            onPressed: () {
                                
                            },
                          ),
                        )),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
