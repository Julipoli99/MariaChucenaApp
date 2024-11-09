import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/Avio.dart';

class BoxDialogAvio extends StatelessWidget {
  const BoxDialogAvio({
    super.key,
    required this.avio,
    required this.onCancel,
  });

  final Avio avio;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[200],
      title: Text('Detalles del Avio: ${avio.nombre}'),
      content: SizedBox(
        height: 400,
        width: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Código Proveedor:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(avio.codigoProveedor ?? 'No disponible'),
            const SizedBox(height: 10),
            const Text('Tipo de Producto ID:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(avio.tipoProductoId.toString()),
            const SizedBox(height: 10),
            const Text('Stock:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(avio.stock.toString()),
            const SizedBox(height: 10),
            const Text('Proveedor:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(avio.proveedor?.nombre ?? 'No disponible'),
            const SizedBox(height: 20),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}
