import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/Avio.dart';
import 'package:gestion_indumentaria/models/AviosModelo.dart';
import 'package:gestion_indumentaria/models/Talle.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditAvioDialog extends StatefulWidget {
  final AvioModelo avioModelo; // El avío que se va a editar
  final int modeloId; // ID del modelo al que pertenece el avío
  final Function(AvioModelo) onSave; // Callback para guardar los cambios

  EditAvioDialog(
      {required this.avioModelo, required this.modeloId, required this.onSave});

  @override
  _EditAvioDialogState createState() => _EditAvioDialogState();
}

class _EditAvioDialogState extends State<EditAvioDialog> {
  late String? selectedTipoAvio;
  bool esPorTalle = false;
  bool esPorColor = false;
  TextEditingController _cantidadController = TextEditingController();
  List<Talle>? selectedTalles = [];
  List<Avio> avios = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedTipoAvio = widget.avioModelo.avio?.nombre;
    _cantidadController.text = widget.avioModelo.cantidadRequerida.toString();
    esPorTalle = widget.avioModelo.esPorTalle;
    esPorColor = widget.avioModelo.esPorColor;
    selectedTalles = List.from(widget.avioModelo.talles ?? []);
    fetchAvios();
  }

  Future<void> fetchAvios() async {
    final response = await http.get(
        Uri.parse('https://maria-chucena-api-production.up.railway.app/avio'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        avios = data.map((item) => Avio.fromJson(item)).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print('Failed to load avios');
    }
  }

  Future<void> updateAvioModelo() async {
    final url = Uri.parse(
      'https://maria-chucena-api-production.up.railway.app/modelo/avio-modelo/${widget.modeloId}/${widget.avioModelo.id}',
    );

    final updatedAvioModelo = {
      "cantidadRequerida": int.parse(_cantidadController.text),
      "esPorTalle": esPorTalle,
      "esPorColor": esPorColor,
      "talles": selectedTalles?.map((talle) => talle.toJson()).toList(),
      "avioId": avios.firstWhere((av) => av.nombre == selectedTipoAvio).id,
    };

    final response = await http.patch(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(updatedAvioModelo),
    );

    if (response.statusCode == 200) {
      print('AvioModelo updated successfully');
    } else {
      print('Failed to update AvioModelo');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Avío'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            isLoading
                ? const CircularProgressIndicator()
                : DropdownButton<String>(
                    hint: const Text('Seleccione el avio'),
                    value: selectedTipoAvio,
                    items: avios.map((av) {
                      return DropdownMenuItem<String>(
                        value: av.nombre,
                        child: Text(av.nombre),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedTipoAvio = value;
                      });
                    },
                  ),
            const SizedBox(height: 10),
            CheckboxListTile(
              title: const Text('Es por Talle'),
              value: esPorTalle,
              onChanged: (bool? value) {
                setState(() {
                  esPorTalle = value ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Es por Color'),
              value: esPorColor,
              onChanged: (bool? value) {
                setState(() {
                  esPorColor = value ?? false;
                });
              },
            ),
            TextField(
              controller: _cantidadController,
              decoration: const InputDecoration(
                labelText: 'Cantidad Requerida',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            await updateAvioModelo();
            widget.onSave(widget.avioModelo);
            Navigator.of(context).pop();
          },
          child: const Text('Guardar Cambios'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
