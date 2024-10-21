import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/tipoPrenda.dart';
import 'package:gestion_indumentaria/widgets/boxDialog/boxdialogoPrenda.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Para decodificar JSON
import 'package:gestion_indumentaria/widgets/boxDialog/boxdialogoTalle.dart';

class Prendaselectorwidget extends StatefulWidget {
  final String? selectedprenda;
  final ValueChanged<String?> onPrendaSelected;

  const Prendaselectorwidget({
    Key? key,
    required this.selectedprenda,
    required this.onPrendaSelected,
  }) : super(key: key);

  @override
  _prendaSelectorState createState() => _prendaSelectorState();
}

class _prendaSelectorState extends State<Prendaselectorwidget> {
  List<String> _prendas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTallesFromApi();
  }

  Future<void> _fetchTallesFromApi() async {
    const String apiUrl =
        'https://maria-chucena-api-production.up.railway.app/categoria'; // Cambia por tu endpoint.

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _prendas = data.map((prenda) => prenda["tipo"].toString()).toList();
          _isLoading = false;
        });
      } else {
        _showError('Error al obtener los prenda: ${response.statusCode}');
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

  void _showAddPrendaDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddPrendaDialog(
        onPrendaAdded: (nuevaPrenda) {
          setState(() {
            _prendas.add(nuevaPrenda);
          });
          widget.onPrendaSelected(nuevaPrenda);
        },
      ),
    );
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
          'Prenda',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Wrap(
          spacing: 10,
          children: [
            DropdownButton<String>(
              value: widget.selectedprenda, // Valor seleccionado
              hint: const Text('Seleccione una prenda'), // Texto de sugerencia
              onChanged: (String? newValue) {
                widget
                    .onPrendaSelected(newValue); // Llamar al método de selección
              },
              items: _prendas.map<DropdownMenuItem<String>>((String prenda) {
                return DropdownMenuItem<String>(
                  value: prenda,
                  child: Text(prenda),
                );
              }).toList(),
            ),
            ActionChip(
              label: const Icon(Icons.add),
              onPressed: () => _showAddPrendaDialog(context),
            ),
          ],
        ),
      ],
    );
  }
}
