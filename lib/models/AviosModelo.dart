import 'package:gestion_indumentaria/models/Avio.dart';
import 'package:gestion_indumentaria/models/talle.dart';

class AvioModelo {
  final int? id;
  final int? modeloId;
  final int avioId;
  late final bool esPorTalle;
  late final bool esPorColor;
  late final int cantidadRequerida;
  final Avio? avio;
  late final List<Talle>? talles;

  AvioModelo({
    this.id,
    this.modeloId,
    required this.avioId,
    required this.esPorTalle,
    required this.esPorColor,
    required this.cantidadRequerida,
    this.avio,
    this.talles,
  });

  factory AvioModelo.fromJson(Map<String, dynamic> json) {
    List<Talle> talles = (json['curva'] as List? ?? []).map((t) {
      return Talle.fromJson(t);
    }).toList();

    // Verificar que el objeto `avio` no sea null en el JSON
    Avio? avio = json['avio'] != null ? Avio.fromJson(json['avio']) : null;

    // Imprimir el JSON recibido para verificar su estructura
    print('JSON de AvioModelo: $json');

    return AvioModelo(
      id: json['id'],
      modeloId: json['modeloId'],
      avioId: json['avioId'],
      esPorTalle: json['esPorTalle'],
      esPorColor: json['esPorColor'],
      cantidadRequerida: json['cantidadRequerida'],
      avio: avio,
      talles: talles,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'modeloId': modeloId,
      'avioId': avioId,
      'esPorTalle': esPorTalle,
      'esPorColor': esPorColor,
      'cantidadRequerida': cantidadRequerida,
      'avio': avio?.toJson(),
      'curva': talles?.map((t) => t.toJson()).toList(),
    };
  }
}
