import 'package:gestion_indumentaria/models/ModeloCorte.dart';
import 'package:gestion_indumentaria/models/talleRepetecion.dart';

class ModeloTizada {
  double consumo;
  int modeloCorteId;
  List<TalleRepeticion> curva;
  ModeloCorte? modelo;
  int? totalPrendas;

  ModeloTizada({
    required this.consumo,
    required this.modeloCorteId,
    required this.curva,
    this.modelo,
    this.totalPrendas,
  });

  factory ModeloTizada.fromJson(Map<String, dynamic> json) {
    return ModeloTizada(
        consumo: json['consumo'] ?? 'Sin consumo definido',
        modeloCorteId: json['modeloCorteId'] ?? 'Sin largo definido',
        curva: (json['curva'] as List).map((tr) {
          return TalleRepeticion.fromJson(tr);
        }).toList(),
        modelo: ModeloCorte.fromJson(json['modelo']),
        totalPrendas: json['totalPrendas']);
  }
  Map<String, dynamic> toJson() {
    return {
      'consumo': consumo,
      'modeloCorteId': modeloCorteId,
      'curva': curva,
    };
  }
}
