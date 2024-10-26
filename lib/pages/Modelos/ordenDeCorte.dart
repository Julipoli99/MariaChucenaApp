import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/pages/Avios/nuevoAvios.dart';
import 'package:gestion_indumentaria/pages/Modelos/NuevoModelo.dart';
import 'package:gestion_indumentaria/pages/TipoDeTelas/NuevoTipoDeTela.dart';
import 'package:gestion_indumentaria/widgets/DrawerMenuLateral.dart';
import 'package:gestion_indumentaria/widgets/HomePage.dart';
import 'package:gestion_indumentaria/widgets/TalleSelectorWidget.dart'; // Import del widget

class OrdenDeCorteScreen extends StatefulWidget {
  @override
  _OrdenDeCorteScreenState createState() => _OrdenDeCorteScreenState();
}

class _OrdenDeCorteScreenState extends State<OrdenDeCorteScreen> {
  final List<String> tiposDeTela = ['Algodón', 'Poliéster', 'Lino'];
  final List<String> modelosACortar = ['Modelo A', 'Modelo B', 'Modelo C'];
  final List<String> avios = ['Botones', 'Cremalleras', 'Hilos'];
  String? selectedTalle; // Estado para el talle seleccionado

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
              buildDropdownField('Tipo de Tela', tiposDeTela, context),
              const SizedBox(height: 10),
              buildDropdownField('Modelo a Cortar', modelosACortar, context),
              const SizedBox(height: 10),
              buildDropdownField('Avíos', avios, context),
              const SizedBox(height: 10),
              buildTextField('Observaciones'),
              const SizedBox(height: 10),
              TalleSelector(
                selectedTalle: selectedTalle,
                onTalleSelected: (talle) {
                  setState(() {
                    selectedTalle = talle;
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
          onPressed: () {},
          child: const Text('Cancelar'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Crear Orden'),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {},
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
          buildListItem('Tela: ${tiposDeTela[0]}', context),
          buildListItem('Modelo: ${modelosACortar[0]}', context),
          buildListItem('Avíos: ${avios[0]}', context),
          const SizedBox(height: 10),
          const Text(
            'Detalles adicionales:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Text('• Fecha de creación: 10-10-2021'),
          const Text('• Estado: En progreso'),
        ],
      ),
    );
  }
}

Widget buildDropdownField(
    String label, List<String> items, BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 5),
      Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (value) {},
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              if (label == 'Tipo de Tela') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Nuevotipodetela(),
                  ),
                );
              } else if (label == 'Modelo a Cortar') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Nuevomodelo(),
                  ),
                );
              } else if (label == 'Avíos') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Nuevoavios(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    ],
  );
}

Widget buildTextField(String label) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 5),
      TextField(
        maxLines: 3,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    ],
  );
}

Widget buildListItem(String text, BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(text),
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {},
      ),
    ],
  );
}
