import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/TipoProducto.dart';
import 'package:http/http.dart' as http;

class ModificadorTipoProductoDialog extends StatefulWidget {
  final TipoProducto tipoProducto; // TipoProducto existente a modificar
  final ValueChanged<TipoProducto> onTipoProductoModified;

  const ModificadorTipoProductoDialog({
    Key? key,
    required this.tipoProducto,
    required this.onTipoProductoModified,
  }) : super(key: key);

  @override
  _ModificadorTipoProductoDialog createState() =>
      _ModificadorTipoProductoDialog();
}

class _ModificadorTipoProductoDialog
    extends State<ModificadorTipoProductoDialog> {
  final TextEditingController _tipoProductoController = TextEditingController();
  bool _isSaving = false;
  TipoEnum? selectedTipo;
  UnidadMetricaEnum? selectedUnidad;

  @override
  void initState() {
    super.initState();
    _tipoProductoController.text =
        widget.tipoProducto.nombre; // Cargar el nombre actual
    selectedTipo = widget.tipoProducto.tipo;
    selectedUnidad = widget.tipoProducto.unidadMetrica;
  }

  Future<void> _updateTipoProductoInApi() async {
    final String apiUrl =
        'https://maria-chucena-api-production.up.railway.app/tipo-producto/${widget.tipoProducto.id}';

    try {
      setState(() => _isSaving = true);
      final response = await http.patch(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombre': _tipoProductoController.text.trim(),
          'tipo': selectedTipo.toString().split('.').last,
          'unidadMetrica': selectedUnidad.toString().split('.').last,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final updatedTipoProducto = TipoProducto(
          id: responseData['id'],
          nombre: responseData['nombre'],
          tipo: TipoEnum.values.firstWhere(
              (e) => e.toString().split('.').last == responseData['tipo']),
          unidadMetrica: UnidadMetricaEnum.values.firstWhere((e) =>
              e.toString().split('.').last == responseData['unidadMetrica']),
        );

        widget.onTipoProductoModified(
            updatedTipoProducto); // Callback con la tipoProducto actualizada
      } else {
        print(
            'Error al actualizar el tipo de producto en la API. ${response.body}');
        _showError(
            'Error al actualizar el tipo de producto en la API. ${response.body}');
      }
    } catch (e) {
      print('Ocurrió un error: $e');
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

  Widget buildTipoProductoSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tipo de Producto',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: TipoEnum.values.map((tipo) {
            return ChoiceChip(
              label: Text(tipo.toString().split('.').last),
              selected: selectedTipo == tipo,
              onSelected: (selected) {
                setState(() {
                  if (selected) selectedTipo = tipo;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget buildUnidadMetricaProductoSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Unidad Métrica',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: UnidadMetricaEnum.values.map((unidad) {
            return ChoiceChip(
              label: Text(unidad.toString().split('.').last),
              selected: selectedUnidad == unidad,
              onSelected: (selected) {
                setState(() {
                  if (selected) selectedUnidad = unidad;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Modificar Tipo de Producto'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _tipoProductoController,
              decoration: const InputDecoration(
                labelText: 'Nuevo nombre',
              ),
            ),
            const SizedBox(height: 20),
            buildTipoProductoSelector(),
            const SizedBox(height: 20),
            buildUnidadMetricaProductoSelector(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _updateTipoProductoInApi,
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
    _tipoProductoController.dispose();
    super.dispose();
  }
}
