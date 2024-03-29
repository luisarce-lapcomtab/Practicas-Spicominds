import 'package:flutter/material.dart';
import 'package:psychomind/widgets/widgets.dart';

class RegisterPage extends StatelessWidget {
  static const routeName = 'register-page';
  final bool isUser;
  const RegisterPage({
    super.key,
    this.isUser = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: Stack(
          children: [
            Positioned(
              top: 10,
              left: 0,
              right: 0,
              child: RegisterForm(
                isUser: isUser,
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
        ),
      ),
    );
  }
}
