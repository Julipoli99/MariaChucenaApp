import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/Corte.dart';
import 'package:gestion_indumentaria/models/ModeloCorte.dart';
import 'package:gestion_indumentaria/models/rolloCorte.dart';
import 'package:gestion_indumentaria/models/talleRepetecion.dart';
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
  List<dynamic> modelosACortar = [];
  Map<String, dynamic>? modeloSeleccionadoCompleto;
  String? selectedModelo;

  double? consumo;
  double? capas;
  double? ancho;
  double? largo;

  late Corte corte;

  List<dynamic> rollosDeTela = [];
  Map<String, dynamic>? selectedRolloCompleto;
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

        modelosACortar = (data['modelos'] as List)
            .map((modeloJson) => ModeloCorte.fromJson(modeloJson))
            .toList();
        rollosDeTela = (data['rollos'] as List)
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
                        const SizedBox(height: 20),

                        // Campo de Ancho de la tizada
                        const TextField(
                          decoration: InputDecoration(
                            labelText: 'Ancho de la tizada',
                            hintText: 'Ancho',
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Campo de Largo de la tizada
                        const TextField(
                          decoration: InputDecoration(
                            labelText: 'Largo de la tizada',
                            hintText: 'Largo',
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Dropdown para Nombre del Modelo
                        const Text(
                          'Modelo',
                          style: TextStyle(fontSize: 16),
                        ),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Modelo',
                            border: OutlineInputBorder(),
                          ),
                          items: modelosACortar.map((modelo) {
                            return DropdownMenuItem<String>(
                              value: modelo.modelo.nombre,
                              child: Text(modelo.modelo.nombre),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedModelo = value;
                              modeloSeleccionadoCompleto =
                                  modelosACortar.firstWhere((modelo) =>
                                      modelo.modelo.nombre == selectedModelo);
                            });
                          },
                        ),
                        const SizedBox(height: 20),

                        const SizedBox(height: 20),

                        // Tabla de repetición
                        const Text(
                          'Repetición utilizadas',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        TalleRepeticionSelector(
                          selectedTalleRepeticion: selectedTalle,
                          onTalleRepeticionSelected: (updatedTalleRepeticion) {
                            setState(() {
                              selectedTalle = updatedTalleRepeticion;
                            });
                          },
                        ),

                        const SizedBox(height: 20),

                        // Campo de Consumo de tela
                        const TextField(
                          decoration: InputDecoration(
                            labelText: 'Consumo',
                            hintText: 'Seleccione el consumo',
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          'Rollo',
                          style: TextStyle(fontSize: 16),
                        ),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Rollo',
                            border: OutlineInputBorder(),
                          ),
                          items: rollosDeTela.map((rollo) {
                            return DropdownMenuItem<String>(
                              value: rollo.rollo?.descripcion,
                              child: Text(rollo.rollo!.descripcion),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedRollo = value;
                              selectedRolloCompleto = rollosDeTela.firstWhere(
                                  (rollo) =>
                                      rollo.rollo?.descripcion ==
                                      selectedRollo);
                            });
                          },
                        ),
                        const SizedBox(height: 20),

                        // Campo de Capas del rollo
                        const TextField(
                          decoration: InputDecoration(
                            labelText: 'Capas del rollo',
                            hintText: 'Capas',
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
