import 'Modelo.dart';
import 'Tela.dart';
import 'observacion.dart';
import 'talleRepetecion.dart';

class ModeloCorte {
  int id;
  final bool esParaEstampar;
  final bool usaTelaSecundaria;
  final bool usaTelaAuxiliar;
  int? totalPrendas;
  Modelo? modelo;
  final int modeloId;
  final List<ObservacionModel>? observacion;
  final List<TalleRepeticion> curvas;

  ModeloCorte({
    required this.id,
    required this.esParaEstampar,
    required this.usaTelaSecundaria,
    required this.usaTelaAuxiliar,
    this.totalPrendas,
    required this.modeloId,
    this.modelo,
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
      modeloId: json['modeloId'],

      modelo: Modelo.fromJson(
          json['modelo']), // Asumiendo que Modelo tiene un fromJson
      observacion: json['observaciones'] != null
          ? (json['observaciones'] as List)
              .map((obs) => ObservacionModel.fromJson(obs))
              .toList()
          : null,
      curvas: json['curva'] != null
          ? (json['curva'] as List)
              .map((curva) => TalleRepeticion.fromJson(curva))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'modeloId': modeloId,
      'esParaEstampar': esParaEstampar,
      'usaTelaSecundaria': usaTelaSecundaria,
      'usaTelaAuxiliar': usaTelaAuxiliar,
      //  'modelo': modelo?.toJson(), // Asumiendo que Modelo tiene un toJson
      'observacion': observacion?.map((obs) => obs.toJson()).toList(),
      'curva': curvas.map((curva) => curva.toJson()).toList(),
    };
  }
}
