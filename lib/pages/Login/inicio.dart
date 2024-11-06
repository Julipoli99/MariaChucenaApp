import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/pages/Login/recuperarContrase%C3%B1a.dart';
import 'package:gestion_indumentaria/pages/Login/registro.dart';
import 'package:gestion_indumentaria/pages/principal.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                          const TextField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'Example@email.com',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          const TextField(
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              hintText: 'Mínimo 8',
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                          ),
                          const SizedBox(height: 10.0),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RecuperacionScreen()),
                              );
                            },
                            child: const Text('¿Has olvidado tu contraseña?'),
                          ),
                          const SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomePage()),
                              );
                            },
                            child: const Text('Ingresar'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                            ),
                          ),
                          const SizedBox(height: 20.0),
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
