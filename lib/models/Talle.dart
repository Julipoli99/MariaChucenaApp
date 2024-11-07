class Talle {
  int id;
  String nombre;

  Talle({
    this.id = 0,
    required this.nombre,
  });

  /// **Fábrica para crear un Talle desde JSON**
  factory Talle.fromJson(Map<String, dynamic> json) {
    return Talle(
      id: json['id'] ?? 0, // Valor por defecto si 'id' es nulo
      nombre: json['talle']?.isNotEmpty == true
          ? json['talle']
          : 'Sin talle', // Verificación si el nombre no está vacío
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
    };
  }
}
