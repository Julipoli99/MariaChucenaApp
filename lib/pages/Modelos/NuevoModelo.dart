import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/widgets/DrawerMenuLateral.dart';
import 'package:gestion_indumentaria/widgets/HomePage.dart';

class Nuevomodelo extends StatefulWidget {
  const Nuevomodelo({super.key});

  @override
  State<Nuevomodelo> createState() => _NuevomodeloState();
}

class _NuevomodeloState extends State<Nuevomodelo> {
  // Variables de estado para las selecciones
  String? selectedTipo;
  String? selectedGenero;
  String? selectedTela;
  String? selectedPrenda;
  List<String> selectedTalles = [];

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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección izquierda para el título y subtítulo
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Registrar Modelo',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Complete todos los detalles relevantes del modelo',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),
            // Sección derecha para el formulario
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextField('Nombre de Modelo', 'Ej: M001',
                              'nombre del modelo'),
                          const SizedBox(height: 15),
                          _buildRadioGroup(
                              'Tipo',
                              ['Hombre', 'Mujer', 'Niños', 'Unisex'],
                              selectedTipo, (value) {
                            setState(() {
                              selectedTipo = value;
                            });
                          }),
                          const SizedBox(height: 15),
                          _buildDropdown(
                              'Prenda',
                              ['Remera', 'Pantalón', 'Otro'],
                              'Seleccione la prenda del modelo',
                              selectedPrenda, (value) {
                            setState(() {
                              selectedPrenda = value;
                            });
                          }),
                          const SizedBox(height: 15),
                          _buildRadioGroup(
                              'Género',
                              ['Masculino', 'Femenino', 'Otro'],
                              selectedGenero, (value) {
                            setState(() {
                              selectedGenero = value;
                            });
                          }),
                          const SizedBox(height: 15),
                          _buildRadioGroup('Telas', ['Secundaria', 'Terciaria'],
                              selectedTela, (value) {
                            setState(() {
                              selectedTela = value;
                            });
                          }),
                          const SizedBox(height: 15),
                          _buildTextField('Observación', '', 'observación'),
                          const SizedBox(height: 15),
                          _buildTallesRow(),
                          const SizedBox(height: 15),
                          _buildTextField(
                              'Avíos', 'Detalles adicionales del modelo', ''),
                          const SizedBox(height: 15),
                          _buildTextField(
                              'Extras', 'Otros elementos del modelo', ''),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Acción para guardar el modelo
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize:
                                      const Size(140, 50), // Ajusta el tamaño
                                ),
                                child: const Text('Guardar Modelo'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Acción para cargar foto
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize:
                                      const Size(140, 50), // Ajusta el tamaño
                                ),
                                child: const Text('Cargar Foto'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),

                  // Pie de página
                  const Center(
                    child: Text(
                      '© 2024 Maria Chucena ERP System. All rights reserved.',
                      textAlign: TextAlign.center,
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
            border: const OutlineInputBorder(),
            hintText: hint,
            labelText: hintText,
            filled: true,
            fillColor: Colors.grey[200], // Color de fondo del campo
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> items, String hint,
      String? selectedItem, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        DropdownButtonFormField<String>(
          value: selectedItem,
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: hint,
            filled: true,
            fillColor: Colors.grey[200], // Color de fondo del dropdown
          ),
        ),
      ],
    );
  }

  Widget _buildRadioGroup(String label, List<String> options,
      String? groupValue, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Wrap(
          spacing: 10,
          children: options.map((option) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<String>(
                  value: option,
                  groupValue: groupValue, // Almacena la opción seleccionada
                  onChanged: onChanged,
                ),
                Text(option),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTallesRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Talles',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: ['S', 'M', 'L', 'XL'].map((talle) {
            return ChoiceChip(
              label: Text(talle),
              selected: selectedTalles.contains(talle),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedTalles.add(talle);
                  } else {
                    selectedTalles.remove(talle);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
