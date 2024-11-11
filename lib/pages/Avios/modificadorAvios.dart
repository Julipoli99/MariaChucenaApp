import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/Avio.dart';
import 'package:http/http.dart' as http;

class ModificadoraviosDialog extends StatefulWidget {
  final Avio? avio;
  final int? avioId;

  const ModificadoraviosDialog({super.key, this.avio, this.avioId});

  @override
  _ModificadoraviosDialogState createState() => _ModificadoraviosDialogState();
}

class _ModificadoraviosDialogState extends State<ModificadoraviosDialog> {
  Avio? avioData;
  int cantidadInicial = 0;
  int cantidadActual = -1; // Valor inicial inválido
  List<String> proveedores = [];
  String? selectedProveedor;

  @override
  void initState() {
    super.initState();
    if (widget.avio != null) {
      avioData = widget.avio;
      cantidadInicial = avioData!.stock;
      cantidadActual = cantidadInicial;
      _cargarProveedores();
    } else if (widget.avioId != null) {
      fetchAvioById(widget.avioId!);
      _cargarProveedores();
    }
  }

  Future<void> _cargarProveedores() async {
    final url = 'https://maria-chucena-api-production.up.railway.app/proveedor';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        proveedores = data.map((p) => p['nombre'].toString()).toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar proveedores: ${response.body}'),
        ),
      );
    }
  }

  Future<void> fetchAvioById(int avioId) async {
    final url =
        'https://maria-chucena-api-production.up.railway.app/avio/$avioId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        avioData = Avio.fromJson(jsonDecode(response.body));
        cantidadInicial = avioData!.stock;
        cantidadActual = cantidadInicial;
      });
    } else {
      throw Exception('Error al cargar el avío');
    }
  }

  Future<void> updateStock() async {
    if (cantidadActual > 0) {
      if (avioData != null) {
        final nuevaCantidad = cantidadActual;
        final response = await http.patch(
          Uri.parse(
              'https://maria-chucena-api-production.up.railway.app/avio/${avioData!.id}'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'stock': nuevaCantidad}),
        );

        if (response.statusCode == 200) {
          Navigator.of(context)
              .pop(true); // Retorna true solo si se guarda exitosamente
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Stock actualizado correctamente')),
          );
        } else {
          throw Exception('Error al actualizar el stock: ${response.body}');
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Agregar una nueva cantidad para actualizar stock'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Modificar avío'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            avioData?.nombre ?? 'Modificar Avío',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text('Proveedor: ${avioData?.proveedor.nombre ?? 'No disponible'}'),
          const SizedBox(height: 10),
          Text('Cantidad Inicial: $cantidadInicial'),
          const SizedBox(height: 16),
          TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Cantidad Actual'),
            onChanged: (value) {
              setState(() {
                cantidadActual = int.tryParse(value) ??
                    -1; // Si no es número, valor inválido
              });
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: updateStock,
                child: const Text('Guardar cambios'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop(); // Cierra el diálogo sin hacer cambios
                },
                child: const Text('Cancelar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
