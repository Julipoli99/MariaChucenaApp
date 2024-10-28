import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/AviosModelo.dart';
import 'package:gestion_indumentaria/models/Modelo.dart';
import 'package:gestion_indumentaria/models/observacion.dart';
import 'package:gestion_indumentaria/models/Talle.dart';
import 'package:gestion_indumentaria/pages/Modelos/NuevoModelo.dart';
import 'package:gestion_indumentaria/widgets/boxDialog/BoxDialogModelo.dart';
import 'package:gestion_indumentaria/widgets/tablaCrud/TablaCrud.dart';
import 'package:http/http.dart' as http;

class ModelCrudView extends StatefulWidget {
  const ModelCrudView({super.key});

  @override
  State<ModelCrudView> createState() => _ModelCrudViewState();
}

class _ModelCrudViewState extends State<ModelCrudView> {
  List<Modelo> models = [];

  @override
  void initState() {
    super.initState();
    fetchModels(); // Llamamos al fetch cuando la página se carga
  }

  void showBox(Modelo modelo) {
    showDialog(
      context: context,
      builder: (context) {
        return BoxDialogModelo(
          modelo: modelo,
          onCancel: onCancel,
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
                    TextButton(
                      onPressed: () {
                        // Aquí podrías abrir un diálogo o una nueva pantalla para seleccionar el modelo a modificar
                        print('Seleccionar modelo para modificar');
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue[300],
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Modificar modelo'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: TablaCrud<Modelo>(
              tituloAppBar: 'Modelos registrados',
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
                (model) => Text(model.categoriaTipo.toString()),
                (model) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            showBox(model);
                          },
                          icon: const Icon(Icons.remove_red_eye_outlined),
                        ),
                        IconButton(
                          onPressed: () {
                            print('Edición para modelo con id: ${model.id}');
                            // Aquí podrías abrir un diálogo o una pantalla para editar el modelo
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            deleteModel(model.id);
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
    const url = "https://maria-chucena-api-production.up.railway.app/modelo";
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri);
      print("Respuesta de la API: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);

        setState(() {
          models = jsonData.map((json) {
            // Manejo seguro de nulos
            List<AvioModelo> avio = (json['avios'] as List<dynamic>?)
                    ?.map((av) => AvioModelo.fromJson(av))
                    .toList() ??
                [];
            List<ObservacionModel> observaciones =
                (json['observaciones'] as List<dynamic>?)
                        ?.map((obs) => ObservacionModel.fromJson(obs))
                        .toList() ??
                    [];
            List<Talle> curva = (json['talle'] as List<dynamic>?)
                    ?.map((t) => Talle.fromJson(t))
                    .toList() ??
                [];

            return Modelo(
              id: json['id'],
              codigo: json['codigo'],
              genero: json['genero'],
              nombre: json['nombre'],
              tieneTelaSecundaria: json['tieneTelaSecundaria'],
              tieneTelaAuxiliar: json['tieneTelaAuxiliar'],
              avios: avio,
              curva: curva,
              categoriaTipo: json['categoria'] != null
                  ? json['categoria']['tipo']
                  : null, // Asegúrate de manejar nulos
              observaciones: observaciones,
            );
          }).toList();
        });

        print("Modelos cargados: ${models.length}");
      } else {
        print("Error al cargar modelos: ${response.statusCode}");
      }
    } catch (e) {
      print("Error al hacer la petición: $e");
    }
  }

  void deleteModel(int id) async {
    final url =
        'https://maria-chucena-api-production.up.railway.app/modelo/$id';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        models.removeWhere((model) => model.id == id);
      });
      print("Modelo eliminado");
    } else {
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
}
