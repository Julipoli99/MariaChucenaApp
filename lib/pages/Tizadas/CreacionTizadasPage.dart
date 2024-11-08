// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/Corte.dart';
import 'package:gestion_indumentaria/models/ModeloCorte.dart';
import 'package:gestion_indumentaria/models/rolloCorte.dart';
import 'package:gestion_indumentaria/models/talleRepetecion.dart';
import 'package:gestion_indumentaria/pages/Modelos/orden%20de%20corte/controlDeCorte.dart';
import 'package:gestion_indumentaria/widgets/DrawerMenuLateral.dart';
import 'package:gestion_indumentaria/widgets/HomePage.dart';
import 'package:gestion_indumentaria/widgets/TalleRepeticionSelector.dart';
import 'package:http/http.dart' as http;

class CreacionTizadasPage extends StatefulWidget {
  CreacionTizadasPage({super.key, required this.idCorte});
  final int idCorte;

  _CreacionTizadasPageState createState() => _CreacionTizadasPageState();
}

class _CreacionTizadasPageState extends State<CreacionTizadasPage> {
  List<TalleRepeticion> selectedTalle = [];

  List<dynamic> modelosCorte = [];
  ModeloCorte? modeloSeleccionadoCompleto;
  String? selectedModelo;

  double? consumo;
  double? capas;
  double? ancho;
  double? largo;

  late Corte corte;

  List<dynamic> rollosCorte = [];
  RolloCorte? rolloSeleccionadoCompleto;
  String? selectedRollo;

  @override
  void initState() {
    super.initState();
    _cargarCorte(widget.idCorte);
  }

