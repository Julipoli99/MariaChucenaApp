import 'package:flutter/material.dart';

Widget buildOptionCard(String title, String description, double width,
    double height, String imagePath) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3), // Cambia la posición de la sombra
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          width: 60,
          height: 60,
          margin: const EdgeInsets.all(10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildResourceCard(
  String title,
  String subtitle,
  double width,
  double height,
  String imagePath,
) {
  // Nuevo parámetro para manejar la navegación
  return Card(
    elevation: 2,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Imagen en la parte superior
        Image.asset(
          imagePath,
          width: width * 10,
          height: height * 0.8, // La imagen ocupará el 80% del height del Card
          fit: BoxFit
              .cover, // Ajusta la imagen para cubrir todo el espacio disponible
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 15),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildLoggedInUser(String userImage, String userRank) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(userImage),
        ),
        const SizedBox(width: 10),
        Text(
          userRank,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    ),
  );
}
