import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTalleDialog extends StatefulWidget {
  final ValueChanged<String> onTalleAdded;

  const AddTalleDialog({Key? key, required this.onTalleAdded})
      : super(key: key);

  @override
  _AddTalleDialogState createState() => _AddTalleDialogState();
}

class _AddTalleDialogState extends State<AddTalleDialog> {
  final TextEditingController _talleController = TextEditingController();
  bool _isSaving = false; // Para mostrar un loader mientras se guarda.

  Future<void> _saveTalleToApi(String talle) async {
    const String apiUrl =
        'https://maria-chucena-api-production.up.railway.app/talle'; // Cambia por tu endpoint.

    try {
      setState(() => _isSaving = true);
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: '{"talle": "$talle"}',
      );

      if (response.statusCode == 201) {
        widget.onTalleAdded(talle); // Agregar a la lista local.
      } else {
        _showError('Error al guardar el talle en la API.');
      }
    } catch (e) {
      _showError('Ocurrió un error: $e');
    } finally {
      setState(() => _isSaving = false);
      Navigator.of(context).pop(); // Cerrar el diálogo.
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
