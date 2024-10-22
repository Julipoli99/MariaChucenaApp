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
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white),
                    child: const Text('Inicio')),
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
                "ESTAMPADO",
                "DESCRIPCION",
                "TIPO DE ROLLO",
                "TIPO PRODUCTO ID",
                "PROVEDOR"
                    "OPCIONES"
              ], // Encabezados
              items: telas, // Lista de usuarios
              dataMapper: [
                // Celdas/valores
                (tela) => Text(tela.id),
                (tela) => Text(tela.cantidad.toString()),
                (tela) => Text(tela.color),
                (tela) => Text(tela.estampado.toString()),
                (tela) => Text(tela.descripcion),
                (tela) => Text(tela.tipoDeRollo),
                (tela) => Text(tela.tipoProductoId.toString()),
                (tela) => Text(tela.proveedorId.toString()),
                //Parte de Opciones, se le pasa una funcion que retorna una List de Widgets en este caso Row.
                (tela) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            print('Edicion para tela: ${tela.id}');
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            print('Vista para tela: ${tela.id}');
                          },
                          icon: const Icon(Icons.remove_red_eye_outlined),
                        ),
                        IconButton(
                          onPressed: () {
                            print('Tela borrado: ${tela.id}');
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

  void fetchModels() async {
    const url = "https://maria-chucena-api-production.up.railway.app/rollo";
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    // Imprimir la respuesta de la API para depuración
    print(response.body);

    final List<dynamic> jsonData = jsonDecode(response.body);

    setState(() {
      telas = jsonData.map((json) {
        return Tela(
          id: json['id'] ?? 0, // Valor por defecto si 'id' es nulo
          tipoDeRollo: json['tipoDeRollo'] ?? 'Sin tipo de rollo',
          proveedorId: json['provedorId'] ?? 'Sin provedor',
          color: json['color'] ?? 'Sin color',
          cantidad: json['cantidad'] ?? 'Sin cantidad',
          estampado: json['estampado'] ?? 'Sin estampado',
          descripcion: json['descripcion'] ?? 'Sin descripcion',
          tipoProductoId:
              json['tipoProductoId'] ?? 0, // Asignar un valor por defecto
        );
      }).toList();
    });

    print("rollos cargados");
  }

  Future<void> deleteTela(int id) async {
    final url =
        'https://maria-chucena-api-production.up.railway.app/rollo/$id'; // Endpoint para eliminar un avio
    final uri = Uri.parse(url);

    try {
      final response = await http.delete(uri);

      if (response.statusCode == 200 || response.statusCode == 204) {
        setState(() {
          telas.removeWhere((tela) => tela.id == id); // Remover avio localmente
        });
        print('rollo eliminado correctamente.');
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
                deleteTela(id); // Llama a la función para eliminar el avio
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}
