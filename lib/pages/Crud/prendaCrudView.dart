import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/tipoPrenda.dart';
import 'package:gestion_indumentaria/widgets/boxDialog/BoxDialogPrendaModificador.dart';
import 'package:gestion_indumentaria/widgets/boxDialog/boxdialogoPrenda.dart';
import 'package:gestion_indumentaria/widgets/tablaCrud/TablaCrud.dart';
import 'package:http/http.dart' as http;

class Prendacrudview extends StatefulWidget {
  const Prendacrudview({super.key});

  @override
  State<Prendacrudview> createState() => _PrendaCrudViewState();
}

class _PrendaCrudViewState extends State<Prendacrudview> {
  List<Prenda> prendas = [];

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
                    showDialog(
                      context: context,
                      builder: (context) => AddPrendaDialog(
                        onPrendaAdded: (Prenda nuevaPrenda) {
                          setState(() {
                            prendas.add(nuevaPrenda); // Agrega el objeto Prenda
                          });
                        },
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
          ),
          Expanded(
            child: TablaCrud<Prenda>(
              tituloAppBar: '', // Titulo del appBar
              encabezados: const [
                "ID",
                "NOMBRE",
                "ACCIONES" // Agregado para reflejar el número de columnas
              ], // Encabezados
              items: prendas, // Lista de modelos
              dataMapper: [
                // Celdas/valores
                (prenda) => Text(prenda.id.toString()),
                (prenda) => Text(prenda.nombre),
                (prenda) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => ModificadorPrendaDialog(
                                prenda: prenda,
                                onPrendaModified: (Prenda updatedPrenda) {
                                  setState(() {
                                    // Actualizar la prenda en la lista
                                    final index = prendas.indexWhere(
                                        (p) => p.id == updatedPrenda.id);
                                    if (index != -1) {
                                      prendas[index] = updatedPrenda;
                                    }
                                  });
                                },
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            _confirmDelete(context,
                                prenda.id); // Confirmación antes de eliminar
                            print('Prenda por borrar: ${prenda.id}');
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
    const url = "https://maria-chucena-api-production.up.railway.app/categoria";
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    // Imprimir la respuesta de la API para depuración
    print(response.body);

    final List<dynamic> jsonData = jsonDecode(response.body);

    setState(() {
      prendas = jsonData.map((json) {
        return Prenda(
          id: json['id'] ?? 0, // Asignar un valor por defecto si es null
          nombre: json['tipo'] ?? 'Sin nombre', // Asignar un valor por defecto
        );
      }).toList();
    });

    print("Prendas cargadas");
  }

  Future<void> deletePrenda(int id) async {
    final url =
        'https://maria-chucena-api-production.up.railway.app/categoria/$id';
    final uri = Uri.parse(url);

    try {
      final response = await http.delete(uri);

      if (response.statusCode == 200 || response.statusCode == 204) {
        setState(() {
          prendas.removeWhere((prenda) => prenda.id == id);
        });
        print('prenda eliminado correctamente.');
      } else {
        print(
            'Error: No se pudo eliminar el prenda. Código de estado ${response.statusCode}');
      }
    } catch (e) {
      print('Error al eliminar la prenda: $e');
    }
  }

  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content:
              const Text('¿Estás seguro de que deseas eliminar esta prenda?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                deletePrenda(id); // Llama a la función para eliminar el avio
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
