import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/pages/Provedores/NuevoProvedor.dart';
import 'package:gestion_indumentaria/pages/TipoDeTelas/NuevoTipoDeTela.dart';
// import 'package:http/http.dart' as http; // Se comentan temporalmente para el ejemplo.
// import 'dart:convert'; // Para trabajar con JSON, se comentan por ahora.
import 'package:gestion_indumentaria/widgets/DrawerMenuLateral.dart';
import 'package:gestion_indumentaria/widgets/HomePage.dart';

class NuevasTelas extends StatefulWidget {
  const NuevasTelas({super.key});

  @override
  _NuevasTelasState createState() => _NuevasTelasState();
}

class _NuevasTelasState extends State<NuevasTelas> {
  // Lista para manejar los tipos de tejidos seleccionados
  List<String> selectedTejidos = [];

  // Listas simuladas para almacenar los datos en lugar de obtenerlos desde la API
  List<String> tiposTela = ['Algodón', 'Lana', 'Poliéster', 'Seda'];
  List<String> proveedores = ['Proveedor A', 'Proveedor B', 'Proveedor C'];

  @override
  void initState() {
    super.initState();
    // Comentar las llamadas a la API ya que estamos simulando los datos
    // fetchTiposTela();
    // fetchProveedores();
  }

  // Función simulada para cargar los tipos de tela
  Future<void> fetchTiposTela() async {
    // Simular un tiempo de carga como si viniera de una API
    await Future.delayed(Duration(seconds: 1));
    // Se usan datos estáticos para simular la respuesta
    setState(() {
      tiposTela = ['Algodón', 'Lana', 'Poliéster', 'Seda'];
    });
  }

  // Función simulada para cargar los proveedores
  Future<void> fetchProveedores() async {
    // Simular un tiempo de carga como si viniera de una API
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      proveedores = ['Proveedor A', 'Proveedor B', 'Proveedor C'];
    });
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
                          SizedBox(height: 50), // Espacio inicial
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
                        buildDropdownField('Tipo de tela', tiposTela),
                        buildTipoTejidoSelector(),
                        const SizedBox(height: 10),
                        buildDropdownField('Proveedor', proveedores),
                        buildTextField('Cantidad',
                            'Cantidad de tela registrada, en metros o kilos'),
                        buildTextField('Descripción',
                            'Nombre del color o descripción del estampado'),
                        buildTextField('Código',
                            'Código de referencia proporcionado por el proveedor'),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
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

  Widget buildDropdownField(String label, List<String> items) {
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
              onChanged: (value) {},
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
          'Tipo de Tejido',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: ['Plano', 'Tubular'].map((tipoTejido) {
            return ChoiceChip(
              label: Text(tipoTejido),
              selected: selectedTejidos.contains(tipoTejido),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedTejidos.add(tipoTejido);
                  } else {
                    selectedTejidos.remove(tipoTejido);
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

  Widget buildTextField(String label, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextField(
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
}
