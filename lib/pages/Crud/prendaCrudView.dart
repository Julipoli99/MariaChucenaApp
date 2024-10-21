import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/Avios.dart';
import 'package:gestion_indumentaria/models/Modelo.dart';
import 'package:gestion_indumentaria/models/tipoPrenda.dart';
import 'package:gestion_indumentaria/widgets/boxDialog/BoxDialogModelo.dart';
import 'package:gestion_indumentaria/widgets/tablaCrud/TablaCrud.dart';
import 'package:http/http.dart' as http;

class Prendacrudview extends StatefulWidget {
  const Prendacrudview({super.key});

  @override
  State<Prendacrudview> createState() => _PrendaCrudViewState();
}

class _PrendaCrudViewState extends State<Prendacrudview> {
  List<prenda> prendas = [];

  @override
  void initState() {
    super.initState();
    fetchModels(); // Llamamos al fetch cuando la página se carga
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TablaCrud<prenda>(
        tituloAppBar: 'Prendas registradas', // Titulo del appBar
        encabezados: const [
          "ID",
          "NOMBRE",
          "ACCIONES" // Agregado para reflejar el número de columnas
        ], // Encabezados
        items: prendas, // Lista de modelos
        dataMapper: [
          // Celdas/valores
          (prenda) => Text(prenda.id.toString()),
          (prenda) => Text(prenda.nombre ?? 'Sin nombre'),
          (prenda) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      print('Edicion para prenda con id: ${prenda.id}');
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {
                      print('Prenda borrada: ${prenda.id}');
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
    const url = "https://maria-chucena-api-production.up.railway.app/categoria";
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    // Imprimir la respuesta de la API para depuración
    print(response.body);

    final List<dynamic> jsonData = jsonDecode(response.body);

    setState(() {
      prendas = jsonData.map((json) {
        return prenda(
          id: json['id'] ?? 0, // Asignar un valor por defecto si es null
          nombre: json['tipo'] ?? 'Sin nombre', // Asignar un valor por defecto
        );
      }).toList();
    });

    print("Prendas cargadas");
  }
}
