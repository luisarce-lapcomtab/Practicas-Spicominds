// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:psychomind/model/models.dart';
import 'package:psychomind/service/preferences_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<RegistrationResult> signInWithEmailandPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userId = userCredential.user?.uid;

      if (userId != null) {
        bool isProfessional = await FirestoreService().isProfessional(userId);
        if (isProfessional) {
          UserOrProfessionalModel? professionalData =
              await FirestoreService().getProfessionalData(userId);

          if (professionalData != null) {
            if (professionalData.perfil.isEmpty ||
                professionalData.area.isEmpty ||
                professionalData.educacion.isEmpty ||
                professionalData.experiencia.isEmpty) {
              await PreferencesService().areProfessionalDataValid(
                  isDataValid: true); // Campos vacíos,
            } else {
              await PreferencesService().areProfessionalDataValid(
                  isDataValid: false); // Campos no están vacíos
            }
            // Guardamos los datos del usuario en SharedPreferences
            await PreferencesService().saveUserData(professionalData);
          }
        } else {
          // Obtenemos los datos del usuario del FirestoreService
          UserOrProfessionalModel? userData =
              await FirestoreService().getUserData(userId);

          if (userData != null) {
            // Guardamos los datos del usuario en SharedPreferences
            await PreferencesService().saveUserData(userData);
          }
        }
        return RegistrationResult(success: true);
      }
      return RegistrationResult(success: false);
    } catch (e) {
      if (e.toString().contains("user-not-found")) {
        return RegistrationResult(
            success: false,
            errorMessage: "Usuario no encontrado. Verifica tus credenciales.");
      } else {
        return RegistrationResult(
            success: false,
            errorMessage: "Por favor, Verifica tus credenciales.");
      }
    }
  }

// Método para registrar un usuario en Firebase Authentication
  Future<RegistrationResult> createUserWithEmailandPassword(
      String email,
      String password,
      String name,
      String phone,
      String cedula,
      bool isUser) async {
    try {
      // Registro del usuario en Firebase Authentication
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      // Guardar información del usuario en Firestore
      if (user != null) {
        String uid = user.uid;
        if (isUser) {
          RegistrationResult saveResult = await FirestoreService()
              .saveUserInfo(uid, email, name, phone, cedula);
          return saveResult;
        } else {
          RegistrationResult saveResult = await FirestoreService()
              .saveProfessionalInfo(uid, email, name, phone, cedula);
          return saveResult;
        }
      }
    } catch (e) {
      // Manejo de errores durante el registro
      if (e.toString().contains("email-already-in-use")) {
        return RegistrationResult(
            success: false,
            errorMessage: "El correo electrónico ya está registrado.");
      } else {
        return RegistrationResult(
            success: false, errorMessage: "Error al registrar usuario: $e");
      }
    }
    return RegistrationResult(success: false, errorMessage: "Error inesperado");
  }
}

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> isProfessional(String uid) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('profesional').doc(uid).get();
      return snapshot.exists;
    } catch (e) {
      print("Error al verificar si el usuario es un profesional: $e");
      return false;
    }
  }

  // Método para guardar información del usuario en Firestore
  Future<RegistrationResult> saveUserInfo(String uid, String email, String name,
      String phone, String cedula) async {
    try {
      // Guardar información del usuario en Firestore
      await _firestore.collection('usuarios').doc(uid).set({
        'nombres': name,
        'celular': phone,
        'correo': email,
        'cedula': cedula,
      });
      return RegistrationResult(success: true);
    } catch (e) {
      // Manejo de errores durante la escritura en Firestore
      return RegistrationResult(
          success: false,
          errorMessage: "Error al guardar la información del usuario: $e");
    }
  }

  // Método para guardar información del profesional en Firestore
  Future<RegistrationResult> saveProfessionalInfo(String uid, String email,
      String name, String phone, String cedula) async {
    try {
      // Guardar información del usuario en Firestore
      await _firestore.collection('profesional').doc(uid).set({
        'nombres': name,
        'celular': phone,
        'correo': email,
        'cedula': cedula,
      });
      return RegistrationResult(success: true);
    } catch (e) {
      // Manejo de errores durante la escritura en Firestore
      return RegistrationResult(
          success: false,
          errorMessage: "Error al guardar la información del usuario: $e");
    }
  }

  // Método para actualizar detalles del profesional en Firestore
  Future<RegistrationResult> updateProfessionalInfo(
      String uid,
      String city,
      String profession,
      String therapy,
      String location,
      String social,
      List<String> profileDetailsList,
      List<String> areaDetailsList,
      List<String> educationDetailsList,
      List<String> experienceDetailsList) async {
    try {
      // Guardar información en Firestore
      await _firestore.collection('profesional').doc(uid).update({
        'ciudad': city,
        'profession': profession,
        'therapy': therapy,
        'location': location,
        'social': social,
        'perfil': profileDetailsList,
        'area': areaDetailsList,
        'educacion': educationDetailsList,
        'experiencia': experienceDetailsList,
      });
      return RegistrationResult(success: true);
    } catch (e) {
      // Manejo de errores durante la escritura en Firestore
      return RegistrationResult(
          success: false,
          errorMessage: "Error al actualizar los detalles del profesional: $e");
    }
  }

  // Método para obtener los datos de un usuario desde Firestore
  Future<UserOrProfessionalModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot userDataSnapshot =
          await _firestore.collection('usuarios').doc(uid).get();

      if (userDataSnapshot.exists) {
        Map<String, dynamic> userData =
            userDataSnapshot.data() as Map<String, dynamic>;
        userData['id'] = userDataSnapshot.id;
        return UserOrProfessionalModel.fromJson(userData);
      } else {
        return UserOrProfessionalModel.empty(); // Si el documento no existe
      }
    } catch (e) {
      print("Error al obtener datos de usuario: $e");
    }
    return null;
  }

  // Método para obtener los datos de un profesional desde Firestore
  Future<UserOrProfessionalModel?> getProfessionalData(String uid) async {
    try {
      DocumentSnapshot professionalSnapshot =
          await _firestore.collection('profesional').doc(uid).get();
      if (professionalSnapshot.exists) {
        Map<String, dynamic> professionalData =
            professionalSnapshot.data() as Map<String, dynamic>;
        professionalData['id'] = professionalSnapshot.id;
        print('Datos del profesional obtenidos: $professionalData');
        return UserOrProfessionalModel.fromJson(professionalData);
      } else {
        return UserOrProfessionalModel.empty(); // Si el documento no existe
      }
    } catch (e) {
      // Manejo de errores
      print('Error al cargar los datos del profesional: $e');
    }
    return null;
  }

  Future<List<UserOrProfessionalModel>> getProfessionalList() async {
    final querySnapshot = await _firestore.collection('profesional').get();
    return querySnapshot.docs.map((doc) {
      return UserOrProfessionalModel.fromJson(doc.data());
    }).toList();
  }
}

class RegistrationResult {
  final bool success; // Indica si la operación fue exitosa
  final String? errorMessage; // Mensaje de error en caso de fallo

  RegistrationResult({required this.success, this.errorMessage});
}
