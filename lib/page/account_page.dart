import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:psychomind/model/models.dart';
import 'package:psychomind/page/login_page.dart';
import 'package:psychomind/service/preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAccountPage extends StatelessWidget {
  const MyAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepPurple[100],
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          centerTitle: true,
          title: const Text(
            'Perfil',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                // Cierrar la sesión en FirebaseAuth
                await FirebaseAuth.instance.signOut();
                // Actualizar el estado de inicio de sesión y borra los datos del usuario
                await PreferencesService().updateLoginStatus(false);
                await PreferencesService().clearUserData();
                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              icon: const Icon(Icons.logout_outlined, color: Colors.white),
            )
          ],
        ),
        body: FutureBuilder<UserOrProfessionalModel?>(
          future: _getUserDataFromSharedPreferences(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasData) {
              final UserOrProfessionalModel user = snapshot.data!;
              return Stack(
                children: [
                  Positioned(
                    top: 55,
                    right: 0,
                    left: 0,
                    child: AccountInfo(
                        name: user.name,
                        cedula: user.cedula,
                        email: user.email,
                        phone: user.phone),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                        onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EditAccountInfo(),
                              ),
                            ),
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.deepPurple,
                        )),
                  )
                ],
              );
            }
            return const Text('No se encontraron datos del usuario');
          },
        ));
  }

  Future<UserOrProfessionalModel?> _getUserDataFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataJson = prefs.getString('userData');
    if (userDataJson != null) {
      return UserOrProfessionalModel.fromJson(json.decode(userDataJson));
    } else {
      return null;
    }
  }
}

class AccountInfo extends StatelessWidget {
  final String name;
  final String cedula;
  final String email;
  final String phone;

  const AccountInfo({
    Key? key,
    required this.name,
    required this.cedula,
    required this.email,
    required this.phone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: const FadeInImage(
            placeholder: AssetImage('assets/no-image.jpg'),
            image:
                NetworkImage("https://source.unsplash.com/100x130/?portrait"),
            fit: BoxFit.cover,
            height: 100,
            width: 100,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            name,
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(fontSize: 22),
            ),
          ),
        ),
        Text(
          email,
          style: const TextStyle(fontSize: 16),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(phone, style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}

class EditAccountInfo extends StatelessWidget {
  const EditAccountInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white, size: 28),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text(
          'Edit Account Info',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: const Center(
        child: Text('Edit Account Info'),
      ),
    );
  }
}
