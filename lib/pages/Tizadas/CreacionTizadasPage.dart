import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/widgets/DrawerMenuLateral.dart';
import 'package:gestion_indumentaria/widgets/HomePage.dart';

class CreacionTizadasPage extends StatelessWidget {
  const CreacionTizadasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Maria Chucena ERP System'),
        toolbarHeight: 80,
        actions: [
          buildLoggedInUser('assets/imagen/logo.png', 'Supervisor'),
        ],
      ),
      drawer: const DrawerMenuLateral(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40), // Separación con la parte superior

            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Para centrar verticalmente
              children: [
                // Título en la parte izquierda centrado verticalmente
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 100.0), // Ajuste de posición vertical
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .center, // Para centrar horizontalmente
                      children: const [
                        Text(
                          'Registrar Tizada',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Complete todos los detalles relevantes de la tizada',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                    width: 40), // Separación entre título y formulario

                // Formulario y tabla a la derecha
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Dropdown para Nombre del Modelo
                        const Text(
                          'Nombre de Modelo',
                          style: TextStyle(fontSize: 16),
                        ),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            hintText: 'nombre del modelo',
                          ),
                          items: <String>[
                            'Ma123',
                            'Ma124',
                            'Ma125',
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            print('Modelo seleccionado: $newValue');
                          },
                        ),
                        const SizedBox(height: 20),

                        // Tabla de repetición
                        const Text(
                          'Repetición utilizadas',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Table(
                          border: TableBorder.all(color: Colors.black),
                          children: [
                            const TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('T1'),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('T2'),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('T3'),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('T4'),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      labelText: 'Cantidad',
                                      hintText: '0',
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      print('Cantidad T1: $value');
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      labelText: 'Cantidad',
                                      hintText: '0',
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      print('Cantidad T2: $value');
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      labelText: 'Cantidad',
                                      hintText: '0',
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      print('Cantidad T3: $value');
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      labelText: 'Cantidad',
                                      hintText: '0',
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      print('Cantidad T4: $value');
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Campo de Consumo de tela
                        const TextField(
                          decoration: InputDecoration(
                            labelText: 'Consumo de tela',
                            hintText: 'Seleccione el consumo de tela',
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Botón de guardar
                        ElevatedButton(
                          onPressed: () {
                            print('Tizadas guardadas');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 20,
                            ),
                          ),
                          child: const Text(
                            'Guardar todas las tizadas',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Espacio entre el contenido y el pie de página
            const SizedBox(height: 40),

            // Pie de página con usuario logueado
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
    );
  }
}
