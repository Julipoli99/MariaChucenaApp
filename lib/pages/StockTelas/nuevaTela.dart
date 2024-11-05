import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/Proveedor.dart';
import 'package:gestion_indumentaria/models/TipoProducto.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NuevasTelasDialog extends StatefulWidget {
  const NuevasTelasDialog({super.key});

  @override
  _NuevasTelasDialogState createState() => _NuevasTelasDialogState();
}

class _NuevasTelasDialogState extends State<NuevasTelasDialog> {
  List<String> selectedTejidos = [];
  TipoEnum? selectedTipo;
  List<Proveedor> proveedores = [];
  List<TipoProducto> tipoProductos = [];
  int? selectedProveedorId;
  int? selectedTipoProductoId;

  double cantidad = 0.0;
  String color = '';
  bool estampado = false;
  String descripcion = '';
  String tipoRollo = '';

  @override
  void initState() {
    super.initState();
    _cargarProveedores();
    _cargarTipoProductos();
  }

  Future<void> _cargarProveedores() async {
    final url = 'https://maria-chucena-api-production.up.railway.app/proveedor';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        proveedores = data.map((item) => Proveedor.fromJson(item)).toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error al cargar proveedores: ${response.body}')),
      );
    }
  }

  Future<void> _cargarTipoProductos() async {
    final url =
        'https://maria-chucena-api-production.up.railway.app/tipo-Producto';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        tipoProductos = data
            .map((item) => TipoProducto.fromJson(item))
            .where((tipo) => tipo.tipo == TipoEnum.TELA)
            .toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Error al cargar tipos de productos: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Registro de Telas'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTipoTejidoSelector(),
            const SizedBox(height: 15),
            buildProveedorDropdown(),
            buildDropdownTipoProducto(),
            buildTextField(
                'Cantidad', 'Cantidad de tela registrada, en metros o kilos',
                (value) {
              cantidad = double.tryParse(value) ?? 0.0;
            }),
            buildTextField('Color', 'Nombre del color', (value) {
              color = value;
            }),
            buildCheckboxField('Estampado', (value) {
              setState(() {
                estampado = value!;
              });
            }),
            buildTextField('Descripción', 'Descripción del estampado', (value) {
              descripcion = value;
            }),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _guardarTela,
          child: const Text('Guardar Tela'),
        ),
      ],
    );
  }

  Future<void> _guardarTela() async {
    final datosTela = {
      "cantidad": cantidad,
      "color": color,
      "estampado": estampado,
      "descripcion": descripcion,
      "tipoRollo": tipoRollo,
      "tipoProductoId": selectedTipoProductoId,
      "proveedorId": selectedProveedorId,
    };

    final url = 'https://maria-chucena-api-production.up.railway.app/Rollo';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(datosTela),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tela registrada exitosamente')),
      );
      Navigator.of(context).pop(true); // Cierra el diálogo al guardar
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar la tela: ${response.body}')),
      );
    }
  }

  Widget buildProveedorDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: DropdownButtonFormField<int>(
        decoration: InputDecoration(
          labelText: 'Proveedor',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        items: proveedores.map((proveedor) {
          return DropdownMenuItem<int>(
            value: proveedor.id,
            child: Text(proveedor.nombre),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedProveedorId = value;
          });
        },
      ),
    );
  }

  Widget buildDropdownTipoProducto() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: DropdownButtonFormField<int>(
        decoration: InputDecoration(
          labelText: 'Tipo de Producto (Tela)',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        items: tipoProductos.map((tipoProducto) {
          return DropdownMenuItem<int>(
            value: tipoProducto.id,
            child: Text(tipoProducto.nombre),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedTipoProductoId = value;
          });
        },
      ),
    );
  }

  Widget buildTipoTejidoSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tipo de Rollo',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: ['PLANO', 'TUBULAR'].map((tipoTejido) {
            return ChoiceChip(
              label: Text(tipoTejido),
              selected: tipoRollo == tipoTejido,
              onSelected: (isSelected) {
                setState(() {
                  tipoRollo = isSelected ? tipoTejido : '';
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget buildTextField(
      String label, String hintText, ValueChanged<String> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget buildCheckboxField(String label, ValueChanged<bool?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Checkbox(
            value: estampado,
            onChanged: onChanged,
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
