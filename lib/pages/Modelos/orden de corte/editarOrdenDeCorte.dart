import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/talle.dart';
import 'package:gestion_indumentaria/pages/principal.dart';
import 'package:gestion_indumentaria/widgets/HomePage.dart';
import 'package:http/http.dart' as http;
import 'package:gestion_indumentaria/widgets/TalleSelectorWidget.dart';

class ModificarOrdenDeCorteScreen extends StatefulWidget {
  final int ordenId; // ID de la orden de corte a modificar
  final dynamic corteExistente; // Corte existente para prellenar los campos

  const ModificarOrdenDeCorteScreen({
    super.key,
    required this.ordenId,
    this.corteExistente, // Parámetro opcional
  });

  @override
  _ModificarOrdenDeCorteScreenState createState() =>
      _ModificarOrdenDeCorteScreenState();
}

class _ModificarOrdenDeCorteScreenState
    extends State<ModificarOrdenDeCorteScreen> {
  List<String> tiposDeTela = [];
  List<dynamic> modelosACortar = [];
  List<String> avios = [];
  List<Talle> selectedTalle = [];
  String? selectedTipoDeTela;
  String? selectedModelo;
  String? selectedAvio;
  String? observaciones;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    await fetchAvios();
    await fetchModelo();
    await fetchTiposDeTela();
    await fetchOrdenCorte();
  }

  Future<void> fetchAvios() async {
    final response = await http.get(
        Uri.parse('https://maria-chucena-api-production.up.railway.app/avio'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        avios = List<String>.from(data.map((avio) => avio['nombre']));
      });
    } else {
      print('Error al cargar los avíos');
    }
  }

  Future<void> fetchModelo() async {
    final response = await http.get(Uri.parse(
        'https://maria-chucena-api-production.up.railway.app/modelo'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        modelosACortar = data;
      });
    } else {
      print('Error al cargar los modelos');
    }
  }

  Future<void> fetchTiposDeTela() async {
    final response = await http.get(Uri.parse(
        'https://maria-chucena-api-production.up.railway.app/tipo-Producto'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        tiposDeTela.addAll(data
            .where((tipo) => tipo['tipo'] == 'TELA')
            .map<String>((tipo) => tipo['nombre'].toString()));
      });
    } else {
      print('Error al cargar los tipos de producto');
    }
  }

  Future<void> fetchOrdenCorte() async {
    final response = await http.get(Uri.parse(
        'https://maria-chucena-api-production.up.railway.app/corte/${widget.ordenId}'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        selectedTipoDeTela = data['tipoDeTela'];
        selectedModelo = data['modeloNombre'];
        selectedAvio = data['avioNombre'];
        observaciones = data['observaciones'];
        selectedTalle =
            List<Talle>.from(data['curva'].map((t) => Talle.fromJson(t)));
        isLoading = false;
      });
    } else {
      print('Error al cargar la orden de corte');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> modifyOrdenDeCorte() async {
    if (selectedTipoDeTela == null ||
        selectedModelo == null ||
        selectedAvio == null ||
        selectedTalle.isEmpty ||
        observaciones == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos.')),
      );
      return;
    }

    final modeloSeleccionado = modelosACortar
        .firstWhere((modelo) => modelo['nombre'] == selectedModelo);

    final orderData = {
      'id': widget.ordenId,
      'modelos': [
        {
          'modeloId': modeloSeleccionado['id'],
          'esParaEstampar': true,
          'usaTelaSecundaria': false,
          'usaTelaAuxiliar': false,
          'observaciones': [
            {
              'titulo': 'Collareta',
              'descripcion': observaciones ?? '',
            },
          ],
          'curva': selectedTalle.map((talle) {
            return {
              'talleId': talle.id,
              'repeticion': 1,
            };
          }).toList(),
        },
      ],
      'rollos': [
        {
          'rolloId': 1,
          'categoria': 'PRIMARIA',
          'cantidadUtilizada': 25.6,
        },
      ],
    };

    try {
      final response = await http.put(
        Uri.parse(
            'https://maria-chucena-api-production.up.railway.app/corte/${widget.ordenId}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(orderData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Orden de corte modificada exitosamente.')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        final responseBody = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Error al modificar la orden de corte: ${responseBody['message'] ?? 'Error desconocido'}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modificar Orden de Corte'),
        toolbarHeight: 80,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildDropdownField('Tipo de Tela', tiposDeTela, context,
                        (value) {
                      setState(() {
                        selectedTipoDeTela = value;
                      });
                    }, initialValue: selectedTipoDeTela),
                    const SizedBox(height: 10),
                    buildDropdownField(
                        'Modelo a Cortar',
                        modelosACortar
                            .map((modelo) => modelo['nombre'].toString())
                            .toList(),
                        context, (value) {
                      setState(() {
                        selectedModelo = value;
                      });
                    }, initialValue: selectedModelo),
                    const SizedBox(height: 10),
                    buildDropdownField('Avíos', avios, context, (value) {
                      setState(() {
                        selectedAvio = value;
                      });
                    }, initialValue: selectedAvio),
                    const SizedBox(height: 10),
                    buildTextField('Observaciones', (value) {
                      setState(() {
                        observaciones = value;
                      });
                    }, initialValue: observaciones),
                    const SizedBox(height: 10),
                    TalleSelector(
                      selectedTalles: selectedTalle,
                      onTalleSelected: (talles) {
                        setState(() {
                          selectedTalle = talles;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancelar'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: modifyOrdenDeCorte,
          child: const Text('Modificar Orden'),
        ),
      ],
    );
  }

  Widget buildDropdownField(String label, List<String> items,
      BuildContext context, ValueChanged<String?> onChanged,
      {String? initialValue}) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label),
      value: initialValue,
      onChanged: onChanged,
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget buildTextField(String label, ValueChanged<String?> onChanged,
      {String? initialValue}) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      initialValue: initialValue,
      onChanged: onChanged,
    );
  }
}
