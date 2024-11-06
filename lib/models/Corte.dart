import 'ModeloCorte.dart';
import 'RolloCorte.dart';

class Corte {
  final int id;
  final List<ModeloCorte> modelos;
  final List<RolloCorte> rollos;

  Corte({
    required this.id,
    required this.modelos,
    required this.rollos,
  });

  factory Corte.fromJson(Map<String, dynamic> json) {
    return Corte(
      id: json['id'],
      modelos: (json['modelos'] as List<dynamic>?)
              ?.map((modelo) => ModeloCorte.fromJson(
                  modelo)) // Asegúrate que el tipo sea correcto
              .toList() ??
          [], // Retorna lista vacía si es null
      rollos: (json['rollos'] as List<dynamic>?)
              ?.map((rollo) =>
                  RolloCorte.fromJson(rollo)) // Cambia Tela por RolloCorte
              .toList() ??
          [], // Retorna lista vacía si es null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'modelos': modelos.map((model) => model.toJson()).toList(),
      'rollos': rollos.map((rollo) => rollo.toJson()).toList(),
    };
  }
}
