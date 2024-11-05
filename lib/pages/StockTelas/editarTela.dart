import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/Tela.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditarTelaDialog extends StatefulWidget {
  final Tela tela;

  const EditarTelaDialog({super.key, required this.tela});

  @override
  _EditarTelaDialogState createState() => _EditarTelaDialogState();
}

class _EditarTelaDialogState extends State<EditarTelaDialog> {
  final _formKey = GlobalKey<FormState>();
  double cantidad = 0.0;
  String color = '';
  bool estampado = false;
  String descripcion = '';
  String tipoRollo = '';
  int? tipoProductoId;
  int? selectedProveedorId;

  List<String> proveedores = [];

  @override
  void initState() {
    super.initState();
    _cargarDatosTela();
    _cargarProveedores();
  }

  Future<void> _cargarDatosTela() async {
    final url =
        'https://maria-chucena-api-production.up.railway.app/Rollo/${widget.tela.id}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        cantidad = data['cantidad'].toDouble();
        color = data['color'];
        estampado = data['estampado'];
        descripcion = data['descripcion'];
        tipoRollo = data['tipoRollo'];
        tipoProductoId = data['tipoProductoId'];
        selectedProveedorId = data['proveedorId'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar datos de la tela: ${response.body}'),
        ),
      );
    }
  }

  Future<void> _cargarProveedores() async {
    final url = 'https://maria-chucena-api-production.up.railway.app/proveedor';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        proveedores =
            data.map((proveedor) => proveedor['nombre'].toString()).toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error al cargar proveedores: ${response.body}')),
      );
    }
  }

  Future<void> _actualizarTela() async {
    if (_formKey.currentState!.validate()) {
      final datosTela = {
        "cantidad": cantidad,
        "color": color,
        "estampado": estampado,
        "descripcion": descripcion,
        "tipoRollo": tipoRollo,
        "tipoProductoId": tipoProductoId,
        "proveedorId": selectedProveedorId,
      };

      final url =
          'https://maria-chucena-api-production.up.railway.app/Rollo/${widget.tela.id}';
      final response = await http.patch(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(datosTela),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tela actualizada exitosamente')),
        );
        Navigator.pop(context, true); // Cierra el diálogo y devuelve éxito
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error al actualizar la tela: ${response.body}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Tela'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTextField('Cantidad', cantidad.toString(), (value) {
                cantidad = double.tryParse(value) ?? 0.0;
              }),
              buildTextField('Color', color, (value) {
                color = value;
              }),
              buildCheckboxField('Estampado', (value) {
                setState(() {
                  estampado = value!;
                });
              }),
              buildTextField('Descripción', descripcion, (value) {
                descripcion = value;
              }),
              buildTipoTejidoSelector(),
              const SizedBox(height: 10),
              buildDropdownField('Proveedor', proveedores, (value) {
                setState(() {
                  selectedProveedorId = proveedores.indexOf(value!) + 1;
                });
              }),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.pop(context, false), // Cierra el diálogo sin cambios
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _actualizarTela,
          child: const Text('Guardar'),
        ),
      ],
    );
  }

  Widget buildTextField(
      String label, String initialValue, ValueChanged<String> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor ingrese $label';
          }
          return null;
        },
      ),
    );
  }

  Widget buildCheckboxField(String label, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        Checkbox(
          value: estampado,
          onChanged: onChanged,
        ),
        Text(label),
      ],
    );
  }

  Widget buildTipoTejidoSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tipo de Rollo'),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: ['PLANO', 'TUBULAR'].map((tipo) {
            return ChoiceChip(
              label: Text(tipo),
              selected: tipoRollo == tipo,
              onSelected: (selected) {
                setState(() {
                  tipoRollo = selected ? tipo : '';
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget buildDropdownField(
      String label, List<String> items, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: DropdownButtonFormField<String>(
        value:
            selectedProveedorId != null && selectedProveedorId! <= items.length
                ? items[selectedProveedorId! - 1]
                : null,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
