import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/Talle.dart';
import 'package:gestion_indumentaria/pages/principal.dart';
import 'package:gestion_indumentaria/widgets/HomePage.dart';
import 'package:http/http.dart' as http;
import 'package:gestion_indumentaria/widgets/DrawerMenuLateral.dart';
import 'package:gestion_indumentaria/widgets/TalleSelectorWidget.dart';

class OrdenDeCorteScreen extends StatefulWidget {
  const OrdenDeCorteScreen({super.key});

  @override
  _OrdenDeCorteScreenState createState() => _OrdenDeCorteScreenState();
}

class _OrdenDeCorteScreenState extends State<OrdenDeCorteScreen> {
  List<String> tiposDeTela = [];
  List<dynamic> modelosACortar = [];
  List<String> avios = [];
  List<Talle> selectedTalle = [];
  String? selectedTipoDeTela;
  String? selectedModelo;
  String? selectedAvio;
  String? observaciones;

  @override
  void initState() {
    super.initState();
    fetchAvios();
    fetchModelo();
    fetchTiposDeTela();
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

  Future<void> createOrdenDeCorte() async {
    if (selectedTipoDeTela == null ||
        selectedModelo == null ||
        selectedAvio == null ||
        selectedTalle.isEmpty || // Verifica que selectedTalle no esté vacío
        observaciones == null) {
      // Mostrar un mensaje de error si falta algún campo
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos.')),
      );
      return;
    }

    final orderData = {
      'tipoDeTela': selectedTipoDeTela,
      'modelo': selectedModelo,
      'avio': selectedAvio,
      'observaciones': observaciones,
      'talles': selectedTalle
          .map((talle) => talle.toJson())
          .toList(), // Envía los talles como un arreglo
      // Aquí deberías agregar la lista de rollos si es necesario
    };

    try {
      final response = await http.post(
        Uri.parse('https://maria-chucena-api-production.up.railway.app/corte'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(orderData),
      );

      if (response.statusCode == 201) {
        // La orden de corte fue creada exitosamente
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Orden de corte creada exitosamente.')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        // Manejar error, muestra el cuerpo de la respuesta
        final responseBody = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Error al crear la orden de corte: ${responseBody['message'] ?? 'Error desconocido'}')),
        );
      }
    } catch (e) {
      // Manejar excepciones de la red o del cliente
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e')),
      );
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
              'Bienvenidos al sistema de Gestión de corte',
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
              buildDropdownField('Tipo de Tela', tiposDeTela, context, (value) {
                setState(() {
                  selectedTipoDeTela = value;
                });
              }),
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
              }),
              const SizedBox(height: 10),
              buildDropdownField('Avíos', avios, context, (value) {
                setState(() {
                  selectedAvio = value;
                });
              }),
              const SizedBox(height: 10),
              buildTextField('Observaciones', (value) {
                setState(() {
                  observaciones = value;
                });
              }),
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
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[300],
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lista de cosas cargadas:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: modelosACortar.length,
              itemBuilder: (context, index) {
                final modelo = modelosACortar[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(modelo['nombre'].toString()),
                    // Aquí puedes mostrar más detalles del modelo si lo deseas
                    const Divider(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDropdownField(String label, List<String> items,
      BuildContext context, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      isExpanded: true,
    );
  }

  Widget buildTextField(String label, Function(String) onChanged) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      onChanged: onChanged,
    );
  }
}
