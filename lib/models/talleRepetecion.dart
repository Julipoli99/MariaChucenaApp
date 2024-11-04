import 'Talle.dart';

class TalleRepeticion {
  final int id;
  final Talle talle;
  final int repeticion;

  TalleRepeticion({
    required this.id,
    required this.talle,
    required this.repeticion,
  });

  factory TalleRepeticion.fromJson(Map<String, dynamic> json) {
    return TalleRepeticion(
      id: json['id'],
      talle: Talle.fromJson(
          json['talle']), // Asumiendo que Talle tiene un fromJson
      repeticion: json['repeticion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'talle': talle.toJson(), // Asumiendo que Talle tiene un toJson
      'repeticion': repeticion,
    };
  }
}
