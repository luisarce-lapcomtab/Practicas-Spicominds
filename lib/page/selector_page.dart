import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:psychomind/page/register_page.dart';
import 'package:psychomind/widgets/widgets.dart';

class SelectorPage extends StatelessWidget {
  static const routeName = 'selector-page';
  const SelectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height / 5,
              left: 0,
              right: 0,
              child: const RolSelector(),
            ),
          ],
        ),
      ),
    );
  }
}

class RolSelector extends StatelessWidget {
  const RolSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          const Hero(
            tag: 'icon',
            child: Image(
              image: AssetImage('assets/icon.png'),
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                'ANTES DE EMPEZAR',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Text(
            'Elige tu rol en PsychoMind',
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                  color: Colors.deepPurple, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 50),
          CustomButton(
              text: 'Especialista',
              onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegisterPage(
                            isUser: false,
                          )))),
          const SizedBox(height: 20),
          CustomButton(
              text: 'Usuario',
              onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegisterPage(
                            isUser: true,
                          )))),
        ],
      ),
    );
  }
}
