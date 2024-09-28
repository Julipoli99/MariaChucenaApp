import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/Tela.dart';
import 'package:gestion_indumentaria/widgets/tablaCrud/TablaCrud.dart';

class TelaCrudView extends StatelessWidget {
  TelaCrudView({super.key});

  final List<Tela> telas = [
    Tela(id: "Tela 1", tipoDeTela: "tipoDeTela1", tipoDeTejido: "Plano", proveedor: "proveedor1", cantidad: 2, descripcion: "Lorem ipsum", codigo: "Z002"),
    Tela(id: "Tela 2", tipoDeTela: "tipoDeTela2", tipoDeTejido: "Tubular", proveedor: "proveedor2", cantidad: 1, descripcion: "Lorem ipsum", codigo: "Z003"),
    Tela(id: "Tela 3", tipoDeTela: "tipoDeTela3", tipoDeTejido: "Tubular", proveedor: "proveedor3", cantidad: 3, descripcion: "Lorem ipsum", codigo: "Z004"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TablaCrud<Tela>(
        tituloAppBar: 'Telas registradas', // Titulo del appBar
        encabezados: const ["ID", "TIPO DE TELA", "TIPO DE TEJIDO", "PROVEEDOR", "CANTIDAD", "DESCRIPCION", "CODIGO", "OPCIONES"], // Encabezados
        items: telas,   // Lista de usuarios
        dataMapper: [ // Celdas/valores
          (tela) => Text(tela.id),
          (tela) => Text(tela.tipoDeTela),
          (tela) => Text(tela.tipoDeTejido),
          (tela) => Text(tela.proveedor),
          (tela) => Text(tela.cantidad.toString()),
          (tela) => Text(tela.descripcion),
          (tela) => Text(tela.codigo),
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
    );
  }
}