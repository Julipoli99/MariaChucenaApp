import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/RolloCorte.dart';
import 'package:gestion_indumentaria/models/Talle.dart';
import 'package:gestion_indumentaria/models/Tela.dart';
import 'package:gestion_indumentaria/models/observacion.dart';
import 'package:gestion_indumentaria/models/talleRepetecion.dart';
import 'package:gestion_indumentaria/pages/principal.dart';
import 'package:gestion_indumentaria/widgets/HomePage.dart';
import 'package:gestion_indumentaria/widgets/DrawerMenuLateral.dart';
import 'package:gestion_indumentaria/widgets/TalleRepeticionSelector.dart';
import 'package:http/http.dart' as http;

class OrdenDeCorteScreen extends StatefulWidget {
  const OrdenDeCorteScreen({super.key});

  @override
  _OrdenDeCorteScreenState createState() => _OrdenDeCorteScreenState();
}

class _OrdenDeCorteScreenState extends State<OrdenDeCorteScreen> {
  List<Tela> tiposDeTela = [];
  List<dynamic> modelosACortar = [];
  List<String> avios = [];
  List<TalleRepeticion> selectedTalle = [];
  Tela? selectedTipoDeTela;
  String? selectedModelo;
  String? selectedAvio;
  CategoriaTela? selectedCategoriaTela;

  double? cantidadUtilizada;
  List<ObservacionModel>? observaciones;

  String tituloObservacion = "Sin titulo";
  String descripcionObservacion = "Sin descripción";

  @override
  void initState() {
    super.initState();
    // fetchAvios();
    fetchModelo();
    fetchTiposDeTela();
  }

  /*Future<void> fetchAvios() async {
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
  }*/

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
    final response = await http.get(
        Uri.parse('https://maria-chucena-api-production.up.railway.app/rollo'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        // Crea objetos de tipo Tela en lugar de solo Strings
        tiposDeTela = List<Tela>.from(
          data.map((tipo) => Tela.fromJson(tipo)),
        );
      });
    } else {
      print('Error al cargar los tipos de tela');
    }
  }

  Future<void> createOrdenDeCorte() async {
    if (selectedTipoDeTela == null ||
        selectedModelo == null ||
        selectedTalle.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos.')),
      );
      return;
    }

    final modeloSeleccionado = modelosACortar
        .firstWhere((modelo) => modelo['nombre'] == selectedModelo);

    // Mapear los talles seleccionados (selectedTalle) a la estructura de corte
    final talleRepeticionList = selectedTalle.map((talleRepeticion) {
      return {
        'talleId': talleRepeticion
            .talleId, // Asumiendo que TalleRepeticion tiene un talleId
        'repeticion': talleRepeticion
            .repeticion, // Asumiendo que TalleRepeticion tiene un campo de repetición
      };
    }).toList();

    final orderData = {
      'modelos': [
        {
          'modeloId': modeloSeleccionado['id'],
          'totalPrendas': 1,
          'esParaEstampar': false,
          'usaTelaSecundaria': false,
          'usaTelaAuxiliar': false,
          'observaciones': [
            ObservacionModel(
              id: 1,
              titulo: tituloObservacion,
              descripcion: descripcionObservacion,
            ).toJson(),
          ],
          'curva': talleRepeticionList, // Aquí insertamos la lista de talles
        },
      ],
      'rollos': [
        {
          'rolloId': selectedTipoDeTela?.id,
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
              'BCreación de Corte',
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

  Widget _buildMainContent(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Para Tipo de Tela
              buildDropdownField(
                'Tipo de Tela',
                tiposDeTela.map((tipo) => tipo.descripcion).toList(),
                context,
                (value) {
                  setState(() {
                    // Encuentra el rollo completo según el nombre seleccionado
                    selectedTipoDeTela = tiposDeTela
                        .firstWhere((tipo) => tipo.descripcion == value);
                  });
                },
              ),
              const SizedBox(height: 10),

              // Para Modelo a Cortar
              buildDropdownField(
                'Modelo a Cortar',
                modelosACortar
                    .map((modelo) => modelo['nombre'].toString())
                    .toList(),
                context,
                (value) {
                  setState(() {
                    // Encuentra el modelo completo según el nombre seleccionado
                    selectedModelo = value;
                  });
                },
              ),

              const SizedBox(height: 10),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Observación',
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
              buildTextField('Cantidad Utilizada', (value) {
                setState(() {
                  // Convert the input string to a double
                  if (value != null && value.isNotEmpty) {
                    cantidadUtilizada = double.tryParse(
                        value); // Safely parse the string to a double
                  } else {
                    cantidadUtilizada =
                        null; // Set to null if the input is empty
                  }
                });
              }),
              const SizedBox(height: 10),
              TalleRepeticionSelector(
                selectedTalleRepeticion: selectedTalle,
                onTalleRepeticionSelected: (updatedTalleRepeticion) {
                  setState(() {
                    selectedTalle = updatedTalleRepeticion;
                  });
                },
              ),
              const SizedBox(height: 20),
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
          child: const Text('Cancelar'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: createOrdenDeCorte,
          child: const Text('Crear Orden'),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {}, // Lógica para crear tizadas
          child: const Text('Crear Tizadas'),
        ),
      ],
    );
  }

  Widget _buildSummaryCard() {
    return const Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumen',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Divider(),
            Text('Aquí aparecerá el resumen de la orden de corte.'),
            // Agrega más detalles del resumen aquí según sea necesario
          ],
        ),
      ),
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
}
