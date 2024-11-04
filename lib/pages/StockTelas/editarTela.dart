import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/Tela.dart';
import 'package:gestion_indumentaria/widgets/DrawerMenuLateral.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditarTela extends StatefulWidget {
  final Tela tela; // Cambiar 'telaId' a 'tela' para reflejar el uso correcto

  const EditarTela({super.key, required this.tela});

  @override
  _EditarTelaState createState() => _EditarTelaState();
}

class _EditarTelaState extends State<EditarTela> {
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
        'https://maria-chucena-api-production.up.railway.app/Rollo/${widget.tela.id}'; // Usar widget.tela.id
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
            content:
                Text('Error al cargar datos de la tela: ${response.body}')),
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
          'https://maria-chucena-api-production.up.railway.app/Rollo/${widget.tela.id}'; // Usar widget.tela.id
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(datosTela),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tela actualizada exitosamente')),
        );
        Navigator.pop(context); // Regresa a la pantalla anterior
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Tela'),
      ),
      drawer: const DrawerMenuLateral(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
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
              buildDropdownField('Proveedor', proveedores, (value) {
                setState(() {
                  selectedProveedorId = proveedores.indexOf(value!) +
                      1; // +1 si el id empieza en 1
                });
              }),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _actualizarTela,
                child: const Text('Actualizar Tela'),
              ),
            ],
          ),
        ),
      ),
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
                ? items[selectedProveedorId! - 1] // Ajusta aquí si necesario
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
