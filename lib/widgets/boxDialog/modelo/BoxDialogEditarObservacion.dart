import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/observacion.dart';
import 'package:http/http.dart' as http;

class ModificadorObservacionDialog extends StatefulWidget {
  final ObservacionModel observacion; // Observación a modificar
  final int idModelo; // ID del modelo asociado a la observación
// Callback para actualizar el CRUD

  const ModificadorObservacionDialog({
    Key? key,
    required this.observacion,
    required this.idModelo, // Recibimos el ID del modelo
    // Recibimos el callback para actualizar el CRUD
  }) : super(key: key);

  @override
  _ModificadorObservacionDialogState createState() =>
      _ModificadorObservacionDialogState();
}

class _ModificadorObservacionDialogState
    extends State<ModificadorObservacionDialog> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _tituloController.text = widget.observacion.titulo ?? '';
    _descripcionController.text = widget.observacion.descripcion ?? '';
  }

  Future<void> _updateObservacionInApi() async {
    final String apiUrl =
        'https://maria-chucena-api-production.up.railway.app/modelo/observacion/${widget.idModelo}/${widget.observacion.id}';
    try {
      setState(() => _isSaving = true);
      final response = await http.patch(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'titulo': _tituloController.text.trim(),
          'descripcion': _descripcionController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        // Si la respuesta es exitosa, retornamos la observación actualizada
        Navigator.of(context).pop(ObservacionModel(
          id: widget.observacion.id,
          titulo: _tituloController.text.trim(),
          descripcion: _descripcionController.text.trim(),
        ));
      } else {
        _showError('Complete todos los campos');
      }
    } catch (e) {
      _showError('Ocurrió un error: $e');
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Modificar Observación'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Título actual: ${widget.observacion.titulo ?? "Sin título"}'),
          const SizedBox(height: 10),
          TextField(
            controller: _tituloController,
            decoration: const InputDecoration(
              labelText: 'Nuevo título de la observación',
            ),
          ),
          const SizedBox(height: 20),
          Text(
              'Descripción actual: ${widget.observacion.descripcion ?? "Sin descripción"}'),
          const SizedBox(height: 10),
          TextField(
            controller: _descripcionController,
            decoration: const InputDecoration(
              labelText: 'Nueva descripción de la observación',
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
          onPressed: _isSaving ? null : _updateObservacionInApi,
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
    _tituloController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }
}
