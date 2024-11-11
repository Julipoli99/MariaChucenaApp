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
    final String telefono = _telefonoController.text.trim();

    // Verifica si algún campo está vacío
    if (_nombreController.text.trim().isEmpty || telefono.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, complete todos los campos.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Verifica si el teléfono tiene menos de 10 caracteres
    if (telefono.length < 10) {
      int faltantes = 10 - telefono.length;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Teléfono incorrecto, faltan $faltantes caracteres.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Verifica si el teléfono tiene más de 10 caracteres
    if (telefono.length > 10) {
      int sobrantes = telefono.length - 10;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Teléfono incorrecto, sobran $sobrantes caracteres.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Verifica si el teléfono comienza con "11"
    if (!telefono.startsWith('11')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El teléfono debe comenzar con "11".'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    const String apiUrl =
        'https://maria-chucena-api-production.up.railway.app/proveedor';
    final Map<String, dynamic> proveedorData = {
      'nombre': _nombreController.text.trim(),
      'telefono': telefono,
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
          const SnackBar(
            content: Text('Proveedor guardado con éxito.'),
            backgroundColor: Colors.green,
          ),
        );
        widget.onProveedorAgregado();

        Navigator.of(context).pop(true); // Retorna true para indicar éxito
        _nombreController.clear();
        _telefonoController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al guardar el proveedor.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ocurrió un error: $e'),
          backgroundColor: Colors.red,
        ),
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
                'Teléfono',
                'número de teléfono (10 dígitos, comienza con 11)',
                _telefonoController),
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
      keyboardType:
          label == 'Teléfono' ? TextInputType.phone : TextInputType.text,
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }
}
