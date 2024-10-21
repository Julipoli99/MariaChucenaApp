import 'package:gestion_indumentaria/models/Proveedor.dart';

class Avios {
  int id;
  String nombre;
  String
      proveedores; // Por ahora lo dejamos como String, pero podría ser List<Proveedor>
  List<String>? talles;
  String? color;
  String? cantidad;

  Avios({
    this.id = 0,
    required this.nombre,
    required this.proveedores,
    this.talles,
    this.color,
    this.cantidad,
  });

  /// **Fábrica para crear un Avios desde JSON**
  factory Avios.fromJson(Map<String, dynamic> json) {
    return Avios(
      id: json['id'] ?? 0, // Valor por defecto si 'id' es nulo
      nombre: json['nombre'] ?? 'Sin nombre',
      proveedores: json['codigoProvedor'] ?? 'Sin proveedor',
      cantidad: json['stock']?.toString() ?? '0', // Convertimos stock a String
      color: json['color'] ?? 'Sin color',
      talles: (json['talles'] as List?)?.map((t) => t.toString()).toList(),
    );
  }

  /// **Método para convertir un Avios a JSON**
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'codigoProvedor': proveedores,
      'stock': cantidad,
      'color': color,
      'talles': talles,
    };
  }
}
