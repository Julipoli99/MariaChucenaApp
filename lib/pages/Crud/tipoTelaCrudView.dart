import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/TipoTela.dart';
import 'package:gestion_indumentaria/widgets/tablaCrud/TablaCrud.dart';

class TipoTelaCrudView extends StatelessWidget {
  TipoTelaCrudView({super.key});

  final List<TipoTela> tiposDeTelas = [
    TipoTela(id: "1", nombreTipo: "PREMIUM"),
    TipoTela(id: "2", nombreTipo: "STANDARD"),
  ];

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
                
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue[300],
                    foregroundColor: Colors.white
                  ), 
                  child: const Text('Nuevo registro'),
                  
                  ),
            
                  TextButton(
                  onPressed: () {
                
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white
                  ), 
                  child: const Text('Inicio')
                  
                  ),
              ],
            ),
          )
          ,
          Expanded(
            child: TablaCrud<TipoTela>(
              // Titulo del appBar
              tituloAppBar: 'Tipo de telas registrados',
              encabezados: const ["ID", "TIPO DE TELA", "OPCIONES"], // Encabezados
              items: tiposDeTelas,   // Lista de items
              dataMapper: [ // Celdas/valores
                (type) => Text(type.id),
                (type) => Text(type.nombreTipo),
                //Parte de Opciones, se le pasa una funcion que retorna una List de Widgets en este caso Row.
                (type) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {
                        print('Edicion para tipo de tela: ${type.nombreTipo}');
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {
                        print('Vista para tipo de tela: ${type.nombreTipo}');
                      },
                      icon: const Icon(Icons.remove_red_eye_outlined),
                    ),
                    IconButton(
                      onPressed: () {
                        print('Tipo de tela borrado: ${type.nombreTipo}');
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
}