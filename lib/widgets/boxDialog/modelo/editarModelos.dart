import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/Modelo.dart';
import 'package:gestion_indumentaria/models/talle.dart';
import 'package:gestion_indumentaria/widgets/TalleSelectorWidget.dart';
import 'package:http/http.dart' as http;

class EditModelDialog extends StatefulWidget {
  final Modelo modelo;
  final ValueChanged<Modelo> onModeloModified;

  const EditModelDialog({
    super.key,
    required this.modelo,
    required this.onModeloModified,
  });

  @override
  _EditModelDialogState createState() => _EditModelDialogState();
}

class _EditModelDialogState extends State<EditModelDialog> {
  final TextEditingController _nombreController = TextEditingController();
  bool _tieneTelaSecundaria = false;
  bool _tieneTelaAuxiliar = false;
  bool _isSaving = false;

  List<Talle> selectedTallesForm = [];

  @override
  void initState() {
    super.initState();
    _nombreController.text = widget.modelo.nombre;
    _tieneTelaSecundaria = widget.modelo.tieneTelaSecundaria;
    _tieneTelaAuxiliar = widget.modelo.tieneTelaAuxiliar;
    selectedTallesForm = List<Talle>.from(widget.modelo.curva);
  }

  Future<void> _updateModeloInApi() async {
    final String apiUrl =
        'https://maria-chucena-api-production.up.railway.app/modelo/${widget.modelo.id}';

    setState(() => _isSaving = true);

    try {
      final response = await http.patch(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombre': _nombreController.text.trim(),
          'tieneTelaSecundaria': _tieneTelaSecundaria,
          'tieneTelaAuxiliar': _tieneTelaAuxiliar,
          'curva': selectedTallesForm.map((talle) => talle.toJson()).toList(),
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final updatedModelo = Modelo.fromJson(responseData);
        widget.onModeloModified(updatedModelo);
        Navigator.of(context).pop(true);
      } else {
        _showError('Error al actualizar el modelo en la API. ${response.body}');
      }
    } catch (e) {
      _showError('Ocurrió un error: $e');
    } finally {
      setState(() => _isSaving = false);
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
      title: const Text('Modificar Modelo'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Código actual: ${widget.modelo.codigo}'),
            const SizedBox(height: 20),
            Text('Nombre actual: ${widget.modelo.nombre}'),
            const SizedBox(height: 10),
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nuevo nombre del modelo',
              ),
            ),
            const SizedBox(height: 20),
            CheckboxListTile(
              title: const Text('¿Tiene tela secundaria?'),
              value: _tieneTelaSecundaria,
              onChanged: (value) {
                setState(() => _tieneTelaSecundaria = value ?? false);
              },
            ),
            CheckboxListTile(
              title: const Text('¿Tiene tela auxiliar?'),
              value: _tieneTelaAuxiliar,
              onChanged: (value) {
                setState(() => _tieneTelaAuxiliar = value ?? false);
              },
            ),
            const SizedBox(height: 15),
            TalleSelector(
              selectedTalles: selectedTallesForm,
              onTalleSelected: (talles) {
                setState(() {
                  selectedTallesForm = talles;
                });
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: _isSaving ? null : _updateModeloInApi,
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
