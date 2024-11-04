import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/Avio.dart';
import 'package:gestion_indumentaria/models/AviosModelo.dart';
import 'package:gestion_indumentaria/models/talle.dart';
import 'package:http/http.dart' as http;

// Define las clases Avio, AvioModelo, Talle, etc. según tu estructura de datos.

class EditModelScreen extends StatefulWidget {
  final int modelId; // ID del modelo a editar

  const EditModelScreen({Key? key, required this.modelId}) : super(key: key);

  @override
  _EditModelScreenState createState() => _EditModelScreenState();
}

class _EditModelScreenState extends State<EditModelScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();
  String? selectedTipoAvioDialog;
  bool esPorTalle = false;
  bool esPorColor = false;
  List<AvioModelo> aviosSeleccionados = [];
  List<Talle>? selectedTallesDialog = [];
  List<String> auxOptions = ['Sí', 'No'];
  bool selectedAuxForm = false;
  bool selectedPrimForm = false;

  @override
  void initState() {
    super.initState();
    _loadModelData(); // Cargar datos del modelo
  }

  Future<void> _loadModelData() async {
    // Aquí debes agregar la lógica para cargar los datos del modelo desde la API
    final response = await http.get(Uri.parse(
        'https://maria-chucena-api-production.up.railway.app/modelo/${widget.modelId}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _nombreController.text = data['nombre'];
      // Carga otros campos según la estructura de datos
    } else {
      _showErrorDialog(
          'Error al cargar los datos del modelo: ${response.statusCode}');
    }
  }

  void _showAviosDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<List<Avio>>(
          future: fetchAviosFromApi(),
          builder: (BuildContext context, AsyncSnapshot<List<Avio>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text('Error al cargar los avíos: ${snapshot.error}'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cerrar'),
                  ),
                ],
              );
            } else {
              List<Avio> aviosData = snapshot.data!;

              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setDialogState) {
                  return AlertDialog(
                    title: const Text('Seleccione los detalles del Avio'),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DropdownButton<String>(
                            hint: const Text('Seleccione el avio'),
                            value: selectedTipoAvioDialog,
                            items: aviosData.map((Avio avio) {
                              return DropdownMenuItem<String>(
                                value: avio.nombre,
                                child: Text(avio.nombre),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setDialogState(() {
                                selectedTipoAvioDialog = value;
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          CheckboxListTile(
                            title: const Text('Es por Talle'),
                            value: esPorTalle,
                            onChanged: (bool? value) {
                              setDialogState(() {
                                esPorTalle = value ?? false;
                                if (esPorTalle) {
                                  _showTalleSelectionDialog(setDialogState);
                                }
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: const Text('Es por Color'),
                            value: esPorColor,
                            onChanged: (bool? value) {
                              setDialogState(() {
                                esPorColor = value ?? false;
                              });
                            },
                          ),
                          TextField(
                            controller: _cantidadController,
                            decoration: const InputDecoration(
                              labelText: 'Cantidad Requerida',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 10),
                          // Mostrar los talles seleccionados
                          if (selectedTallesDialog != null &&
                              selectedTallesDialog!.isNotEmpty)
                            Column(
                              children: [
                                const Text('Talles Seleccionados:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Wrap(
                                  spacing: 8.0,
                                  children: selectedTallesDialog!.map((talle) {
                                    return Chip(
                                      label: Text(talle
                                          .nombre), // Asegúrate de que Talle tiene la propiedad nombre
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          // Agregar avio a la lista con los datos ingresados
                          setState(() {
                            if (selectedTipoAvioDialog != null &&
                                _cantidadController.text.isNotEmpty) {
                              final avioSeleccionado = aviosData.firstWhere(
                                  (avio) =>
                                      avio.nombre == selectedTipoAvioDialog);
                              aviosSeleccionados.add(
                                AvioModelo(
                                  avioId: avioSeleccionado.id,
                                  esPorTalle: esPorTalle,
                                  esPorColor: esPorColor,
                                  // Asigna talles seleccionados
                                  cantidadRequerida:
                                      int.parse(_cantidadController.text),
                                ),
                              );
                            }
                          });
                          // Limpiar campos
                          setDialogState(() {
                            selectedTipoAvioDialog = null;
                            _cantidadController.clear();
                            esPorTalle = false;
                            esPorColor = false;
                            selectedTallesDialog?.clear();
                          });
                        },
                        child: const Text('Agregar Avio'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Cerrar el diálogo
                        },
                        child: const Text('Cerrar'),
                      ),
                    ],
                  );
                },
              );
            }
          },
        );
      },
    );
  }

  // Diálogo para seleccionar los talles
  void _showTalleSelectionDialog(StateSetter setState) async {
    List<Talle> talles = [];
    bool isLoading = true;

    // Llamada a la API para obtener los talles
    const String apiUrl =
        'https://maria-chucena-api-production.up.railway.app/talle';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        talles = data
            .map((talle) => Talle.fromJson(talle))
            .toList(); // Asumiendo que tienes un método fromJson en Talle
        isLoading = false;
      } else {
        _showErrorDialog('Error al obtener los talles: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorDialog('Error de conexión: $e');
    }

    // Mostrar el diálogo con los talles cargados
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccione los talles'),
          content: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Wrap(
                  spacing: 10,
                  children: talles.map((Talle talle) {
                    return ChoiceChip(
                      label: Text(talle
                          .nombre), // Asegúrate de que Talle tiene la propiedad nombre
                      selected: selectedTallesDialog!.contains(talle),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedTallesDialog?.add(talle);
                          } else {
                            selectedTallesDialog?.remove(talle);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  Future<List<Avio>> fetchAviosFromApi() async {
    // Simulando una llamada a la API
    final response = await http.get(
        Uri.parse('https://maria-chucena-api-production.up.railway.app/avio'));

    if (response.statusCode == 200) {
      // Decodificando el JSON y convirtiendo a objetos Avio
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => Avio.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar avíos');
    }
  }

  void _updateModel() async {
    // Aquí puedes implementar la lógica para enviar la información actualizada a la API
    final updatedModel = {
      'nombre': _nombreController.text,
      // Agrega otros campos del modelo que se deseen actualizar
      'avios': aviosSeleccionados.map((e) => e.toJson()).toList(),
    };

    final response = await http.put(
      Uri.parse('https://api-url-to-update-model/${widget.modelId}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updatedModel),
    );

    if (response.statusCode == 200) {
      Navigator.of(context).pop(); // Regresar a la pantalla anterior
    } else {
      _showErrorDialog('Error al actualizar el modelo: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Modelo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _updateModel, // Llamar al método de actualización
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _showAviosDialog,
              child: const Text('Seleccionar Avios'),
            ),
            const SizedBox(height: 16),
            // Mostrar la tabla de avíos seleccionados
            _buildAviosTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildAviosTable() {
    return DataTable(
      columns: const [
        DataColumn(label: Text('ID')),
        DataColumn(label: Text('Por Talle')),
        DataColumn(label: Text('Por Color')),
        DataColumn(label: Text('Cantidad')),
      ],
      rows: aviosSeleccionados.map((AvioModelo avio) {
        return DataRow(
          cells: [
            DataCell(Text(avio.avioId.toString())),
            DataCell(Text(avio.esPorTalle ? 'Sí' : 'No')),
            DataCell(Text(avio.esPorColor ? 'Sí' : 'No')),
            DataCell(Text(avio.cantidadRequerida.toString())),
          ],
        );
      }).toList(),
    );
  }
}
