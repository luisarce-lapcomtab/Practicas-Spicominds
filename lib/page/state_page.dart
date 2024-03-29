// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import 'package:psychomind/page/account_page.dart';
import 'package:psychomind/page/home_page.dart';
import 'package:psychomind/page/messages_page.dart';
import 'package:psychomind/page/professionals_page.dart';

class MyPageState extends StatefulWidget {
  const MyPageState({super.key});

  @override
  State<MyPageState> createState() => _MyPageStateState();
}

class _MyPageStateState extends State<MyPageState> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Inicio',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.search),
            icon: Icon(Icons.search_outlined),
            label: 'Profesio..',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.assignment),
            icon: Icon(Icons.assignment_outlined),
            label: 'Registros',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.more),
            icon: Icon(Icons.more_outlined),
            label: 'Foro',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('2'),
              child: Icon(Icons.messenger),
            ),
            label: 'Mensajes',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_2_outlined),
            label: 'Perfil',
          ),
        ],
      ),
      body: <Widget>[
        const MyHomePage(),
        const MyProfessionalsPage(),
        Scaffold(
          backgroundColor: Colors.deepPurple[100],
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            centerTitle: true,
            title: const Text(
              'Registros',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          body: const Center(
            child: Text('Registros'),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.deepPurple[100],
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            centerTitle: true,
            title: const Text(
              'Foro',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          body: const Center(
            child: Text('Foro'),
          ),
        ),
        const MessagesPage(),
        const MyAccountPage(),
      ][currentPageIndex],
    );
  }
}
