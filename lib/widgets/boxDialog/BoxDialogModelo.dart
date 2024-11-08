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
        height: 600,
        width: 600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Observaciones - con Card para destacar cada una
            Text(
              'Observaciones:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: modelo.observaciones?.length ?? 0,
                itemBuilder: (context, index) {
                  final observacion = modelo.observaciones?[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(
                          'Observación: ${observacion?.titulo ?? 'Sin título'}'),
                      subtitle: Text(
                          'Descripción: ${observacion?.descripcion ?? 'Sin descripción'}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // Implementar funcionalidad para editar la observación
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            // Información de telas - sin Card
            Text(
              'Telas:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '¿Tiene tela primaria? ${modelo.tieneTelaAuxiliar ? 'Sí' : 'No'}'),
                  Text(
                      '¿Tiene tela secundaria? ${modelo.tieneTelaSecundaria ? 'Sí' : 'No'}'),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Avios - con Card para cada uno
            Text(
              'Avios (${modelo.avios?.length ?? 0}):',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: modelo.avios?.length ?? 0,
                itemBuilder: (context, index) {
                  final avioModelo = modelo.avios?[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
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
                                  return Text(' - ${talle.nombre}');
                                }).toList(),
                              ],
                            ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // Implementar funcionalidad para editar el avio
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            // Curvas - sin Card
            Text(
              'Curva (${modelo.curva.length}):',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (modelo.curva.isNotEmpty)
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: modelo.curva.length,
                  itemBuilder: (context, index) {
                    final talle = modelo.curva[index];
                    return ListTile(
                      title: Text('Talle: ${talle.nombre}'),
                    );
                  },
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
