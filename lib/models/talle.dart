class talle {
  int id;
  String? nombre;

  talle({
    this.id = 0,
    this.nombre,
  });

  /// **Fábrica para crear un Avios desde JSON**
  factory talle.fromJson(Map<String, dynamic> json) {
    return talle(
      id: json['id'] ?? 0, // Valor por defecto si 'id' es nulo
      nombre: json['talle'] ?? 'Sin talle',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
    };
  }
}
