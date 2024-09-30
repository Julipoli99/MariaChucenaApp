import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/Modelo.dart';
import 'package:gestion_indumentaria/widgets/tablaCrud/TablaCrud.dart';

class ModelCrudView extends StatelessWidget {
  ModelCrudView({super.key});

  // Ejemplo para el crud de Modelos
  final List<Modelo> models = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TablaCrud<Modelo>(
        tituloAppBar: 'Modelos registrados', // Titulo del appBar
        encabezados: const [
          "CODIGO",
          "GENERO",
          "PRENDA",
          "TIPO",
          "TELA",
          "OPCIONES"
        ], // Encabezados
        items: models, // Lista de usuarios
        dataMapper: [
          // Celdas/valores
          (model) => Text(model.codigo.toString()),

          //Parte de Opciones, se le pasa una funcion que retorna una List de Widgets en este caso Row.
          (model) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      print('Vista para usuario: ${model.codigo}');
                    },
                    icon: const Icon(Icons.remove_red_eye_outlined),
                  ),
                  IconButton(
                    onPressed: () {
                      print('Edicion para usuario: ${model.codigo}');
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {
                      print('Usuario borrado: ${model.codigo}');
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
        ],
      ),
    );
  }
}
