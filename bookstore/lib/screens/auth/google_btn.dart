import 'package:bookstore/root_screen.dart';
import 'package:bookstore/services/app_function.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ionicons/ionicons.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});
  Future<void> signInWithGoogle({required BuildContext context}) async {
    try {
      final googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      final googleAccount = await googleSignIn.signIn();
      if (googleAccount != null) {
        final googleAuth = await googleAccount.authentication;
        if (googleAuth.accessToken != null && googleAuth.idToken != null) {
          final authResults = await FirebaseAuth.instance.signInWithCredential(
              GoogleAuthProvider.credential(
                  accessToken: googleAuth.accessToken,
                  idToken: googleAuth.idToken));
          if (authResults.additionalUserInfo!.isNewUser) {
            await FirebaseFirestore.instance
                .collection("users")
                .doc(authResults.user!.uid)
                .set({
              "userId": authResults.user!.uid,
              "userName": authResults.user!.displayName,
              "userImage": authResults.user!.photoURL,
              "userEmail": authResults.user!.email,
              "createdAt": Timestamp.now(),
              "userWishlist": [],
              "userCart": [],
              "addresses": [],
              "userPoint": 0,
            });
          }
        }
      }
      // if (!context.mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.pushReplacementNamed(context, RootScreen.routeName);
      });
      Fluttertoast.showToast(
            msg: "Đăng nhập thành công",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER_LEFT,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
    } on FirebaseException catch (error) {
      await MyAppFunction.showErrorOrWarningDialog(
          context: context,
          subtitle: error.message.toString(),
          fct: () {});
    } catch (error) {
      await MyAppFunction.showErrorOrWarningDialog(
          context: context, subtitle: error.toString(), fct: () {}
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          elevation: 1,
          padding: const EdgeInsets.all(12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          )),
      icon: const Icon(
        Ionicons.logo_google,
        color: Colors.red,
      ),
      label: const Text(
        "Đăng nhập bằng Google",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      onPressed: () async {
        await signInWithGoogle(context: context);
      },
    );
  }
}
