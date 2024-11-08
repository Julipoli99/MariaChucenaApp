import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/Avio.dart';
import 'package:gestion_indumentaria/models/Modelo.dart';
import 'package:gestion_indumentaria/models/AviosModelo.dart';
import 'package:gestion_indumentaria/models/talle.dart';
import 'package:gestion_indumentaria/widgets/TalleSelectorWidget.dart';
import 'package:http/http.dart' as http;

class EditModelScreen extends StatefulWidget {
  final Modelo modelo;
  final ValueChanged<Modelo> onModeloModified;

  const EditModelScreen({
    Key? key,
    required this.modelo,
    required this.onModeloModified,
  }) : super(key: key);

  @override
  _EditModelScreenState createState() => _EditModelScreenState();
}

class _EditModelScreenState extends State<EditModelScreen> {
  final TextEditingController _codigoController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _cantidadController =
      TextEditingController(); // Agregar controlador para cantidad
  bool _tieneTelaSecundaria = false;
  bool _tieneTelaAuxiliar = false;
  bool _isSaving = false;
  List<AvioModelo> _aviosSeleccionados = [];
  List<Avio>? aviosData;
  List<Talle> selectedTallesForm = [];
  String? selectedTipoAvioDialog; // Variable para el tipo de avio seleccionado
  bool esPorTalle = false; // Variable para indicar si es por talle
  bool esPorColor = false; // Variable para indicar si es por color
  List<Talle>? selectedTallesDialog; // Almacena los talles seleccionados

  @override
  void initState() {
    super.initState();
    _codigoController.text = widget.modelo.codigo;
    _nombreController.text = widget.modelo.nombre;
    _tieneTelaSecundaria = widget.modelo.tieneTelaSecundaria;
    _tieneTelaAuxiliar = widget.modelo.tieneTelaAuxiliar;
    selectedTallesDialog = widget.modelo.curva.cast<Talle>();
    _aviosSeleccionados =
        widget.modelo.avios ?? []; // Inicializar con avíos existentes
  }

