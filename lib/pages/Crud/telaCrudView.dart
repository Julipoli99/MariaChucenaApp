import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/Tela.dart';
import 'package:gestion_indumentaria/pages/StockTelas/nuevaTela.dart';
import 'package:gestion_indumentaria/pages/principal.dart';
import 'package:gestion_indumentaria/widgets/tablaCrud/TablaCrud.dart';
import 'package:http/http.dart' as http;

class Telacrudview extends StatefulWidget {
  const Telacrudview({super.key});

  @override
  State<Telacrudview> createState() => _telaCrudViewState();
}

class _telaCrudViewState extends State<Telacrudview> {
  List<Tela> telas = [];

  @override
  void initState() {
    super.initState();
    fetchModels(); // Llamamos al fetch cuando la página se carga
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NuevasTelas(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.blue[300],
                      foregroundColor: Colors.white),
                  child: const Text('Nuevo registro'),
                ),
              ],
            ),
          ),
          Expanded(
            child: TablaCrud<Tela>(
              tituloAppBar: 'Telas registradas', // Titulo del appBar
              encabezados: const [
                "ID",
                "CANTIDAD",
                "COLOR",
                "TIPO DE ROLLO",
                "OPCIONES"
              ], // Encabezados visibles en la tabla
              items: telas, // Lista de telas
              dataMapper: [
                // Celdas/valores visibles en la tabla
                (tela) => Text(tela.id.toString()),
                (tela) => Text(tela.cantidad.toString()),
                (tela) => Text(tela.color),
                (tela) => Text(tela.tipoDeRollo.toString()),
                // Botones de opciones
                (tela) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            _showDetailDialog(context, tela);
                          },
                          icon: const Icon(Icons.remove_red_eye_outlined),
                        ),
                        IconButton(
                          onPressed: () {
                            _confirmDelete(context, tela.id);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Función para mostrar el diálogo con detalles adicionales de una tela
  void _showDetailDialog(BuildContext context, Tela tela) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalles de la Tela ID: ${tela.id}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Estampado: ${tela.estampado}"),
              Text("Descripción: ${tela.descripcion}"),
              Text("Tipo Producto ID: ${tela.tipoProductoId}"),
              Text("Proveedor ID: ${tela.proveedorId}"),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void fetchModels() async {
    const url = "https://maria-chucena-api-production.up.railway.app/rollo";
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    final List<dynamic> jsonData = jsonDecode(response.body);

    setState(() {
      telas = jsonData.map((json) {
        return Tela(
          id: json['id'] ?? 0,
          tipoDeRollo: json['tipoRollo'] ?? 'Sin tipo de rollo',
          proveedorId: json['proveedorId'] ?? 0,
          color: json['color'] ?? 'Sin color',
          cantidad: json['cantidad'] ?? 'Sin cantidad',
          estampado: json['estampado'] ?? 'Sin estampado',
          descripcion: json['descripcion'] ?? 'Sin descripcion',
          tipoProductoId: json['tipoProductoId'] ?? 0,
        );
      }).toList();
    });
  }

  Future<void> deleteTela(int id) async {
    final url = 'https://maria-chucena-api-production.up.railway.app/rollo/$id';
    final uri = Uri.parse(url);

    try {
      final response = await http.delete(uri);

      if (response.statusCode == 200 || response.statusCode == 204) {
        setState(() {
          telas.removeWhere((tela) => tela.id == id);
        });
      } else {
        print(
            'Error: No se pudo eliminar el rollo. Código de estado ${response.statusCode}');
      }
    } catch (e) {
      print('Error al eliminar el rollo: $e');
    }
  }

  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content:
              const Text('¿Estás seguro de que deseas eliminar este rollo?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                deleteTela(id);
                Navigator.of(context).pop();
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}
