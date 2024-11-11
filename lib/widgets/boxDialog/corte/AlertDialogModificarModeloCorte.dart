import 'dart:convert';
import 'package:gestion_indumentaria/models/ModeloCorte.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AlertDialogModificarModeloCorte extends StatefulWidget {
  final ModeloCorte modelo; // Recibes el modelo que quieres modificar
  final VoidCallback onUpdated; // Callback para actualizar la vista

  const AlertDialogModificarModeloCorte({
    super.key,
    required this.modelo,
    required this.onUpdated,
  });

  @override
  _AlertDialogModificarModeloCorteState createState() =>
      _AlertDialogModificarModeloCorteState();
}

class _AlertDialogModificarModeloCorteState
    extends State<AlertDialogModificarModeloCorte> {
  late TextEditingController _totalPrendasController;

  @override
  void initState() {
    super.initState();
    // Inicializa el controller con el totalPrendas del modelo
    _totalPrendasController = TextEditingController(
      text: widget.modelo.totalPrendas.toString(),
    );
  }

  Future<void> _updateTotalPrendas() async {
    final response = await http.patch(
      Uri.parse(
          'https://maria-chucena-api-production.up.railway.app/modelo-corte/${widget.modelo.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, int>{
        'totalPrendas': int.parse(_totalPrendasController.text)
      }),
    );

    if (response.statusCode == 200) {
      // Si la actualización es exitosa, actualizamos el modelo en la UI
      setState(() {
        widget.modelo.totalPrendas = int.parse(
            _totalPrendasController.text); // Actualizamos el modelo local
      });
      widget.onUpdated(); // Llamamos al callback para actualizar la vista
      Navigator.of(context).pop(); // Cierra el diálogo
    } else {
      // Si hubo un error en la actualización
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Error al actualizar el total de prendas')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Modificar Total de Prendas'),
      content: TextField(
        controller: _totalPrendasController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: 'Nuevo Total de Prendas'),
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
            int? newTotal = int.tryParse(_totalPrendasController.text);
            if (newTotal != null) {
              _updateTotalPrendas(); // Actualiza el modelo
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ingrese un número válido')),
              );
            }
          },
        ),
      ],
    );
  }
}
