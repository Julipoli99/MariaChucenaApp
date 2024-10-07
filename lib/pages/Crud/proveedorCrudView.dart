import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/Proveedor.dart';
import 'package:gestion_indumentaria/pages/Provedores/NuevoProvedor.dart';
import 'package:gestion_indumentaria/widgets/tablaCrud/TablaCrud.dart';

class ProveedorCrudView extends StatelessWidget {
  ProveedorCrudView({super.key});

  final List<Proveedor> proovedores = [
    Proveedor(id: "1", nombre: "Proveedor1"),
    Proveedor(id: "2", nombre: "Proveedor2"),
    Proveedor(id: "3", nombre: "Proveedor3"),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Nuevoprovedor(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.blue[300],
                      foregroundColor: Colors.white),
                  child: const Text('Nuevo registro'),
                ),
                TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white),
                    child: const Text('Inicio')),
              ],
            ),
          ),
          Expanded(
            child: TablaCrud<Proveedor>(
              tituloAppBar: 'Proveedores', // Titulo del appBar
              encabezados: const ["ID", "NOMBRE", "OPCIONES"], // Encabezados
              items: proovedores, // Lista de proveedores
              dataMapper: [
                // Celdas/valores
                (proveedor) => Text(proveedor.id),
                (proveedor) => Text(proveedor.nombre),
                //Parte de Opciones, se le pasa una funcion que retorna una List de Widgets en este caso Row.
                (proveedor) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            print('Vista para proveedor: ${proveedor.nombre}');
                          },
                          icon: const Icon(Icons.remove_red_eye_outlined),
                        ),
                        IconButton(
                          onPressed: () {
                            print('proveedor borrado: ${proveedor.nombre}');
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
