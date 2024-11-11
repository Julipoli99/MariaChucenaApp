import 'Modelo.dart';
import 'Tela.dart';
import 'observacion.dart';
import 'talleRepetecion.dart';

class ModeloCorte {
  int id;
  final bool esParaEstampar;
  final bool usaTelaSecundaria;
  final bool usaTelaAuxiliar;
  final int totalPrendas;
  final Modelo modelo;
  final List<ObservacionModel>? observacion;
  final List<TalleRepeticion> curvas;

  ModeloCorte({
    required this.id,
    required this.esParaEstampar,
    required this.usaTelaSecundaria,
    required this.usaTelaAuxiliar,
    required this.totalPrendas,
    required this.modelo,
    this.observacion,
    required this.curvas,
  });

  factory ModeloCorte.fromJson(Map<String, dynamic> json) {
    return ModeloCorte(
      id: json['id'],
      esParaEstampar: json['esParaEstampar'],
      usaTelaSecundaria: json['usaTelaSecundaria'],
      usaTelaAuxiliar: json['usaTelaAuxiliar'],
      totalPrendas: json['totalPrendas'],
      modelo: Modelo.fromJson(
          json['modelo']), // Asumiendo que Modelo tiene un fromJson
      observacion: (json['observaciones'] as List)
          .map((obs) => ObservacionModel.fromJson(obs))
          .toList(),
      curvas: (json['curva'] as List)
          .map((curva) => TalleRepeticion.fromJson(curva))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'esParaEstampar': esParaEstampar,
      'usaTelaSecundaria': usaTelaSecundaria,
      'usaTelaAuxiliar': usaTelaAuxiliar,
      'totalPrendas': totalPrendas,
      'modelo': modelo.toJson(), // Asumiendo que Modelo tiene un toJson
      'observacion': observacion?.map((obs) => obs.toJson()).toList(),
      'curva': curvas.map((curva) => curva.toJson()).toList(),
    };
  }
}
