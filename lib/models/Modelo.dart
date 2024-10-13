import 'package:gestion_indumentaria/models/Avios.dart';

class Modelo {
  final int id;
  final String codigo;
  final String nombre;
 // final int categoriaId;
  final bool tieneTelaSecundaria;
  final bool tieneTelaAuxiliar;
  final String genero;
  final List<dynamic> observaciones;
  final List<dynamic> avios;
  final List<dynamic> curva;
  final String categoriaTipo;

  Modelo({
    required this.id,
    required this.codigo,
    required this.nombre,
   // required this.categoriaId,
    required this.tieneTelaSecundaria,
    required this.tieneTelaAuxiliar,
    required this.genero,
    required this.observaciones,
    required this.avios,
    required this.curva,
    required this.categoriaTipo,
  });


  // Método toJson para convertir el objeto a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'codigo': codigo,
      'nombre': nombre,
      'categoriaId': 1,
      'tieneTelaSecundaria': tieneTelaSecundaria,
      'tieneTelaAuxiliar': tieneTelaAuxiliar,
      'genero': genero,
      'observaciones': observaciones, // Asegúrate de que el formato sea el adecuado
      'avios': avios, // Asegúrate de que el formato sea el adecuado
      'curva': curva, // Asegúrate de que el formato sea el adecuado
      'categoria': {
        'tipo': categoriaTipo,
      },
    };
  }



  factory Modelo.fromJson(Map<String, dynamic> json) {
    return Modelo(
      id: json['id'],
      codigo: json['codigo'],
      nombre: json['nombre'],
      tieneTelaSecundaria: json['tieneTelaSecundaria'],
      tieneTelaAuxiliar: json['tieneTelaAuxiliar'],
      genero: json['genero'],
      observaciones: json['observaciones'] ?? [],
      avios: json['avios'] ?? [],
      curva: json['curva'] ?? [],
      categoriaTipo: json['categoria']['tipo'],
    );
  }
}
