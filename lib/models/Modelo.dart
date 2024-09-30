class Modelo {
  final String codigo;
  final String nombre;
  final bool tieneTelaSecundaria;
  final bool tieneTelaAuxiliar;
  final String genero;
  final List<dynamic> observaciones;
  final List<dynamic> avios;
  final List<dynamic> curva;
  final String categoriaTipo;

  Modelo({
    required this.codigo,
    required this.nombre,
    required this.tieneTelaSecundaria,
    required this.tieneTelaAuxiliar,
    required this.genero,
    required this.observaciones,
    required this.avios,
    required this.curva,
    required this.categoriaTipo,
  });

  factory Modelo.fromJson(Map<String, dynamic> json) {
    return Modelo(
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