import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_june_sample/utils/app_utils.dart';

import 'package:flutter/material.dart';

class LoginScreenController with ChangeNotifier {
  bool isLoading = false;
  Future<void> onLogin(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      isLoading = true;
      notifyListeners();
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      log(credential.user?.email.toString() ?? "no data");
    } on FirebaseAuthException catch (e) {
      log(e.code.toString());
      if (e.code == 'invalid-email') {
        print('No user found for that email.');

        AppUtils.showOnetimeSnackbar(
            context: context, message: "No user found for that email.");
      } else if (e.code == 'invalid-credential') {
        print('Wrong password provided for that user.');
        AppUtils.showOnetimeSnackbar(
            context: context,
            message: "Wrong password provided for that user.");
      }
    } catch (e) {
      AppUtils.showOnetimeSnackbar(context: context, message: e.toString());
    }
    isLoading = false;
    notifyListeners();
  }
}
