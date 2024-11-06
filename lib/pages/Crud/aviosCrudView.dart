import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/Avio.dart';
import 'package:gestion_indumentaria/pages/Avios/modificadorAvios.dart';
import 'package:gestion_indumentaria/pages/Avios/nuevoAvios.dart';
import 'package:gestion_indumentaria/widgets/boxDialog/BoxDialogoAviosDetalles.dart';
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
    _fetchAvios();
  }

  void showBox(Avio avio) {
    showDialog(
      context: context,
      builder: (context) {
        return BoxDialogAvio(
          avio: avio,
          onCancel: onCancel,
        );
      },
    );
  }

  Future<void> _showEditAvioDialog(Avio avio) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ModificadoraviosDialog(avio: avio),
    );

    if (result == true) {
      // Si se modifica el avío, actualizar la lista
      _fetchAvios();
    }
  }

  void onCancel() {
    Navigator.of(context).pop();
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
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => NuevoaviosDialog(
                              onProductoAgregado: _fetchAvios,
                            ));
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
            child: TablaCrud<Avio>(
              tituloAppBar: '',
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
                (avio) => Text(avio.proveedor.nombre.toString()),
                (avio) => Text(avio.stock.toString()),
                (avio) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            showBox(avio);
                          },
                          icon: const Icon(Icons.remove_red_eye_outlined),
                        ),
                        IconButton(
                          onPressed: () {
                            _showEditAvioDialog(avio);
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            _confirmDelete(context, avio.id);
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

  Future<void> _fetchAvios() async {
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
    final url = 'https://maria-chucena-api-production.up.railway.app/avio/$id';
    final uri = Uri.parse(url);

    try {
      final response = await http.delete(uri);

      if (response.statusCode == 204 || response.statusCode == 200) {
        setState(() {
          avios.removeWhere((avio) => avio.id == id);
        });
        print('Avio eliminado correctamente.');
        await _fetchAvios(); // Recarga la lista después de eliminar un registro
      } else {
        print(
            'Error: No se pudo eliminar el avio. Código de estado ${response.statusCode}');
      }
    } catch (e) {
      print('Error al eliminar el avio: $e');
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
                await deleteAvio(id);
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
