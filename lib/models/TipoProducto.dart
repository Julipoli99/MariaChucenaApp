// ignore: constant_identifier_names
enum TipoEnum { AVIO, TELA }

// ignore: constant_identifier_names
enum UnidadMetricaEnum { UNIDAD, METRO, KILO }

class TipoProducto {
  int? id; // El ID se auto genera
  String nombre;
  TipoEnum tipo;
  UnidadMetricaEnum unidadMetrica;

  TipoProducto({
    this.id,
    required this.nombre,
    required this.tipo,
    required this.unidadMetrica,
  });

  // Método para convertir de JSON a TipoProducto
  factory TipoProducto.fromJson(Map<String, dynamic> json) {
    return TipoProducto(
      id: json['id'] as int?,
      nombre: json['nombre'] as String,
      tipo: TipoEnum.values
          .firstWhere((e) => e.toString().split('.').last == json['tipo']),
      unidadMetrica: UnidadMetricaEnum.values.firstWhere(
          (e) => e.toString().split('.').last == json['unidadMetrica']),
    );
  }

  // Método para convertir de TipoProducto a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'tipo': tipo.toString().split('.').last,
      'unidadMetrica': unidadMetrica.toString().split('.').last,
    };
  }
}
