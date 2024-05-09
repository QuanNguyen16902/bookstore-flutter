import 'package:bookstore/consts/validator.dart';
import 'package:bookstore/inner_screen/loadding_widget.dart';
import 'package:bookstore/root_screen.dart';
import 'package:bookstore/screens/auth/forgot_password.dart';
import 'package:bookstore/screens/auth/google_btn.dart';
import 'package:bookstore/screens/auth/register.dart';
import 'package:bookstore/services/app_function.dart';
import 'package:bookstore/widgets/appname_text.dart';
import 'package:bookstore/widgets/subtitle_text.dart';
import 'package:bookstore/widgets/title_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
 static const routeName = "/LoginScreen";
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool hidePassword = true;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  late final FocusNode emailFocusNode;
  late final FocusNode passwordFocusNode;

  final formkey = GlobalKey<FormState>();
  bool isLoading = false;
  final auth = FirebaseAuth.instance;
  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void disposed() {
    if (mounted) {
      emailController.dispose();
      passwordController.dispose();

      emailFocusNode.dispose();
      passwordFocusNode.dispose();
    }
    super.dispose();
  }

  Future<void> loginFunction() async {
    final isValid = formkey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      try {
        setState(() {
          isLoading = true;
        });
        await auth.signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim());
        Fluttertoast.showToast(
          msg: "Đăng nhập thành công",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER_LEFT,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
        );
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, RootScreen.routeName);
      } on FirebaseException catch (error) {
        await MyAppFunction.showErrorOrWarningDialog(
            context: context,
            subtitle: error.message.toString(),
            fct: () {});
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
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: LoadingWidget(
          isLoading: isLoading,
          child: Padding(
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
                      child: TitleTextWidget(label: "Xin chào!")),
                  const SizedBox(
                    height: 16,
                  ),
                  Form(
                      key: formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            controller: emailController,
                            focusNode: emailFocusNode,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              hintText: "Email",
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
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: hidePassword,
                            decoration:  InputDecoration(
                                hintText: "Password",
                                prefixIcon: const Icon(
                                  IconlyLight.lock,
                                ),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                         hidePassword = !hidePassword;
                                      });
                                    },
                                    icon: Icon(hidePassword ? Icons.visibility : Icons.visibility_off))),
                            validator: (value) {
                              return MyValidator.passwordValidator(value!);
                            },
                            onFieldSubmitted: (value) async {
                              await loginFunction();
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, ForgotPasswordScreen.routeName);
                                },
                                child: const SubtitleTextWidget(
                                  label: "Forgot password?",
                                  fontStyle: FontStyle.italic,
                                  textDecoration: TextDecoration.underline,
                                )),
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(12.0),
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  )),
                              icon: const Icon(Icons.login),
                              label: const Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal),
                              ),
                              onPressed: () async {
                                await loginFunction();
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          SubtitleTextWidget(
                            label: "Or connect using".toUpperCase(),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            height: kBottomNavigationBarHeight + 10,
                            child: Row(
                              children: [
                                const Expanded(
                                  flex: 2,
                                  child: SizedBox(
                                    height: kBottomNavigationBarHeight,
                                    child: GoogleButton(),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: kBottomNavigationBarHeight + 2,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          elevation: 3,
                                          padding: const EdgeInsets.all(8.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          )),
                                      child: const Text(
                                        "Guest",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      onPressed: () async {
                                        Navigator.of(context).pushNamed(RootScreen.routeName);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SubtitleTextWidget(
                                  label: "Bạn chưa có tài khoản?"),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, RegisterScreen.routeName);
                                },
                                child: const SubtitleTextWidget(
                                  label: "Đăng ký",
                                  fontStyle: FontStyle.italic,
                                  textDecoration: TextDecoration.underline,
                                ),
                              )
                            ],
                          )
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
