import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/Proveedor.dart';
import 'package:gestion_indumentaria/models/Tela.dart';
import 'package:gestion_indumentaria/models/TipoProducto.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditarTelasDialog extends StatefulWidget {
  final Tela tela; // ID de la tela a editar

  const EditarTelasDialog(this.tela, {Key? key}) : super(key: key);

  @override
  _EditarTelasDialogState createState() => _EditarTelasDialogState();
}

class _EditarTelasDialogState extends State<EditarTelasDialog> {
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
    // Inicializar los valores con la tela recibida
    _initializeValues();
  }

  void _initializeValues() {
    // Setear los valores iniciales de la tela a editar
    setState(() {
      selectedProveedorId = widget.tela.proveedorId;
      selectedTipoProductoId = widget.tela.tipoProductoId;
      cantidad = widget.tela.cantidad;
      color = widget.tela.color;
      estampado = widget.tela.estampado;
      descripcion = widget.tela.descripcion;
      tipoRollo = widget.tela.tipoDeRollo;
    });
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
      title: const Text('Editar Tela'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTipoTejidoSelector(),
            const SizedBox(height: 15),
            buildProveedorDropdown(),
            buildDropdownTipoProducto(),
            buildTextField(
              'Cantidad',
              'Cantidad de tela registrada, en metros o kilos',
              (value) {
                cantidad = double.tryParse(value) ?? 0.0;
              },
              initialValue: cantidad.toString(),
            ),
            buildTextField(
              'Color',
              'Nombre del color',
              (value) {
                color = value;
              },
              initialValue: color,
            ),
            buildCheckboxField(
              'Estampado',
              (value) {
                setState(() {
                  estampado = value!;
                });
              },
              initialValue: estampado,
            ),
            buildTextField(
              'Descripción',
              'Descripción del estampado',
              (value) {
                descripcion = value;
              },
              initialValue: descripcion,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _editarTela,
          child: const Text('Guardar Cambios'),
        ),
      ],
    );
  }

  Future<void> _editarTela() async {
    final datosTela = {
      "cantidad": cantidad,
      "color": color,
      "estampado": estampado,
      "descripcion": descripcion,
      "tipoRollo": tipoRollo,
      "tipoProductoId": selectedTipoProductoId,
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
        const SnackBar(
          content: Text('Tela editada exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop(true); // Cierra el diálogo al guardar
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al editar la tela: ${response.body}'),
          backgroundColor: Colors.red,
        ),
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
        value: selectedProveedorId, // Set the selected value
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
        value: selectedTipoProductoId, // Set the selected value
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
      String label, String hintText, ValueChanged<String> onChanged,
      {String initialValue = ''}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        onChanged: onChanged,
        initialValue: initialValue, // Use initialValue for pre-setting text
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

  Widget buildCheckboxField(String label, ValueChanged<bool?> onChanged,
      {bool initialValue = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: CheckboxListTile(
        title: Text(label),
        value: initialValue,
        onChanged: onChanged,
      ),
    );
  }
}
