import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/widgets/DrawerMenuLateral.dart';
import 'package:gestion_indumentaria/widgets/HomePage.dart';

class Nuevoprovedor extends StatelessWidget {
  const Nuevoprovedor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Maria Chucena ERP System'),
        toolbarHeight: 80,
        actions: [
          buildLoggedInUser('assets/imagen/logo.png',
              'Supervisor'), // El tipo de rango lo tendria que traer de la base de datos
        ],
      ),
      drawer: const DrawerMenuLateral(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centrar en el medio
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Registro de proveedores',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        buildTextField('Proveedor', 'nombre de proveedor'),
                        const SizedBox(height: 20),
                        buildTextField('Teléfono', 'número de teléfono'),
                        const SizedBox(height: 20),
                        buildTextField('Local', 'nombre del local'),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Acción al guardar el proveedor
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 20),
                              ),
                              child: const Text('Guardar proveedor'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              const Divider(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: Text(
                          '© 2024 Maria Chucena ERP System. All rights reserved.',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Función para construir los campos de texto
  static Widget buildTextField(String label, String hintText) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 18),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
