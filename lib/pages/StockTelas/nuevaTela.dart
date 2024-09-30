import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/widgets/DrawerMenuLateral.dart';
import 'package:gestion_indumentaria/widgets/HomePage.dart';

class nuevasTelas extends StatelessWidget {
  const nuevasTelas({super.key});

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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Columna izquierda para el título y descripción
                  const Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(right: 32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Registro de Telas',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Complete todos los detalles relevantes de la tela',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Columna derecha para el formulario
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildDropdownField('Tipo de tela',
                            ['Elige una', 'Algodón', 'Poliéster', 'Lino']),
                        buildTipoTejidoSelector(),
                        buildDropdownField('Proveedor',
                            ['Elige uno', 'Proveedor A', 'Proveedor B']),
                        buildTextField('Cantidad',
                            'Cantidad de tela registrada, en metros o kilos'),
                        buildTextField('Descripción',
                            'Nombre del color o descripción del estampado'),
                        buildTextField('Código',
                            'Código de referencia proporcionado por el proveedor'),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text('Guardar Tela'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 20),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Lógica para cargar la foto
                              },
                              child: const Text('Cargar Foto'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 20),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              // Footer
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: Text(
                          '© 2024 Maria Chucena ERP System. All rights reserved.',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para construir el dropdown con los datos
  Widget buildDropdownField(String label, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: DropdownButtonFormField<String>(
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (value) {},
              decoration: InputDecoration(
                labelText: label,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Lógica para agregar nuevo elemento
            },
          ),
        ],
      ),
    );
  }

  // Widget para construir los botones de selección de tipo de tejido
  Widget buildTipoTejidoSelector() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: ChoiceChip(
              label: const Text('Plano'),
              selected: false, // Cambiar según la lógica de selección
              onSelected: (selected) {},
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ChoiceChip(
              label: const Text('Tubular'),
              selected: false, // Cambiar según la lógica de selección
              onSelected: (selected) {},
            ),
          ),
        ],
      ),
    );
  }

  // Widget para construir los campos de texto
  Widget buildTextField(String label, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
