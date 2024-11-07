import 'Talle.dart';

class TalleRepeticion {
  final int id;
//  final Talle talle;
  int repeticion;
  int talleId;

  TalleRepeticion({
    required this.id,
    //  required this.talle,
    required this.talleId,
    required this.repeticion,
  });

  factory TalleRepeticion.fromJson(Map<String, dynamic> json) {
    return TalleRepeticion(
      id: json['id'],
      talleId: json['talleId'],
      //     talle: Talle.fromJson(
      //        json['talle']), // Asumiendo que Talle tiene un fromJson
      repeticion: json['repeticion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'talleId': talleId,
      //   'talle': talle.toJson(), // Asumiendo que Talle tiene un toJson
      'repeticion': repeticion,
    };
  }
}
