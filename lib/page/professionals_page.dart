// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:psychomind/model/models.dart';
import 'package:psychomind/service/firebaservice.dart';

// Modelo
class ProfileData {
  final String title;
  final String subtitle;
  final String city;

  const ProfileData({
    required this.title,
    required this.subtitle,
    required this.city,
  });
}

class MyProfessionalsPage extends StatelessWidget {
  const MyProfessionalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          centerTitle: true,
          title: const Text(
            'Profesionales',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          )),
      body: FutureBuilder<List<UserOrProfessionalModel>>(
        future: FirestoreService().getProfessionalList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final professionals = snapshot.data!;
            return ProfileList(professionals: professionals);
          }
        },
      ),
    );
  }
}

class ProfileList extends StatelessWidget {
  final List<UserOrProfessionalModel> professionals;

  const ProfileList({super.key, required this.professionals});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: professionals.length,
      itemBuilder: (context, index) {
        return ProfileCard(
          name: professionals[index].name,
          profession: professionals[index].profession,
          city: professionals[index].ciudad,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfesionalProfile(
                  professional: professionals[index],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String name;
  final String profession;
  final String city;
  final VoidCallback onPressed;

  const ProfileCard({
    super.key,
    required this.name,
    required this.profession,
    required this.onPressed,
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.all(10.0),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            offset: Offset(1, 1),
            blurRadius: 2,
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        children: [
          const ClipRRect(
            child: FadeInImage(
              placeholder: AssetImage('assets/no-image.jpg'),
              image:
                  NetworkImage("https://source.unsplash.com/100x130/?portrait"),
              fit: BoxFit.cover,
              height: 100,
              width: 80,
            ),
          ),
          const SizedBox(height: 20.0),
          Text(
            name,
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    fontSize: 18,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold)),
          ),
          Text(profession,
              style: GoogleFonts.poppins(
                  textStyle: const TextStyle(color: Colors.deepPurple))),
          Text(
            '$city - Ecuador',
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    color: Colors.deepPurple, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FilledButton(
                  style: ElevatedButton.styleFrom(minimumSize: Size(50, 33)),
                  onPressed: onPressed,
                  child: Text('Ver Perfil', style: GoogleFonts.poppins())),
              FilledButton(
                  style: ElevatedButton.styleFrom(minimumSize: Size(50, 33)),
                  onPressed: () {},
                  child: Text('Agendar cita', style: GoogleFonts.poppins())),
              FilledButton(
                  style: ElevatedButton.styleFrom(minimumSize: Size(50, 33)),
                  onPressed: () {},
                  child: Text('Mensaje', style: GoogleFonts.poppins()))
            ],
          ),
        ],
      ),
    );
  }
}

class ProfesionalProfile extends StatelessWidget {
  final UserOrProfessionalModel professional; // El profesional correspondiente
  const ProfesionalProfile({super.key, required this.professional});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white, size: 28),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text(
          'Perfil del profesional',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfessionalDrawerHeader(
              professional: professional,
            ),
            DetailsProfile(professional: professional),
          ],
        ),
      ),
    );
  }
}

//
class ProfessionalDrawerHeader extends StatelessWidget {
  final UserOrProfessionalModel professional;
  const ProfessionalDrawerHeader({super.key, required this.professional});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.deepPurple[50],
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: const Color.fromARGB(255, 173, 238, 231),
            margin: EdgeInsets.only(top: 8),
            height: 135,
            width: 105,
            child: FadeInImage(
              placeholder: AssetImage('assets/no-image.jpg'),
              image:
                  NetworkImage("https://source.unsplash.com/100x130/?portrait"),
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  professional.name,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  professional.profession,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontWeight: FontWeight.bold)),
                ),
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
                      TextSpan(
                        text: 'Modelo Terapéutico: ',
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold)),
                      ),
                      TextSpan(
                        text: professional.therapy,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${professional.ciudad} - Ecuador',
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        'Agendar Cita',
                        style: GoogleFonts.poppins(textStyle: TextStyle()),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        'Mensaje',
                        style: GoogleFonts.poppins(textStyle: TextStyle()),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetailsProfile extends StatelessWidget {
  final UserOrProfessionalModel professional;
  const DetailsProfile({super.key, required this.professional});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Perfil',
            style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    fontSize: 20.0,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: professional.perfil.map((perfil) {
              return BulletText(text: perfil);
            }).toList(),
          ),

          SizedBox(height: 20.0),

          // Área de Atención
          Text(
            'Área de Atención',
            style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    fontSize: 20.0,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: professional.area.map((area) {
              return BulletText(text: area);
            }).toList(),
          ),
          SizedBox(height: 20.0),

          // Formación Académica
          Text(
            'Formación Académica',
            style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    fontSize: 20.0,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: professional.educacion.map((formacion) {
              return BulletText(text: formacion);
            }).toList(),
          ),
          SizedBox(height: 20.0),

          // Experiencia Profesional
          Text(
            'Experiencia Profesional',
            style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    fontSize: 20.0,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: professional.experiencia.map((exp) {
              return BulletText(text: exp);
            }).toList(),
          ),
          SizedBox(height: 20.0),

          // Contacto
          Text(
            'Contacto',
            style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    fontSize: 20.0,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold)),
          ),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2.5,
            children: [
              ContactInfo(
                icon: Icons.phone,
                title: 'Teléfono',
                subtitle: professional.phone,
              ),
              ContactInfo(
                icon: Icons.email,
                title: 'Email',
                subtitle: professional.email,
              ),
              ContactInfo(
                icon: Icons.facebook,
                title: 'Red Social',
                subtitle: professional.social,
              ),
              ContactInfo(
                icon: Icons.location_on,
                title: 'Ubicación',
                subtitle: professional.location,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ContactInfo extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const ContactInfo({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(child: Icon(icon)),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold)),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontSize: 10.0, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BulletText extends StatelessWidget {
  final String text;

  const BulletText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      minVerticalPadding: 0,
      horizontalTitleGap: 0,
      title: Text(text,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          )),
      leading: Icon(Icons.fiber_manual_record, size: 10),
    );
  }
}
