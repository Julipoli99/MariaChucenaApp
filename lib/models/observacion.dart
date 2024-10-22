class Observacion {
  final int id;
  final String titulo;
  final String descripcion;

  Observacion({
    required this.id,
    required this.titulo,
    required this.descripcion,
  });
  // Método toJson para convertir el objeto a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
    };
  }

  factory Observacion.fromJson(Map<String, dynamic> json) {
    return Observacion(
      id: json['id'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
    );
  }
}
