class TipoProducto {
  int? id; // El ID se auto genera
  String nombre;
  String tipo;
  String unidadMetrica;

  TipoProducto({
    this.id,
    required this.nombre,
    required this.tipo,
    required this.unidadMetrica,
  });

  // Método para convertir de JSON a TipoProducto
  factory TipoProducto.fromJson(Map<String, dynamic> json) {
    return TipoProducto(
      id: json['id'] as int?, // El ID se puede recibir como null
      nombre: json['nombre'] as String,
      tipo: json['tipo'] as String,
      unidadMetrica: json['unidadMetrica'] as String,
    );
  }

  // Método para convertir de TipoProducto a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id, // Solo enviar el ID si no es null
      'nombre': nombre,
      'tipo': tipo,
      'unidadMetrica': unidadMetrica,
    };
  }
}
