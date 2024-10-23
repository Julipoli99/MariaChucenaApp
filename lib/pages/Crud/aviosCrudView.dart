import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/AviosModel.dart';
import 'package:gestion_indumentaria/pages/Avios/modificadorAvios.dart';
import 'package:gestion_indumentaria/pages/Avios/nuevoAvios.dart';
import 'package:gestion_indumentaria/widgets/tablaCrud/TablaCrud.dart';
import 'package:http/http.dart' as http;

class Avioscrudview extends StatefulWidget {
  Avioscrudview({super.key});

  @override
  State<Avioscrudview> createState() => _AvioCrudViewState();
}

class _AvioCrudViewState extends State<Avioscrudview> {
  List<Avio> avios = [];

  @override
  void initState() {
    super.initState();
    fetchModels();
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
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Nuevoavios(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue[300],
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Nuevo registro'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Modificadoravios(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue[300],
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Modificar stock'),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Inicio'),
                ),
              ],
            ),
          ),
          Expanded(
            child: TablaCrud<Avio>(
              tituloAppBar: 'Avios',
              encabezados: const [
                "ID",
                "NOMBRE",
                "PROVEEDORES",
                "Stock",
                "OPCIONES",
              ],
              items: avios,
              dataMapper: [
                (avio) => Text(avio.id.toString()),
                (avio) => Text(avio.nombre),
                (avio) => Text(avio.codigoProveedor),
                (avio) => Text(avio.stock.toString()),
                (avio) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            print('Vista para avio: ${avio.nombre}');
                          },
                          icon: const Icon(Icons.remove_red_eye_outlined),
                        ),
                        IconButton(
                          onPressed: () {
                            _confirmDelete(context, avio.id);
                            print('Avio borrado: ${avio.nombre}');
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

  Future<void> fetchModels() async {
    const url = "https://maria-chucena-api-production.up.railway.app/avio";
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final body = response.body;

        if (body.isEmpty) {
          print("Error: La respuesta de la API está vacía.");
          return;
        }

        final List<dynamic> jsonData = jsonDecode(body);

        if (jsonData is! List) {
          print("Error: La respuesta no es una lista válida.");
          return;
        }

        setState(() {
          avios = jsonData.map((json) => Avio.fromJson(json)).toList();
        });

        print("Avios cargados correctamente.");
      } else {
        print("Error: Código de estado ${response.statusCode}");
      }
    } catch (e) {
      print("Error al cargar los datos: $e");
    }
  }

  Future<void> deleteAvio(int id) async {
    final url =
        'https://maria-chucena-api-production.up.railway.app/avio/$id'; // Endpoint para eliminar un avio
    final uri = Uri.parse(url);

    try {
      final response = await http.delete(uri);

      if (response.statusCode == 204) {
        setState(() {
          avios.removeWhere((avio) => avio.id == id); // Remover avio localmente
        });
        print('avio eliminado correctamente.');
      } else {
        print(
            'Error: No se pudo eliminar el avio. Código de estado ${response.statusCode}');
      }
    } catch (e) {
      print('Error al eliminar la avio: $e');
    }
  }

  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content:
              const Text('¿Estás seguro de que deseas eliminar este avio?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                await deleteAvio(id); // Esperar a que se elimine el avio
                Navigator.of(context)
                    .pop(); // Cierra el diálogo después de la eliminación
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}
