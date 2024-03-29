// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:psychomind/model/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  Future<void> updateLoginStatus(bool isLoggedIn) async {
    try {
      print('Estado de inicio de sesión. isLoggedIn: $isLoggedIn');

      final prefs = await SharedPreferences.getInstance();

      if (isLoggedIn) {
        prefs.setBool('isLoggedIn', true);
      } else {
        prefs.remove('isLoggedIn');
      }
    } catch (e) {
      print('Error al actualizar el estado de inicio de sesión: $e');
    }
  }

  Future<void> saveUserData(UserOrProfessionalModel userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataJson = json.encode(userData.toJson());
      prefs.setString('userData', userDataJson);
    } catch (e) {
      print('Error al guardar los datos del usuario: $e');
    }
  }

  Future<void> clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('userData');
    } catch (e) {
      print('Error al borrar los datos del usuario: $e');
    }
  }

  Future<bool> areProfessionalDataValid({bool? isDataValid}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (isDataValid != null) {
        await prefs.setBool('isProfessionalDataValid', isDataValid);
      }
      return prefs.getBool('isProfessionalDataValid') ?? false;
    } catch (e) {
      print('Error al establecer el valor en SharedPreferences: $e');
      return false;
    }
  }

  Future<bool> checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      return prefs.getBool('isLoggedIn') ?? false;
    } catch (e) {
      print('Error al verificar el estado de inicio de sesión: $e');
      return false;
    }
  }
}
