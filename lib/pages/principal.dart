import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/pages/Avios/avios.dart';
import 'package:gestion_indumentaria/pages/Modelos/tipodePrendaRegistrada.dart';
import 'package:gestion_indumentaria/pages/Tizadas/CreacionTizadasPage.dart';
import 'package:gestion_indumentaria/pages/Modelos/ModelosRegistradosPage.dart';
import 'package:gestion_indumentaria/pages/Modelos/ordenDeCorte.dart';
import 'package:gestion_indumentaria/pages/Provedores/provedoresPage.dart';
import 'package:gestion_indumentaria/widgets/DrawerMenuLateral.dart';
import 'package:gestion_indumentaria/widgets/HomePage.dart';
import 'package:gestion_indumentaria/pages/StockTelas/stock_Control_Page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Maria Chucena ERP System'),
        toolbarHeight: 80,
        actions: [
          buildLoggedInUser('assets/imagen/logo.png',
              'Supervisor'), //el tipo de rango lo tendria que traer de la base de datos
        ],
      ),
      drawer: const DrawerMenuLateral(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título principal centrado con subtítulo
              Container(
                color: Colors.grey[800],
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                child: const Center(
                  child: Column(
                    children: [
                      Text(
                        'Bienvenidos a Maria Chucena ERP System',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Optimice sus operaciones con nuestra solución ERP basada en web.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Gestión de Corte (Texto centrado con tarjetas a la derecha y espacio en blanco a la izquierda)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(
                    flex: 2, // Ajustamos el espacio para centrar el texto
                    child: Center(
                      child: Text(
                        'Gestión de Corte',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3, // Ajustamos el espacio para las tarjetas
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Añadimos un Container para limitar el ancho de las tarjetas
                        SizedBox(
                          width: 600, // Limita el ancho de las tarjetas
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            OrdenDeCorteScreen()),
                                  );
                                },
                                child: buildOptionCard(
                                  'Orden de Corte',
                                  'Descripción de las órdenes de corte.',
                                  250,
                                  80,
                                  'assets/imagen/orden.png',
                                ),
                              ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Avios()),
                                  );
                                },
                                child: buildOptionCard(
                                  'Informe de Avíos',
                                  'Detalles de avíos necesarios.',
                                  250,
                                  80,
                                  'assets/imagen/avios.png',
                                ),
                              ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Prendasregistradospage()),
                                  );
                                },
                                child: buildOptionCard(
                                  'Informe de prendas',
                                  'Detalles de prendas registradas.',
                                  250,
                                  80,
                                  'assets/imagen/avios.png',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 60),

              // Dentro del widget donde muestras las tarjetas de Gestión de Recursos
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Gestión de Recursos',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 1), // Margen
                              child: SizedBox(
                                width: 350, // Ancho ajustado
                                height: 250, // Alto ajustado
                                child: GestureDetector(
                                  onTap: () {
                                    // Navegar a la página de StockControlPage
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const Stockcontrolpage(),
                                      ),
                                    );
                                  },
                                  child: buildResourceCard(
                                    'Stock control',
                                    'Área textil',
                                    250,
                                    140,
                                    'assets/imagen/stock.png',
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 1), // Margen
                              child: SizedBox(
                                width: 350, // Ancho ajustado
                                height: 250, // Alto ajustado
                                child: GestureDetector(
                                  onTap: () {
                                    // Navegar a la página de CreacionTizadasPage
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CreacionTizadasPage(),
                                      ),
                                    );
                                  },
                                  child: buildResourceCard(
                                    'Creación de tizadas',
                                    'Administración',
                                    250,
                                    140,
                                    'assets/imagen/tizada.jpg',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10), // Espacio entre filas
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 1), // Margen
                              child: SizedBox(
                                width: 350, // Ancho ajustado
                                height: 250, // Alto ajustado
                                child: GestureDetector(
                                  onTap: () {
                                    // Navegar a la página de ModelosPage
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const Modelosregistradospage(),
                                      ),
                                    );
                                  },
                                  child: buildResourceCard(
                                    'Registrados',
                                    'Modelos',
                                    250,
                                    140,
                                    'assets/imagen/modelos.jpeg',
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 1), // Margen
                              child: SizedBox(
                                width: 350, // Ancho ajustado
                                height: 250, // Alto ajustado
                                child: GestureDetector(
                                  onTap: () {
                                    // Navegar a la página de ProveedoresPage
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const Provedorespage(),
                                      ),
                                    );
                                  },
                                  child: buildResourceCard(
                                    'Lista de proveedores',
                                    'Proveedores',
                                    250,
                                    140,
                                    'assets/imagen/provedores.jpeg',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Divider(),
              // Pie de página con usuario logueado
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: Text(
                          '© 2024 Maria Chucena ERP System. All rights reserved.',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
