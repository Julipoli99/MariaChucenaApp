import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/tipoPrenda.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PrendaSelectorWidget extends StatefulWidget {
  final int? selectedPrendaId;
  final ValueChanged<int?> onPrendaSelected;

  const PrendaSelectorWidget({
    super.key,
    this.selectedPrendaId,
    required this.onPrendaSelected,
  });

  @override
  _PrendaSelectorWidgetState createState() => _PrendaSelectorWidgetState();
}

class _PrendaSelectorWidgetState extends State<PrendaSelectorWidget> {
  List<Prenda> prendas = [];
  int? selectedPrendaId;

  @override
  void initState() {
    super.initState();
    selectedPrendaId = widget.selectedPrendaId;
    fetchPrendas();
  }

  Future<void> fetchPrendas() async {
    const url =
        'https://maria-chucena-api-production.up.railway.app/categoria'; // Reemplaza con la URL real de tu API
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          prendas = data.map((json) => Prenda.fromJson(json)).toList();
        });
      } else {
        throw Exception('Error al cargar prendas: ${response.statusCode}');
      }
    } catch (e) {
      print("Error de red: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      hint: const Text('Seleccione una prenda'),
      value: selectedPrendaId,
      items: prendas.map((Prenda prenda) {
        return DropdownMenuItem<int>(
          value: prenda.id,
          child: Text(prenda.nombre),
        );
      }).toList(),
      onChanged: (int? newPrendaId) {
        setState(() {
          selectedPrendaId = newPrendaId;
        });
        widget.onPrendaSelected(newPrendaId);
      },
      isExpanded: true,
    );
  }
}
