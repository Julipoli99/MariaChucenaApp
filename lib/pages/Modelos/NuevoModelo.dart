import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/widgets/DrawerMenuLateral.dart';
import 'package:gestion_indumentaria/widgets/HomePage.dart';

class Nuevomodelo extends StatefulWidget {
  const Nuevomodelo({super.key});

  @override
  State<Nuevomodelo> createState() => _NuevomodeloState();
}

class _NuevomodeloState extends State<Nuevomodelo> {
  // Variables de estado para las selecciones del formulario principal
  String? selectedTipo;
  String? selectedGenero;
  String? selectedAvios;
  String? selectedTela;
  String? selectedPrenda;
  List<String> selectedTallesForm =
      []; // Lista de talles en el formulario principal

  // Variables de estado para las selecciones dentro del cuadro de diálogo
  String?
      selectedTipoAvioDialog; // Variable para el tipo de avio en el cuadro de diálogo
  List<String> selectedTallesDialog =
      []; // Lista de talles en el cuadro de diálogo
  String? selectedColorDialog; // Variable para el color en el cuadro de diálogo

  // Lista para almacenar los avios elegidos y sus detalles
  List<Map<String, dynamic>> aviosSeleccionados = [];

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
                          _buildTextField('codigo de modelo ', 'Ej: M001',
                              'codigo de modelo '),
                          const SizedBox(height: 15),
                          _buildTextField('Nombre de Modelo', 'Ej: M001',
                              'nombre del modelo'),
                          const SizedBox(height: 15),
                          _buildDropdown(
                            'Prenda',
                            ['Remera', 'Pantalón', 'Otro'],
                            'Seleccione la prenda del modelo',
                            selectedPrenda,
                            (value) {
                              setState(() {
                                selectedPrenda = value;
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
                              });
                            },
                          ),
                          const SizedBox(height: 15),
                          _buildTelaRow(),
                          const SizedBox(height: 15),
                          _buildTextField('Observación', '', 'observación'),
                          const SizedBox(height: 15),
                          _buildTallesRowForm(),
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
                          _buildTextField(
                              'Extras', 'Otros elementos del modelo', ''),
                          const SizedBox(height: 20),
                          _buildAviosTable(), // Tabla de avios seleccionados
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Acción para guardar el modelo
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

  // Función para mostrar el cuadro de diálogo con los botones "Talle" y "Color"
  void _showAviosDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
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
                      setState(() {
                        selectedTipoAvioDialog = value;
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  // Botón para seleccionar talles
                  ElevatedButton(
                    onPressed: () {
                      _showTalleSelectionDialog(setState);
                    },
                    child: const Text('Seleccionar Talle'),
                  ),
                  const SizedBox(height: 15),
                  // Botón para seleccionar el color sin abrir un nuevo cuadro de diálogo
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedColorDialog =
                            'Color seleccionado'; // Acción directa sin abrir otro diálogo
                      });
                    },
                    child: const Text('Seleccionar Color'),
                  ),
                  const SizedBox(height: 10),
                  // Mostrar el color seleccionado
                  if (selectedColorDialog != null)
                    Text(
                      'Color: $selectedColorDialog',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  const SizedBox(height: 10),
                  // Mostrar los talles seleccionados
                  if (selectedTallesDialog.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      children: selectedTallesDialog
                          .map((talle) => Chip(
                                label: Text(talle),
                              ))
                          .toList(),
                    ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    // Añadir avios seleccionados a la lista
                    if (selectedTipoAvioDialog != null) {
                      aviosSeleccionados.add({
                        'tipo': selectedTipoAvioDialog,
                        'talles': List.from(
                            selectedTallesDialog), // Clonar lista para evitar referencias
                        'color': selectedColorDialog,
                      });
                      // Limpiar selecciones del diálogo
                      setState(() {
                        selectedTipoAvioDialog = null;
                        selectedTallesDialog.clear();
                        selectedColorDialog = null;
                      });
                      Navigator.of(context)
                          .pop(); // Cerrar el cuadro de diálogo después de agregar
                      setState(() {}); // Actualizar la tabla en el formulario
                    }
                  },
                  child: const Text('Agregar Avio'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Diálogo para seleccionar los talles
  void _showTalleSelectionDialog(StateSetter setState) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccione los talles'),
          content: Wrap(
            spacing: 10,
            children: ['S', 'M', 'L', 'XL'].map((talle) {
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

  // Widget para mostrar los talles en el formulario
  Widget _buildTallesRowForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Seleccione los talles:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: ['S', 'M', 'L', 'XL'].map((talle) {
            return ChoiceChip(
              label: Text(talle),
              selected: selectedTallesForm.contains(talle),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedTallesForm.add(talle);
                  } else {
                    selectedTallesForm.remove(talle);
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
              });
            },
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 3,
          child: _buildDropdown(
            'Tipo de tela',
            ['Plano', 'Punto', 'Tejido', 'Otro'],
            'Seleccione el tipo de tela',
            selectedTipo,
            (value) {
              setState(() {
                selectedTipo = value;
              });
            },
          ),
        ),
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
      ],
      rows: aviosSeleccionados.map((avio) {
        return DataRow(cells: [
          DataCell(Text(avio['tipo'])),
          DataCell(Text(avio['talles'].join(', '))),
          DataCell(Text(avio['color'] ?? 'Ninguno')),
        ]);
      }).toList(),
    );
  }
}
