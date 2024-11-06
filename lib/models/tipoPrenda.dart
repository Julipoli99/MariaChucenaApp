class Prenda {
  int id;
  String nombre;

  Prenda({
    this.id = 0,
    required this.nombre,
  });

  /// **Fábrica para crear un Avios desde JSON**
  factory Prenda.fromJson(Map<String, dynamic> json) {
    return Prenda(
      id: json['id'] ?? 0, // Valor por defecto si 'id' es nulo
      nombre: json['tipo'] ?? 'Sin nombre',
    );
  }
}
