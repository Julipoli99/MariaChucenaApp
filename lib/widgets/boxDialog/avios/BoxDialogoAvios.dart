/*
import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/Avios.dart';
import 'package:gestion_indumentaria/models/Modelo.dart';
import 'package:gestion_indumentaria/models/Proveedor.dart';

class BoxDialogAvios extends StatelessWidget {
  const BoxDialogAvios({super.key, required this.avio, required this.onCancel});

  final Avios avio;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[200],
      title: Text('Detalles del avio: ${avio.nombre}'),
      content: SizedBox(
        height: 400, // Altura total del contenido del diálogo
        width: 500, // Ajusta el ancho si es necesario
        child: Column(
          children: [
            // Observaciones
            const Text('Talle:', style: TextStyle(fontWeight: FontWeight.bold)),
            Flexible(
              child: Scrollbar(
                thumbVisibility: true, // Hace visible la scrollbar
                child: ListView.builder(
                  itemCount: avio.talles,
                  itemBuilder: (context, index) {
                    final talle = avio.talles[index];
                    return ListTile(
                      title: Text('curva de talle: ${avio.talles}'),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10), // Espaciado entre secciones

            // Avios
            Text(
              'cantidad (${avio.cantidad.length}):', // Muestra la cantidad de avios
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Flexible(
              child: Scrollbar(
                thumbVisibility: true, // Hace visible la scrollbar
                child: ListView.builder(
                  itemCount: avio.cantidad.length,
                  itemBuilder: (context, index) {
                    final cantidades = avio.cantidad[index];
                    return ListTile(
                      title: Text('cantidad: ${avio.cantidad}'),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10), // Espaciado entre secciones

            // Curva
            Text(
              'color (${avio.color}):', // Muestra la cantidad de ítems en la curva
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Flexible(
              child: Scrollbar(
                thumbVisibility: true, // Hace visible la scrollbar
                child: ListView.builder(
                  itemCount: avio.color,
                  itemBuilder: (context, index) {
                    final Color = avio.color[index];
                    return ListTile(
                      title: Text('color: ${Color['color']}'),
                    );
                  },
                ),
              ),
            ),
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
}*/