  Future<void> _cargarCorte(int idCorte) async {
    final url =
        'https://maria-chucena-api-production.up.railway.app/corte/$idCorte';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      setState(() {
        corte = Corte.fromJson(data);

        modelosCorte = (data['modelos'] as List)
            .map((modeloJson) => ModeloCorte.fromJson(modeloJson))
            .toList();
        rollosCorte = (data['rollos'] as List)
            .map((rolloJson) => RolloCorte.fromJson(rolloJson))
            .toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar el corte: ${response.body}'),
        ),
      );
    }
  }

  Future<void> createTizada() async {
    if (modeloSeleccionadoCompleto == null ||
        rolloSeleccionadoCompleto == null ||
        consumo == null ||
        capas == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Por favor, completa todos los campos obligatorios.')),
      );
      return;
    }

    final talleRepeticionList = selectedTalle.map((talleRepeticion) {
      return {
        'talleId': talleRepeticion.talleId,
        'repeticion': talleRepeticion.repeticion,
      };
    }).toList();

    final orderData = {
      'ancho': ancho,
      'largo': largo,
      'corteId': widget.idCorte,
      'modelos': [
        {
          'modeloCorteId': modeloSeleccionadoCompleto?.id,
          'consumo': consumo,
          'curva': talleRepeticionList,
        },
      ],
      'rollosUtilizados': [
        {
          'rolloCorteId': rolloSeleccionadoCompleto?.id,
          'capas': capas,
        },
      ],
    };

    print(orderData);

    try {
      final response = await http.post(
        Uri.parse('https://maria-chucena-api-production.up.railway.app/tizada'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(orderData),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tizada creada exitosamente.')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ordenDeCorteregistradospage(),
          ),
        );
      } else {
        final responseBody = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error al crear la tizada: ${responseBody['message'] ?? 'Error desconocido'}',
            ),
          ),
        );
        print('Error al crear la tizada: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e')),
      );
      print('Error de conexión: $e');
    }
  }

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
                const Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 100.0), // Ajuste de posición vertical
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .center, // Para centrar horizontalmente
                      children: [
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
                        const Text(
                          'Datos de la tizada:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),

                        // Campo de Ancho de la tizada
                        buildTextField('Ancho de la tizada', (value) {
                          setState(() {
                            if (value != null && value.isNotEmpty) {
                              ancho = double.tryParse(
                                  value); // Safely parse the string to a double
                            } else {
                              ancho = null; // Set to null if the input is empty
                            }
                          });
                        }),

                        const SizedBox(height: 20),

                        // Campo de Largo de la tizada
                        buildTextField('Largo de la tizada', (value) {
                          setState(() {
                            // Convert the input string to a double
                            if (value != null && value.isNotEmpty) {
                              largo = double.tryParse(
                                  value); // Safely parse the string to a double
                            } else {
                              largo = null; // Set to null if the input is empty
                            }
                          });
                        }),

                        const SizedBox(height: 30),
                        const Text(
                          'Modelo de la tizada:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),

                        buildDropdownModeloCorte(),

                        const SizedBox(height: 20),

                        // Campo de Consumo de tela
                        buildTextField('Consumo', (value) {
                          setState(() {
                            // Convert the input string to a double
                            if (value != null && value.isNotEmpty) {
                              consumo = double.tryParse(
                                  value); // Safely parse the string to a double
                            } else {
                              consumo =
                                  null; // Set to null if the input is empty
                            }
                          });
                        }),

                        // Tabla de repetición

                        const SizedBox(height: 20),
                        TalleRepeticionSelector(
                          selectedTalleRepeticion: selectedTalle,
                          onTalleRepeticionSelected: (updatedTalleRepeticion) {
                            setState(() {
                              selectedTalle = updatedTalleRepeticion;
                            });
                          },
                        ),

                        const SizedBox(height: 30),

                        const Text(
                          'Rollo de la tizada:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),

                        buildDropdownRolloCorte(),
                        const SizedBox(height: 20),

                        // Campo de Capas del rollo
                        buildTextField('Capas', (value) {
                          setState(() {
                            // Convert the input string to a double
                            if (value != null && value.isNotEmpty) {
                              capas = double.tryParse(
                                  value); // Safely parse the string to a double
                            } else {
                              capas = null; // Set to null if the input is empty
                            }
                          });
                        }),

                        const SizedBox(height: 30),

                        // Botón de guardar
                        ElevatedButton(
                          onPressed: createTizada,
                          child: const Text('Crear tizada'),
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

  Widget buildDropdownModeloCorte() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: DropdownButtonFormField<ModeloCorte>(
        decoration: const InputDecoration(
          labelText: 'Seleccionar modelo',
          border: OutlineInputBorder(),
        ),
        items: modelosCorte.isNotEmpty
            ? modelosCorte.map((modeloCorte) {
                return DropdownMenuItem<ModeloCorte>(
                  value: modeloCorte, // Aquí pasamos el objeto completo
                  child:
                      Text(modeloCorte.modelo.nombre), // Visualizamos el nombre
                );
              }).toList()
            : [],
        onChanged: (selectedModeloCorte) {
          setState(() {
            modeloSeleccionadoCompleto = selectedModeloCorte;
            selectedModelo = selectedModeloCorte?.modelo.nombre;
            print(
                'Modelo seleccionado: ${modeloSeleccionadoCompleto?.modelo.nombre}');
            print(
                'ID del modelo seleccionado: ${modeloSeleccionadoCompleto?.id}');
          });
        },
        value:
            modeloSeleccionadoCompleto, // Asociamos el objeto completo como valor
      ),
    );
  }

  Widget buildTextField(String label, ValueChanged<String?> onChanged) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
    );
  }

  Widget buildDropdownRolloCorte() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: DropdownButtonFormField<RolloCorte>(
        decoration: const InputDecoration(
          labelText: 'Seleccionar rollo',
          border: OutlineInputBorder(),
        ),
        items: rollosCorte.isNotEmpty
            ? rollosCorte.map((rolloCorte) {
                return DropdownMenuItem<RolloCorte>(
                  // Cambié el tipo aquí
                  value: rolloCorte, // Aquí pasamos el objeto completo
                  child: Text(
                      rolloCorte.rollo.descripcion), // Visualizamos el nombre
                );
              }).toList()
            : [],
        onChanged: (selectedRolloCorte) {
          setState(() {
            rolloSeleccionadoCompleto = selectedRolloCorte;
            selectedRollo = selectedRolloCorte!.rollo?.descripcion;
            print(
                'ROLLO seleccionado: ${rolloSeleccionadoCompleto!.rollo!.descripcion}');
            print(
                'ID del modelo seleccionado: ${rolloSeleccionadoCompleto?.id}');
          });
        },
        value:
            rolloSeleccionadoCompleto, // Asociamos el objeto completo como valor
      ),
    );
  }
}
