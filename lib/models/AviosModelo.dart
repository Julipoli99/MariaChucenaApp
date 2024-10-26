import 'package:gestion_indumentaria/models/talle.dart';

class AvioModelo {
  final int avioId;
  final bool? esPorTalle;
  final bool? esPorColor;
  final List<talle>? talles;
  final int? cantidadRequerida;

  AvioModelo({
    required this.avioId,
    this.esPorTalle,
    this.esPorColor,
    this.talles,
    this.cantidadRequerida,
  });

  factory AvioModelo.fromJson(Map<String, dynamic> json) {
    return AvioModelo(
      avioId: json['avioId'],
      esPorTalle: json['esPorTalle'] ?? false,
      esPorColor: json['esPorColor'] ?? false,
      talles: (json['talles'] as List).map((t) => talle.fromJson(t)).toList(),
      cantidadRequerida: json['cantidadRequerida'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'avioId': avioId,
      'esPorTalle': esPorTalle,
      'esPorColor': esPorColor,
      'talles': talles?.map((t) => t.toJson()).toList(),
      'cantidadRequerida': cantidadRequerida,
    };
  }
}
