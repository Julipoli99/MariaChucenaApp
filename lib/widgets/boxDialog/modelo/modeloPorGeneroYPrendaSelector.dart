import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/Modelo.dart';
import 'package:http/http.dart' as http;

class ModeloPorGeneroYPrendaSelectorWidget extends StatefulWidget {
  final String? genero;
  final int? categoriaPrenda;
  final int? selectedModeloId;
  final ValueChanged<int?> onModeloSelected;

  const ModeloPorGeneroYPrendaSelectorWidget({
    super.key,
    this.selectedModeloId,
    required this.onModeloSelected,
    this.genero,
    this.categoriaPrenda,
  });

  @override
  _ModeloPorGeneroYPrendaSelectorWidgetState createState() =>
      _ModeloPorGeneroYPrendaSelectorWidgetState();
}

class _ModeloPorGeneroYPrendaSelectorWidgetState
    extends State<ModeloPorGeneroYPrendaSelectorWidget> {
  List<Modelo> modelos = [];
  int? selectedModeloId;

  @override
  void initState() {
    super.initState();
    selectedModeloId = widget.selectedModeloId;
    fetchModelos();
  }

  @override
  void didUpdateWidget(
      covariant ModeloPorGeneroYPrendaSelectorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.genero != oldWidget.genero ||
        widget.categoriaPrenda != oldWidget.categoriaPrenda) {
      selectedModeloId = null; // Limpia la selección si los filtros cambian
      fetchModelos();
    }
  }

  Future<void> fetchModelos() async {
    const url = 'https://maria-chucena-api-production.up.railway.app/modelo';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          modelos = data
              .map((item) => Modelo.fromJson(item))
              .where((modelo) =>
                  modelo.categoriaTipo == widget.categoriaPrenda &&
                  modelo.genero == widget.genero)
              .toList();
          // Reinicia `selectedModeloId` después de cargar los modelos si ya está seleccionado
          if (!modelos.any((modelo) => modelo.id == selectedModeloId)) {
            selectedModeloId = null;
          }
        });
      } else {
        throw Exception('Error al cargar modelos: ${response.statusCode}');
      }
    } catch (e) {
      print("Error de red: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      decoration: InputDecoration(
        labelText: 'Modelo',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      hint: const Text('Seleccione un modelo'),
      value: selectedModeloId,
      items: modelos.map((modelo) {
        return DropdownMenuItem<int>(
          value: modelo.id,
          child: Text(modelo.nombre),
        );
      }).toList(),
      onChanged: (int? newModeloId) {
        setState(() {
          selectedModeloId = newModeloId;
        });
        widget.onModeloSelected(newModeloId);
      },
    );
  }
}
