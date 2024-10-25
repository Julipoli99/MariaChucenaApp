import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/tipoPrenda.dart';
import 'package:http/http.dart' as http;

class AddPrendaDialog extends StatefulWidget {
  final ValueChanged<String> onPrendaAdded;

  const AddPrendaDialog({Key? key, required this.onPrendaAdded})
      : super(key: key);

  @override
  _AddPrendaDialogState createState() => _AddPrendaDialogState();
}

class _AddPrendaDialogState extends State<AddPrendaDialog> {
  final TextEditingController _prendaController = TextEditingController();
  bool _isSaving = false; // Para mostrar un loader mientras se guarda.

  Future<void> _savePrendaToApi(String prenda) async {
    const String apiUrl =
        'https://maria-chucena-api-production.up.railway.app/categoria'; // Cambia por tu endpoint.

    try {
      setState(() => _isSaving = true);
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: '{"tipo": "$prenda"}',
      );

      if (response.statusCode == 201) {
        widget.onPrendaAdded(prenda); // Agregar a la lista local.
      } else {
        print('Error: ${response.statusCode} ${response.body}');
        _showError('Error al guardar el prenda en la API.${response.body}');
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
      title: const Text('Agregar nueva prenda'),
      content: TextField(
        controller: _prendaController,
        decoration: const InputDecoration(
          hintText: 'Ingrese la nueva prenda',
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
                  final nuevaPrenda = _prendaController.text.trim();
                  if (nuevaPrenda.isNotEmpty) {
                    _savePrendaToApi(nuevaPrenda);
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
    _prendaController.dispose();
    super.dispose();
  }
}
