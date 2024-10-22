import 'observacion.dart'; // Asegúrate de que este archivo exista
import 'talle.dart'; // Asegúrate de que este archivo exista
import 'avios.dart'; // Asegúrate de que este archivo exista

class Modelo {
  final int id;
  final String codigo;
  final String nombre;
  final bool tieneTelaSecundaria;
  final bool tieneTelaAuxiliar;
  final List<Observacion>? observaciones; // Lista opcional
  final List<Avios>? avios; // Lista opcional
  final List<Talle>
      curva; // Representa los talles como una lista de objetos Talle
  final String genero;
  final String categoriaTipo;

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
    List<Observacion>? observaciones =
        (json['observaciones'] as List?)?.map((obs) {
      return Observacion.fromJson(obs);
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
        return Avios.fromJson(
            av); // Asegúrate de que tu clase Avios tenga este método
      }).toList(),
      curva: talles,
      genero: json['genero'],
      categoriaTipo: json['categoria']['tipo'],
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
      'categoria': {'tipo': categoriaTipo},
    };
  }
}
