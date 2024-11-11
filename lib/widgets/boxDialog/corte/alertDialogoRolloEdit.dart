import 'dart:convert';
import 'package:gestion_indumentaria/models/rolloCorte.dart';
import 'package:gestion_indumentaria/models/rolloCorte.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AlertDialogRolloCorte extends StatefulWidget {
  final RolloCorte rolloCorte; // Recibes el rollo que quieres modificar
  final VoidCallback onUpdated; // Callback para actualizar la vista

  const AlertDialogRolloCorte({
    super.key,
    required this.rolloCorte,
    required this.onUpdated,
  });

  @override
  _AlertDialogRolloCorte createState() => _AlertDialogRolloCorte();
}

class _AlertDialogRolloCorte extends State<AlertDialogRolloCorte> {
  late TextEditingController _totalcorteController;

  @override
  void initState() {
    super.initState();
    // Inicializa el controller con el totalPrendas del rollo
    _totalcorteController = TextEditingController(
      text: widget.rolloCorte.cantidadUtilizada.toString(),
    );
  }

  Future<void> _updateTotalcortes() async {
    final response = await http.patch(
      Uri.parse(
          'https://maria-chucena-api-production.up.railway.app/rollo-corte/${widget.rolloCorte.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, double>{
        'cantidadUtilizada': double.parse(_totalcorteController.text)
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        widget.rolloCorte.cantidadUtilizada = double.parse(
            _totalcorteController.text); // Actualizamos el modelo local
      });
      // Si la actualización es exitosa, llamamos al callback para que la vista se actualice
      widget.onUpdated(); // Esto notificará que la vista debe actualizarse
      Navigator.of(context).pop(true); // Cierra el diálogo
    } else {
      // Si hubo un error en la actualización
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al actualizar el total de cortes')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Modificar Total de cortes'),
      content: TextField(
        controller: _totalcorteController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: 'Nuevo Total de cortes'),
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
            int? newTotal = int.tryParse(_totalcorteController.text);
            if (newTotal != null) {
              _updateTotalcortes(); // Actualiza el rollo
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
