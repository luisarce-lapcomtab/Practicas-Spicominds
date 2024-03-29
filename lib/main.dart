import 'package:flutter/material.dart';

import 'package:psychomind/page/login_page.dart';

import 'package:psychomind/page/register_page.dart';
import 'package:psychomind/page/selector_page.dart';
import 'package:psychomind/page/splash_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// ignore_for_file: prefer_const_constructors
void main() async {
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
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashPage(),
      routes: {
        LoginPage.routeName: (_) => const LoginPage(),
        RegisterPage.routeName: (_) => const RegisterPage(),
        SelectorPage.routeName: (_) => const SelectorPage(),
      },
    );
  }
}
