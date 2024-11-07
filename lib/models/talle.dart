class Talle {
  int id;
  String nombre;

  Talle({
    this.id = 0,
    required this.nombre,
  });

  /// **Fábrica para crear un Avios desde JSON**
  factory Talle.fromJson(Map<String, dynamic> json) {
    return Talle(
      id: json['id'] ?? 0, // Valor por defecto si 'id' es nulo
      nombre: json['nombre'] ?? 'Sin talle',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
    };
  }
}
