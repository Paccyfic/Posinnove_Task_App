import 'package:get/get.dart';
import 'package:flutter/material.dart';
//import 'app.dart'; // your root widget if any
//import 'screens/login.dart';
import 'screens/sign_up.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SignUpScreen(), // or your initial route
    );
  }
}