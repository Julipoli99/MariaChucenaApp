// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/Modelo.dart';
import 'package:gestion_indumentaria/models/RolloCorte.dart';
import 'package:gestion_indumentaria/models/TipoProducto.dart';
import 'package:gestion_indumentaria/models/Tela.dart';
import 'package:gestion_indumentaria/models/observacion.dart';
import 'package:gestion_indumentaria/models/talleRepetecion.dart';
import 'package:gestion_indumentaria/pages/Tizadas/CreacionTizadasPage.dart';
import 'package:gestion_indumentaria/pages/principal.dart';
import 'package:gestion_indumentaria/widgets/HomePage.dart';
import 'package:gestion_indumentaria/widgets/DrawerMenuLateral.dart';
import 'package:gestion_indumentaria/widgets/TalleRepeticionSelector.dart';
import 'package:gestion_indumentaria/widgets/boxDialog/modelo/modeloPorGeneroYPrendaSelector.dart';
import 'package:gestion_indumentaria/widgets/boxDialog/prenda/prendaSelectorWidget.dart';
import 'package:http/http.dart' as http;

class OrdenDeCorteScreen extends StatefulWidget {
  const OrdenDeCorteScreen({super.key});

  @override
  _OrdenDeCorteScreenState createState() => _OrdenDeCorteScreenState();
}

class _OrdenDeCorteScreenState extends State<OrdenDeCorteScreen> {
  //Tipo de tela
  List<TipoProducto> tipoProductos = [];
  int? selectedTipoProductoId;

  //Rollo
  List<dynamic> tiposDeTela = [];
  CategoriaTela? selectedCategoriaTela;
  Tela? selectedTipoDeTela;
  int? selectedTelaId;
  double? cantidadUtilizada;

  //Modelo
  List<dynamic> modelosACortar = [];
  int? selectedPrendaId;
  String? selectedGenero;
  final List<String> generos = ['MASCULINO', 'FEMENINO', 'UNISEX'];

  Modelo? modeloSeleccionadoCompleto;
  int? selectedModeloId;

  //Curva
  List<TalleRepeticion> selectedTalle = [];

  //Observacion
  List<ObservacionModel>? observaciones;
  String tituloObservacion = "Sin titulo";
  String descripcionObservacion = "Sin descripción";

  @override
  void initState() {
    super.initState();
    fetchModelo();
    fetchTiposDeTela();
    fetchTipoProductos();
  }

