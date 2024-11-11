import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/pages/principal.dart';
import 'package:http/http.dart' as http;

enum TipoUsuario { USUARIO, ADMINISTRADOR, MODERADOR }

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  _RegistroScreenState createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _emailController = TextEditingController();
  final _contrasenaController = TextEditingController();
  TipoUsuario? _tipoUsuario =
      TipoUsuario.USUARIO; // Valor inicial del tipo de usuario

  // Función para registrar un nuevo usuario
  Future<void> crearUsuario() async {
    final url =
        'https://maria-chucena-api-production.up.railway.app/auth/register'; // Reemplaza con la URL de tu API
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nombre': _nombreController.text,
        'apellido': _apellidoController.text,
        'email': _emailController.text,
        'password': _contrasenaController.text,
        'tipoUsuario': _tipoUsuario
            .toString()
            .split('.')
            .last, // Convertir a string (USUARIO, ADMINISTRADOR, MODERADOR)
      }),
    );

    if (response.statusCode == 201) {
      // Si la respuesta es exitosa, mostramos un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuario creado exitosamente.'),
          backgroundColor: Colors.green,
        ),
      );
      // Redirigir a la pantalla principal
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      // Si la respuesta no es exitosa, mostramos un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al crear el usuario.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Parte izquierda (Formulario de registro)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 300),
                      child: Column(
                        children: [
                          const Text(
                            'Bienvenido A Maria Chucena',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20.0),
                          TextField(
                            controller: _nombreController,
                            decoration: const InputDecoration(
                              labelText: 'Nombre',
                              hintText: 'nombre completo',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          TextField(
                            controller: _apellidoController,
                            decoration: const InputDecoration(
                              labelText: 'Apellido',
                              hintText: 'apellido completo',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          TextField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              hintText: 'example@email.com',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          TextField(
                            controller: _contrasenaController,
                            decoration: const InputDecoration(
                              labelText: 'Contraseña',
                              hintText: 'Mínimo 8 caracteres',
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                          ),
                          const SizedBox(height: 20.0),
                          // Dropdown para seleccionar el tipo de usuario
                          DropdownButtonFormField<TipoUsuario>(
                            value: _tipoUsuario,
                            decoration: const InputDecoration(
                              labelText: 'Tipo de Usuario',
                              border: OutlineInputBorder(),
                            ),
                            items: TipoUsuario.values.map((TipoUsuario tipo) {
                              return DropdownMenuItem<TipoUsuario>(
                                value: tipo,
                                child: Text(tipo.toString().split('.').last),
                              );
                            }).toList(),
                            onChanged: (TipoUsuario? nuevoTipo) {
                              setState(() {
                                _tipoUsuario = nuevoTipo;
                              });
                            },
                          ),
                          const SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: crearUsuario,
                            child: const Text('Crear Cuenta'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
                                ),
                              );
                              // Acción para CANCELAR
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(
                                  double.infinity, 50), // Ajusta el tamaño
                            ),
                            child: const Text('Cancelar'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 50.0),
              // Parte derecha (Imagen y logo)
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('imagen/im.jpg'), // Imagen de fondo
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'imagen/logo.png', // Logo
                          height: 500,
                          width: 500,
                        ),
                        const SizedBox(height: 100.0),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
