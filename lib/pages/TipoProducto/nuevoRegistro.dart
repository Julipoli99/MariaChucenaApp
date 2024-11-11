import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/pages/principal.dart';
import 'package:http/http.dart' as http;
import 'package:gestion_indumentaria/models/TipoProducto.dart';

String? tipoProductoSeleccionado;
String? tipounidadSeleccionado;
TipoEnum? selectedTipo;
UnidadMetricaEnum? selectedUnidad;

class NuevoTipoDeProductoDialog extends StatefulWidget {
  final VoidCallback onProductoAgregado;

  const NuevoTipoDeProductoDialog(
      {super.key, required this.onProductoAgregado});

  @override
  _NuevoTipoDeProductoDialogState createState() =>
      _NuevoTipoDeProductoDialogState();
}

class _NuevoTipoDeProductoDialogState extends State<NuevoTipoDeProductoDialog> {
  final TextEditingController _nombreController = TextEditingController();
  final String apiUrl =
      'https://maria-chucena-api-production.up.railway.app/tipo-producto';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nuevo Tipo de Producto'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTextField('Nombre', 'Ej: Botón', _nombreController),
            const SizedBox(height: 20),
            buildTipoProductoSelector(),
            const SizedBox(height: 20),
            buildUnidadMetricaProductoSelector(),
            const SizedBox(height: 30),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(140, 50), // Ajusta el tamaño
                      ),
                      child: const Text('Cancelar'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        _guardarTipoProducto(context);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(140, 50), // Ajusta el tamaño
                      ),
                      child: const Text('Guardar'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildTextField(
      String label, String hintText, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
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
                  }
                });
              },
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
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<void> _guardarTipoProducto(BuildContext context) async {
    final String nombre = _nombreController.text;

    if (nombre.isEmpty ||
        tipoProductoSeleccionado == null ||
        tipounidadSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final Map<String, String> data = {
      'nombre': nombre,
      'tipo': tipoProductoSeleccionado!,
      'unidadMetrica': tipounidadSeleccionado!,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tipo de producto guardado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        widget.onProductoAgregado(); // Llama al callback
        Navigator.pop(context); // Cierra el diálogo después de guardar
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error de conexión: $error'),
            backgroundColor: Colors.red),
      );
    }
  }
}
