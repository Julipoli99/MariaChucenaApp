import 'Tela.dart';

enum CategoriaTela { PRIMARIA, SECUNDARIA, TERCIARIA }

class RolloCorte {
  int id;
  double? cantidadUtilizada;
  Tela? rollo;
  final CategoriaTela categoria;

  RolloCorte({
    required this.id,
    this.cantidadUtilizada,
    this.rollo,
    required this.categoria,
  });

  factory RolloCorte.fromJson(Map<String, dynamic> json) {
    return RolloCorte(
      id: json['id'],
      cantidadUtilizada: json['cantidadUtilizada'],
      rollo: json['rollo'] != null
          ? Tela.fromJson(json['rollo'])
          : null, // Verifica si 'rollo' no es nulo
      categoria: CategoriaTela.values.firstWhere((e) =>
          e.toString() ==
          'CategoriaTela.${json['categoria']}'), // Mapea el string a la enumeración
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cantidadUtilizada': cantidadUtilizada,
      'rollo': rollo?.toJson(), // Usa ?. para evitar null pointer exception
      'categoria':
          categoria.toString().split('.').last, // Convierte la enum a string
    };
  }
}
