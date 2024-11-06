import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/Proveedor.dart';
import 'package:gestion_indumentaria/models/Tela.dart';
import 'package:gestion_indumentaria/models/TipoProducto.dart';
import 'package:gestion_indumentaria/pages/StockTelas/editarTela.dart';
import 'package:gestion_indumentaria/pages/StockTelas/nuevaTela.dart';
import 'package:gestion_indumentaria/widgets/tablaCrud/TablaCrud.dart';
import 'package:http/http.dart' as http;

class Telacrudview extends StatefulWidget {
  const Telacrudview({super.key});

  @override
  State<Telacrudview> createState() => _telaCrudViewState();
}

class _telaCrudViewState extends State<Telacrudview> {
  List<Tela> telas = [];
  List<Proveedor> proveedores = [];

  @override
  void initState() {
    super.initState();
    fetchModels();
    fetchProveedores();
    fetchTipoProductos();
  }

  Future<void> fetchProveedores() async {
    const url = 'https://maria-chucena-api-production.up.railway.app/proveedor';
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);

        setState(() {
          proveedores =
              jsonData.map((json) => Proveedor.fromJson(json)).toList();
        });
      } else {
        print("Error: Código de estado ${response.statusCode}");
      }
    } catch (e) {
      print("Error al cargar los proveedores: $e");
    }
  }

  String? getNombreProveedor(int proveedorId) {
    final proveedor = proveedores.firstWhere(
      (proveedor) => proveedor.id == proveedorId,
    );
    return proveedor.nombre;
  }

  List<TipoProducto> tipoProductos =
      []; // Lista para almacenar tipos de productos

  Future<void> fetchTipoProductos() async {
    const url =
        'https://maria-chucena-api-production.up.railway.app/tipo-Producto'; // Asegúrate de que esta URL sea correcta
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);

        setState(() {
          tipoProductos =
              jsonData.map((json) => TipoProducto.fromJson(json)).toList();
        });
      } else {
        print("Error: Código de estado ${response.statusCode}");
      }
    } catch (e) {
      print("Error al cargar los tipos de productos: $e");
    }
  }

  String? getNombreProducto(int tipoProductoId) {
    try {
      final tipoProducto = tipoProductos.firstWhere(
        (tipoProducto) => tipoProducto.id == tipoProductoId,
      );
      return tipoProducto
          .nombre; // Retorna el nombre del tipo de producto encontrado
    } catch (e) {
      print('Tipo de producto no encontrado: $tipoProductoId');
      return null; // Retorna null si no se encuentra
    }
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
                    final result = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) =>
                          const NuevasTelasDialog(),
                    );

                    if (result == true) {
                      fetchModels(); // Refresca la lista si se agrega una nueva tela
                    }
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
              tituloAppBar: 'Telas registradas',
              encabezados: const [
                "ID",
                "CANTIDAD",
                "COLOR",
                "DESCRIPCION",
                "ESTAMPADO",
                "TIPO DE ROLLO",
                "OPCIONES"
              ],
              items: telas,
              dataMapper: [
                (tela) => Text(tela.id.toString()),
                (tela) => Text(tela.cantidad.toString()),
                (tela) => Text(tela.color),
                (tela) => Text(tela.descripcion.toString()),
                (tela) => Text(tela.estampado ? 'SI' : 'NO'),
                (tela) => Text(tela.tipoDeRollo.toString()),
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
                            _openEditarTelaDialog(context, tela);
                          },
                          icon: const Icon(Icons.edit),
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

  void _showDetailDialog(BuildContext context, Tela tela) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalles de la Tela : ${tela.descripcion}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'Tipo Producto :  ${getNombreProducto(tela.tipoProductoId)}'),
              Text("Proveedor: ${getNombreProveedor(tela.proveedorId)}"),
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

  void _openEditarTelaDialog(BuildContext context, Tela tela) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => EditarTelasDialog(tela),
    );

    if (result == true) {
      fetchModels(); // Refresca la lista si se actualiza una tela
    }
  }
}
