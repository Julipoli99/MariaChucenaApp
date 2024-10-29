import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/TipoProducto.dart';
import 'package:gestion_indumentaria/pages/Crud/TallesCrudView.dart';
import 'package:gestion_indumentaria/pages/Login/usuariosRegistrados.dart';
import 'package:gestion_indumentaria/pages/Talles/tallesVista.dart';
import 'package:gestion_indumentaria/pages/TipoProducto/registroTipoProducto.dart';
import 'package:gestion_indumentaria/pages/principal.dart';

class DrawerMenuLateral extends StatelessWidget {
  const DrawerMenuLateral({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // logo
              DrawerHeader(
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'imagen/im.jpg'), // Imagen de fondo desde la carpeta 'imagenes'
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'imagen/logo.png', // Logo desde la carpeta 'imagenes'
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Divider(
                  color: Colors.grey[800],
                ),
              ),

              // Icono de Home
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: const Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Home',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                ),
              ),

              // Icono de Acerca de...
              const Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.info_outline,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Acerca de',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              // Icono de Ordenes
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading:
                      const Icon(color: Colors.white, Icons.list_alt_rounded),
                  title: const Text(
                    'Talles',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const tallesregistradospage()),
                    );
                    print('Presionado boton de talles');
                  },
                ),
              ),

              // Icono de Productos
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: const Icon(
                      color: Colors.white,
                      Icons.production_quantity_limits_sharp),
                  title: const Text(
                    'Tipo de Productos',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const TipoProductoregistradospage()),
                    );
                    print('Presionado boton Productos');
                  },
                ),
              ),

              // Icono de Usuarios
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: const Icon(
                      color: Colors.white, Icons.account_circle_outlined),
                  title: const Text(
                    'Usuarios',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Usuariosregistrados()),
                    );
                  },
                ),
              ),
            ],
          ),

          // Icono de Cerrar Sesión
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25),
            child: ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              title: const Text(
                'Cerrar Sesión',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                print('Presionado boton Cerrar Sesion');
              },
            ),
          ),
        ],
      ),
    );
  }
}
