import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/tipoPrenda.dart';
import 'package:http/http.dart' as http;

class AddPrendaDialog extends StatefulWidget {
  final ValueChanged<Prenda> onPrendaAdded;
  final List<Prenda> prendasExistentes; // Lista de prendas existentes

  const AddPrendaDialog({
    Key? key,
    required this.onPrendaAdded,
    required this.prendasExistentes,
  }) : super(key: key);

  @override
  _AddPrendaDialogState createState() => _AddPrendaDialogState();
}

class _AddPrendaDialogState extends State<AddPrendaDialog> {
  final TextEditingController _prendaController = TextEditingController();
  bool _isSaving = false;

  Future<void> _savePrendaToApi(String prenda) async {
    const String apiUrl =
        'https://maria-chucena-api-production.up.railway.app/categoria';
    try {
      setState(() => _isSaving = true);
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'tipo': prenda}),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final newPrenda = Prenda(
          id: responseData['id'],
          nombre: responseData['tipo'],
        );
        widget.onPrendaAdded(newPrenda);
      } else {
        _showError('Error al guardar la prenda en la API. ${response.body}');
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
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange, // Fondo rojo para el error
      ),
    );
  }

  void _validateAndSavePrenda() {
    final nuevaPrenda = _prendaController.text.trim().toUpperCase();

    // Verificar si el nombre de la prenda ya existe en la lista de prendas
    final prendaExiste = widget.prendasExistentes.any(
      (prenda) => prenda.nombre.toUpperCase() == nuevaPrenda,
    );

    if (prendaExiste) {
      _showError('Ya existe una prenda con este nombre.');
    } else if (nuevaPrenda.isNotEmpty) {
      _savePrendaToApi(nuevaPrenda);
    }
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
          onPressed: () {
            final nuevaPrenda = _prendaController.text.trim();
            if (nuevaPrenda.isEmpty) {
              _showError('Por favor, complete el campo de la prenda.');
            } else {
              _validateAndSavePrenda();
            }
          },
          child: _isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Agregar'), // Siempre muestra "Agregar"
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
