import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/Avio.dart';
import 'package:gestion_indumentaria/models/AviosModelo.dart';
import 'package:gestion_indumentaria/models/Talle.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditAvioDialog extends StatefulWidget {
  final AvioModelo avioModelo; // Avío a modificar
  final int modeloId; // ID del modelo al que pertenece el avío
  final Function(AvioModelo) onSave; // Callback para actualizar el CRUD

  const EditAvioDialog({
    Key? key,
    required this.avioModelo,
    required this.modeloId,
    required this.onSave,
  }) : super(key: key);

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
  bool _isSaving = false;
  int? avioId; // Variable para almacenar el ID del avío seleccionado

  @override
  void initState() {
    super.initState();
    selectedTipoAvio = widget.avioModelo.avio?.nombre;
    _cantidadController.text = widget.avioModelo.cantidadRequerida.toString();
    esPorTalle = widget.avioModelo.esPorTalle;
    esPorColor = widget.avioModelo.esPorColor;
    selectedTalles = List.from(widget.avioModelo.talles ?? []);
    avioId = widget.avioModelo.avio?.id; // Inicializamos el avioId
    fetchAvios();
  }

  Future<void> fetchAvios() async {
    final response = await http.get(
      Uri.parse('https://maria-chucena-api-production.up.railway.app/avio'),
    );

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
      print('Error al cargar avíos');
    }
  }

  Future<void> _updateAvioModelo() async {
    if (avioId == null) {
      _showError('Por favor, seleccione un avío válido.');
      return;
    }

    final url = Uri.parse(
      'https://maria-chucena-api-production.up.railway.app/modelo/avio-modelo/${widget.modeloId}/${widget.avioModelo.id}',
    );

    final updatedAvioModelo = {
      "cantidadRequerida": int.parse(_cantidadController.text),
      "esPorTalle": esPorTalle,
      "esPorColor": esPorColor,
      "talles": selectedTalles?.map((talle) => talle.toJson()).toList(),
      "avioId": avioId, // Enviamos el ID del avío seleccionado
    };

    try {
      setState(() => _isSaving = true);
      final response = await http.patch(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(updatedAvioModelo),
      );

      if (response.statusCode == 200) {
        print('AvioModelo actualizado correctamente');
        widget.onSave(AvioModelo(
          id: widget.avioModelo.id,
          cantidadRequerida: int.parse(_cantidadController.text),
          esPorTalle: esPorTalle,
          esPorColor: esPorColor,
          avioId: avioId!, // Actualizamos el avío con el ID correcto
        ));
      } else {
        _showError('Error al actualizar el AvioModelo. ${response.body}');
      }
    } catch (e) {
      _showError('Ocurrió un error: $e');
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10),
      ),
    );
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
                    hint: const Text('Seleccione el avío'),
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

                        // Verifica si el nombre del avío no es nulo ni vacío
                        if (selectedTipoAvio != null &&
                            selectedTipoAvio!.isNotEmpty) {
                          // Asigna el ID correctamente fuera de setState
                          avioId = avios
                              .firstWhere((av) => av.nombre == selectedTipoAvio)
                              .id;
                        } else {
                          avioId = null; // Asegura que el ID no sea nulo
                        }
                        // Actualiza el modelo
                        _updateAvioModelo(); // Actualización del modelo con el ID seleccionado
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
                  _updateAvioModelo(); // Actualización instantánea
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Es por Color'),
              value: esPorColor,
              onChanged: (bool? value) {
                setState(() {
                  esPorColor = value ?? false;
                  _updateAvioModelo(); // Actualización instantánea
                });
              },
            ),
            TextField(
              controller: _cantidadController,
              decoration: const InputDecoration(
                labelText: 'Cantidad Requerida',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) =>
                  _updateAvioModelo(), // Actualización al cambiar cantidad
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cerrar'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _cantidadController.dispose();
    super.dispose();
  }
}
