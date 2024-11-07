class Curva {
  int id;
  String talle;

  Curva({
    required this.id,
    required this.talle
  });

  factory Curva.fromJson(Map<String, dynamic> json) {
    return Curva(
      id: json['id'] ?? 0, // Valor por defecto si 'id' es nulo
      talle: json['talle'] ?? 'Sin talle',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'talle': talle,
    };
  }
}