import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/ModeloCorte.dart';
import 'package:gestion_indumentaria/models/rolloCorte.dart';
import 'package:gestion_indumentaria/models/tizada.dart';
import 'package:gestion_indumentaria/widgets/boxDialog/corte/AlertDialogModificarModeloCorte.dart';
import 'package:gestion_indumentaria/widgets/boxDialog/corte/alertDialogoRolloEdit.dart';
import 'package:gestion_indumentaria/widgets/boxDialog/corte/tizadaDialogoEdit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:gestion_indumentaria/models/Corte.dart';
import 'package:gestion_indumentaria/models/talle.dart';

class BoxDialogCorte extends StatefulWidget {
  const BoxDialogCorte({
    super.key,
    required this.corte,
    required this.onCancel,
  });

  final Corte corte;
  final VoidCallback onCancel;

  @override
  _BoxDialogCorteState createState() => _BoxDialogCorteState();
}

class _BoxDialogCorteState extends State<BoxDialogCorte> {
  late Future<List<Talle>> _tallesFuture;
  List<dynamic> _tizadas =
      []; // Aquí guardamos las tizadas que recibimos de la API

  @override
  void initState() {
    super.initState();
    _tallesFuture = fetchTalles(); // Llamada a la API para talles
    fetchTizadas(widget.corte.id); // Llamada a la API para tizadas
  }

  Future<List<Talle>> fetchTalles() async {
    try {
      final response = await http.get(Uri.parse(
          'https://maria-chucena-api-production.up.railway.app/talle'));

      if (response.statusCode == 200) {
        List<dynamic> json = jsonDecode(response.body);
        print('Talles cargados: $json'); // Print de los datos recibidos
        return json.map((e) => Talle.fromJson(e)).toList();
      } else {
        throw Exception('Error al cargar los talles: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al cargar los talles: $e');
      rethrow; // Vuelve a lanzar el error para manejarlo en el lugar de la llamada
    }
  }

  void fetchTizadas(int corteId) async {
    try {
      final response = await http.get(Uri.parse(
          'https://maria-chucena-api-production.up.railway.app/tizada/$corteId'));

      if (response.statusCode == 200) {
        List<dynamic> json = jsonDecode(response.body);
        print('Tizadas cargadas: $json'); // Imprime las tizadas recibidas

        // Mapeamos solo a los valores de ancho y largo que necesitamos
        setState(() {
          _tizadas = json.map((e) {
            return Tizada(
              id: e['id'],
              ancho: e['ancho']?.toDouble() ?? 0.0,
              largo: e['largo']?.toDouble() ?? 0.0,
              corteId: corteId,
              modelos: [],
              rollosUtilizados: [],
            );
          }).toList();
        });
      } else {
        throw Exception('Error al cargar las tizadas');
      }
    } catch (e) {
      print('Error al obtener las tizadas: $e');
    }
  }

  void _showEditTotalPrendasDialog(BuildContext context, ModeloCorte modelo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialogModificarModeloCorte(
          modelo: modelo,
          onUpdated: () {
            setState(() {
              // Recargamos las tizadas o talles si es necesario
              fetchTizadas(
                  widget.corte.id); // Recargamos las tizadas al actualizar
            });
            (context as Element)
                .markNeedsBuild(); // Forzamos la reconstrucción del widget
          },
        );
      },
    );
  }

  void _showEditTotalcortesDialog(BuildContext context, RolloCorte rollo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialogRolloCorte(
          rolloCorte: rollo,
          onUpdated: () {
            setState(() {
              // Recargamos los datos de los rollos si es necesario
              fetchTizadas(
                  widget.corte.id); // Recargamos las tizadas al actualizar
            });
            (context as Element)
                .markNeedsBuild(); // Forzamos la reconstrucción del widget
          },
        );
      },
    );
  }

  void _showEditTotalTizadaDialog(BuildContext context, Tizada tizada) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialogTizadaCorte(
          tizada: tizada,
          onUpdated: () {
            setState(() {
              // Recargamos los datos de los rollos si es necesario
              fetchTizadas(
                  widget.corte.id); // Recargamos las tizadas al actualizar
            });
            (context as Element)
                .markNeedsBuild(); // Forzamos la reconstrucción del widget
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Detalles del Corte: ${widget.corte.id}'),
      content: SizedBox(
        height: 500,
        width: 600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Modelos (${widget.corte.modelos.length}):',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: widget.corte.modelos.length,
                itemBuilder: (context, index) {
                  final modeloCorte = widget.corte.modelos[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(modeloCorte.modelo!.nombre),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Prendas: ${modeloCorte.totalPrendas}'),
                          const Text('Observaciones:'),
                          ...modeloCorte.observacion!.map((obs) {
                            return Text(' - ${obs.titulo}: ${obs.descripcion}');
                          }),
                          const Text('Curva:'),
                          ...modeloCorte.curvas.map((curva) {
                            return Text(
                                '${curva.talleId} - repetición: ${curva.repeticion}');
                          }),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showEditTotalPrendasDialog(context, modeloCorte);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Rollos (${widget.corte.rollos.length}):',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: widget.corte.rollos.length,
                itemBuilder: (context, index) {
                  final rolloCorte = widget.corte.rollos[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text('${rolloCorte.rollo?.descripcion}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Categoría: ${rolloCorte.categoria.name.toString()}'),
                          Text(
                              'Cantidad Utilizada: ${rolloCorte.cantidadUtilizada}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showEditTotalcortesDialog(context,
                              rolloCorte); // Aquí podrías implementar la función de modificación.
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Tizadas:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            _tizadas.isEmpty
                ? const Text('No hay tizadas disponibles.')
                : Flexible(
                    child: ListView.builder(
                      itemCount: _tizadas.length,
                      itemBuilder: (context, index) {
                        final tizada = _tizadas[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text('Tizada ID: ${tizada.id}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Ancho: ${tizada.ancho != 0.0 ? tizada.ancho : 'N/A'} cm'),
                                Text(
                                    'Largo: ${tizada.largo != 0.0 ? tizada.largo : 'N/A'} cm'),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _showEditTotalTizadaDialog(context, tizada);
                              },
                            ),
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
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}
