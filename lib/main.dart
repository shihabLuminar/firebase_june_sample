import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_june_sample/controller/home_screen_controller.dart';
import 'package:firebase_june_sample/controller/login_screen_controller.dart';
import 'package:firebase_june_sample/controller/registration_screen_controller.dart';
import 'package:firebase_june_sample/firebase_options.dart';
import 'package:firebase_june_sample/views/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => RegistrationScreenController()),
        ChangeNotifierProvider(create: (context) => LoginScreenController()),
        ChangeNotifierProvider(create: (context) => HomeScreenController()),
      ],
      child: MaterialApp(
        home: SplashScreen(),
      ),
    );
  }
}
