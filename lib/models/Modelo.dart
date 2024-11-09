import 'package:gestion_indumentaria/models/AviosModelo.dart';

import 'observacion.dart'; // Asegúrate de que este archivo exista
import 'talle.dart'; // Asegúrate de que este archivo exista
// Asegúrate de que este archivo exista

class Modelo {
  final int id;
  final String codigo;
  final String nombre;
  final bool tieneTelaSecundaria;
  final bool tieneTelaAuxiliar;
  final List<ObservacionModel>? observaciones; // Lista opcional
  final List<AvioModelo>? avios; // Lista opcional
  final List<dynamic>
      curva; 
  final String genero;
  final int categoriaTipo;

  Modelo({
    required this.id,
    required this.codigo,
    required this.nombre,
    required this.tieneTelaSecundaria,
    required this.tieneTelaAuxiliar,
    this.observaciones, // Puede ser nulo
    this.avios, // Puede ser nulo
    required this.curva,
    required this.genero,
    required this.categoriaTipo,
  });

  factory Modelo.fromJson(Map<String, dynamic> json) {
    List<ObservacionModel>? observaciones =
        (json['observaciones'] as List?)?.map((obs) {
      return ObservacionModel.fromJson(obs);
    }).toList();

    List<Talle> talles = (json['curva'] as List).map((t) {
      return Talle.fromJson(
          t); // Asumiendo que la API devuelve talles en formato JSON
    }).toList();

    return Modelo(
      id: json['id'],
      codigo: json['codigo'],
      nombre: json['nombre'],
      tieneTelaSecundaria: json['tieneTelaSecundaria'],
      tieneTelaAuxiliar: json['tieneTelaAuxiliar'],
      observaciones: observaciones,
      avios: (json['avios'] as List?)?.map((av) {
        return AvioModelo.fromJson(
            av); // Asegúrate de que tu clase Avios tenga este método
      }).toList(),
      curva: talles,
      genero: json['genero'],
      categoriaTipo: json['categoriaId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'codigo': codigo,
      'nombre': nombre,
      'tieneTelaSecundaria': tieneTelaSecundaria,
      'tieneTelaAuxiliar': tieneTelaAuxiliar,
      'observaciones': observaciones?.map((obs) => obs.toJson()).toList(),
      'avios': avios
          ?.map((av) => av.toJson())
          .toList(), // Asegúrate de que tu clase Avios tenga este método
      'curva': curva.map((t) => t.toJson()).toList(), // Convierte talles a JSON
      'genero': genero,
      'categoriaId': categoriaTipo,
    };
  }
}
