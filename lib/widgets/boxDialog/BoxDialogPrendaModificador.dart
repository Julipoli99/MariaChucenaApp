import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/tipoPrenda.dart';
import 'package:http/http.dart' as http;

class ModificadorPrendaDialog extends StatefulWidget {
  final Prenda prenda; // Prenda existente a modificar
  final ValueChanged<Prenda> onPrendaModified;

  const ModificadorPrendaDialog({
    Key? key,
    required this.prenda,
    required this.onPrendaModified,
  }) : super(key: key);

  @override
  _ModificadorPrendaDialogState createState() =>
      _ModificadorPrendaDialogState();
}

class _ModificadorPrendaDialogState extends State<ModificadorPrendaDialog> {
  final TextEditingController _prendaController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _prendaController.text = widget.prenda.nombre ?? ''; // Cargar el nombre actual
  }

  Future<void> _updatePrendaInApi() async {
    final String apiUrl =
        'https://maria-chucena-api-production.up.railway.app/categoria/${widget.prenda.id}';

    try {
      setState(() => _isSaving = true);
      final response = await http.patch(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'tipo': _prendaController.text.trim()}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final updatedPrenda = Prenda(
          id: responseData['id'],
          nombre: responseData['tipo'],
        );
        widget.onPrendaModified(updatedPrenda); // Callback con la prenda actualizada
      } else {
        _showError('Error al actualizar la prenda en la API. ${response.body}');
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
      title: const Text('Modificar prenda'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nombre actual: ${widget.prenda.nombre ?? "Sin nombre"}'),
          const SizedBox(height: 10),
          TextField(
            controller: _prendaController,
            decoration: const InputDecoration(
              labelText: 'Nuevo nombre de la prenda',
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
          onPressed: _isSaving ? null : _updatePrendaInApi,
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
    _prendaController.dispose();
    super.dispose();
  }
}
