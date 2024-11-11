import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/Corte.dart';
import 'package:gestion_indumentaria/pages/Modelos/orden%20de%20corte/ordenDeCorte.dart';
import 'package:gestion_indumentaria/pages/Tizadas/CreacionTizadasPage.dart';
import 'package:gestion_indumentaria/widgets/boxDialog/corte/BoxDialogoCorte.dart';
import 'package:gestion_indumentaria/widgets/tablaCrud/TablaCrud.dart';
import 'package:http/http.dart' as http;

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
                            builder: (context) => OrdenDeCorteScreen(),
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
              tituloAppBar: '',
              encabezados: const [
                "ID",
                "MODELO",
                "ROLLO",
                "OPCIONES",
              ],
              items: cortes,
              dataMapper: [
                (corte) => Text(corte.id.toString()),
                (corte) => Text(corte.modelos
                    .map((modelo) => modelo.modelo?.nombre.toString())
                    .join(', ')),
                (corte) => Text(corte.rollos
                    .map((rollo) => rollo.rollo?.descripcion ?? 'Sin nombre')
                    .join(', ')),
                (corte) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            _showCorteDetailsDialog(context, corte);
                            print('Vista para corte: ${corte.id}');
                          },
                          icon: const Icon(Icons.remove_red_eye_outlined),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreacionTizadasPage(
                                  idCorte: corte.id,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.cut),
                        ),
                        IconButton(
                          onPressed: () {
                            _confirmDelete(context, corte.id);
                            print('Corte borrado: ${corte.id}');
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
    const url = "https://maria-chucena-api-production.up.railway.app/corte";
    final uri = Uri.parse(url);

    try {
      print("Intentando cargar datos desde la API...");
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final body = response.body;

        if (body.isEmpty) {
          print("Error: La respuesta de la API está vacía.");
          return;
        }

        final List<dynamic>? jsonData = jsonDecode(body) as List<dynamic>?;

        if (jsonData == null) {
          print("Error: La respuesta es nula. Verifica el formato de la API.");
          return;
        }

        setState(() {
          cortes = jsonData
              .map((json) {
                try {
                  return Corte.fromJson(json);
                } catch (e) {
                  print("Error al deserializar corte: $e");
                  return null;
                }
              })
              .where((corte) => corte != null)
              .cast<Corte>()
              .toList();
        });

        print("Cortes cargados correctamente.");
      } else {
        print("Error: Código de estado ${response.statusCode}");
      }
    } catch (e) {
      print("Error al cargar los datos: $e");
    }
  }

  Future<void> deleteCorte(int id) async {
    final url = 'https://maria-chucena-api-production.up.railway.app/corte/$id';
    final uri = Uri.parse(url);

    try {
      final response = await http.delete(uri);

      if (response.statusCode == 204) {
        setState(() {
          cortes.removeWhere((corte) => corte.id == id);
        });
        print('Corte eliminado correctamente.');
      } else {
        print(
            'Error: No se pudo eliminar el corte. Código de estado ${response.statusCode}');
      }
    } catch (e) {
      print('Error al eliminar el corte: $e');
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
                await deleteCorte(id);
                // Llama a fetchModels después de la eliminación para actualizar la lista
                await fetchModels();
                Navigator.of(context).pop();
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _showCorteDetailsDialog(BuildContext context, Corte corte) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BoxDialogCorte(
          corte: corte,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  /*void _editCorte(BuildContext context, Corte corte) {
    // Navega a una pantalla de edición o muestra un cuadro de diálogo para editar el corte
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditarOrdenDeCorteScreen(
            // Asegúrate de manejar esto en la pantalla de edición
            ),
      ),
    );
  }*/
}
