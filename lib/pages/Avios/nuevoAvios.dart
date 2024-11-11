import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NuevoaviosDialog extends StatefulWidget {
  final Function onProductoAgregado; // Callback para recargar el CRUD

  NuevoaviosDialog({required this.onProductoAgregado});

  @override
  _NuevoaviosDialogState createState() => _NuevoaviosDialogState();
}

class _NuevoaviosDialogState extends State<NuevoaviosDialog> {
  List<Map<String, dynamic>> proveedores = [];
  int? selectedProveedorId;
  final TextEditingController _tipoController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _codigoProveedorController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarProveedores(); // Cargar proveedores al iniciar
  }

  Future<void> _cargarProveedores() async {
    final url = 'https://maria-chucena-api-production.up.railway.app/proveedor';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        proveedores = data
            .map((proveedor) => {
                  'id': proveedor['id'],
                  'nombre': proveedor['nombre'],
                })
            .toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error al cargar proveedores: ${response.body}')),
      );
    }
  }

  Future<void> _guardarAvios(String tipo, String codigoProveedor,
      int? proveedorId, String cantidad) async {
    const String url =
        'https://maria-chucena-api-production.up.railway.app/avio';

    final Map<String, dynamic> avioData = {
      "codigoProveedor": codigoProveedor,
      "proveedorId": proveedorId,
      "tipoProductoId": 1, // Cambia esto según tu lógica
      "nombre": tipo,
      "stock": int.tryParse(cantidad) ?? 0,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(avioData),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Avío guardado con éxito')),
      );
      widget.onProductoAgregado(); // Llamar al callback para recargar el CRUD
      Navigator.of(context).pop(); // Cerrar el diálogo
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar los avíos: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: const Text('Nuevo avio'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _tipoController,
              decoration: const InputDecoration(
                labelText: 'Tipo',
                hintText: 'Nombre del avío',
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<int>(
              hint: const Text('Seleccione un proveedor'),
              value: selectedProveedorId,
              onChanged: (int? newValue) {
                setState(() {
                  selectedProveedorId = newValue;
                });
              },
              items: proveedores.map((proveedor) {
                return DropdownMenuItem<int>(
                  value: proveedor['id'],
                  child: Text(proveedor['nombre']),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Proveedor',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _codigoProveedorController,
              decoration: const InputDecoration(
                labelText: 'Código de proveedor',
                hintText: 'Código del proveedor',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _cantidadController,
              decoration: const InputDecoration(
                labelText: 'Cantidad',
                hintText: 'Cantidad inicial',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Verificar si la cantidad ingresada es un número
                    if (int.tryParse(_cantidadController.text) == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Cantidad inválida, ingrese un número')),
                      );
                    } else {
                      // Verificar si todos los campos están completos
                      if (_tipoController.text.isNotEmpty &&
                          selectedProveedorId != null &&
                          _codigoProveedorController.text.isNotEmpty &&
                          _cantidadController.text.isNotEmpty) {
                        // Guardar el avío si todos los datos son válidos
                        _guardarAvios(
                          _tipoController.text,
                          _codigoProveedorController.text,
                          selectedProveedorId,
                          _cantidadController.text,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Por favor completa todos los campos.')),
                        );
                      }
                    }
                  },
                  child: const Text('Guardar avío'),
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cerrar el diálogo
                  },
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Método para mostrar el diálogo desde otro lugar en tu aplicación
void mostrarDialogoNuevoAvio(
    BuildContext context, Function onProductoAgregado) {
  showDialog(
    context: context,
    builder: (context) {
      return NuevoaviosDialog(
        onProductoAgregado: onProductoAgregado, // Pasar el callback
      );
    },
  );
}
