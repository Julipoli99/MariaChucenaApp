import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/widgets/DrawerMenuLateral.dart';
import 'package:gestion_indumentaria/widgets/HomePage.dart';

class Nuevomodelo extends StatelessWidget {
  const Nuevomodelo({super.key});

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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Título principal
            Container(
              color: Colors.grey[800],
              padding: const EdgeInsets.all(20.0),
              child: const Center(
                child: Column(
                  children: [
                    Text(
                      'Registrar Modelo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Complete todos los detalles relevantes del modelo',
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

            // Formulario para registrar modelo
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                        'Nombre de Modelo', 'Ej: M001', 'nombre del modelo'),
                    const SizedBox(height: 15),
                    _buildDropdown(
                        'Tipo',
                        ['Hombre', 'Mujer', 'Niños', 'Unisex'],
                        'Seleccione el tipo de modelo'),
                    const SizedBox(height: 15),
                    _buildDropdown('Prenda', ['Remera', 'Pantalón', 'Otro'],
                        'Seleccione la prenda de modelo'),
                    const SizedBox(height: 15),
                    _buildDropdown('Género', ['Masculino', 'Femenino', 'Otro'],
                        'Seleccione el género del modelo'),
                    const SizedBox(height: 15),
                    _buildDropdown('Telas', ['Secundaria', 'Terciaria'],
                        'Seleccione el tipo de tela del modelo'),
                    const SizedBox(height: 15),
                    _buildTextField('Observación', '', 'observación'),
                    const SizedBox(height: 15),
                    _buildTextField(
                        'Talles', 'Ingrese los talles disponibles', ''),
                    const SizedBox(height: 15),
                    _buildTextField(
                        'Avíos', 'Detalles adicionales del modelo', ''),
                    const SizedBox(height: 15),
                    _buildTextField('Extras', 'Otros elementos del modelo', ''),
                    const SizedBox(height: 30),

                    // Botones de guardar y cargar foto
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Acción para guardar el modelo
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(
                                150, 50), // Ajusta el tamaño del botón
                          ),
                          child: const Text('Guardar Modelo'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Acción para cargar foto
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(
                                150, 50), // Ajusta el tamaño del botón
                          ),
                          child: const Text('Cargar Foto'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Pie de página
            const Center(
              child: Text(
                '© 2024 Maria Chucena ERP System. All rights reserved.',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, String hintText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: hint,
            labelText: hintText,
            filled: true,
            fillColor: Colors.grey[200], // Color de fondo del campo
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> items, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        DropdownButtonFormField<String>(
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
          onChanged: (value) {},
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: hint,
            filled: true,
            fillColor: Colors.grey[200], // Color de fondo del dropdown
          ),
        ),
      ],
    );
  }
}
