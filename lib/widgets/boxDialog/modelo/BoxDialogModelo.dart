import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/AviosModelo.dart';
import 'package:gestion_indumentaria/models/Modelo.dart';
import 'package:gestion_indumentaria/models/observacion.dart';
import 'package:gestion_indumentaria/widgets/boxDialog/modelo/BoxDialogEditarObservacion.dart';
import 'package:gestion_indumentaria/widgets/boxDialog/modelo/boxDialogoEditarAvio.dart';
import 'package:http/http.dart' as http;

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

  // Función para eliminar un avío
  Future<void> deleteAvio(AvioModelo avioModelo) async {
    final url = Uri.parse(
      'https://maria-chucena-api-production.up.railway.app/modelo/avio-modelo/${widget.modelo.id}/${avioModelo.id}',
    );

    final response = await http.delete(url);

    if (response.statusCode == 200) {
      // Eliminar el avío localmente
      setState(() {
        modelo.avios?.removeWhere((a) => a.id == avioModelo.id);
      });
      // Actualizar los modelos
      widget.fetchModels();
    } else {
      print('Failed to delete AvioModelo');
    }
  }

  /*// Función para agregar un nuevo avío
  Future<void> addAvio() async {
    final result = await showDialog<AvioModelo>(
      context: context,
      builder: (context) {
        return EditAvioDialog(
          modeloId: modelo.id,
          avioModelo: AvioModelo(), // Avío vacío para agregar
          onSave: (newAvioModelo) {
            // Agregar el nuevo avío
            setState(() {
              modelo.avios?.add(newAvioModelo);
            });
            // Actualizar los modelos
            widget.fetchModels();
          },
        );
      },
    );

    if (result != null) {
      // El nuevo avío se guardó correctamente
      setState(() {
        modelo.avios?.add(result); // Agregar el nuevo avío al modelo
      });
    }
  }*/

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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
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
                                            (a) =>
                                                a.id == updatedAvioModelo.id);
                                        if (index != null && index >= 0) {
                                          modelo.avios?[index] =
                                              updatedAvioModelo;
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
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              // Confirmar eliminación del avío
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Eliminar Avío'),
                                    content: const Text(
                                        '¿Estás seguro de que deseas eliminar este avío?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          await deleteAvio(avioModelo!);
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Eliminar'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            // Botón para agregar un nuevo avío
            /*ElevatedButton(
              onPressed: addAvio,
              child: const Text('Agregar Nuevo Avío'),
            ),*/
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
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        title: Text(modelo.curva[index].nombre),
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
          onPressed: widget.onCancel,
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            // Llamar a alguna función de guardado si es necesario
          },
          child: const Text('Guardar Cambios'),
        ),
      ],
    );
  }
}
