import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/Avios.dart';
import 'package:gestion_indumentaria/pages/Avios/modificadorAvios.dart';
import 'package:gestion_indumentaria/pages/Avios/nuevoAvios.dart';
import 'package:gestion_indumentaria/widgets/boxDialog/BoxDialogoAvios.dart';
import 'package:gestion_indumentaria/widgets/tablaCrud/TablaCrud.dart';
import 'package:http/http.dart' as http;

class Avioscrudview extends StatefulWidget {
  Avioscrudview({super.key});

  @override
  State<Avioscrudview> createState() => _AvioCrudViewState();
}

class _AvioCrudViewState extends State<Avioscrudview> {
  List<Avios> avios = [];

  @override
  void initState() {
    super.initState();
    fetchModels();
  }

  // Muestra un diálogo con el mensaje proporcionado
  /*void showBox(Avios avio) {
    showDialog(
      context: context,
      builder: (context) {
        return BoxDialogAvios(
          avio: avio,
          onCancel: onCancel,
        );
      },
    );
  }*/

  // Función de cancelación para cerrar el diálogo
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
            child: TablaCrud<Avios>(
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
                (avio) => Text(avio.proveedores),
                (avio) => Text(avio.cantidad.toString()),
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

        // Verificamos que la respuesta no esté vacía
        if (body.isEmpty) {
          print("Error: La respuesta de la API está vacía.");
          return;
        }

        final List<dynamic> jsonData = jsonDecode(body);

        // Verificamos si jsonData es realmente una lista
        if (jsonData is! List) {
          print("Error: La respuesta no es una lista válida.");
          return;
        }

        setState(() {
          avios = jsonData.map((json) {
            try {
              return Avios(
                id: json['id'] ?? 0,
                nombre: json['nombre'] ?? 'Sin nombre',
                proveedores: json['codigoProveedor'] ?? 'Sin proveedor',
                cantidad: (json['stock'] ?? 0).toString(),
              );
            } catch (e) {
              print("Error al mapear un avio: $e");
              return Avios(
                  id: 0,
                  nombre: 'Desconocido',
                  proveedores: 'N/A',
                  cantidad: '0');
            }
          }).toList();
        });

        print("Avios cargados correctamente.");
      } else {
        print("Error: Código de estado ${response.statusCode}");
      }
    } catch (e) {
      print("Error al cargar los datos: $e");
    }
  }
}
