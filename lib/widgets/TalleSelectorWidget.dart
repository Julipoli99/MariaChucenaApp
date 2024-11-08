import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gestion_indumentaria/models/talle.dart';
import 'package:gestion_indumentaria/widgets/boxDialog/boxdialogoTalle.dart';

class TalleSelector extends StatefulWidget {
  final List<Talle> selectedTalles;
  final ValueChanged<List<Talle>> onTalleSelected;

  const TalleSelector({
    Key? key,
    required this.selectedTalles,
    required this.onTalleSelected,
  }) : super(key: key);

  @override
  _TalleSelectorState createState() => _TalleSelectorState();
}

class _TalleSelectorState extends State<TalleSelector> {
  List<Talle> _talles = [];
  bool _isLoading = true;

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

  void _showAddTalleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddTalleDialog(
        onTalleAdded: (nuevoTalle) {
          setState(() {
            _talles.add(nuevoTalle as Talle);
          });
          _toggleTalleSelection(nuevoTalle as Talle);
        },
      ),
    );
  }

  void _toggleTalleSelection(Talle talle) {
    setState(() {
      if (widget.selectedTalles.contains(talle)) {
        widget.selectedTalles.remove(talle);
      } else {
        widget.selectedTalles.add(talle);
      }
      widget.onTalleSelected(List.from(widget.selectedTalles));
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
          'Talles',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Wrap(
          spacing: 10,
          children: [
            ..._talles.map((talle) {
              return ChoiceChip(
                label: Text(talle.nombre),
                selected: widget.selectedTalles.contains(talle),
                onSelected: (selected) {
                  _toggleTalleSelection(talle);
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
