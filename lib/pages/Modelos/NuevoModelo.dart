import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/AviosModelo.dart';
import 'package:gestion_indumentaria/models/Avio.dart';

import 'package:gestion_indumentaria/models/Modelo.dart';
import 'package:gestion_indumentaria/models/observacion.dart';
import 'package:gestion_indumentaria/models/Talle.dart';
import 'package:gestion_indumentaria/widgets/DrawerMenuLateral.dart';
import 'package:gestion_indumentaria/widgets/HomePage.dart';
import 'package:gestion_indumentaria/widgets/TalleSelectorWidget.dart';
import 'package:gestion_indumentaria/widgets/prendaSelectorWidget.dart';

import 'package:http/http.dart' as http;

class Nuevomodelo extends StatefulWidget {
  const Nuevomodelo({super.key});

  @override
  State<Nuevomodelo> createState() => _NuevomodeloState();
}

class _NuevomodeloState extends State<Nuevomodelo> {
  // Variables de estado para las selecciones del formulario principal
  String? selectedTipo;
  String? selectedGenero;
  String? selectedEdad;
  String? selectedAvios;
  int? selectedPrenda;
  String? selectedTallesForm; // Lista de talles en el formulario principal
  String? codigoModelo;
  String? nombreModelo;
  List<ObservacionModel>? observaciones;
  String? cantidad;
  String? tipoEdad;
  String tituloObservacion = "Sin titulo";
  String descripcionObservacion = "Sin descripción";
  bool? selectedAuxForm;
  bool? selectedPrimForm;
  final List<String> auxOptions = ['auxiliar'];
  final List<String> primOptions = ['primaria'];

  // data para la parte de Avio
  String? nombreAvio;
  String? tipoTalleAvio;
  List<String> selectedTallesDialog = [];
  bool esPorTalle = true;
  bool esPorColor = false;
  final int cantRequerida = 2;

  // Variables de estado para las selecciones dentro del cuadro de diálogo
  String?
      selectedTipoAvioDialog; // Variable para el tipo de avio en el cuadro de diálogo
  // Lista de talles en el cuadro de diálogo
  String? selectedColorDialog;
  final TextEditingController _cantidadController =
      TextEditingController(); // Variable para el color en el cuadro de diálogo
  String? cantidadAvioDialog;
  // Lista para almacenar los avios elegidos y sus detalles
  List<AvioModelo> aviosSeleccionados = [];

  void _createPost() {
    //Avios(nombre: selectedTipoAvioDialog!, proveedores: "Proveedor1");
    Modelo modeloCreado = Modelo(
        id: 0,
        codigo: " codigo-prueba",
        nombre: nombreModelo!,
        tieneTelaSecundaria: selectedPrimForm!,
        tieneTelaAuxiliar: selectedAuxForm!,
        genero: selectedGenero!,
        observaciones: [
          ObservacionModel(
            id: 1,
            titulo: tituloObservacion,
            descripcion: descripcionObservacion,
          )
        ],
        avios: aviosSeleccionados,
        curva: [Talle(id: 1, nombre: "T1")],
        categoriaTipo: selectedPrenda!);

    print('MODELO POST: ${modeloCreado.toJson()}');

    // metodo post
    _post(modeloCreado);
  }

