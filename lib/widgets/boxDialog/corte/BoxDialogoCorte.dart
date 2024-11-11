import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/ModeloCorte.dart';
import 'package:gestion_indumentaria/models/tizada.dart';
import 'package:gestion_indumentaria/widgets/boxDialog/corte/AlertDialogModificarModeloCorte.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:gestion_indumentaria/models/Corte.dart';
import 'package:gestion_indumentaria/models/talle.dart';
import 'package:gestion_indumentaria/models/talleRepetecion.dart';

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
  late Future<List<Tizada>> _tizadasFuture;

  @override
  void initState() {
    super.initState();
    _tallesFuture = fetchTalles(); // Llamada a la API para talles
    _tizadasFuture = fetchTizadas(
        widget.corte.id); // Llamada a la API para tizadas de este corte
  }

  Future<List<Talle>> fetchTalles() async {
    final response = await http.get(
        Uri.parse('https://maria-chucena-api-production.up.railway.app/talle'));

    if (response.statusCode == 200) {
      List<dynamic> json = jsonDecode(response.body);
      return json.map((e) => Talle.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar los talles');
    }
  }

  Future<List<Tizada>> fetchTizadas(int corteId) async {
    final response = await http.get(Uri.parse(
        'https://maria-chucena-api-production.up.railway.app/tizada/$corteId'));

    if (response.statusCode == 200) {
      List<dynamic> json = jsonDecode(response.body);
      return json.isNotEmpty
          ? json.map((e) => Tizada.fromJson(e)).toList()
          : [];
    } else {
      throw Exception('Error al cargar las tizadas');
    }
  }

  void _showEditTotalPrendasDialog(BuildContext context, ModeloCorte modelo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialogModificarModeloCorte(
          modelo: modelo,
          onUpdated: () {
            (context as Element)
                .markNeedsBuild(); // Forzamos una actualización en el widget
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
                      title: Text(modeloCorte.modelo.nombre),
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
                              'Cantidad Utilizada: ${rolloCorte.cantidadUtilizada}')
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // Aquí podrías implementar la función de modificación.
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
            FutureBuilder<List<Tizada>>(
              future:
                  _tizadasFuture, // Mostramos las tizadas asociadas al corte
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No hay tizadas disponibles.');
                } else {
                  final tizadas = snapshot.data!;
                  return Flexible(
                    child: ListView.builder(
                      itemCount: tizadas.length,
                      itemBuilder: (context, index) {
                        final tizada = tizadas[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text('Tizada ID: ${tizada.id}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Ancho: ${tizada.ancho} cm'),
                                Text('Largo: ${tizada.largo} cm'),
                                const Text('Rollos:'),
                                ...tizada.rollosUtilizados.map((rollo) {
                                  return Text(' - ${rollo.capas} ');
                                }).toList(),
                                const Text('Modelos:'),
                                ...tizada.modelos.map((modelo) {
                                  return Text(
                                      ' - ${modelo.consumo} (curva : ${modelo.curva})');
                                }).toList(),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
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
