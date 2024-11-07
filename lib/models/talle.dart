class Talle {
  int id;
  String nombre;

  Talle({
    this.id = 0,
    required this.nombre,
  });

<<<<<<< HEAD
  /// **Fábrica para crear un Talle desde JSON**
=======
  /// **Fábrica para crear un Avios desde JSON**
>>>>>>> 0d46c86ab392a295e493474be22081c4fc5d7e49
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
