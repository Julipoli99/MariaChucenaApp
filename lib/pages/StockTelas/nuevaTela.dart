import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/TipoProducto.dart';
import 'package:gestion_indumentaria/pages/StockTelas/stock_Control_Page.dart';
import 'package:gestion_indumentaria/pages/principal.dart';
import 'package:gestion_indumentaria/widgets/HomePage.dart';
import 'package:http/http.dart' as http; // Importa el paquete http
import 'dart:convert'; // Importa esto para convertir a JSON
import 'package:gestion_indumentaria/pages/Provedores/NuevoProvedor.dart';

import 'package:gestion_indumentaria/widgets/DrawerMenuLateral.dart';

class NuevasTelas extends StatefulWidget {
  const NuevasTelas({super.key});

  @override
  _NuevasTelasState createState() => _NuevasTelasState();
}

class _NuevasTelasState extends State<NuevasTelas> {
  List<String> selectedTejidos = [];
  TipoEnum? selectedTipo;
  List<String> proveedores = [];
  int? selectedProveedorId;

  double cantidad = 0.0;
  String color = '';
  bool estampado = false;
  String descripcion = '';
  String tipoRollo = ''; // Valor por defecto
  int? tipoProductoId; // Suponiendo que se cargará desde un API

  @override
  void initState() {
    super.initState();
    _cargarProveedores(); // Cargar proveedores al iniciar
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
            .map((proveedor) => proveedor['nombre'].toString())
            .toList(); // Suponiendo que el JSON tiene un campo 'nombre'
      });
    } else {
      // Manejar error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error al cargar proveedores: ${response.body}')),
      );
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(right: 32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 50),
                          Text(
                            'Registro de Telas',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Complete todos los detalles relevantes de la tela',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTipoTejidoSelector(),
                        const SizedBox(height: 15),
                        buildDropdownField('Proveedor', proveedores, (value) {
                          setState(() {
                            selectedProveedorId = proveedores.indexOf(
                                value!); // Asignar el índice del proveedor seleccionado
                          });
                        }),
                        buildTextField('Cantidad',
                            'Cantidad de tela registrada, en metros o kilos',
                            (value) {
                          cantidad = double.tryParse(value) ?? 0.0;
                        }),
                        buildTextField('Color', 'Nombre del color', (value) {
                          color = value;
                        }),
                        buildCheckboxField('Estampado', (value) {
                          setState(() {
                            estampado = value!;
                          });
                        }),
                        buildTextField(
                            'Descripción', 'Descripción del estampado',
                            (value) {
                          descripcion = value;
                        }),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomePage(),
                                  ),
                                );
                                // Acción para CANCELAR
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize:
                                    const Size(140, 50), // Ajusta el tamaño
                              ),
                              child: const Text('Cancelar'),
                            ),
                            FilledButton(
                              onPressed: () {
                                _guardarTela();
                              },
                              child: const Text('Guardar Tela'),
                              style: ElevatedButton.styleFrom(
                                minimumSize:
                                    const Size(140, 50), // Ajusta el tamaño
                              ),
                            ),
                            /* ElevatedButton(
                              onPressed: () {
                                // Lógica para cargar la foto
                              },
                              child: const Text('Cargar Foto'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 20),
                              ),
                            ),*/
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
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

  Future<void> _guardarTela() async {
    final datosTela = {
      "cantidad": cantidad,
      "color": color,
      "estampado": estampado,
      "descripcion": descripcion,
      "tipoRollo": tipoRollo,
      "tipoProductoId": 2,
      "proveedorId":
          selectedProveedorId != null ? selectedProveedorId! + 1 : null,
    };
    final url = 'https://maria-chucena-api-production.up.railway.app/Rollo';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(datosTela),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tela registrada exitosamente')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Stockcontrolpage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar la tela: ${response.body}')),
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
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              if (label == 'Proveedor') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NuevoProveedorDialog(
                      onProveedorAgregado: () {},
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildTipoTejidoSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tipo de Rollo',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: ['PLANO', 'TUBULAR'].map((tipoTejido) {
            return ChoiceChip(
              label: Text(tipoTejido),
              selected: tipoRollo == tipoTejido,
              onSelected: (isSelected) {
                setState(() {
                  tipoRollo = isSelected ? tipoTejido : '';
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget buildTextField(
      String label, String hintText, ValueChanged<String> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          labelStyle: const TextStyle(fontSize: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget buildCheckboxField(String label, ValueChanged<bool?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Checkbox(
            value: estampado,
            onChanged: onChanged,
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
