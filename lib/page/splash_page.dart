import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:psychomind/page/completeprofile_page.dart';

import 'package:psychomind/page/login_page.dart';
import 'package:psychomind/page/state_page.dart';
import 'package:psychomind/service/preferences_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    _navigateToNextScreen();
    super.initState();
  }

  Future<void> _navigateToNextScreen() async {
    final isLoggedIn = await PreferencesService().checkLoginStatus();

    await Future.delayed(const Duration(seconds: 5)).then((value) async {
      if (isLoggedIn) {
        bool isProfessionalDataValid =
            await PreferencesService().areProfessionalDataValid();

        if (isProfessionalDataValid) {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const DetailsProfessionalProfile()),
          );
        } else {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyPageState()),
          );
        }
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Image(
            image: AssetImage('assets/logo.png'),
            fit: BoxFit.cover,
          ),
          Center(
            child: Text(
              'Conectemos',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          )
        ],
      ),
    );
  }
}
