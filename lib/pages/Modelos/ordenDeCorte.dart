import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/pages/Avios/nuevoAvios.dart';
import 'package:gestion_indumentaria/pages/Modelos/NuevoModelo.dart';
import 'package:gestion_indumentaria/pages/Telas/nuevaTela.dart';
import 'package:gestion_indumentaria/widgets/DrawerMenuLateral.dart';
import 'package:gestion_indumentaria/widgets/HomePage.dart';

class OrdenDeCorteScreen extends StatelessWidget {
  final List<String> tiposDeTela = [
    'Algodón',
    'Poliéster',
    'Lino'
  ]; // Ejemplo de datos desde la base de datos
  final List<String> modelosACortar = [
    'Modelo A',
    'Modelo B',
    'Modelo C'
  ]; // Ejemplo de datos desde la base de datos
  final List<String> avios = [
    'Botones',
    'Cremalleras',
    'Hilos'
  ]; // Ejemplo de datos desde la base de datos
  final List<String> talles = ['S', 'M', 'L', 'XL']; // Tipos de talles

  OrdenDeCorteScreen({super.key});

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
              // Encabezado
              Container(
                color: Colors.grey[800],
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                child: const Center(
                  child: Column(
                    children: [
                      Text(
                        'Bienvenidos al sistema de Gestion de corte ',
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
              ),
              const SizedBox(height: 20),

              // Formulario
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildDropdownField(
                            'Tipo de Tela', tiposDeTela, context),
                        const SizedBox(height: 10),
                        buildDropdownField(
                            'Modelo a Cortar', modelosACortar, context),
                        const SizedBox(height: 10),
                        buildDropdownField('Avíos', avios, context),
                        const SizedBox(height: 10),
                        buildTextField('Observaciones'),
                        const SizedBox(height: 10),
                        buildTalleSelector(),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 20),

                  // Cuadro gris con lista de cosas cargadas
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.grey[300],
                      height: 400, // Ajuste del alto del cuadro
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Lista de cosas cargadas:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Aquí se pueden mostrar los datos cargados para el modelo
                          buildListItem('Tela: ${tiposDeTela[0]}', context),
                          buildListItem(
                              'Modelo: ${modelosACortar[0]}', context),
                          buildListItem('Avíos: ${avios[0]}', context),
                          const SizedBox(height: 10),
                          // Mostrar más detalles tomados de la base de datos
                          const Text(
                            'Detalles adicionales:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text('• Fecha de creación: 10-10-2021'),
                          const Text('• Estado: En progreso'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Pie de página
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

  // Widget para construir el dropdown con los datos
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
                // Navegar a la pantalla correspondiente según el label
                if (label == 'Tipo de Tela') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const nuevasTelas(),
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

  // Widget para construir el campo de texto
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

  // Widget para construir los botones de selección de talles
  Widget buildTalleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Talle',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Row(
          children: List.generate(talles.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: ChoiceChip(
                label: Text(talles[index]),
                selected: false, // Cambiar según la lógica de selección
                onSelected: (selected) {},
              ),
            );
          }),
        ),
      ],
    );
  }

  // Widget para construir un elemento de la lista con botón "x"
  Widget buildListItem(String text, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            // Lógica para eliminar o navegar a una nueva pantalla si es necesario
          },
        ),
      ],
    );
  }
}

// Página de ejemplo para agregar un nuevo elemento
class NewItemScreen extends StatelessWidget {
  const NewItemScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Nuevo Elemento')),
      body: Center(
        child: const Text('Aquí puedes agregar un nuevo elemento.'),
      ),
    );
  }
}
