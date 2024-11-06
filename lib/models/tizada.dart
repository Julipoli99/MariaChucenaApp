import 'modeloTizada.dart';
import 'rolloTizada.dart';

class Tizada {
  double ancho;
  double largo;
  int corteId;
  List<ModeloTizada> modelos;
  List<RolloTizada> rollosUtilizados;

  Tizada({
    required this.ancho,
    required this.largo,
    required this.corteId,
    required this.modelos,
    required this.rollosUtilizados,
  });

  factory Tizada.fromJson(Map<String, dynamic> json) {
    return Tizada(
      ancho: json['ancho'] ?? 'Sin ancho definido',
      largo: json['largo'] ?? 'Sin largo definido',
      corteId: json['corteId'] ?? 'Sin corte definido',
      modelos: (json['modelos'] as List).map((av) {
        return ModeloTizada.fromJson(av);
      }).toList(),
      rollosUtilizados: (json['rollosUtilizados'] as List).map((av) {
        return RolloTizada.fromJson(av);
      }).toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'ancho': ancho,
      'largo': largo,
      'corteId': corteId,
      'modelos': modelos,
      'rollosUtilizados': rollosUtilizados,
    };
  }
}
