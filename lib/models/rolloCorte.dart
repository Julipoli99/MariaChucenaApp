import 'Tela.dart';

enum CategoriaTela { PRIMARIA, SECUNDARIA, TERCIARIA }

class RolloCorte {
  int id;
  double? cantidadUtilizada;
  Tela? rollo;
  final CategoriaTela categoria;
  final int rolloId;

  RolloCorte({
    required this.id,
    this.cantidadUtilizada,
    this.rollo,
    required this.categoria,
    required this.rolloId,
  });

  factory RolloCorte.fromJson(Map<String, dynamic> json) {
    return RolloCorte(
      id: json['id'],
      cantidadUtilizada: json['cantidadUtilizada'],
      rollo: json['rollo'] != null ? Tela.fromJson(json['rollo']) : null,
      categoria: CategoriaTela.values.firstWhere(
          (e) => e.toString() == 'CategoriaTela.${json['categoria']}'),
      rolloId: json['rolloId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cantidadUtilizada': cantidadUtilizada,
      'categoria': categoria.toString().split('.').last,
      'rolloId': rolloId,
    };
  }
}
