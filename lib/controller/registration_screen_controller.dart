import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_june_sample/utils/app_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RegistrationScreenController with ChangeNotifier {
  bool isLoading = false;

  Future<void> onRegistration(
      {required String email,
      required String password,
      required BuildContext context}) async {
    isLoading = true;
    notifyListeners();
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user?.uid != null) {
        AppUtils.showOnetimeSnackbar(
            bg: Colors.green,
            context: context,
            message: "Registration successful");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        AppUtils.showOnetimeSnackbar(
            context: context, message: "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        AppUtils.showOnetimeSnackbar(
            context: context,
            message: "The account already exists for that email.");
      }
    } catch (e) {
      print(e);
      AppUtils.showOnetimeSnackbar(context: context, message: e.toString());
    }

    isLoading = false;
    notifyListeners();
  }
}
