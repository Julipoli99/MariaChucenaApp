import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gestion_indumentaria/models/talle.dart';

class AddTalleDialog extends StatefulWidget {
  final ValueChanged<Talle> onTalleAdded;
  final List<Talle>
      existingTalles; // Lista de talles existentes para verificar duplicados

  const AddTalleDialog({
    Key? key,
    required this.onTalleAdded,
    required this.existingTalles, // Añadir lista de talles existentes como parámetro
  }) : super(key: key);

  @override
  _AddTalleDialogState createState() => _AddTalleDialogState();
}

class _AddTalleDialogState extends State<AddTalleDialog> {
  final TextEditingController _talleController = TextEditingController();
  bool _isSaving = false;

  Future<void> _saveTalleToApi(String talleNombre) async {
    const String apiUrl =
        'https://maria-chucena-api-production.up.railway.app/talle';

    // Convertir el nombre del talle a mayúsculas
    final String normalizedTalle = talleNombre.toUpperCase();

    // Verificar si el talle ya existe
    if (widget.existingTalles.any((talle) => talle.nombre == normalizedTalle)) {
      _showError('Este talle ya existe.');
      return;
    }

    try {
      setState(() => _isSaving = true);
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: '{"talle": "$normalizedTalle"}', // Guardar en mayúsculas
      );

      if (response.statusCode == 201) {
        final nuevoTalle = Talle(id: 0, nombre: normalizedTalle);
        widget.onTalleAdded(nuevoTalle);
      } else {
        _showError('Error al guardar el talle en la API.');
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
      title: const Text('Agregar nuevo talle'),
      content: TextField(
        controller: _talleController,
        decoration: const InputDecoration(
          hintText: 'Ingrese el nuevo talle',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isSaving
              ? null
              : () {
                  final nuevoTalle = _talleController.text.trim();
                  if (nuevoTalle.isNotEmpty) {
                    _saveTalleToApi(nuevoTalle);
                  }
                },
          child: _isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Agregar'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _talleController.dispose();
    super.dispose();
  }
}
