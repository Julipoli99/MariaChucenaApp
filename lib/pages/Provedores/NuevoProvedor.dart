import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NuevoProveedorDialog extends StatefulWidget {
  final VoidCallback onProveedorAgregado;
  const NuevoProveedorDialog({super.key, required this.onProveedorAgregado});

  @override
  _NuevoProveedorDialogState createState() => _NuevoProveedorDialogState();
}

class _NuevoProveedorDialogState extends State<NuevoProveedorDialog> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  bool _isSaving = false;

  Future<void> _guardarProveedor() async {
    const String apiUrl =
        'https://maria-chucena-api-production.up.railway.app/proveedor';
    final Map<String, dynamic> proveedorData = {
      'nombre': _nombreController.text.trim(),
      'telefono': _telefonoController.text.trim(),
    };

    try {
      setState(() => _isSaving = true);
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(proveedorData),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Proveedor guardado con éxito.')),
        );
        widget.onProveedorAgregado();

        Navigator.of(context).pop(true); // Retorna true para indicar éxito
        _nombreController.clear();
        _telefonoController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocurrió un error: $e')),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nuevo Proveedor'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
                'Proveedor', 'nombre de proveedor', _nombreController),
            const SizedBox(height: 20),
            _buildTextField(
                'Teléfono', 'número de teléfono', _telefonoController),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context)
              .pop(false), // Retorna false para indicar cancelación
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _guardarProveedor,
          child: _isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Guardar'),
        ),
      ],
    );
  }

  Widget _buildTextField(
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
