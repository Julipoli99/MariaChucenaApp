import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gestion_indumentaria/models/talle.dart';
import 'package:gestion_indumentaria/models/talleRepetecion.dart';

class TalleRepeticionSelector extends StatefulWidget {
  final List<TalleRepeticion> selectedTalleRepeticion;
  final ValueChanged<List<TalleRepeticion>> onTalleRepeticionSelected;

  const TalleRepeticionSelector({
    super.key,
    required this.selectedTalleRepeticion,
    required this.onTalleRepeticionSelected,
  });

  @override
  _TalleRepeticionSelectorState createState() =>
      _TalleRepeticionSelectorState();
}

class _TalleRepeticionSelectorState extends State<TalleRepeticionSelector> {
  List<Talle> _talles = [];
  bool _isLoading = true;
  final Map<int, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _fetchTallesFromApi();
  }

  Future<void> _fetchTallesFromApi() async {
    const String apiUrl =
        'https://maria-chucena-api-production.up.railway.app/talle';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _talles = data.map((json) => Talle.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        _showError('Error al obtener los talles: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Error de conexión: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _toggleTalleSelection(Talle talle) {
    setState(() {
      final existingTalleRepeticion = widget.selectedTalleRepeticion.firstWhere(
          (tr) => tr.talleId == talle.id,
          orElse: () =>
              TalleRepeticion(talleId: talle.id, repeticion: 1, id: 0));

      if (widget.selectedTalleRepeticion.contains(existingTalleRepeticion)) {
        widget.selectedTalleRepeticion.remove(existingTalleRepeticion);
        _controllers.remove(talle.id);
      } else {
        widget.selectedTalleRepeticion.add(existingTalleRepeticion);
        _controllers[talle.id] = TextEditingController(
          text: existingTalleRepeticion.repeticion.toString(),
        );
      }
      widget
          .onTalleRepeticionSelected(List.from(widget.selectedTalleRepeticion));
    });
  }

  void _updateRepeticion(Talle talle, int newRepeticion) {
    setState(() {
      final talleRepeticion = widget.selectedTalleRepeticion.firstWhere(
        (tr) => tr.talleId == talle.id,
      );
      talleRepeticion.repeticion = newRepeticion;
      widget
          .onTalleRepeticionSelected(List.from(widget.selectedTalleRepeticion));
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selecciona Talles y Especifica Cantidad',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ..._talles.map((talle) {
              final isSelected = widget.selectedTalleRepeticion
                  .any((tr) => tr.talleId == talle.id);

              if (!_controllers.containsKey(talle.id)) {
                _controllers[talle.id] = TextEditingController(
                    text: widget.selectedTalleRepeticion
                        .firstWhere(
                          (tr) => tr.talleId == talle.id,
                          orElse: () => TalleRepeticion(
                              talleId: talle.id, repeticion: 1, id: 0),
                        )
                        .repeticion
                        .toString());
              }

              return ChoiceChip(
                label: Row(
                  children: [
                    Text(talle.nombre),
                    if (isSelected) ...[
                      const SizedBox(width: 5),
                      SizedBox(
                        width: 50,
                        child: TextFormField(
                          controller: _controllers[talle.id],
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            final newRepeticion = int.tryParse(value) ?? 1;
                            if (newRepeticion > 0) {
                              _updateRepeticion(talle, newRepeticion);
                            } else {
                              _showError('La cantidad debe ser mayor a 0');
                            }
                          },
                          autofocus: true, // Agregar autofocus
                          decoration: const InputDecoration(
                            labelText: 'Cant',
                            labelStyle: TextStyle(fontSize: 10),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            enabled:
                                true, // Asegurarse de que el campo esté habilitado
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                selected: isSelected,
                onSelected: (selected) {
                  _toggleTalleSelection(talle);
                },
              );
            }).toList(),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
