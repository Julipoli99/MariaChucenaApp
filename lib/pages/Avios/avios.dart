import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/widgets/DrawerMenuLateral.dart';

import 'package:gestion_indumentaria/widgets/HomePage.dart';

import '../Crud/aviosCrudView.dart'; // Importa el archivo de AviosCrudView

class Avios extends StatelessWidget {
  const Avios({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Maria Chucena ERP System'),
        toolbarHeight: 80,
        actions: [
          // Usuario logueado en la esquina superior derecha
          buildLoggedInUser('assets/imagen/logo.png', 'Supervisor'),
        ],
      ),
      drawer: const DrawerMenuLateral(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título principal centrado con subtítulo
            Container(
              color: Colors.grey[800],
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              child: const Center(
                child: Column(
                  children: [
                    Text(
                      'Bienvenidos al sistema de Gestión de Avios',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'De Maria Chucena ERP System',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Aquí mostramos el AviosCrudView
            SizedBox(
              height: 600, // Ajusta el alto según lo necesario
              child: Avioscrudview(),
            ),

            const Divider(),

            // Pie de página centrado
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Text(
                  '© 2024 Maria Chucena ERP System. All rights reserved.',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
