import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_june_sample/controller/login_screen_controller.dart';
import 'package:firebase_june_sample/main.dart';
import 'package:firebase_june_sample/views/home_screen/home_screen.dart';
import 'package:firebase_june_sample/views/registration_screen/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        log(snapshot.data?.uid.toString() ?? "");

        if (snapshot.hasData) {
          return HomeScreen();
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('Login'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 24),
                  context.watch<LoginScreenController>().isLoading
                      ? CircularProgressIndicator.adaptive()
                      : ElevatedButton(
                          onPressed: () async {
                            await context.read<LoginScreenController>().onLogin(
                                email: emailController.text,
                                password: passwordController.text,
                                context: context);

                            emailController.clear();
                            passwordController.clear();
                          },
                          child: Text('Login'),
                        ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegistrationScreen(),
                            ));
                      },
                      child: Text("Don't have an account, Register Now"))
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
