import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/Avios.dart';
import 'package:gestion_indumentaria/widgets/tablaCrud/TablaCrud.dart';

class AviosCrudView extends StatelessWidget {
  AviosCrudView({super.key});

  final List<Avios> avios = [
    Avios(id: 1, nombre: "Avios1", proveedores: "proveedor1"),
    Avios(id: 2, nombre: "Avios2", proveedores: "proveedor2"),
    Avios(id: 3, nombre: "Avios3", proveedores: "proveedor3"),
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
                Row(
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
                    backgroundColor: Colors.blue[300],
                    foregroundColor: Colors.white
                  ), 
                  child: const Text('Modificar stock'),
                  
                  ),
                  ],
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
            child: TablaCrud<Avios>(
              // Titulo del appBar
              tituloAppBar: 'Avios',
              encabezados: const ["ID", "NOMBRE", "PROVEEDORES", "OPCIONES"], // Encabezados
              items: avios,   // Lista de avios
              dataMapper: [ // Celdas/valores
                (avio) => Text(avio.id.toString()),
                (avio) => Text(avio.nombre),
                (avio) => Text(avio.proveedores),
                //Parte de Opciones, se le pasa una funcion que retorna una List de Widgets en este caso Row.
                (avio) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {
                        print('Vista para avio: ${avio.nombre}');
                      },
                      icon: const Icon(Icons.remove_red_eye_outlined),
                    ),
                    IconButton(
                      onPressed: () {
                        print('Avio borrado: ${avio.nombre}');
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