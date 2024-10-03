import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/widgets/DrawerMenuLateral.dart';
import 'package:gestion_indumentaria/widgets/HomePage.dart';

class Nuevotipodetela extends StatefulWidget {
  const Nuevotipodetela({super.key});

  @override
  _NuevotipodetelaState createState() => _NuevotipodetelaState();
}

class _NuevotipodetelaState extends State<Nuevotipodetela> {
  final List<bool> _selectedSeasons = [false, false, false, false];
  final List<String> _seasons = ['Primavera', 'Verano', 'Otoño', 'Invierno'];

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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Registro tipo de Telas',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Complete todos los detalles relevantes del tipo de tela',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTextField('Tipo de tela', 'frizada'),
                        const SizedBox(height: 20),
                        const Text(
                          'Estación',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        ToggleButtons(
                          isSelected: _selectedSeasons,
                          selectedColor: Colors.white,
                          color: Colors.grey,
                          fillColor: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                          children: _seasons
                              .map((season) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    child: Text(season),
                                  ))
                              .toList(),
                          onPressed: (int index) {
                            setState(() {
                              _selectedSeasons[index] =
                                  !_selectedSeasons[index]; // Cambiar estado
                            });
                          },
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Acción al guardar el tipo de tela
                                // Aquí puedes manejar las estaciones seleccionadas
                                final selectedStations = _seasons
                                    .asMap()
                                    .entries
                                    .where(
                                        (entry) => _selectedSeasons[entry.key])
                                    .map((entry) => entry.value)
                                    .toList();

                                print(
                                    'Estaciones seleccionadas: $selectedStations');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 20),
                              ),
                              child: const Text('Guardar Tipo Tela'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
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
