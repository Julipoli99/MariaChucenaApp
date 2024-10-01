import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/Avios.dart';
import 'package:gestion_indumentaria/models/Modelo.dart';
import 'package:gestion_indumentaria/widgets/boxDialog/BoxDialog.dart';
import 'package:gestion_indumentaria/widgets/tablaCrud/TablaCrud.dart';
import 'package:http/http.dart' as http;

class ModelCrudView extends StatefulWidget {
  ModelCrudView({super.key});

  @override
  State<ModelCrudView> createState() => _ModelCrudViewState();
}

class _ModelCrudViewState extends State<ModelCrudView> {
  
  List<dynamic> modelos = [];

  // Ejemplo para el crud de Modelos
   List<Modelo> models = [
    
  ];

  @override
  void initState() {
    super.initState();
    // Llamamos al fetch cuando la página se carga
    fetchModels();
  }

  // Muestra un diálogo con el mensaje proporcionado
  void showBox(Modelo modelo) {
    showDialog(
      context: context,
      builder: (context) {
        return BoxDialog(
          modelo: modelo,
          onCancel: onCancel,
        );
      },
    );
  }

  // Función de cancelación para cerrar el diálogo
  void onCancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TablaCrud<Modelo>(
        tituloAppBar: 'Modelos registrados', // Titulo del appBar
        encabezados: const ["ID", "CODIGO", "NOMBRE", "GENERO", "TIPO", "OPCIONES"], // Encabezados
        items: models,   // Lista de modelos
        dataMapper: [ // Celdas/valores
          (model) => Text(model.id.toString()),
          (model) => Text(model.codigo.toString()),
          (model) => Text(model.nombre),
          (model) => Text(model.genero),
          (model) => Text(model.categoriaTipo),
          //(model) => Text(model.tipo),
          //(model) => Text(model.tela),
          //Parte de Opciones, se le pasa una funcion que retorna una List de Widgets en este caso Row.
          (model) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      print('Vista para modelo con id: ${model.id}');

                      // Muestra un pantallazo de los atributos restantes del modelo
                      showBox(model);

                    },
                    icon: const Icon(Icons.remove_red_eye_outlined),
                  ),
                  IconButton(
                    onPressed: () {
                      print('Edicion para modelo con id: ${model.id}');
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {
                      print('Modelo borrado: ${model.id}');
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
        ],
      ),
    );
  }

  void fetchModels() async {
  const url = "https://maria-chucena-api-production.up.railway.app/modelo";
  final uri = Uri.parse(url);
  final response = await http.get(uri);
  final List<dynamic> jsonData = jsonDecode(response.body);

  setState(() {
    models = jsonData.map((json) {
      List<Avios> avios = (json['avios'] as List).map((av) {
        return Avios(
          id: av['avio']['id'] as int,
          nombre: av['avio']['nombre'],
          proveedores: av['avio']['codigoProveedor'], // Puedes ajustar según la estructura de tu clase Avios
        );
      }).toList();

      return Modelo(
        id: json['id'],
        codigo: json['codigo'],
        genero: json['genero'], // Ajustando para usar el tipo de la categoría como prenda
        nombre: json['nombre'],
        tieneTelaSecundaria: json['tieneTelaSecundaria'],
        tieneTelaAuxiliar: json['tieneTelaAuxiliar'],
        avios: avios,
        curva: json['curva'],
        categoriaTipo: json['categoria']['tipo'],
        observaciones: json['observaciones']
      );
    }).toList();
  });

  print("Modelos cargados");
}
}
