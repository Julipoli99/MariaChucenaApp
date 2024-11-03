import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/pages/Avios/avios.dart';
import 'package:gestion_indumentaria/widgets/DrawerMenuLateral.dart';
import 'package:gestion_indumentaria/widgets/HomePage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Nuevoavios extends StatefulWidget {
  const Nuevoavios({super.key});

  @override
  _NuevoaviosState createState() => _NuevoaviosState();
}

class _NuevoaviosState extends State<Nuevoavios> {
  final TextEditingController _tipoController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _provedorCodigoController =
      TextEditingController();
  String? _selectedProveedor;
  List<Map<String, dynamic>> proveedores = [];
  int? selectedProveedorId;

  @override
  void initState() {
    super.initState();
    _cargarProveedores(); // Cargar proveedores al iniciar
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
              // Título principal centrado con subtítulo
              Container(
                color: Colors.grey[800],
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                child: const Center(
                  child: Column(
                    children: [
                      Text(
                        'Bienvenidos al sistema de Gestion de Nuevos avios',
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

              // Formulario de Registro de Avios
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
                            'Registro de avios',
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
                          TextField(
                            controller: _tipoController,
                            decoration: const InputDecoration(
                              labelText: 'Tipo',
                              hintText: 'nombre',
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Dropdown para Proveedores
                          buildDropdownField(
                              'Proveedor',
                              proveedores
                                  .map((p) => p['nombre'].toString())
                                  .toList(), (value) {
                            setState(() {
                              _selectedProveedor = value;
                              selectedProveedorId = proveedores.firstWhere(
                                (p) => p['nombre'] == value,
                              )['id']; // Asignar el ID del proveedor seleccionado
                            });
                          }),
                          TextField(
                            controller: _provedorCodigoController,
                            decoration: const InputDecoration(
                              labelText: 'Código de proveedor',
                              hintText: 'Proveedor',
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _cantidadController,
                            decoration: const InputDecoration(
                              labelText: 'Cantidad',
                              hintText: 'Cantidad inicial',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _guardarAvios,
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

  Future<void> _guardarAvios() async {
    const String url =
        'https://maria-chucena-api-production.up.railway.app/avio';

    final Map<String, dynamic> avioData = {
      "codigoProveedor": _provedorCodigoController.text,
      "proveedorId": selectedProveedorId,
      "tipoProductoId": 1, // Asegúrate de cambiar esto si el tipo es dinámico
      "nombre": _tipoController.text,
      "stock": int.tryParse(_cantidadController.text) ?? 0,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(avioData),
    );

    if (response.statusCode == 201) {
      // Navegar a la pantalla de CRUD de avíos
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Avios()), // Cambia a la pantalla que desees
      );
    } else {
      // Manejo de errores
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar los avíos: ${response.body}')),
      );
    }
  }

  Future<void> _cargarProveedores() async {
    final url =
        'https://maria-chucena-api-production.up.railway.app/proveedor'; // URL de la API de proveedores
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Éxito, parsear los datos
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        proveedores = data
            .map((proveedor) => {
                  'id': proveedor['id'],
                  'nombre': proveedor['nombre'],
                })
            .toList(); // Suponiendo que el JSON tiene campos 'id' y 'nombre'
      });
    } else {
      // Manejar error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error al cargar proveedores: ${response.body}')),
      );
    }
  }

  Widget buildDropdownField(
      String label, List<String> items, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: DropdownButtonFormField<String>(
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: const TextStyle(fontSize: 18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
