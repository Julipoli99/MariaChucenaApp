import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:gestion_indumentaria/models/Corte.dart'; // Asegúrate de que la ruta sea correcta
import 'package:gestion_indumentaria/models/talle.dart'; // Asegúrate de que la ruta sea correcta

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

  @override
  void initState() {
    super.initState();
    _tallesFuture = fetchTalles(); // Llamada a la API
  }

  // Función para obtener los talles desde la API
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
                          const Text('Curvas:'),
                          // Aquí iteramos sobre las curvas para mostrar cada talle
                          FutureBuilder<List<Talle>>(
                            future: _tallesFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (snapshot.hasData) {
                                // Iterar sobre las curvas y mostrar los talles correspondientes
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:
                                      modeloCorte.curvas.map<Widget>((curva) {
                                    // Filtrar los talles correspondientes
                                    final tallesCurva = snapshot.data!
                                        .where((t) => curva.talleId == t.id)
                                        .toList();
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ...tallesCurva.map((talle) {
                                          return Text(
                                              '${talle.nombre} - Repetición: ${curva.repeticion}');
                                        }).toList()
                                      ],
                                    );
                                  }).toList(),
                                );
                              } else {
                                return const Text('No se encontraron talles.');
                              }
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
            Text(
              'Rollos (${widget.corte.rollos.length}):',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: widget.corte.rollos.length,
                itemBuilder: (context, index) {
                  final rolloCorte = widget.corte.rollos[index];
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
          onPressed: widget.onCancel,
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}
