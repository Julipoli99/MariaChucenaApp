import 'dart:convert';
import 'package:gestion_indumentaria/models/rolloCorte.dart';
import 'package:gestion_indumentaria/models/tizada.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AlertDialogTizadaCorte extends StatefulWidget {
  final Tizada tizada; // Recibes la tizada que quieres modificar
  final VoidCallback onUpdated; // Callback para actualizar la vista

  const AlertDialogTizadaCorte({
    super.key,
    required this.tizada,
    required this.onUpdated,
  });

  @override
  _AlertDialogTizadaCorte createState() => _AlertDialogTizadaCorte();
}

class _AlertDialogTizadaCorte extends State<AlertDialogTizadaCorte> {
  late TextEditingController _totaltizadaAnchoController;
  late TextEditingController _totaltizadaLargoController;

  @override
  void initState() {
    super.initState();
    // Inicializa los controllers con los valores actuales de la tizada
    _totaltizadaAnchoController = TextEditingController(
      text: widget.tizada.ancho.toString(),
    );
    _totaltizadaLargoController = TextEditingController(
      text: widget.tizada.largo.toString(),
    );
  }

  Future<void> _updateTizada() async {
    final response = await http.patch(
      Uri.parse(
          'https://maria-chucena-api-production.up.railway.app/tizada/${widget.tizada.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, double>{
        'ancho': double.parse(_totaltizadaAnchoController.text),
        'largo': double.parse(_totaltizadaLargoController.text),
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        widget.tizada.ancho = double.parse(_totaltizadaAnchoController.text);
        widget.tizada.largo = double.parse(_totaltizadaLargoController.text);
      });
      // Si la actualización es exitosa, llamamos al callback para que la vista se actualice
      widget.onUpdated(); // Esto notificará que la vista debe actualizarse
      Navigator.of(context).pop(true); // Cierra el diálogo
    } else {
      // Si hubo un error en la actualización
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al actualizar la tizada')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Modificar el largo y el ancho de la tizada'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Campo para editar el ancho
          TextField(
            controller: _totaltizadaAnchoController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Nuevo ancho'),
          ),
          const SizedBox(height: 10),
          // Campo para editar el largo
          TextField(
            controller: _totaltizadaLargoController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Nuevo largo'),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Guardar'),
          onPressed: () {
            _updateTizada(); // Actualiza la tizada
          },
        ),
      ],
    );
  }
}
