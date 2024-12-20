import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/AviosModelo.dart';
import 'package:gestion_indumentaria/models/Curva.dart';
import 'package:gestion_indumentaria/models/Modelo.dart';
import 'package:gestion_indumentaria/models/observacion.dart';
import 'package:gestion_indumentaria/models/talle.dart';
import 'package:gestion_indumentaria/models/tipoPrenda.dart';
import 'package:gestion_indumentaria/pages/Modelos/NuevoModelo.dart';

import 'package:gestion_indumentaria/widgets/boxDialog/modelo/editarModelos.dart';
import 'package:gestion_indumentaria/widgets/boxDialog/modelo/BoxDialogModelo.dart';

import 'package:gestion_indumentaria/widgets/tablaCrud/TablaCrud.dart';
import 'package:http/http.dart' as http;

class ModelCrudView extends StatefulWidget {
  const ModelCrudView({super.key});

  @override
  State<ModelCrudView> createState() => _ModelCrudViewState();
}

class _ModelCrudViewState extends State<ModelCrudView> {
  List<Modelo> models = [];
  List<Prenda> prendas = [];

  @override
  void initState() {
    super.initState();
    fetchModels();
    fetchPrendas(); // Llamamos al fetch cuando la página se carga
  }

  void showBox(Modelo modelo) {
    showDialog(
      context: context,
      builder: (context) {
        return BoxDialogModelo(
          modelo: modelo,
          onCancel: onCancel,
          fetchModels: fetchModels,
        );
      },
    );
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
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const Nuevomodelo(), // Pantalla para crear nuevo modelo
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue[300],
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Nuevo modelo'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: TablaCrud<Modelo>(
              tituloAppBar: '',
              encabezados: const [
                "ID",
                "CODIGO",
                "NOMBRE",
                "GENERO",
                "TIPO",
                "OPCIONES"
              ],
              items: models,
              dataMapper: [
                (model) => Text(model.id.toString()),
                (model) => Text(model.codigo),
                (model) => Text(model.nombre),
                (model) => Text(model.genero),
                (model) => Text(getCategoriaNombre(model.categoriaTipo)),
                (model) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            showBox(
                                model); // Llamada correcta a la función showBox
                          },
                          icon: const Icon(Icons.remove_red_eye_outlined),
                        ),
                        IconButton(
                          onPressed: () async {
                            final result = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return EditModelDialog(
                                  modelo: model,
                                  onModeloModified: (updatedModelo) {
                                    // Lógica para actualizar el modelo en tu interfaz (si es necesario)
                                  },
                                );
                              },
                            );

                            if (result == true) {
                              fetchModels(); // Refresca la lista si se actualizó el modelo
                            }
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            _confirmDelete(context, model.id);
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

  String getCategoriaNombre(int categoriaId) {
    final categoria = prendas.firstWhere(
      (cat) => cat.id == categoriaId,
      orElse: () => Prenda(id: 0, nombre: 'Desconocida'),
    );
    return categoria.nombre;
  }

  void fetchModels() async {
    const url = "https://maria-chucena-api-production.up.railway.app/modelo";
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri);
      print("Respuesta de la API: ${response.body}");
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        print(response.body);

        print("###################");

        setState(() {
          models = jsonData.map((json) {
            return Modelo(
              id: json[
                  'id'], // Asegúrate de que este campo exista en la respuesta
              codigo: json['codigo'],
              genero: json['genero'],
              nombre: json['nombre'],
              tieneTelaSecundaria: json['tieneTelaSecundaria'] ?? false,
              tieneTelaAuxiliar: json['tieneTelaAuxiliar'] ?? false,
              avios: (json['avios'] as List<dynamic>?)?.map((av) {
                    return AvioModelo.fromJson(
                        av); // Mapea correctamente el avio
                  }).toList() ??
                  [],
              curva: (json['curva'] as List<
                          dynamic>?) // Asegúrate de que este campo exista
                      ?.map((item) => Talle.fromJson(item))
                      .toList() ??
                  [], // Ajusta según la estructura de tu modelo
              categoriaTipo: json['categoriaId'], // Ajusta según sea necesario
              observaciones: (json['observaciones'] as List<dynamic>?)
                      ?.map((obs) => ObservacionModel.fromJson(obs))
                      .toList() ??
                  [],
            );
          }).toList();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("cortes cargados correctamente."),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        print("Error al cargar modelos: ${response.statusCode}");
      }
    } catch (e) {
      print("Error al hacer la petición: $e");
    }
  }

  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content:
              const Text('¿Estás seguro de que deseas eliminar este modelo?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                deleteModel(id); // Elimina el modelo
                Navigator.of(context)
                    .pop(); // Cierra el diálogo después de eliminar
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void deleteModel(int id) async {
    final url =
        'https://maria-chucena-api-production.up.railway.app/modelo/$id';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        // Elimina el modelo de la lista localmente
        models.removeWhere((model) => model.id == id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Modelo eliminado correctamente'),
            backgroundColor: Colors.green, // Fondo naranja
          ),
        );
      });
      print("Modelo eliminado");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Error al eliminar el modelo: modelo vinculado con un corte.'),
          backgroundColor: Colors.red, // Fondo naranja
        ),
      );
      print("Error al eliminar modelo: ${response.statusCode}");
    }
  }

  void updateModel(Modelo updatedModelo) async {
    final url =
        'https://maria-chucena-api-production.up.railway.app/modelo/${updatedModelo.id}';
    final response = await http.put(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(updatedModelo.toJson()),
    );

    if (response.statusCode == 200) {
      setState(() {
        int index = models.indexWhere((model) => model.id == updatedModelo.id);
        if (index != -1) {
          models[index] = updatedModelo; // Actualiza el modelo en la lista
        }
      });
      print("Modelo actualizado");
    } else {
      print("Error al actualizar modelo: ${response.statusCode}");
    }
  }

  Future<void> fetchPrendas() async {
    const url = "https://maria-chucena-api-production.up.railway.app/categoria";
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    // Decodifica y actualiza la lista de categorías
    final List<dynamic> jsonData = jsonDecode(response.body);
    setState(() {
      prendas = jsonData.map((json) {
        return Prenda(
          id: json['id'] ?? 0,
          nombre: json['tipo'] ?? 'Sin nombre',
        );
      }).toList();
    });
  }
}