  Future<void> _post(Modelo model) async {
    // Convertir el modelo a JSON
    Map<String, dynamic> modeloJson = model.toJson();

    // URL de la API
    const url =
        "https://maria-chucena-api-production.up.railway.app/modelo"; // Reemplaza con tu URL real
    final uri = Uri.parse(url);

    try {
      // Realizar el POST
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(modeloJson), // Convertimos el modelo a JSON
      );

      // Verificar el estado de la respuesta
      if (response.statusCode == 201) {
        print("Modelo creado con éxito: ${response.body}");

        // Suponiendo que el servidor devuelve el modelo completo, lo puedes parsear
        Modelo modeloCreado = Modelo.fromJson(jsonDecode(response.body));
        print("Código del modelo creado: ${modeloCreado.codigo}");
      } else {
        print(
            "Error al crear el modelo: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error en la solicitud: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Maria Chucena ERP System'),
        toolbarHeight: 80,
        actions: [
          buildLoggedInUser('assets/imagen/logo.png', 'Supervisor'),
        ],
      ),
      drawer: const DrawerMenuLateral(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección izquierda para el título y subtítulo
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Registrar Modelo',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Complete todos los detalles relevantes del modelo',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),
            // Sección derecha para el formulario
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                nombreModelo = value;
                                print('Nombre del modelo: $nombreModelo');
                              });
                            },
                            decoration: const InputDecoration(
                                labelText: 'Nombre de Modelo'),
                          ),
                          const SizedBox(height: 15),
                          PrendaSelectorWidget(
                            selectedPrendaId: selectedPrenda,
                            onPrendaSelected: (id) {
                              setState(() {
                                selectedPrenda =
                                    id; // Guarda el id seleccionado
                              });
                            },
                          ),

                          const SizedBox(height: 15),
                          _buildRadioGroup(
                            'Género',
                            ['MASCULINO', 'FEMENINO', 'UNISEX'],
                            selectedGenero,
                            (value) {
                              setState(() {
                                selectedGenero = value;
                                print('Genero del modelo: $selectedGenero');
                              });
                            },
                          ),
                          const SizedBox(height: 15),
                          _buildRadioGroup(
                            'edad de la tela',
                            ['BEBE', 'chico', 'adulto'],
                            selectedEdad,
                            (value) {
                              setState(() {
                                selectedEdad = value;
                                print('Genero del modelo: $selectedEdad');
                              });
                            },
                          ),
                          const SizedBox(height: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildAuxSelection(),
                              const SizedBox(height: 15),
                              _buildPrimSelection(),
                            ],
                          ),

                          const SizedBox(height: 15),

                          TextField(
                            onChanged: (value) {
                              setState(() {
                                tituloObservacion = value;
                              });
                            },
                            decoration:
                                const InputDecoration(labelText: 'Título'),
                          ),
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                descripcionObservacion = value;
                              });
                            },
                            decoration:
                                const InputDecoration(labelText: 'Descripción'),
                          ),
                          const SizedBox(height: 15),
                          TalleSelector(
                            selectedTalle: selectedTallesForm,
                            onTalleSelected: (talle) {
                              setState(() {
                                selectedTallesForm = talle;
                              });
                            },
                          ),
                          const SizedBox(height: 15),
                          _buildRadioGroup(
                            'Tiene avios',
                            ['SI', 'NO'],
                            selectedAvios,
                            (value) {
                              setState(() {
                                selectedAvios = value;
                                if (value == 'SI') {
                                  _showAviosDialog();
                                }
                              });
                            },
                          ),
                          const SizedBox(height: 15),
                          // _buildTextField(
                          //     'Extras', 'Otros elementos del modelo', ''),
                          const SizedBox(height: 20),
                          Container(
                            child: aviosSeleccionados.isNotEmpty
                                ? _buildAviosTable()
                                : const Text('No hay avios'),
                          ),
                          // Tabla de avios seleccionados
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Acción para guardar el modelo
                                  _createPost();
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize:
                                      const Size(140, 50), // Ajusta el tamaño
                                ),
                                child: const Text('Guardar Modelo'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Acción para cargar foto
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize:
                                      const Size(140, 50), // Ajusta el tamaño
                                ),
                                child: const Text('Cargar Foto'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  const Center(
                    child: Text(
                      '© 2024 Maria Chucena ERP System. All rights reserved.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
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
                                  talle: [Talle(id: 1, nombre: "T1")],
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
                            selectedTallesDialog.clear();
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

  // Agregar el avio seleccionado a la lista

  // Diálogo para seleccionar los talles
  void _showTalleSelectionDialog(StateSetter setState) async {
    List<String> talles = [];
    bool isLoading = true;

    // Llamada a la API para obtener los talles
    const String apiUrl =
        'https://maria-chucena-api-production.up.railway.app/talle';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        talles = data.map((talle) => talle["talle"].toString()).toList();
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
                  children: talles.map((talle) {
                    return ChoiceChip(
                      label: Text(talle),
                      selected: selectedTallesDialog.contains(talle),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedTallesDialog.add(talle);
                          } else {
                            selectedTallesDialog.remove(talle);
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

  // Widget para construir el campo de texto
  Widget _buildTextField(String label, String hint, String key) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  // Widget para construir el grupo de botones de radio
  Widget _buildRadioGroup(String title, List<String> options,
      String? selectedValue, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          children: options.map((option) {
            return Expanded(
              child: RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: selectedValue,
                onChanged: onChanged,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Widget para construir el menú desplegable
  Widget _buildDropdown(String label, List<String> items, String hint,
      String? selectedItem, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        DropdownButton<String>(
          value: selectedItem,
          hint: Text(hint),
          isExpanded: true,
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildAuxSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Seleccione si es tela auxiliar:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: auxOptions.map((aux) {
            return ChoiceChip(
              label: Text(aux),
              selected: selectedAuxForm = false,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedAuxForm = true; // Solo permitir una selección
                  } else {
                    selectedAuxForm = false;
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPrimSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Seleccione si es tela primaria:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: primOptions.map((prim) {
            return ChoiceChip(
              label: Text(prim),
              selected: selectedPrimForm = false,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedPrimForm = true; // Solo permitir una selección
                  } else {
                    selectedPrimForm = false;
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAviosTable() {
    if (aviosSeleccionados.isEmpty) {
      return const Text('No hay avios seleccionados.');
    }

    return DataTable(
      columns: const [
        DataColumn(label: Text('ID de Avio')),
        DataColumn(label: Text('Es por Talle')),
        DataColumn(label: Text('Es por Color')),
        DataColumn(label: Text('Cantidad')),
      ],
      rows: aviosSeleccionados.map((AvioModelo avio) {
        return DataRow(cells: [
          DataCell(Text(avio.avioId.toString())),
          DataCell(Text(avio.esPorTalle == true ? 'Sí' : 'No')),
          DataCell(Text(avio.esPorColor == true ? 'Sí' : 'No')),
          DataCell(Text(avio.cantidadRequerida.toString())),
        ]);
      }).toList(),
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
      throw Exception('Error al cargar los avios');
    }
  }
/*
// Función para obtener los avíos desde la API
  Future<List<Map<String, dynamic>>> fetchAviosFromApi() async {
    const String apiUrl =
        'https://maria-chucena-api-production.up.railway.app/avio'; // URL de la API

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Decodificar la respuesta JSON
        final List<dynamic> data = jsonDecode(response.body);

        // Convertir la lista dinámica en una lista de mapas
        return data.map((avio) => avio as Map<String, dynamic>).toList();
      } else {
        throw Exception('Error al cargar los avíos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }*/
}
