class ObservacionModel {
  final int id;
  final String? titulo;
  final String? descripcion;
  final int? modeloCorteId;

  ObservacionModel({
    required this.id,
    this.titulo,
    this.descripcion,
    this.modeloCorteId = 0,
  });
  // Método toJson para convertir el objeto a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
    };
  }

  factory ObservacionModel.fromJson(Map<String, dynamic> json) {
    return ObservacionModel(
      id: json['id'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      modeloCorteId: json[' this.modeloCorteId'],
    );
  }
}
