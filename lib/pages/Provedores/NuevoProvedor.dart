import 'dart:convert'; // Importar para manejar JSON
import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/pages/Crud/proveedorCrudView.dart';
import 'package:gestion_indumentaria/pages/Provedores/provedoresPage.dart';
import 'package:http/http.dart'
    as http; // Importar para realizar solicitudes HTTP
import 'package:gestion_indumentaria/widgets/DrawerMenuLateral.dart';
import 'package:gestion_indumentaria/widgets/HomePage.dart';

class Nuevoprovedor extends StatelessWidget {
  const Nuevoprovedor({super.key});

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
      body:
          const NuevoprovedorForm(), // Usar un StatefulWidget para el formulario
    );
  }
}

class NuevoprovedorForm extends StatefulWidget {
  const NuevoprovedorForm({Key? key}) : super(key: key);

  @override
  _NuevoprovedorFormState createState() => _NuevoprovedorFormState();
}

class _NuevoprovedorFormState extends State<NuevoprovedorForm> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();

  bool _isSaving = false; // Estado para mostrar indicador de carga

  Future<void> _guardarProveedor() async {
    final String apiUrl =
        'https://maria-chucena-api-production.up.railway.app/proveedor';

    // Crear un mapa con los datos a enviar
    final Map<String, dynamic> proveedorData = {
      'nombre': _nombreController.text.trim(),
      'telefono': _telefonoController.text.trim(),
    };

    try {
      setState(() => _isSaving = true);
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(proveedorData), // Convertir a JSON
      );

      if (response.statusCode == 201) {
        // El proveedor se creó correctamente
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Proveedor guardado con éxito.')),
        );
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const Provedorespage()),
        );
        _nombreController.clear(); // Limpiar campos después de guardar
        _telefonoController.clear();
      } else {
        // Manejar errores de la API
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.body}')),
        );
      }
    } catch (e) {
      // Manejar excepciones
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocurrió un error: $e')),
      );
    } finally {
      setState(() => _isSaving = false); // Finalizar estado de carga
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Registro de proveedores',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildTextField('Proveedor', 'nombre de proveedor',
                          _nombreController),
                      const SizedBox(height: 20),
                      buildTextField('Teléfono', 'número de teléfono',
                          _telefonoController),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            onPressed: _isSaving ? null : _guardarProveedor,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 20),
                            ),
                            child: _isSaving
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text('Guardar proveedor'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
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
    );
  }

  // Función para construir los campos de texto
  static Widget buildTextField(
      String label, String hintText, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 18),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }
}
