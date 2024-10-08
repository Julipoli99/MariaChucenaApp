import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/pages/Home.dart';
import 'package:gestion_indumentaria/pages/Login/inicio.dart';
import 'package:gestion_indumentaria/pages/principal.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: LoginScreen(),
      ),
    );
  }
}
