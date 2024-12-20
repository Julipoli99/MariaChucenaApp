import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/talle.dart';
import 'package:gestion_indumentaria/widgets/boxDialog/talle/boxdialogoTalle.dart';
import 'package:gestion_indumentaria/widgets/tablaCrud/TablaCrud.dart';
import 'package:http/http.dart' as http;

class Tallescrudview extends StatefulWidget {
  const Tallescrudview({super.key});

  @override
  State<Tallescrudview> createState() => _TallesCrudViewState();
}

class _TallesCrudViewState extends State<Tallescrudview> {
  List<Talle> talles = [];

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
                TextButton(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) => AddTalleDialog(
                        existingTalles:
                            talles, // Pasamos la lista de talles existentes
                        onTalleAdded: (nuevoTalle) {
                          // Convertimos el nombre a mayúsculas
                          String nombreMayuscula =
                              nuevoTalle.nombre.toUpperCase();

                          // Verificamos si el talle ya existe
                          if (_talleExists(nombreMayuscula)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Este talle ya existe."),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else {
                            setState(() {
                              talles.add(Talle(
                                  id: nuevoTalle.id, nombre: nombreMayuscula));
                            });
                            Navigator.of(context).pop(); // Cerramos el diálogo
                            fetchModels(); // Refrescar lista de talles
                          }
                        },
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue[300],
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Nuevo Talle'),
                ),
              ],
            ),
          ),
          Expanded(
            child: TablaCrud<Talle>(
              tituloAppBar: '',
              encabezados: const ["ID", "TALLE", "OPCIONES"],
              items: talles,
              dataMapper: [
                (talle) => Text(talle.id.toString()),
                (talle) => Text(talle.nombre),
                (talle) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () => _confirmDelete(context, talle.id),
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

  bool _talleExists(String nombre) {
    // Validación insensible a mayúsculas/minúsculas
    return talles.any((talle) => talle.nombre.toUpperCase() == nombre);
  }

  Future<void> fetchModels() async {
    const url = "https://maria-chucena-api-production.up.railway.app/talle";
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final body = response.body;
        if (body.isNotEmpty) {
          final List<dynamic> jsonData = jsonDecode(body);
          setState(() {
            talles = jsonData.map((json) => Talle.fromJson(json)).toList();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Talles cargados correctamente."),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Error: La respuesta está vacía.")),
          );
        }
      } else {
        print("Error: Código de estado ${response.statusCode}");
      }
    } catch (e) {
      print("Error al cargar los datos: $e");
    }
  }

  Future<void> deleteTalle(int id) async {
    final url = 'https://maria-chucena-api-production.up.railway.app/talle/$id';
    final uri = Uri.parse(url);

    try {
      final response = await http.delete(uri);

      if (response.statusCode == 200) {
        setState(() => talles.removeWhere((talle) => talle.id == id));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Talle eliminado correctamente.'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: No se pudo eliminar el talle.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar el talle: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content:
              const Text('¿Estás seguro de que deseas eliminar este talle?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                await deleteTalle(id);
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
