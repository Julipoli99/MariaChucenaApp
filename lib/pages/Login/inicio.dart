import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/pages/principal.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor ingrese ambos campos.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    // Realizar la llamada a la API
    const url =
        'https://maria-chucena-api-production.up.railway.app/auth/login'; // Cambiar por la URL de tu API de login
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'pass': password,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      // Para ver la estructura completa de la respuesta

      // Verifica si la API devuelve un token o información relevante
      final token = responseData['token'];
      if (token != null) {
        // Guardar token o manejar la autenticación
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        setState(() {
          _errorMessage = 'Correo electrónico o contraseña incorrectos.';
        });
      }
    } else {
      print(response.body);
      setState(() {
        _errorMessage = 'Error al iniciar sesión. Intente de nuevo.';
      });
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
              // Parte izquierda (Formulario de login)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 300),
                      child: Column(
                        children: [
                          // Limitar el ancho máximo
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
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              hintText: 'Example@email.com',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          TextField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Contraseña',
                              hintText: 'Mínimo 8',
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                          ),
                          const SizedBox(height: 20.0),
                          _isLoading
                              ? const CircularProgressIndicator() // Mostrar indicador de carga
                              : ElevatedButton(
                                  onPressed: _login,
                                  child: const Text('Ingresar'),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                  ),
                                ),
                          const SizedBox(height: 20.0),
                          if (_errorMessage.isNotEmpty)
                            Text(
                              _errorMessage,
                              style: const TextStyle(color: Colors.red),
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
                      image: AssetImage(
                          'imagen/im.jpg'), // Imagen de fondo desde la carpeta 'imagenes'
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'imagen/logo.png', // Logo desde la carpeta 'imagenes'
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
