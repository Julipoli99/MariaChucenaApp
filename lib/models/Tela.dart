class Tela {
  int id;
  String tipoDeRollo; //tubular o plano
  int proveedorId;
  double cantidad;
  String color;
  bool estampado;
  String descripcion;
  int tipoProductoId;

  Tela({
    required this.id,
    required this.tipoDeRollo,
    required this.proveedorId,
    required this.color,
    required this.cantidad,
    required this.estampado,
    required this.descripcion,
    required this.tipoProductoId,
  });

  /// **Fábrica para crear un Avios desde JSON**
  factory Tela.fromJson(Map<String, dynamic> json) {
    return Tela(
      id: json['id'] ?? 0, // Valor por defecto si 'id' es nulo
      tipoDeRollo: json['tipoDeRollo'] ?? 'Sin tipo de rollo',
      proveedorId: json['provedorId'] ?? 0,
      color: json['color'] ?? 'Sin color',
      cantidad: json['cantidad'] ?? 'Sin cantidad',
      estampado: json['estampado'] ?? 'Sin estampado',
      descripcion: json['descripcion'] ?? 'Sin descripcion',
      tipoProductoId: json['tipoProductoId'] ?? 0,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipoDeRollo': tipoDeRollo,
      'provedorId': proveedorId,
      'color': color,
      'cantidad': cantidad,
      'estampado': estampado,
      'descripcion': descripcion,
      'tipoProductoId': tipoProductoId,
    };
  }
}
