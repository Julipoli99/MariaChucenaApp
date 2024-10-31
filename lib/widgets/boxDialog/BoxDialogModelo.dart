import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/Modelo.dart';

class BoxDialogModelo extends StatelessWidget {
  const BoxDialogModelo({
    super.key,
    required this.modelo,
    required this.onCancel,
  });

  final Modelo modelo;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[200],
      title: Text('Detalles del Modelo: ${modelo.nombre}'),
      content: SizedBox(
        height: 400, // Altura total del contenido del diálogo
        width: 500, // Ajusta el ancho si es necesario
        child: Column(
          children: [
            // Observaciones
            const Text('Observaciones:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Flexible(
              child: Scrollbar(
                thumbVisibility: true, // Hace visible la scrollbar
                child: ListView.builder(
                  itemCount: modelo.observaciones?.length ?? 0,
                  itemBuilder: (context, index) {
                    final observacion = modelo.observaciones?[index];
                    return ListTile(
                      title: Text(
                          'Observación: ${observacion?.titulo ?? 'Sin título'}'),
                      subtitle: Text(
                          'Descripción: ${observacion?.descripcion ?? 'Sin descripción'}'),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10), // Espaciado entre secciones

            // Avios
            Text(
              'Avios (${modelo.avios?.length}):', // Muestra la cantidad de avios
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Flexible(
              child: Scrollbar(
                thumbVisibility: true, // Hace visible la scrollbar
                child: ListView.builder(
                  itemCount: modelo.avios?.length ?? 0, // Cambiado a '?? 0'
                  itemBuilder: (context, index) {
                    final avioModelo = modelo.avios?[index];
                    print(avioModelo?.toJson());
                    return ListTile(
                      title: Text(
                          'Avio: ${avioModelo?.avio?.nombre ?? 'Sin nombre'}'), // Accede a avio.nombre
                      subtitle: Text(
                          'Cantidad requerida: ${avioModelo?.cantidadRequerida ?? 0}'), // Cantidad requerida
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10), // Espaciado entre secciones

            // Curva
            Text(
              'Curva (${modelo.curva.length}):', // Muestra la cantidad de ítems en la curva
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Flexible(
              child: Scrollbar(
                thumbVisibility: true, // Hace visible la scrollbar
                child: ListView.builder(
                  itemCount: modelo.curva.length,
                  itemBuilder: (context, index) {
                    final talle = modelo.curva[index];
                    return ListTile(
                      title: Text(
                          'Talle: ${talle.nombre}'), // Asumiendo que talle es de tipo Talle
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
}
