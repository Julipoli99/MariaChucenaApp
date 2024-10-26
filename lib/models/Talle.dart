class Talle {
  int id;
  String? nombre;

  Talle({
    this.id = 0,
    this.nombre,
  });

  /// **Fábrica para crear un Avios desde JSON**
  factory Talle.fromJson(Map<String, dynamic> json) {
    return Talle(
      id: json['id'] ?? 0, // Valor por defecto si 'id' es nulo
<<<<<<< HEAD
      nombre: json['nombre'] ?? 'Sin talle',
=======
      nombre: json['talle'] ?? 'Sin talle',
>>>>>>> a344e340814a4b7f4af04f18294f091010270c7b
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
    };
  }
}
