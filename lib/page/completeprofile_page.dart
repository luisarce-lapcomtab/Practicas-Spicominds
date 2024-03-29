// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:psychomind/model/models.dart';
import 'package:psychomind/page/state_page.dart';
import 'package:psychomind/service/firebaservice.dart';
import 'package:psychomind/service/preferences_service.dart';

class DetailsProfessionalProfile extends StatefulWidget {
  const DetailsProfessionalProfile({super.key});

  @override
  State<DetailsProfessionalProfile> createState() => _DetailsProfileState();
}

class _DetailsProfileState extends State<DetailsProfessionalProfile> {
  final PageController _pageController = PageController();
  //
  TextEditingController profileController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController educationController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  //
  TextEditingController cityController = TextEditingController();
  TextEditingController professionController = TextEditingController();
  TextEditingController therapyModelController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController socialMediaController = TextEditingController();
  //
  List<String> profileDetailsList = [];
  List<String> areaDetailsList = [];
  List<String> educationDetailsList = [];
  List<String> experienceDetailsList = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _showWelcomeDialog(context);
    });
  }

  Future<void> _showWelcomeDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("¡Bienvenido!"),
          content: const Text('Por favor, complete su perfil para continuar.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Entendido"),
            ),
          ],
        );
      },
    );
  }

  bool validateForms() {
    return cityController.text.isNotEmpty &&
        professionController.text.isNotEmpty &&
        therapyModelController.text.isNotEmpty &&
        locationController.text.isNotEmpty &&
        socialMediaController.text.isNotEmpty;
  }

  // Validar si todas las listas contienen al menos un detalle
  bool validateDetails() {
    return profileDetailsList.isNotEmpty &&
        areaDetailsList.isNotEmpty &&
        educationDetailsList.isNotEmpty &&
        experienceDetailsList.isNotEmpty;
  }

  // Método para guardar los datos
  Future<void> saveData() async {
    final String city = cityController.text.trim();
    final String profession = professionController.text.trim();
    final String therapy = therapyModelController.text.trim();
    final String location = locationController.text.trim();
    final String social = socialMediaController.text.trim();

    final firestoreService = FirestoreService();

    final prefs = await SharedPreferences.getInstance();
    final userDataJson = prefs.getString('userData');

    if (userDataJson != null) {
      final userData =
          UserOrProfessionalModel.fromJson(json.decode(userDataJson));
      print('User id: ${userData.id}');

      final result = await firestoreService.updateProfessionalInfo(
        userData.id,
        city,
        profession,
        therapy,
        location,
        social,
        profileDetailsList,
        areaDetailsList,
        educationDetailsList,
        experienceDetailsList,
      );

      if (result.success) {
        // La actualización en Firestore fue exitosa
        final professionalData =
            await firestoreService.getProfessionalData(userData.id);

        if (professionalData != null) {
          // Actualizar los datos del usuario en SharedPreferences con los nuevos datos del profesional
          await PreferencesService().saveUserData(professionalData);
          // Marcar los datos del profesional como válidos en SharedPreferences
          await PreferencesService().areProfessionalDataValid(
              isDataValid: false); // Campos no están vacíos
        } else {
          // Manejar el caso en que no se pudieron obtener los datos actualizados del profesional
          print(
              'No se pudieron obtener los datos actualizados del profesional');
        }

        print('Datos del profesional actualizados con éxito');
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyPageState()),
        );
      } else {
        // Ocurrió un error durante la actualización
        print(
            'Error al actualizar los datos del profesional: ${result.errorMessage}');
      }
    } else {
      // No se encontraron datos del usuario en SharedPreferences
      print('No se encontraron datos del usuario en SharedPreferences');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Complete You Profile'),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          buildNewDetailsPage(),
          buildExistingDetailsPage(),
        ],
      ),
    );
  }

  void handleNextPagePress() {
    _pageController.nextPage(
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }

  Future<void> _showAlertDialog(BuildContext context, String message) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Warning'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  Widget buildExistingDetailsPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTitleAndFields(
                "Perfil", profileController, profileDetailsList),
            buildTitleAndFields(
                "Área de Atención", areaController, areaDetailsList),
            buildTitleAndFields("Formación Académica", educationController,
                educationDetailsList),
            buildTitleAndFields("Experiencia Profesional", experienceController,
                experienceDetailsList),
            const SizedBox(height: 50.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(50, 40)),
                    onPressed: () {
                      if (validateDetails()) {
                        handleNextPagePress();
                      } else {
                        _showAlertDialog(context,
                            'Por favor, asegúrate de que todos los campos tengan al menos un detalle.');
                      }
                    },
                    child: const Text(
                      'Guardar',
                      style: TextStyle(fontSize: 17),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildNewDetailsPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildInputField("Ciudad", cityController),
            buildInputField("Profesión", professionController),
            buildInputField("Modelo Terapéutico", therapyModelController),
            buildInputField("Ubicación", locationController),
            buildInputField("Red Social", socialMediaController),
            const SizedBox(height: 50.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton(
                  style:
                      ElevatedButton.styleFrom(minimumSize: const Size(50, 40)),
                  onPressed: () {
                    if (validateForms()) {
                      handleNextPagePress();
                    } else {
                      _showAlertDialog(context,
                          'Por favor, asegúrate de llenar todos los campos.');
                    }
                  },
                  child: const Text(
                    'Siguiente',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget buildTitleAndFields(String title, TextEditingController controller,
      List<String> detailsList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold)),
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: detailsList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                detailsList[index],
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                  fontSize: 13.0,
                )),
              ),
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FilledButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(50, 35)),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    TextEditingController bulletController =
                        TextEditingController();
                    return AlertDialog(
                      title: const Text('Agregar detalle'),
                      content: TextField(
                        controller: bulletController,
                        decoration: const InputDecoration(labelText: 'Detalle'),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            String newDetail = bulletController.text.trim();
                            if (newDetail.isNotEmpty) {
                              setState(() {
                                detailsList.add(bulletController.text);
                              });
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content:
                                    Text('El detalle no puede estar vacío'),
                              ));
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('Agregar'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Agregar detalle'),
            ),
          ],
        ),
        const SizedBox(height: 25.0),
      ],
    );
  }
}
