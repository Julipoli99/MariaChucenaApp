import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/Corte.dart'; // Asegúrate de que la ruta sea correcta

class BoxDialogCorte extends StatelessWidget {
  const BoxDialogCorte({
    super.key,
    required this.corte,
    required this.onCancel,
  });

  final Corte corte;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
//      backgroundColor: Colors.grey[200],
      title: Text('Detalles del Corte: ${corte.id}'),
      content: SizedBox(
        height: 500,
        width: 600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Modelos (${corte.modelos.length}):',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: corte.modelos.length,
                itemBuilder: (context, index) {
                  final modeloCorte = corte.modelos[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        modeloCorte.modelo.nombre,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Prendas: ${modeloCorte.totalPrendas}'),
                          const Text('Observaciones:'),
                          ...modeloCorte.observacion!.map((obs) {
                            return Text(' - ${obs.titulo}: ${obs.descripcion}');
                          }),
                          /*     const Text('Curva:'),
                          ...modeloCorte.curvas.map((curva) {
                            return Text(
                                '${curva.talle.nombre.toString()} - repetición: ${curva.repeticion}');
                          }),
                          */
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Rollos (${corte.rollos.length}):',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: corte.rollos.length,
                itemBuilder: (context, index) {
                  final rolloCorte = corte.rollos[index];
                  return ListTile(
                    title: Text('${rolloCorte.rollo?.descripcion}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Categoría: ${rolloCorte.categoria.name.toString()}'),
                        Text(
                            'Cantidad Utilizada: ${rolloCorte.cantidadUtilizada}')
                      ],
                    ),
                  );
                },
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
