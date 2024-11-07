class Talle {
  int id;
  String talle;

  Talle({
    this.id = 1,
    required this.talle,
  });

  @override
  String toString() {
    return talle; // Devuelve solo el nombre del talle
  }

  /// **Fábrica para crear un Avios desde JSON**
  factory Talle.fromJson(Map<String, dynamic> json) {
    return Talle(
      id: json['id'] ?? 0, // Valor por defecto si 'id' es nulo
      talle: json['talle'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'talle': talle,
    };
  }
}
