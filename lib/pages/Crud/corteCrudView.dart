import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/Avio.dart';
import 'package:gestion_indumentaria/models/Corte.dart';
import 'package:gestion_indumentaria/pages/Modelos/orden%20de%20corte/ordenDeCorte.dart';
import 'package:gestion_indumentaria/widgets/tablaCrud/TablaCrud.dart';
import 'package:http/http.dart' as http;
/*
class Cortecrudview extends StatefulWidget {
  Cortecrudview({super.key});

  @override
  State<Cortecrudview> createState() => _CorteCrudViewState();
}

class _CorteCrudViewState extends State<Cortecrudview> {
  List<Corte> cortes = [];

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
                            builder: (context) => const OrdenDeCorteScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue[300],
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Nuevo registro'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: TablaCrud<Corte>(
              tituloAppBar: 'ordenes de corte',
              encabezados: const [
                "ID",
                "NOMBRE",
                "PROVEEDORES",
                "Stock",
                "OPCIONES",
              ],
              items: cortes,
              dataMapper: [
                //  (cortes) => Text(),
                //  (cortes) => Text(),
                // (cortes) => Text(),
                //  (cortes) => Text(),
                /*   (cortes) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            print('Vista para corte: ${cortes.nombre}');
                          },
                          icon: const Icon(Icons.remove_red_eye_outlined),
                        ),
                        IconButton(
                          onPressed: () {
                            _confirmDelete(context, cortes.id);
                            print('corte borrado: ${cortes.nombre}');
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),*/
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fetchModels() async {
    const url = "https://maria-chucena-api-production.up.railway.app/cortes";
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
          cortes = jsonData.map((json) => Corte.fromJson(json)).toList();
        });

        print("cortes cargados correctamente.");
      } else {
        print("Error: Código de estado ${response.statusCode}");
      }
    } catch (e) {
      print("Error al cargar los datos: $e");
    }
  }

  Future<void> deleteCorte(int id) async {
    final url =
        'https://maria-chucena-api-production.up.railway.app/corte/$id'; // Endpoint para eliminar un avio
    final uri = Uri.parse(url);

    try {
      final response = await http.delete(uri);

      if (response.statusCode == 204) {
        setState(() {
          cortes.removeWhere((corte) => corte.id == id); // Remover avio localmente
        });
        print('corte eliminado correctamente.');
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
              const Text('¿Estás seguro de que deseas eliminar este corte?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                await deleteCorte(id); // Esperar a que se elimine el avio
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
}*/
