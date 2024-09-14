import 'package:flutter/material.dart';

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
                  child: Image.network(
                      'https://www.split.io/wp-content/uploads/flutter.png')),

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
                    print('Presionado boton Home');
                    //context.goNamed(Home.name);
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
                    'Ordenes',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    print('Presionado boton Ordenes');
                  },
                ),
              ),

              // Icono de Productos
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading:
                      const Icon(color: Colors.white, Icons.production_quantity_limits_sharp),
                  title: const Text(
                    'Productos',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    print('Presionado boton Productos');
                  },
                ),
              ),

              // Icono de Usuarios
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading:
                      const Icon(color: Colors.white, Icons.account_circle_outlined),
                  title: const Text(
                    'Usuarios',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    print('Presionado boton Usuarios');
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