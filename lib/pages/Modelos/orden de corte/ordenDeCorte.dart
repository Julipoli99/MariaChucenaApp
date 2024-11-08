import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/models/Proveedor.dart';
import 'package:gestion_indumentaria/models/RolloCorte.dart';
import 'package:gestion_indumentaria/models/TipoProducto.dart';
import 'package:gestion_indumentaria/models/talle.dart';
import 'package:gestion_indumentaria/models/Tela.dart';
import 'package:gestion_indumentaria/models/observacion.dart';
import 'package:gestion_indumentaria/models/talleRepetecion.dart';
import 'package:gestion_indumentaria/pages/Tizadas/CreacionTizadasPage.dart';
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
  Map<String, dynamic>? modeloSeleccionadoCompleto;
  List<String> avios = [];
  List<TalleRepeticion> selectedTalle = [];
  Tela? selectedTipoDeTela;
  String? selectedModelo;
  String? selectedAvio;
  CategoriaTela? selectedCategoriaTela;
  List<Tela> telas = [];
  List<Proveedor> proveedores = [];
  double? cantidadUtilizada;
  List<ObservacionModel>? observaciones;
  int? selectedTipoProductoId;
  int? selectedprovedorId;
  String tituloObservacion = "Sin titulo";
  String descripcionObservacion = "Sin descripción";
  List<TipoProducto> tipoProductos = [];

  @override
  void initState() {
    super.initState();
    fetchModelo();
    fetchTiposDeTela();
    fetchTipoProductos();
    fetchProveedores();
  }

//api

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

  Future<void> fetchProveedores() async {
    const url = 'https://maria-chucena-api-production.up.railway.app/proveedor';
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        print(response.body);
        setState(() {
          proveedores =
              jsonData.map((json) => Proveedor.fromJson(json)).toList();
        });
      } else {
        print("Error: Código de estado ${response.statusCode}");
      }
    } catch (e) {
      print("Error al cargar los proveedores: $e");
    }
  }

  String? getNombreProveedor(int proveedorId) {
    try {
      final proveedor = proveedores.firstWhere(
        (proveedor) => proveedor.id == proveedorId,
      );
      return proveedor.nombre;
    } catch (e) {
      print('Tipo de provedor no encontrado: $proveedorId');
      return null; // Retorna null si no se encuentra
    }
  }

  String? getNombreProducto(int tipoProductoId) {
    try {
      final tipoProducto = tipoProductos.firstWhere(
        (tipoProducto) => tipoProducto.id == tipoProductoId,
      );
      return tipoProducto
          .nombre; // Retorna el nombre del tipo de producto encontrado
    } catch (e) {
      print('Tipo de producto no encontrado: $tipoProductoId');
      return null; // Retorna null si no se encuentra
    }
  }
  // Lista para almacenar tipos de productos

  Future<void> fetchTipoProductos() async {
    const url =
        'https://maria-chucena-api-production.up.railway.app/tipo-Producto'; // Asegúrate de que esta URL sea correcta
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);

        setState(() {
          tipoProductos =
              jsonData.map((json) => TipoProducto.fromJson(json)).toList();
        });
      } else {
        print("Error: Código de estado ${response.statusCode}");
      }
    } catch (e) {
      print("Error al cargar los tipos de productos: $e");
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
          'modeloId': modeloSeleccionadoCompleto?['id'],
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

  // Lista para almacenar tipos de productos

//final de api

//pantalla
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
//final pantalla principal

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
              //tipo producto falta completar funcionalidad
              // Sección: Tipo de Tela (Rollo)
              _buildSectionTitle('Rollo'),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Tipo de Producto'),
                value: selectedTipoProductoId,
                items: tiposDeTela.map((tipoProducto) {
                  return DropdownMenuItem<int>(
                    value: tipoProducto.id,
                    child: Text({getNombreProducto(tipoProducto.tipoProductoId)}
                        .toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedTipoProductoId = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              //provedor falta hacer funcionalidad
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Tipo de Provedor'),
                value: selectedprovedorId,
                items: tiposDeTela.map((tipoProvedor) {
                  return DropdownMenuItem<int>(
                    value: tipoProvedor.id,
                    child: Text(tipoProvedor.proveedorId.toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedprovedorId = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              //rollo falta hacer funcionalidad
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Tipo de rollo'),
                value: selectedprovedorId,
                items: tiposDeTela.map((tipoProvedor) {
                  return DropdownMenuItem<int>(
                    value: tipoProvedor.id,
                    child: Text(tipoProvedor.proveedorId.toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedprovedorId = value;
                  });
                },
              ),
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
              const SizedBox(height: 10),
              // Sección: Modelo a Cortar
              //falta modificar tipo prenda funcionalidad
              _buildSectionTitle('Modelo a Cortar'),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Tipo de prenda'),
                value: selectedprovedorId,
                items: tiposDeTela.map((tipoProvedor) {
                  return DropdownMenuItem<int>(
                    value: tipoProvedor.id,
                    child: Text(tipoProvedor.proveedorId.toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedprovedorId = value;
                  });
                },
              ),
              //falta funcionalidad y cambios en genero
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Tipo de Genero'),
                value: selectedprovedorId,
                items: tiposDeTela.map((tipoProvedor) {
                  return DropdownMenuItem<int>(
                    value: tipoProvedor.id,
                    child: Text(tipoProvedor.proveedorId.toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedprovedorId = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              //modelos falta funcionalidad coinicidan con la busqueda. En nombre debe ser CÓDIGO+NOMBRE

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Modelo',
                  border: OutlineInputBorder(),
                ),
                items: modelosACortar.map((modelo) {
                  return DropdownMenuItem<String>(
                    value: modelo['nombre'],
                    child: Text(modelo['nombre']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedModelo = value;
                    modeloSeleccionadoCompleto = modelosACortar.firstWhere(
                        (modelo) => modelo['nombre'] == selectedModelo);
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
              selected: selectedAux == aux, // Compara con la opción actual
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedAux = aux; // Asigna la opción seleccionada
                    selectedAuxForm = true; // Marca como seleccionada
                  } else {
                    selectedAux = null; // Deselect all
                    selectedAuxForm = false; // Desmarca
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
        style: TextStyle(
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
            selectedModelo != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Modelo seleccionado: $selectedModelo'),
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
                          'ID: ${modeloSeleccionadoCompleto?['id'] ?? 'No disponible'}'),
                      Text(
                          'Nombre: ${modeloSeleccionadoCompleto?['nombre'] ?? 'No disponible'}'),
                      Text(
                          'Categoría: ${modeloSeleccionadoCompleto?['categoria'] ?? 'No disponible'}'),
                      Text(
                          'Género: ${modeloSeleccionadoCompleto?['genero'] ?? 'No disponible'}'),
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
