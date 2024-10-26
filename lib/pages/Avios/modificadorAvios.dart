import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/Avio.dart';
import 'package:gestion_indumentaria/pages/Avios/avios.dart';
import 'package:gestion_indumentaria/widgets/DrawerMenuLateral.dart';
import 'package:gestion_indumentaria/widgets/HomePage.dart';
import 'package:http/http.dart' as http;

class Modificadoravios extends StatefulWidget {
  const Modificadoravios({super.key});

  @override
  _ModificadoraviosState createState() => _ModificadoraviosState();
}

class _ModificadoraviosState extends State<Modificadoravios> {
  List<Avio> aviosData = [];
  String? selectedAvio;
  String? selectedProveedor;
  int cantidadInicial = 0; // Cantidad que se mostrará como inicial
  int cantidadActual = 0; // Cantidad que se mostrará como actual

  @override
  void initState() {
    super.initState();
    fetchAviosFromApi();
  }

  Future<void> fetchAviosFromApi() async {
    final response = await http.get(
        Uri.parse('https://maria-chucena-api-production.up.railway.app/avio'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      aviosData = jsonData.map((item) => Avio.fromJson(item)).toList();
      setState(() {});
    } else {
      throw Exception('Error al cargar los avios');
    }
  }

  void updateCantidadActual() {
    if (selectedAvio != null) {
      final avio =
          aviosData.firstWhere((element) => element.nombre == selectedAvio);
      cantidadInicial = avio
          .stock; // Asumiendo que `stock` es la propiedad que contiene la cantidad actual
      setState(() {});
    }
  }

  Future<void> updateStock() async {
    if (selectedAvio != null) {
      final avio =
          aviosData.firstWhere((element) => element.nombre == selectedAvio);

      // Asegúrate de que avio tenga un ID válido
      if (avio.id == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ID de avío no válido')),
        );
        return;
      }

      int nuevaCantidad = cantidadActual;

      // Realiza la solicitud PUT a la API
      final response = await http.put(
        Uri.parse(
            'https://maria-chucena-api-production.up.railway.app/avio/${avio.id}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'stock': nuevaCantidad,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Stock actualizado correctamente')),
        );
        fetchAviosFromApi(); // Refresca la lista después de la actualización
      } else {
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Error al actualizar el stock: ${response.body}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Maria Chucena ERP System'),
        toolbarHeight: 80,
        actions: [
          buildLoggedInUser('assets/imagen/logo.png', 'Supervisor'),
        ],
      ),
      drawer: const DrawerMenuLateral(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.grey[800],
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                child: const Center(
                  child: Column(
                    children: [
                      Text(
                        'Bienvenidos al sistema de Gestion de Stock De avios',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'De Maria Chucena ERP System',
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
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Modificar Stock de avios',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Tipo de Avio',
                              hintText: 'Seleccione un avío',
                            ),
                            items: aviosData.map((Avio avio) {
                              return DropdownMenuItem<String>(
                                value: avio.nombre,
                                child: Text(avio.nombre),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedAvio = newValue;
                                updateCantidadActual();
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Proveedor',
                              hintText: 'Seleccione un proveedor',
                            ),
                            items: <String>[
                              'Proveedor de prueba 1',
                              'Proveedor de prueba 2',
                              'Proveedor de prueba 3'
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedProveedor = newValue;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Cantidad Inicial',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextField(
                                      enabled: false,
                                      decoration: InputDecoration(
                                        hintText: cantidadInicial.toString(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Cantidad Actual',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextField(
                                      onChanged: (value) {
                                        cantidadActual = int.tryParse(value) ??
                                            0; // Actualiza la cantidad actual
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Ingrese cantidad actual"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              updateStock();
                              // Llama al método para actualizar el stock
                              Avios;
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 50,
                                vertical: 20,
                              ),
                            ),
                            child: const Text(
                              'Guardar avios',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
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
