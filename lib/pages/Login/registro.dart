import 'package:flutter/material.dart';

class registroScreen extends StatelessWidget {
  const registroScreen({super.key});

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
                              labelText: 'Nombre',
                              hintText: 'nombre completo',
                              border: OutlineInputBorder(),
                            ),
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
                              labelText: 'Repetir el Email',
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
                          const SizedBox(height: 20.0),
                          const TextField(
                            decoration: InputDecoration(
                              labelText: 'Repetir la Contraseña',
                              hintText: 'Mínimo 8',
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                          ),

                          const SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: () {
                              // Acción para iniciar sesión
                            },
                            child: const Text('Ingresar'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                            ),
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
