import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:psychomind/model/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? name;
  bool loading = true;
  @override
  void initState() {
    _fetchUserData();
    super.initState();
  }

  void _fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataJson = prefs.getString('userData');
    if (userDataJson != null) {
      final userData =
          UserOrProfessionalModel.fromJson(json.decode(userDataJson));
      setState(() {
        name = userData.name;
        loading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Inicio',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Image(
                        image: AssetImage('assets/icon.png'),
                        fit: BoxFit.cover,
                        height: 50,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(loading ? 'Hola, $name' : '',
                            style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    fontSize: 19, color: Colors.deepPurple))),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black54,
                          offset: Offset(2, 2),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        'Carlos Luis López',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontSize: 19,
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      subtitle: Text('De antemano muchas gracias',
                          style: GoogleFonts.poppins(
                              textStyle:
                                  const TextStyle(color: Colors.deepPurple))),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: const FadeInImage(
                          placeholder: AssetImage('assets/no-image.jpg'),
                          image: NetworkImage(
                              "https://source.unsplash.com/100x130/?portrait"),
                          fit: BoxFit.cover,
                          height: 50,
                          width: 50,
                        ),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('13:11'),
                          const SizedBox(height: 5),
                          ClipOval(
                              child: Container(
                            color: Colors.deepPurple,
                            height: 20,
                            width: 20,
                            child: const Center(
                              child: Text(
                                '2',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nuevas publicaciones',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Registros actualizados',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    height: 140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemExtent: 300,
                      itemCount: 3,
                      itemBuilder: (context, i) {
                        final color =
                            Colors.primaries[i % Colors.primaries.length];
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.only(left: 10, bottom: 20),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      //drawer: const Drawer(child: MyAccountPage()),
    );
  }
}
