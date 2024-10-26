import 'dart:convert';

import 'package:gestion_indumentaria/models/Avio.dart';
import 'package:gestion_indumentaria/models/Talle.dart';

// Clase AvioModelo
class AvioModelo {
  final int? id;
  final int? modeloId;
  final int avioId;
  final bool esPorTalle;
  final bool esPorColor;
  final int cantidadRequerida;
  final Avio? avio;
  final List<Talle>? talle;

  AvioModelo({
    this.id,
    this.modeloId,
    required this.avioId,
    required this.esPorTalle,
    required this.esPorColor,
    required this.cantidadRequerida,
    this.avio,
    this.talle,
  });

  factory AvioModelo.fromJson(Map<String, dynamic> json) {
    List<Talle> talles = (json['curva'] as List).map((t) {
      return Talle.fromJson(
          t); // Asumiendo que la API devuelve talles en formato JSON
    }).toList();
    return AvioModelo(
      id: json['id'],
      modeloId: json['modeloId'],
      avioId: json['avioId'],
      esPorTalle: json['esPorTalle'],
      esPorColor: json['esPorColor'],
      cantidadRequerida: json['cantidadRequerida'],
      avio: Avio.fromJson(json['avio']),
      talle: talles,
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
      'curva': talle?.map((t) => t.toJson()).toList(),
    };
  }
}
