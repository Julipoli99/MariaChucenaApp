import 'package:gestion_indumentaria/models/talleRepetecion.dart';

class ModeloTizada {
  double consumo;
  int modeloCorteId;
  List<TalleRepeticion> curva;

  ModeloTizada({
    required this.consumo,
    required this.modeloCorteId,
    required this.curva,
  });

  factory ModeloTizada.fromJson(Map<String, dynamic> json) {
    return ModeloTizada(
      consumo: json['consumo'] ?? 'Sin consumo definido',
      modeloCorteId: json['modeloCorteId'] ?? 'Sin largo definido',
      curva: (json['curva'] as List).map((tr) {
        return TalleRepeticion.fromJson(
            tr); // Asegúrate de que tu clase Avios tenga este método
      }).toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'consumo': consumo,
      'modeloCorteId': modeloCorteId,
      'curva': curva,
    };
  }
}