  Future<void> _updateModeloInApi() async {
    final String apiUrl =
        'https://maria-chucena-api-production.up.railway.app/modelo/${widget.modelo.id}';

    setState(() => _isSaving = true);

    try {
      final response = await http.patch(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'codigo': _codigoController.text.trim(),
          'nombre': _nombreController.text.trim(),
          'tieneTelaSecundaria': _tieneTelaSecundaria,
          'tieneTelaAuxiliar': _tieneTelaAuxiliar,
          'avios': _aviosSeleccionados
              .map((avio) => avio.toJson())
              .toList(), // Incluir avíos en la actualización
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("*****************+");
        print(responseData);
        final updatedModelo =
            Modelo.fromJson(responseData); // Usar el método fromJson

        // Llamar a la función para actualizar la lista de modelos en CrudModelosPage
        widget.onModeloModified(updatedModelo);

        // Regresar a la vista de CRUD para ver los cambios aplicados
        // Regresa a la home
        Navigator.of(context).pop();
      } else {
        _showError('Error al actualizar el modelo en la API. ${response.body}');
      }
    } catch (e) {
      _showError('Ocurrió un error: $e');
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modificar Modelo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isSaving ? null : _updateModeloInApi,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Código actual: ${widget.modelo.codigo ?? "Sin código"}'),
            const SizedBox(height: 10),
            TextField(
              controller: _codigoController,
              decoration: const InputDecoration(
                labelText: 'Nuevo código del modelo',
              ),
            ),
            const SizedBox(height: 20),
            Text('Nombre actual: ${widget.modelo.nombre ?? "Sin nombre"}'),
            const SizedBox(height: 10),
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nuevo nombre del modelo',
              ),
            ),
            const SizedBox(height: 20),
            CheckboxListTile(
              title: const Text('¿Tiene tela secundaria?'),
              value: _tieneTelaSecundaria,
              onChanged: (value) {
                setState(() => _tieneTelaSecundaria = value ?? false);
              },
            ),
            CheckboxListTile(
              title: const Text('¿Tiene tela auxiliar?'),
              value: _tieneTelaAuxiliar,
              onChanged: (value) {
                setState(() => _tieneTelaAuxiliar = value ?? false);
              },
            ),
            const SizedBox(height: 15),
            TalleSelector(
              selectedTalles: selectedTallesForm,
              onTalleSelected: (talles) {
                setState(() {
                  selectedTallesForm = talles;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text('Avíos:'),
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: _showAviosDialog,
              child: const Text('Modificar Avios'),
            ),
            const SizedBox(height: 20),
            // Tabla para mostrar avios seleccionados
            Expanded(child: _buildAviosTable()),
          ],
        ),
      ),
    );
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
                    title: const Text('Modificar Avios'),
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
                              print('Tipo de avio seleccionado: $value');
                            },
                          ),
                          const SizedBox(height: 10),
                          CheckboxListTile(
                            title: const Text('Es por Talle'),
                            value: esPorTalle,
                            onChanged: (bool? value) {
                              setDialogState(() {
                                esPorTalle = value ?? false;
                                print('Es por Talle: $esPorTalle');
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: const Text('Es por Color'),
                            value: esPorColor,
                            onChanged: (bool? value) {
                              setDialogState(() {
                                esPorColor = value ?? false;
                                print('Es por Color: $esPorColor');
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
                        ],
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          if (selectedTipoAvioDialog != null &&
                              _cantidadController.text.isNotEmpty) {
                            final avioSeleccionado = aviosData.firstWhere(
                                (avio) =>
                                    avio.nombre == selectedTipoAvioDialog);

                            // Mostrar datos que se van a agregar
                            print('Agregando avio: ${avioSeleccionado.nombre}');
                            print('Cantidad: ${_cantidadController.text}');
                            print('Es por Talle: $esPorTalle');
                            print('Es por Color: $esPorColor');
                            print(
                                'Talles seleccionados: $selectedTallesDialog');

                            // Modificar el avio en lugar de agregar uno nuevo
                            setState(() {
                              final cantidadRequerida = int.parse(
                                  _cantidadController
                                      .text); // Asegúrate de que esto sea un número
                              final avioAGuardar = AvioModelo(
                                avioId: avioSeleccionado.id,
                                cantidadRequerida: cantidadRequerida,
                                esPorTalle: esPorTalle,
                                esPorColor: esPorColor,
                              );

                              // Aquí se puede agregar lógica para evitar duplicados
                              if (!_aviosSeleccionados
                                  .any((avio) => avio.id == avioAGuardar.id)) {
                                _aviosSeleccionados.add(avioAGuardar);
                                print('Avio agregado: $avioAGuardar');
                              } else {
                                print('El avio ya está agregado.');
                              }

                              // Reiniciar el estado del diálogo
                              setDialogState(() {
                                selectedTipoAvioDialog = null;
                                _cantidadController.clear();
                                esPorTalle = false;
                                esPorColor = false;
                              });
                            });

                            Navigator.of(context).pop(); // Cerrar el diálogo
                          } else {
                            _showError('Por favor, complete todos los campos.');
                          }
                        },
                        child: const Text('Agregar'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Cerrar el diálogo
                        },
                        child: const Text('Cancelar'),
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

  Widget _buildAviosTable() {
    return ListView.builder(
      itemCount: _aviosSeleccionados.length,
      itemBuilder: (context, index) {
        final avio = _aviosSeleccionados[index];
        return DataTable(
          columns: const [
            DataColumn(label: Text('ID de Avio')),
            DataColumn(label: Text('Es por Talle')),
            DataColumn(label: Text('Es por Color')),
            DataColumn(label: Text('Cantidad')),
            DataColumn(label: Text('Acciones')), // Nueva columna para acciones
          ],
          rows: _aviosSeleccionados.map((AvioModelo avio) {
            return DataRow(cells: [
              DataCell(Text(avio.avioId.toString())),
              DataCell(Text(avio.esPorTalle ? 'Sí' : 'No')),
              DataCell(Text(avio.esPorColor ? 'Sí' : 'No')),
              DataCell(Text(avio.cantidadRequerida.toString())),
              DataCell(Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _editAvio(avio);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteAvio(widget.modelo.id, avio.id!);
                    },
                  ),
                ],
              )),
            ]);
          }).toList(),
        );
      },
    );
  }

  void _editAvio(AvioModelo avio) {
    // Configurar el dialogo para editar el avio
    _cantidadController.text = avio.cantidadRequerida.toString();
    selectedTipoAvioDialog = avio.avioId.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Avio'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                DropdownButton<String>(
                  hint: const Text('Seleccione el avio'),
                  value: selectedTipoAvioDialog,
                  items: aviosData?.map((Avio avio) {
                    return DropdownMenuItem<String>(
                      value: avio.nombre,
                      child: Text(avio.nombre),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedTipoAvioDialog = value;
                    });
                  },
                ),
                TextField(
                  controller: _cantidadController,
                  decoration:
                      const InputDecoration(labelText: 'Cantidad Requerida'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (selectedTipoAvioDialog != null &&
                    _cantidadController.text.isNotEmpty) {
                  final cantidadRequerida = int.parse(_cantidadController.text);
                  final updatedAvio = AvioModelo(
                    avioId: avio.avioId,
                    cantidadRequerida: cantidadRequerida,
                    esPorTalle: avio.esPorTalle,
                    esPorColor: avio.esPorColor,
                  );

                  setState(() {
                    final index = _aviosSeleccionados
                        .indexWhere((a) => a.avioId == avio.avioId);
                    if (index != -1) {
                      _aviosSeleccionados[index] = updatedAvio;
                    }
                  });
                  Navigator.of(context).pop();
                } else {
                  _showError('Por favor, complete todos los campos.');
                }
              },
              child: const Text('Actualizar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  _deleteAvio(int idModelo, int idAvioModelo) async {
    final url =
        'https://maria-chucena-api-production.up.railway.app//modelo/avio-modelo/$idModelo-modelo/$idAvioModelo-avio-modelo';

    try {
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        print('Recurso eliminado con éxito.');
        // Aquí puedes agregar lógica adicional después de la eliminación
      } else {
        final errorResponse = json.decode(response.body);
        throw Exception(
            'Error al eliminar el recurso: ${errorResponse['message']}');
      }
    } catch (error) {
      print('Se produjo un error: $error');
    }
  }

  Future<List<Avio>> fetchAviosFromApi() async {
    final response = await http.get(
      Uri.parse('https://maria-chucena-api-production.up.railway.app/avio'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => Avio.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar avíos');
    }
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
}
