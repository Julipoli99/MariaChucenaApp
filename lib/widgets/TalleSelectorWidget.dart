import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Para decodificar JSON
import 'package:gestion_indumentaria/widgets/boxDialog/boxdialogoTalle.dart';

class TalleSelector extends StatefulWidget {
  final String? selectedTalle;
  final ValueChanged<String?> onTalleSelected;

  const TalleSelector({
    Key? key,
    required this.selectedTalle,
    required this.onTalleSelected,
  }) : super(key: key);

  @override
  _TalleSelectorState createState() => _TalleSelectorState();
}

class _TalleSelectorState extends State<TalleSelector> {
  List<String> _talles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTallesFromApi();
  }

  Future<void> _fetchTallesFromApi() async {
    const String apiUrl =
        'https://maria-chucena-api-production.up.railway.app/talle'; // Cambia por tu endpoint.

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _talles = data.map((talle) => talle["talle"].toString()).toList();
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

  void _showAddTalleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddTalleDialog(
        onTalleAdded: (nuevoTalle) {
          setState(() {
            _talles.add(nuevoTalle);
          });
          widget.onTalleSelected(nuevoTalle);
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
          'Talle',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Wrap(
          spacing: 10,
          children: [
            ..._talles.map((talle) {
              return ChoiceChip(
                label: Text(talle),
                selected: widget.selectedTalle == talle,
                onSelected: (selected) {
                  widget.onTalleSelected(selected ? talle : null);
                },
              );
            }).toList(),
            ActionChip(
              label: const Icon(Icons.add),
              onPressed: () => _showAddTalleDialog(context),
            ),
          ],
        ),
      ],
    );
  }
}
