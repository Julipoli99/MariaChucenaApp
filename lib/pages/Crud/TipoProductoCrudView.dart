import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/TipoProducto.dart';
import 'package:gestion_indumentaria/pages/TipoProducto/nuevoRegistro.dart';
import 'package:gestion_indumentaria/widgets/boxDialog/tipoProducto/BoxDialogTipoProductoModificar.dart';
import 'package:gestion_indumentaria/widgets/tablaCrud/TablaCrud.dart';
import 'package:http/http.dart' as http;

class TipoProductocrudview extends StatefulWidget {
  const TipoProductocrudview({super.key});

  @override
  State<TipoProductocrudview> createState() => _TipoCrudViewState();
}

class _TipoCrudViewState extends State<TipoProductocrudview> {
  List<TipoProducto> productos = [];

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
                        builder: (BuildContext context) =>
                            NuevoTipoDeProductoDialog(
                              onProductoAgregado: () {
                                fetchModels();
                                _showSnackBar('Producto agregado con éxito',
                                    Colors.green);
                              },
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
            child: TablaCrud<TipoProducto>(
              tituloAppBar: '', // Titulo del appBar
              encabezados: const [
                "ID",
                "PRODUCTO",
                "TIPO",
                "MEDIDA",
                "OPCIONES"
              ], // Encabezados visibles en la tabla
              items: productos, // Lista de telas
              dataMapper: [
                // Celdas/valores visibles en la tabla
                (producto) => Text(producto.id.toString()),
                (producto) => Text(producto.nombre.toString()),
                (producto) => Text(producto.tipo.name),
                (producto) => Text(producto.unidadMetrica.name),
                // Botones de opciones
                (producto) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  ModificadorTipoProductoDialog(
                                tipoProducto: producto,
                                onTipoProductoModified:
                                    (TipoProducto updatedTipoProducto) {
                                  setState(() {
                                    // Actualizar la prenda en la lista
                                    final index = productos.indexWhere(
                                        (p) => p.id == updatedTipoProducto.id);
                                    if (index != -1) {
                                      productos[index] = updatedTipoProducto;
                                    }
                                  });
                                  _showSnackBar('Producto modificado con éxito',
                                      Colors.green);
                                },
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            _confirmDelete(context, producto.id);
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
    const url =
        "https://maria-chucena-api-production.up.railway.app/tipo-producto";
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      setState(() {
        productos = jsonData.map((json) {
          return TipoProducto(
            id: json['id'] ?? 0,
            nombre: json['nombre'] ?? 'Sin nombre',
            tipo: TipoEnum.values.firstWhere(
                (e) => e.toString().split('.').last == json['tipo']),
            unidadMetrica: UnidadMetricaEnum.values.firstWhere(
                (e) => e.toString().split('.').last == json['unidadMetrica']),
          );
        }).toList();
      });
      _showSnackBar(
          'Productos cargados correctamente', Colors.green); // Mensaje de éxito
    } else {
      _showSnackBar('Error al cargar productos', Colors.red);
    }
  }

  Future<void> deleteprenda(int id) async {
    final url =
        'https://maria-chucena-api-production.up.railway.app/tipo-producto/$id';
    final uri = Uri.parse(url);

    try {
      final response = await http.delete(uri);

      if (response.statusCode == 200 || response.statusCode == 204) {
        setState(() {
          productos.removeWhere((tela) => tela.id == id);
        });
        _showSnackBar('Producto eliminado con éxito', Colors.green);
      } else {
        _showSnackBar(
            'Error: No se pudo eliminar el producto. Código de estado ${response.statusCode}',
            Colors.red);
      }
    } catch (e) {
      _showSnackBar('Error al eliminar el producto', Colors.red);
    }
  }

  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content:
              const Text('¿Estás seguro de que deseas eliminar este producto?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                deleteprenda(id);
                Navigator.of(context).pop();
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor, // Color de fondo personalizado
      ),
    );
  }
}
