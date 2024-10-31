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
    print('Contenido completo del modelo: ${modelo.toJson()}');

    return AlertDialog(
      backgroundColor: Colors.grey[200],
      title: Text('Detalles del Modelo: ${modelo.nombre}'),
      content: SizedBox(
        height: 400,
        width: 500,
        child: Column(
          children: [
            const Text('Observaciones:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Flexible(
              child: Scrollbar(
                thumbVisibility: true,
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
            const SizedBox(height: 10),
            Text(
              'Avios (${modelo.avios?.length ?? 0}):',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Flexible(
              child: Scrollbar(
                thumbVisibility: true,
                child: ListView.builder(
                  itemCount: modelo.avios?.length ?? 0,
                  itemBuilder: (context, index) {
                    final avioModelo = modelo.avios?[index];

                    return ListTile(
                      title: Text(
                          'Avio: ${avioModelo?.avio?.nombre ?? 'Sin nombre'}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Cantidad requerida: ${avioModelo?.cantidadRequerida ?? 0}'),
                          Text(
                              'Por Talle: ${avioModelo?.esPorTalle ?? false ? "Sí" : "No"}'),
                          Text(
                              'Por Color: ${avioModelo?.esPorColor ?? false ? "Sí" : "No"}'),
                          // Mostrar talles si es por talle
                          if (avioModelo?.esPorTalle == true &&
                              avioModelo?.talles != null &&
                              avioModelo!.talles!.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Talles:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                ...avioModelo.talles!.map((talle) {
                                  return Text(
                                      ' - ${talle.nombre}'); // Asegúrate de que `talle` tiene la propiedad `nombre`
                                }).toList(),
                              ],
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Curva (${modelo.curva.length}):',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (modelo.curva.isNotEmpty)
              Flexible(
                child: Scrollbar(
                  thumbVisibility: true,
                  child: ListView.builder(
                    itemCount: modelo.curva.length,
                    itemBuilder: (context, index) {
                      final talle = modelo.curva[index];
                      return ListTile(
                        title: Text('Talle: ${talle.nombre}'),
                      );
                    },
                  ),
                ),
              )
            else
              const Text('No hay talles disponibles'),
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
