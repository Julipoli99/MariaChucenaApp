import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/TipoProducto.dart';
import 'package:http/http.dart' as http; // Importa el paquete http
import 'dart:convert'; // Importa esto para convertir a JSON
import 'package:gestion_indumentaria/pages/Provedores/NuevoProvedor.dart';
import 'package:gestion_indumentaria/pages/TipoDeTelas/NuevoTipoDeTela.dart';
import 'package:gestion_indumentaria/widgets/DrawerMenuLateral.dart';

class NuevasTelas extends StatefulWidget {
  const NuevasTelas({super.key});

  @override
  _NuevasTelasState createState() => _NuevasTelasState();
}

class _NuevasTelasState extends State<NuevasTelas> {
  List<String> selectedTejidos = [];
  TipoEnum? selectedTipo;
  List<String> proveedores = ['Proveedor A', 'Proveedor B', 'Proveedor C'];

  double cantidad = 0.0;
  String color = '';
  bool estampado = false;
  String descripcion = '';
  String tipoRollo = ''; // Valor por defecto
  int? tipoProductoId; // Suponiendo que se cargará desde un API
  int? proveedorId; // Suponiendo que se cargará desde un API

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
                        const SizedBox(height: 10),
                        buildTipoProductoSelector(),
                        const SizedBox(height: 10),
                        buildDropdownField('Proveedor', proveedores, (value) {
                          // Maneja la selección del proveedor
                        }),
                        buildTextField('Cantidad',
                            'Cantidad de tela registrada, en metros o kilos',
                            (value) {
                          cantidad = double.tryParse(value) ??
                              0.0; // Convertir a double
                        }),
                        buildTextField('Color', 'Nombre del color', (value) {
                          color = value; // Almacenar el color
                        }),
                        buildCheckboxField('Estampado', (value) {
                          setState(() {
                            estampado = value; // Almacenar si es estampado
                          });
                        }),
                        buildTextField(
                            'Descripción', 'Descripción del estampado',
                            (value) {
                          descripcion = value; // Almacenar descripción
                        }),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _guardarTela(); // Llama al método para guardar la tela
                              },
                              child: const Text('Guardar Tela'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 20),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Lógica para cargar la foto
                              },
                              child: const Text('Cargar Foto'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 20),
                              ),
                            ),
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
    // Recolectar datos
    final datosTela = {
      "cantidad": cantidad,
      "color": color,
      "estampado": estampado,
      "descripcion": descripcion,
      "tipoRollo": tipoRollo,
      "tipoProductoId": tipoProductoId, // Cambiar esto para cargar del API
      "proveedorId": 1, // Cambiar esto para cargar del API
    };
    print(datosTela);
    // URL del endpoint
    final url = 'https://maria-chucena-api-production.up.railway.app/Rollo';

    // Enviar solicitud POST
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(datosTela), // Convertir a JSON
    );

    // Manejar la respuesta
    if (response.statusCode == 200) {
      // Éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tela registrada exitosamente')),
      );
    } else {
      // Error
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
              if (label == 'Tipo de tela') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Nuevotipodetela(),
                  ),
                );
              } else if (label == 'Proveedor') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Nuevoprovedor(),
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
              onSelected: (selected) {
                setState(() {
                  tipoRollo = selected
                      ? tipoTejido
                      : ''; // Asigna el valor seleccionado
                });
              },
              labelStyle: const TextStyle(fontSize: 16),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget buildTipoProductoSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tipo de Producto',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: TipoEnum.values.map((tipo) {
            return ChoiceChip(
              label: Text(tipo.toString().split('.').last),
              selected: selectedTipo == tipo,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedTipo = tipo;
                    tipoProductoId =
                        selectedTipo == TipoEnum.AVIO ? 1 : 2; // Ajusta el id
                  }
                });
              },
              labelStyle: const TextStyle(fontSize: 16),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget buildTextField(
      String label, String hint, ValueChanged<String> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 18),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget buildCheckboxField(String label, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: estampado,
          onChanged: (value) {
            setState(() {
              estampado = value!;
              onChanged(value);
            });
          },
        ),
        Text(label, style: const TextStyle(fontSize: 18)),
      ],
    );
  }

  // Método para mostrar el usuario registrado (puedes adaptarlo)
  Widget buildLoggedInUser(String logoUrl, String role) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(logoUrl),
            radius: 20,
          ),
          const SizedBox(width: 8),
          Text(role, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
