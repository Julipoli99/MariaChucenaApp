import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/pages/TipoProducto/registroTipoProducto.dart';
import 'package:gestion_indumentaria/widgets/HomePage.dart';
import 'package:http/http.dart' as http;
import 'package:gestion_indumentaria/models/TipoProducto.dart';
import 'package:gestion_indumentaria/widgets/DrawerMenuLateral.dart';

String? tipoProductoSeleccionado;
String? tipounidadSeleccionado;
TipoEnum? selectedTipo;
UnidadMetricaEnum? selectedUnidad;

class NuevoTipoDeProducto extends StatefulWidget {
  const NuevoTipoDeProducto({super.key});

  @override
  _NuevoTipoDeProducto createState() => _NuevoTipoDeProducto();
}

class _NuevoTipoDeProducto extends State<NuevoTipoDeProducto> {
  final TextEditingController _nombreController = TextEditingController();

  // URL de la API
  final String apiUrl =
      'https://maria-chucena-api-production.up.railway.app/tipo-producto';

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                          'Registro de nuevo tipo de Producto',
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        buildTextField('Nombre', 'nombre del tipo Producto',
                            _nombreController),
                        const SizedBox(height: 20),
                        buildTipoProductoSelector(),
                        const SizedBox(height: 20),
                        buildUnidadMetricaProductoSelector(),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _guardarTipoProducto();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 20),
                              ),
                              child: const Text('Guardar tipo producto'),
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
                            '© 2024 Maria Chucena ERP System. All rights reserved.'),
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
  static Widget buildTextField(
      String label, String hintText, TextEditingController controller) {
    return TextField(
      controller: controller,
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

  Widget buildTipoProductoSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tipo de Producto',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: TipoEnum.values.map((tipo) {
            return ChoiceChip(
              label: Text(tipo.toString().split('.').last),
              selected: selectedTipo == tipo,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedTipo = tipo;
                    tipoProductoSeleccionado =
                        selectedTipo.toString().split('.').last;
                    print(
                        "Tipo seleccionado: $tipoProductoSeleccionado"); // Línea de depuración
                  }
                });
              },
              labelStyle: const TextStyle(fontSize: 16),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget buildUnidadMetricaProductoSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Unidad Metrica',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: UnidadMetricaEnum.values.map((unidad) {
            return ChoiceChip(
              label: Text(unidad.toString().split('.').last),
              selected: selectedUnidad == unidad,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedUnidad = unidad;
                    tipounidadSeleccionado =
                        selectedUnidad.toString().split('.').last;
                  }
                });
              },
              labelStyle: const TextStyle(fontSize: 16),
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<void> _guardarTipoProducto() async {
    final String nombre = _nombreController.text;

    // Verifica si se completaron todos los campos necesarios
    if (nombre.isEmpty ||
        tipoProductoSeleccionado == null ||
        tipounidadSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    // Verifica que el tipo de producto seleccionado sea válido
    if (tipoProductoSeleccionado != 'AVIO' &&
        tipoProductoSeleccionado != 'TELA') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('El tipo de producto debe ser AVIO o TELA')),
      );
      return;
    }

    final Map<String, String> data = {
      'nombre': nombre,
      'tipo': tipoProductoSeleccionado!, // Cambié el campo a 'tipo'
      'unidadMetrica': tipounidadSeleccionado!,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Tipo de producto guardado exitosamente')),
        );
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
              builder: (context) => const TipoProductoregistradospage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.body}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $error')),
      );
    }
  }
}
