class prenda {
  int id;
  String? nombre;

  prenda({
    this.id = 0,
    this.nombre,
  });

  /// **Fábrica para crear un Avios desde JSON**
  factory prenda.fromJson(Map<String, dynamic> json) {
    return prenda(
      id: json['id'] ?? 0, // Valor por defecto si 'id' es nulo
      nombre: json['tipo'] ?? 'Sin nombre',
    );
  }
}