  Future<void> fetchModelo() async {
    final response = await http.get(Uri.parse(
        'https://maria-chucena-api-production.up.railway.app/modelo'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        modelosACortar = data;
      });
      print(modelosACortar);
    } else {
      print('Error al cargar los modelos');
    }
  }

  Future<void> fetchTiposDeTela() async {
    final response = await http.get(
        Uri.parse('https://maria-chucena-api-production.up.railway.app/rollo'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(response.body);
      setState(() {
        // Crea objetos de tipo Tela en lugar de solo Strings
        tiposDeTela = List<Tela>.from(
          data.map((tipo) => Tela.fromJson(tipo)),
        );
        print(tiposDeTela);
      });
    } else {
      print('Error al cargar los tipos de tela');
    }
  }

  Tela? getTelaCompleto(int id) {
    try {
      final selectedTipoDeTela = tiposDeTela.firstWhere(
        (tela) => tela.id == id,
      );
      return selectedTipoDeTela;
    } catch (e) {
      print('Tipo de tela no encontrado: $selectedTipoDeTela');
      return null;
    }
  }

  Modelo? getModeloCompleto(int id) {
    print('MODELO ID SELECCIONADO DENTRO DE GET MODELO: $selectedModeloId');
    try {
      final modeloSeleccionadoCompleto = modelosACortar.firstWhere(
        (modelo) => modelo.id == id,
      );
      return modeloSeleccionadoCompleto;
    } catch (e) {
      print('Tipo de modelo no encontrado: $modeloSeleccionadoCompleto');
      return null;
    }
  }

  Future<void> fetchTipoProductos() async {
    const url =
        'https://maria-chucena-api-production.up.railway.app/tipo-producto';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        tipoProductos = data
            .map((item) => TipoProducto.fromJson(item))
            .where((tipo) => tipo.tipo == TipoEnum.TELA)
            .toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Error al cargar tipos de productos: ${response.body}')),
      );
    }
  }

  Future<void> createOrdenDeCorte() async {
    print(
        'DENTRO DE CREAR ORDEN: telaID: $selectedTelaId   - MODELO $selectedModeloId   -  TALLES $selectedTalle');

    if ((selectedTelaId) == null ||
        (selectedModeloId) == null ||
        selectedTalle.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos.')),
      );
      return;
    }

    // Mapear los talles seleccionados (selectedTalle) a la estructura de corte
    // Mapear los talles seleccionados
    final talleRepeticionList = selectedTalle.map((talleRepeticion) {
      return {
        'talleId': talleRepeticion.talleId,
        'repeticion': talleRepeticion.repeticion,
      };
    }).toList();

    final orderData = {
      'modelos': [
        {
          'modeloId': selectedModeloId,
          'totalPrendas': 1,
          'esParaEstampar': false,
          'usaTelaSecundaria': false,
          'usaTelaAuxiliar': false,
          'observaciones': [
            {
              'titulo': tituloObservacion,
              'descripcion': descripcionObservacion,
            }
          ],
          'curva': talleRepeticionList, // Aquí insertamos la lista de talles
        },
      ],
      'rollos': [
        {
          'rolloId': selectedTelaId,
          'categoria': selectedCategoriaTela.toString().split('.').last,
          'cantidadUtilizada': cantidadUtilizada,
        },
      ],
    };
    print(' PREVIO AL TRYCATCH $orderData');
    try {
      final response = await http.post(
        Uri.parse('https://maria-chucena-api-production.up.railway.app/corte'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(orderData),
      );
      print('DENTRO DEL TRYCATCH $orderData');

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Orden de corte creada exitosamente.')),
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
                  'Error al crear la orden de corte: ${responseBody['message'] ?? 'Error desconocido'}')),
        );
        print(
            'Error al crear la orden de corte: ${responseBody['message'] + response.statusCode ?? 'Error desconocido'}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e')),
      );
      print('Error de conexión: $e');
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeBanner(),
              const SizedBox(height: 20),
              _buildMainContent(context),
              const SizedBox(height: 40),
              const Center(
                child: Text(
                  '© 2024 Maria Chucena ERP System. All rights reserved.',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeBanner() {
    return Container(
      color: Colors.grey[800],
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      child: const Center(
        child: Column(
          children: [
            Text(
              'Creación de Corte',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'De Maria Chucena ERP System',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

//contenedor principal
  Widget _buildMainContent(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Rollo'),
              buildDropdownTipoProducto(),

              const SizedBox(height: 10),
              buildDropdownRollo(),

              const SizedBox(height: 10),
              //cantidad
              buildTextField('Cantidad Utilizada', (value) {
                setState(() {
                  // Convert the input string to a double
                  if (value != null && value.isNotEmpty) {
                    cantidadUtilizada = double.tryParse(value); // Safely parse
                  } else {
                    cantidadUtilizada = null; // Set to null if input is empty
                  }
                });
              }),
              const SizedBox(height: 20),
              // Sección: Modelo a Cortar
              _buildSectionTitle('Modelo'),

              const SizedBox(height: 10),

              //         buildDropdownModelo(),
              PrendaSelectorWidget(
                selectedPrendaId: selectedPrendaId,
                onPrendaSelected: (id) {
                  setState(() {
                    selectedPrendaId = id; // Guarda el id seleccionado
                  });
                },
              ),
              const SizedBox(height: 10),

              buildDropdownGenero(),
              const SizedBox(height: 10),

              ModeloPorGeneroYPrendaSelectorWidget(
                selectedModeloId: selectedModeloId,
                genero: selectedGenero,
                categoriaPrenda: selectedPrendaId,
                onModeloSelected: (id) {
                  setState(() {
                    selectedModeloId = id; // Guarda el id seleccionado
                  });
                },
              ),
              const SizedBox(height: 10),
              // boton estampado falta funcionalidad
              _buildAuxSelection(),
              const SizedBox(height: 10),

              // Sección: Categoría
              _buildSectionTitle('Categoría'),
              buildDropdownField(
                'Categoría',
                CategoriaTela.values
                    .map((e) => e.toString().split('.').last)
                    .toList(),
                context,
                (value) {
                  setState(() {
                    selectedCategoriaTela = CategoriaTela.values.firstWhere(
                        (e) => e.toString().split('.').last == value);
                  });
                },
              ),
              const SizedBox(height: 10),

              // Sección: Talle y Repetición
              _buildSectionTitle('Talle y Repetición'),
              TalleRepeticionSelector(
                selectedTalleRepeticion: selectedTalle,
                onTalleRepeticionSelected: (updatedTalleRepeticion) {
                  setState(() {
                    selectedTalle = updatedTalleRepeticion;
                  });
                },
              ),

              const SizedBox(height: 20),
              // Sección: Observaciones
              _buildSectionTitle('Observación'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Título',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        tituloObservacion = value;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Título'),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Descripción',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        descripcionObservacion = value;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Descripción'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildActionButtons(),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 1,
          child: _buildSummaryCard(),
        ),
      ],
    );
  }

// boton estampado falta funcionalidad
  bool? selectedAuxForm = false;
  bool? selectedPrimForm = false;
  final List<String> auxOptions = ['es estampado'];
  String? selectedAux;

  Widget _buildAuxSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Seleccione si tiene estampa:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: auxOptions.map((aux) {
            return ChoiceChip(
              label: Text(aux),
              selected: selectedAux == aux,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedAux = aux;
                    selectedAuxForm = true;
                  } else {
                    selectedAux = null;
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

// Método auxiliar para agregar título a cada sección
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
          ),
          child: const Text('Cancelar'),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: createOrdenDeCorte,
          child: const Text('Crear Orden'),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreacionTizadasPage(
                  idCorte: 3,
                ),
              ),
            );
          }, // Lógica para crear tizadas
          child: const Text('Crear Tizadas'),
        ),
      ],
    );
  }

  Widget buildDropdownField(String label, List<String> items,
      BuildContext context, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: items
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: onChanged,
      hint: const Text('Selecciona una opción'),
    );
  }

  Widget buildTextField(String label, ValueChanged<String?> onChanged) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
    );
  }

  Widget buildDropdownTipoProducto() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: DropdownButtonFormField<int>(
        decoration: InputDecoration(
          labelText: 'Tipo de Tela',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        items: tipoProductos.map((tipoProducto) {
          return DropdownMenuItem<int>(
            value: tipoProducto.id,
            child: Text(tipoProducto.nombre),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedTipoProductoId = value;
          });
        },
      ),
    );
  }

  Widget buildDropdownRollo() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: DropdownButtonFormField<int>(
        decoration: InputDecoration(
          labelText: 'Rollo de Tela',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        items: tiposDeTela
            .where((tela) =>
                tela.tipoProductoId ==
                selectedTipoProductoId) // Filtrar por tipoProductoId
            .map((tela) {
          return DropdownMenuItem<int>(
            value: tela.id,
            child: Text(tela.descripcion ?? 'Sin descripción'),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedTelaId = value;
          });
        },
        value: selectedTelaId,
      ),
    );
  }

  Widget buildDropdownGenero() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Género',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        // Los ítems en el Dropdown
        items: generos.map((genero) {
          return DropdownMenuItem<String>(
            value: genero,
            child: Text(genero),
          );
        }).toList(),
        // Cuando se selecciona un valor
        onChanged: (value) {
          setState(() {
            selectedGenero = value;
          });
        },
        value: selectedGenero,
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumen',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Divider(),
            selectedModeloId != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Modelo seleccionado: $selectedModeloId'),
                      Text(
                          'Tipo de tela: ${selectedTipoDeTela?.descripcion ?? 'Ninguno'}'),
                      Text(
                          'Cantidad utilizada: ${cantidadUtilizada ?? 'No especificada'}'),
                      Text(
                          'Categoría: ${selectedCategoriaTela?.toString().split('.').last ?? 'No especificada'}'),
                      const SizedBox(height: 10),
                      const Text(
                        'Observación:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('Título: $tituloObservacion'),
                      Text('Descripción: $descripcionObservacion'),
                      const SizedBox(height: 10),
                      const Text(
                        'Detalles completos del modelo:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                          'Código: ${modeloSeleccionadoCompleto?.codigo ?? 'No disponible'}'),
                      Text(
                          'Nombre: ${modeloSeleccionadoCompleto?.nombre ?? 'No disponible'}'),
                      Text(
                          'Categoría: ${modeloSeleccionadoCompleto?.categoriaTipo ?? 'No disponible'}'),
                      Text(
                          'Género: ${modeloSeleccionadoCompleto?.genero ?? 'No disponible'}'),
                      const SizedBox(height: 10),
                      const Text(
                        'Talles seleccionados:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      for (var talle in selectedTalle)
                        Text(
                            'Talle ID: ${talle.talleId}, Repetición: ${talle.repeticion}'),
                    ],
                  )
                : const Text('No se ha seleccionado ningún modelo.'),
          ],
        ),
      ),
    );
  }
}
