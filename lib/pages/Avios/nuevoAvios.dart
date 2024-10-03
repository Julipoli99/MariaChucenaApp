import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/widgets/DrawerMenuLateral.dart';
import 'package:gestion_indumentaria/widgets/HomePage.dart';

class Nuevoavios extends StatelessWidget {
  const Nuevoavios({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Maria Chucena ERP System'),
        toolbarHeight: 80,
        actions: [
          buildLoggedInUser('assets/imagen/logo.png',
              'Supervisor'), //el tipo de rango lo tendria que traer de la base de datos
        ],
      ),
      drawer: const DrawerMenuLateral(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                        'Bienvenidos al sistema de Gestion de Nuevos avios',
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

              // Formulario de Registro de Avios
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Registro de avios',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const TextField(
                            decoration: InputDecoration(
                              labelText: 'Tipo',
                              hintText: 'nombre',
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Dropdown para Proveedores con valores de prueba
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Proveedor',
                              hintText: 'proveedor',
                            ),
                            items: <String>[
                              'Proveedor de prueba 1',
                              'Proveedor de prueba 2',
                              'Proveedor de prueba 3'
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              // Acción al seleccionar un proveedor de prueba
                              // Aquí puedes agregar cualquier acción temporal
                              print('Proveedor seleccionado: $newValue');
                            },
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              // Acción al guardar el avío
                              // Agrega cualquier acción temporal para probar
                              print('Avíos guardados');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 50,
                                vertical: 20,
                              ),
                            ),
                            child: const Text(
                              'Guardar avios',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(),
              // Pie de página con usuario logueado
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
}
