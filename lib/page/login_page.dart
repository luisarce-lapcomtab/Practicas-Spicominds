import 'package:flutter/material.dart';
import 'package:psychomind/widgets/widgets.dart';

class LoginPage extends StatelessWidget {
  static const routeName = 'login-page';
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.grey[200],
          body: Stack(
            children: [
              Positioned(
                top: MediaQuery.of(context).size.height / 5.5,
                left: 0,
                right: 0,
                child: LoginForm(
                  showMessage: (message) {
                    final snackBar = SnackBar(
                      content: Text(
                        textAlign: TextAlign.center,
                        message,
                        style: const TextStyle(color: Colors.white),
                      ),
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                ),
              ),
            ],
          )),
    );
  }
}
