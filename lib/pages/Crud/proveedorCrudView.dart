import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/Proveedor.dart';
import 'package:gestion_indumentaria/pages/Provedores/NuevoProvedor.dart';
import 'package:gestion_indumentaria/widgets/boxDialog/proveedor/BoxDialogoProvedorModificador.dart';
import 'package:gestion_indumentaria/widgets/tablaCrud/TablaCrud.dart';
import 'package:http/http.dart' as http;

class Provedorcrudview extends StatefulWidget {
  const Provedorcrudview({super.key});

  @override
  State<Provedorcrudview> createState() => _ProvedorCrudViewState();
}

class _ProvedorCrudViewState extends State<Provedorcrudview> {
  List<Proveedor> provedores = [];

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
                        builder: (BuildContext context) => NuevoProveedorDialog(
                              onProveedorAgregado: fetchModels,
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
            child: TablaCrud<Proveedor>(
              tituloAppBar: '', // Titulo del appBar
              encabezados: const [
                "ID",
                "NOMBRE",
                "TELEFONO",
                "OPCIONES"
              ], // Encabezados
              items: provedores, // Lista de proveedores
              dataMapper: [
                // Celdas/valores
                (proveedor) => Text(proveedor.id.toString()),
                (proveedor) => Text(proveedor.nombre),
                (proveedor) => Text(proveedor.telefono),
                //Parte de Opciones, se le pasa una funcion que retorna una List de Widgets en este caso Row.
                (proveedor) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => ModificadorProvedorDialog(
                                proveedor: proveedor,
                                onProvedorModified:
                                    (Proveedor updatedProveedor) {
                                  setState(() {
                                    // Actualizar la prenda en la lista
                                    final index = provedores.indexWhere(
                                        (p) => p.id == updatedProveedor.id);
                                    if (index != -1) {
                                      provedores[index] = updatedProveedor;
                                    }
                                  });
                                },
                              ),
                            );
                            print('editar proveedor: ${proveedor.nombre}');
                          },
                          icon: const Icon(Icons.create_sharp),
                        ),
                        IconButton(
                          onPressed: () {
                            _confirmDelete(context, proveedor.id);
                            print('proveedor borrado: ${proveedor.nombre}');
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
    const url = "https://maria-chucena-api-production.up.railway.app/proveedor";
    final uri = Uri.parse(url);
    try {
      final response = await http.get(uri);

      // Verificar la respuesta de la API
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);

        setState(() {
          provedores = jsonData.map((json) {
            return Proveedor(
              id: json['id'] ?? 0, // Asignar un valor por defecto si es null
              nombre: json['nombre'] ??
                  'Sin nombre', // Asignar un valor por defecto
              telefono: json['telefono'] ?? 'Sin telefono',
            );
          }).toList();
        });

        // Mostrar SnackBar de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Proveedores cargados correctamente.'),
            backgroundColor: Colors.green, // Color verde para éxito
          ),
        );

        print("proveedores cargados");
      } else {
        print(
            'Error: No se pudieron cargar los proveedores. Código de estado ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Error al cargar los proveedores.'),
            backgroundColor: Colors.red, // Color rojo para error
          ),
        );
      }
    } catch (e) {
      print('Error al cargar los proveedores: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Error al cargar los proveedores.'),
          backgroundColor: Colors.red, // Color rojo para error
        ),
      );
    }
  }

  Future<void> deleteProvedor(int id) async {
    final url =
        'https://maria-chucena-api-production.up.railway.app/proveedor/$id'; // Endpoint para eliminar un proveedor
    final uri = Uri.parse(url);

    try {
      final response = await http.delete(uri);

      if (response.statusCode == 200 || response.statusCode == 204) {
        setState(() {
          provedores.removeWhere((proveedor) =>
              proveedor.id == id); // Remover proveedor localmente
        });
        // Mostrar SnackBar de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Proveedor eliminado correctamente.'),
            backgroundColor: Colors.green, // Color verde para éxito
          ),
        );
        print('proveedor eliminado correctamente.');
      } else {
        print(
            'Error: No se pudo eliminar el proveedor. Código de estado ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Error al eliminar el proveedor.'),
            backgroundColor: Colors.red, // Color rojo para error
          ),
        );
      }
    } catch (e) {
      print('Error al eliminar el proveedor: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Error al eliminar el proveedor.'),
          backgroundColor: Colors.red, // Color rojo para error
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
          content: const Text(
              '¿Estás seguro de que deseas eliminar este proveedor?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                deleteProvedor(
                    id); // Llama a la función para eliminar el proveedor
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: const Text('Eliminar'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.red, // Color rojo para el botón de eliminar
              ),
            ),
          ],
        );
      },
    );
  }
}
