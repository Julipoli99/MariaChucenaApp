import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/Usuario.dart';
import 'package:gestion_indumentaria/widgets/tablaCrud/TablaCrud.dart';

class UserCrudView extends StatelessWidget {
  UserCrudView({super.key});

  // Ejemplo para el crud de usuarios
  final List<Usuario> users = [
    Usuario(
        id: 1,
        nombre: 'Julian',
        email: 'polimenijulian9@gmail.com',
        rol: 'Admin'),
    Usuario(id: 2, nombre: 'Tomas', email: 'totopoli9@gmail.com', rol: 'free'),
    Usuario(id: 3, nombre: 'Agustin', email: 'aguspoli@gmail.com', rol: 'free'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TablaCrud<Usuario>(
        tituloAppBar: '', // Titulo del appBar
        encabezados: const [
          "ID",
          "NOMBRE",
          "EMAIL",
          "TIPO DE ROL",
          "OPCIONES"
        ], // Encabezados
        items: users, // Lista de usuarios
        dataMapper: [
          // Celdas/valores
          (user) => Text(user.id.toString()),
          (user) => Text(user.nombre),
          (user) => Text(user.email),
          (user) => Text(user.rol),
          //Parte de Opciones, se le pasa una funcion que retorna una List de Widgets en este caso Row.
          (user) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      print('Usuario borrado: ${user.nombre}');
                    },
                    icon: const Icon(Icons.delete),
                  ),
                  IconButton(
                    onPressed: () {
                      print('Vista para usuario: ${user.nombre}');
                    },
                    icon: const Icon(Icons.remove_red_eye_outlined),
                  ),
                ],
              ),
        ],
      ),
    );
  }
}
