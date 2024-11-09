import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/Proveedor.dart';
import 'package:gestion_indumentaria/models/tipoPrenda.dart';
import 'package:http/http.dart' as http;

class ModificadorProvedorDialog extends StatefulWidget {
  final Proveedor proveedor; // Prenda existente a modificar
  final ValueChanged<Proveedor> onProvedorModified;

  const ModificadorProvedorDialog({
    Key? key,
    required this.proveedor,
    required this.onProvedorModified,
  }) : super(key: key);

  @override
  _ModificadorProvedorDialog createState() => _ModificadorProvedorDialog();
}

class _ModificadorProvedorDialog extends State<ModificadorProvedorDialog> {
  final TextEditingController _provedorController = TextEditingController();
  final TextEditingController _provedorControllerTelefono =
      TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _provedorController.text = widget.proveedor.nombre ?? '';
    _provedorControllerTelefono.text =
        widget.proveedor.telefono ?? ''; // Cargar el nombre actual
  }

  Future<void> _updateProvedorInApi() async {
    final String apiUrl =
        'https://maria-chucena-api-production.up.railway.app/proveedor/${widget.proveedor.id}';

    try {
      setState(() => _isSaving = true);
      final response = await http.patch(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombre': _provedorController.text.trim(),
          'telefono':
              _provedorControllerTelefono.text.trim(), // Añadir el teléfono
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final updatedProvedor = Proveedor(
            id: responseData['id'],
            nombre: responseData['nombre'],
            telefono: responseData['telefono']);
        widget.onProvedorModified(
            updatedProvedor); // Callback con la prenda actualizada
      } else {
        _showError(
            'Error al actualizar el provedor en la API. ${response.body}');
      }
    } catch (e) {
      _showError('Ocurrió un error: $e');
    } finally {
      setState(() => _isSaving = false);
      Navigator.of(context).pop();
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Modificar provedor'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nombre actual: ${widget.proveedor.nombre ?? "Sin nombre"}'),
          const SizedBox(height: 10),
          TextField(
            controller: _provedorController,
            decoration: const InputDecoration(
              labelText: 'Nuevo nombre del proveedor ',
            ),
          ),
          const SizedBox(height: 20),
          Text(
              'Telefono actual: ${widget.proveedor.telefono ?? "Sin telefono"}'),
          const SizedBox(height: 10),
          TextField(
            controller: _provedorControllerTelefono,
            decoration: const InputDecoration(
              labelText: 'Nuevo telefono del proveedor ',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _updateProvedorInApi,
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

  @override
  void dispose() {
    _provedorController.dispose();
    super.dispose();
  }
}
