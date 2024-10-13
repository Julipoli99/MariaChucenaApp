import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/widgets/DrawerMenuLateral.dart';
import 'package:gestion_indumentaria/widgets/HomePage.dart';

import 'package:http/http.dart' as http;

class Nuevomodelo extends StatefulWidget {
  const Nuevomodelo({super.key});

  @override
  State<Nuevomodelo> createState() => _NuevomodeloState();
}

class _NuevomodeloState extends State<Nuevomodelo> {

  // Función para crear el POST
  Future<void> createPost() async {
    const url = "https://maria-chucena-api-production.up.railway.app/modelo";
    final uri = Uri.parse(url);

    // Cuerpo de la petición con los datos del modelo
    final Map<String, dynamic> body = {
      'codigo': codigo,
      'nombre': nombre,
      'prenda': selectedPrenda,
      'genero': selectedGenero,
      'tieneTelaAuxiliar': true,
      'tieneTelaSecundaria': selectedTelaSecundaria,
      'talles': selectedTalles,
    };

    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        // Petición exitosa
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Modelo guardado con éxito.')),
        );
      } else {
        // Manejo de errores
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar el modelo: ${response.body}')),
        );
      }
    } catch (e) {
      // Manejo de excepciones
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }



  // Variables de estado para las selecciones
  String? codigo;
  String? nombre;
  String? selectedTipo;
  String? selectedGenero;
  bool? selectedTelaSecundaria = false;
  String? selectedPrenda;
  List<String> selectedTalles = ["M", "S"];
  String? observacion;

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
                          TextField(
                            
              onChanged: (value) {
                setState(() {
                  codigo = value;
                });
              },
              decoration: const InputDecoration(labelText: 'Codigo de Modelo'),
            ),
                          const SizedBox(height: 15),
                          TextField(
              onChanged: (value) {
                setState(() {
                  nombre = value;
                });
              },
              decoration: const InputDecoration(labelText: 'Nombre de Modelo'),
            ),
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
                              ['MASCULINO', 'FEMENINO', 'UNISEX'],
                              selectedGenero, (value) {
                            setState(() {
                              selectedGenero = value;
                            });
                          }),
                          const SizedBox(height: 15),
                          _buillTelaRow(),
                          const SizedBox(height: 15),
                          TextField(
              onChanged: (value) {
                setState(() {
                  observacion = value;
                });
              },
              decoration: const InputDecoration(labelText: 'Observacion'),
            ),
                          const SizedBox(height: 15),
                          _buildTallesRow(),
                          const SizedBox(height: 15),
                          //_buildTextField(
                           //   'Avíos', 'Detalles adicionales del modelo', ''),
                          const SizedBox(height: 15),
                         // _buildTextField(
                         //     'Extras', 'Otros elementos del modelo', ''),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [




                              // ********** Boton para guardar => POST https://maria-chucena-api-production.up.railway.app/modelo



                              ElevatedButton(
                                onPressed: () {
                                  // Acción para guardar el modelo
                                  createPost();
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize:
                                      const Size(140, 50), // Ajusta el tamaño
                                ),
                                child: const Text('Guardar Modelo'),
                              ),
                              ElevatedButton(

                                // INPUT FOTO


                                onPressed: () {
                                  // ###PENDIENTE###...

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

  Widget _buildTextField(String label, String hint, String hintText, dynamic attribute) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        TextField(
          onChanged: (value) {
            setState(() {
              attribute = value;
            });
          },
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
              //  print(selected);
                
                setState(() {
                  if (selected) {
                    selectedTalles.add(talle);
                    print(selectedTalles);
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

  Widget _buillTelaRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Telas',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: ['Primaria', 'Secundaria'].map((telas) {
            return ChoiceChip(
              label: Text(telas),
              selected: selectedTalles.contains(telas),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedTalles.add(telas);
                  } else {
                    selectedTalles.remove(telas);
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
