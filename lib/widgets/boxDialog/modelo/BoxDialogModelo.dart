import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/Modelo.dart';
import 'package:gestion_indumentaria/models/observacion.dart';
import 'package:gestion_indumentaria/widgets/boxDialog/modelo/BoxDialogEditarObservacion.dart';
import 'package:gestion_indumentaria/widgets/boxDialog/modelo/boxDialogoEditarAvio.dart';

class BoxDialogModelo extends StatefulWidget {
  const BoxDialogModelo({
    super.key,
    required this.modelo,
    required this.onCancel,
    required this.fetchModels,
  });

  final Modelo modelo;
  final VoidCallback onCancel;
  final Function fetchModels;

  @override
  _BoxDialogModeloState createState() => _BoxDialogModeloState();
}

class _BoxDialogModeloState extends State<BoxDialogModelo> {
  late Modelo modelo;

  @override
  void initState() {
    super.initState();
    modelo = widget.modelo; // Inicializamos el modelo en el estado
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[200],
      title: Text('Detalles del Modelo: ${modelo.nombre}'),
      content: SizedBox(
        height: 600,
        width: 600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Observaciones
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
                        onPressed: () async {
                          if (observacion != null) {
                            final result = await showDialog<ObservacionModel>(
                              context: context,
                              builder: (context) {
                                return ModificadorObservacionDialog(
                                  observacion: observacion,
                                  idModelo: modelo.id,
                                );
                              },
                            );

                            if (result != null) {
                              // Actualizamos el modelo con la observación modificada
                              setState(() {
                                final index = modelo.observaciones
                                    ?.indexWhere((o) => o.id == result.id);
                                if (index != null && index >= 0) {
                                  modelo.observaciones?[index] =
                                      result; // Actualizamos la observación
                                }
                              });

                              // Actualizamos en la API si es necesario
                              widget.fetchModels();
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Observación no encontrada')),
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            // Información de telas
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
            // Avios
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
                                const Text('Talles: ',
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
                          showDialog(
                            context: context,
                            builder: (context) {
                              return EditAvioDialog(
                                modeloId: modelo.id,
                                avioModelo: avioModelo!,
                                onSave: (updatedAvioModelo) {
                                  setState(() {
                                    // Aseguramos que estamos modificando el modelo original y no una copia
                                    final index = modelo.avios?.indexWhere(
                                        (a) => a.id == updatedAvioModelo.id);
                                    if (index != null && index >= 0) {
                                      modelo.avios?[index] = updatedAvioModelo;
                                    } else {
                                      // Si no lo encontramos, agregamos el nuevo avío al modelo
                                      modelo.avios?.add(updatedAvioModelo);
                                    }
                                  });

                                  // Actualizamos en la API si es necesario
                                  widget.fetchModels();
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),
            // Curvas
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
          onPressed: widget.onCancel,
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}
