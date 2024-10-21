import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/Avios.dart';
import 'package:gestion_indumentaria/models/Modelo.dart';
import 'package:gestion_indumentaria/models/TipoTela.dart';
import 'package:gestion_indumentaria/models/tipoPrenda.dart';
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
  String? selectedTela;
  String? selectedPrenda;
  String? selectedTallesForm; // Lista de talles en el formulario principal
  List<String> selectedTipoDeRolloForm = [];
  String? codigoModelo;
  String? nombreModelo;
  List<String>? observacion;
  String? cantidad;
  String? tipoEdad;
  String? titulo;
  String? subtitulo;
  List<String> selectedAuxForm = [];
  List<String> selectedPrimForm = [];
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
  List<Avios> aviosSeleccionados = [];

  void _createPost() {
    //Avios(nombre: selectedTipoAvioDialog!, proveedores: "Proveedor1");
    Modelo modeloCreado = Modelo(
        id: 15,
        codigo: codigoModelo!,
        nombre: nombreModelo!,
        tieneTelaSecundaria: true,
        tieneTelaAuxiliar: true,
        genero: selectedGenero!,
        observaciones: [titulo, subtitulo],
        avios: aviosSeleccionados,
        curva: [
          {"id": 1, "talle": "T1"},
          {"id": 2, "talle": "T2"},
          {"id": 3, "talle": "T3"},
          {"id": 4, "talle": "T4"},
          {"id": 5, "talle": "T5"}
        ],
        categoriaTipo: selectedPrenda!);

    print(modeloCreado.toJson());

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
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                codigoModelo = value;
                                print('Codigo del modelo: $codigoModelo');
                              });
                            },
                            decoration: const InputDecoration(
                                labelText: 'Codigo de Modelo'),
                          ),
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
                          Prendaselectorwidget(
                            selectedprenda: selectedPrenda,
                            onPrendaSelected: (prenda) {
                              setState(() {
                                selectedPrenda = prenda;
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
                          _buildTelaRow(),
                          const SizedBox(height: 15),
                          _buildTelaRowForm(),
                          const SizedBox(height: 15),

                          TextField(
                            onChanged: (value) {
                              setState(() {
                                titulo = value;
                                print('Título: $titulo');
                              });
                            },
                            decoration:
                                const InputDecoration(labelText: 'Título'),
                          ),
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                subtitulo = value;
                                print('Subtítulo: $subtitulo');
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
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: const Text('Seleccione el tipo de avios'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDropdown(
                    'Tipo de Avios',
                    ['Botón', 'Cierre', 'Etiqueta', 'Otro'],
                    'Seleccione el tipo de avios',
                    selectedTipoAvioDialog,
                    (value) {
                      setDialogState(() {
                        selectedTipoAvioDialog = value;
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      _showTalleSelectionDialog(setDialogState);
                    },
                    child: const Text('Seleccionar Talle'),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      setDialogState(() {
                        selectedColorDialog = 'Color seleccionado'; // Ejemplo
                      });
                    },
                    child: const Text('Seleccionar Color'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _cantidadController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setDialogState(() {
                        cantidadAvioDialog = (value);
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Cantidad'),
                  ),
                  if (selectedColorDialog != null)
                    Text(
                      'Color: $selectedColorDialog',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  const SizedBox(height: 10),
                  if (selectedTallesDialog.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      children: selectedTallesDialog
                          .map((talle) => Chip(label: Text(talle)))
                          .toList(),
                    ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    if (selectedTipoAvioDialog != null &&
                        cantidadAvioDialog != null &&
                        cantidadAvioDialog!.isNotEmpty) {
                      // Crear avio y actualizar lista
                      Avios avioCreado = Avios(
                        nombre: selectedTipoAvioDialog!,
                        proveedores: "Proveedor1",
                        talles: List.from(selectedTallesDialog),
                        color: selectedColorDialog,
                        cantidad: cantidadAvioDialog!,
                      );

                      // Usar setState para actualizar la tabla en la pantalla principal
                      setState(() {
                        aviosSeleccionados.add(avioCreado);
                      });

                      // Limpiar el formulario para un próximo avio
                      setDialogState(() {
                        selectedTipoAvioDialog = null;
                        selectedTallesDialog.clear();
                        selectedColorDialog = null;
                        cantidadAvioDialog = null;
                        _cantidadController.clear();
                      });

                      Navigator.of(context); // Cerrar el diálogo
                    }
                  },
                  child: const Text('Agregar Avio'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedTipoAvioDialog != null &&
                        cantidadAvioDialog != null &&
                        cantidadAvioDialog!.isNotEmpty) {
                      // Crear avio y actualizar lista
                      Avios avioCreado = Avios(
                        nombre: selectedTipoAvioDialog!,
                        proveedores: "Proveedor1",
                        talles: List.from(selectedTallesDialog),
                        color: selectedColorDialog,
                        cantidad: cantidadAvioDialog!,
                      );

                      // Usar setState para actualizar la tabla en la pantalla principal
                      setState(() {
                        aviosSeleccionados.add(avioCreado);
                        selectedTipoAvioDialog = null;
                        selectedTallesDialog.clear();
                        selectedColorDialog = null;
                        cantidadAvioDialog = null;
                        _cantidadController.clear();
                      });

                      Navigator.of(context).pop(); // Cerrar el diálogo
                    }
                  },
                  child: const Text('Finalizar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

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

  // Widget para mostrar los Tipo de tela en el formulario
  Widget _buildTelaRowForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Seleccione el tipo de tela :',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: ['Plano', 'Punto'].map((tipoDeRollo) {
            return ChoiceChip(
              label: Text(tipoDeRollo),
              selected: selectedTipoDeRolloForm.contains(tipoDeRollo),
              onSelected: (selected) {
                //  print(selected);

                setState(() {
                  if (selected) {
                    selectedTipoDeRolloForm.add(tipoDeRollo);
                  } else {
                    selectedTipoDeRolloForm.remove(tipoDeRollo);
                  }
                });
              },
            );
          }).toList(),
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
              selected: selectedAuxForm.contains(aux),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedAuxForm = [aux]; // Solo permitir una selección
                  } else {
                    selectedAuxForm.remove(aux);
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
              selected: selectedPrimForm.contains(prim),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedPrimForm = [prim]; // Solo permitir una selección
                  } else {
                    selectedPrimForm.remove(prim);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  // Widget para construir el menú desplegable de tela
  Widget _buildTelaRow() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: _buildDropdown(
            'Tela',
            ['Algodón', 'Lino', 'Poliéster', 'Seda'],
            'Seleccione la tela',
            selectedTela,
            (value) {
              setState(() {
                selectedTela = value;
                print('Tela de modelo seleccionada: $selectedTela');
              });
            },
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  // Widget para construir la tabla de avios seleccionados
  Widget _buildAviosTable() {
    if (aviosSeleccionados.isEmpty) {
      return const Text('No hay avios seleccionados.');
    }

    return DataTable(
      columns: const [
        DataColumn(label: Text('Tipo de Avio')),
        DataColumn(label: Text('Talles')),
        DataColumn(label: Text('Color')),
        DataColumn(label: Text('cantidad')),
      ],
      rows: aviosSeleccionados.map((avio) {
        return DataRow(cells: [
          DataCell(Text(avio.nombre)),
          DataCell(Text(avio.talles.toString())),
          DataCell(Text(avio.color ?? 'Ninguno')),
          DataCell(Text(avio.cantidad ?? '0')),
        ]);
      }).toList(),
    );
  }
}
