import 'package:gestion_indumentaria/models/Avios.dart';

class Modelo {
  late int id;
  String codigo;
  String nombre;
  bool tieneTelaSecundaria;
  bool tieneTelaAuxiliar;
  List<Observacion> observaciones;
  List<AviosModelo> aviosModelos;
  List<Talle> curva;
  Categoria categoria;
  Genero genero;

  Modelo({
    required this.id,
    required this.codigo,
    required this.nombre,
    required this.tieneTelaSecundaria,
    required this.tieneTelaAuxiliar,
    required this.observaciones,
    required this.aviosModelos,
    required this.curva,
    required this.categoria,
    required this.genero,
  });

  // Deserializar desde JSON
  static Modelo fromJson(Map<String, dynamic> json) {
    return Modelo(
      id: json['id'] as int,
      codigo: json['codigo'] as String,
      nombre: json['nombre'] as String,
      tieneTelaSecundaria: json['tieneTelaSecundaria'] as bool,
      tieneTelaAuxiliar: json['tieneTelaAuxiliar'] as bool,
      observaciones: (json['observaciones'] as List)
          .map((item) => Observacion.fromJson(item))
          .toList(),
      aviosModelos: (json['aviosModelos'] as List)
          .map((item) => AviosModelo.fromJson(item))
          .toList(),
      curva:
          (json['curva'] as List).map((item) => Talle.fromJson(item)).toList(),
      categoria: Categoria.fromJson(json['categoria']),
      genero: Genero.values
          .firstWhere((e) => e.toString() == 'Genero.${json['genero']}'),
    );
  }

  // Serializar a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'codigo': codigo,
      'nombre': nombre,
      'tieneTelaSecundaria': tieneTelaSecundaria,
      'tieneTelaAuxiliar': tieneTelaAuxiliar,
      'observaciones': observaciones.map((item) => item.toJson()).toList(),
      'aviosModelos': aviosModelos.map((item) => item.toJson()).toList(),
      'curva': curva.map((item) => item.toJson()).toList(),
      'categoria': categoria.toJson(),
      'genero': genero.toString().split('.').last,
    };
  }
}

// Enum de Genero
enum Genero {
  UNISEX,
  MASCULINO,
  FEMENINO;
}

// Clase AviosModelo
class AviosModelo {
  late int id;
  late Avios avio;
  bool talle;
  bool color;
  late List<Talle> talles;
  int cantidadRequerida;

  AviosModelo({
    required this.id,
    required this.avio,
    required this.talle,
    required this.color,
    required this.talles,
    required this.cantidadRequerida,
  });

  // Deserializar desde JSON
  static AviosModelo fromJson(Map<String, dynamic> json) {
    return AviosModelo(
      id: json['id'] as int,
      avio: Avios.fromJson(json['avio']),
      talle: json['talle'] as bool,
      color: json['color'] as bool,
      talles:
          (json['talles'] as List).map((item) => Talle.fromJson(item)).toList(),
      cantidadRequerida: json['cantidadRequerida'] as int,
    );
  }

  // Serializar a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'avio': avio.toJson(),
      'talle': talle,
      'color': color,
      'talles': talles.map((item) => item.toJson()).toList(),
      'cantidadRequerida': cantidadRequerida,
    };
  }
}

// Clase Talle
class Talle {
  late int id;
  late String talle;

  Talle({
    required this.id,
    required this.talle,
  });

  // Deserializar desde JSON
  static Talle fromJson(Map<String, dynamic> json) {
    return Talle(
      id: json['id'] as int,
      talle: json['talle'] as String,
    );
  }

  // Serializar a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'talle': talle,
    };
  }
}

// Clase Observacion
class Observacion {
  late int id;
  late String titulo;
  late String descripcion;

  Observacion({
    required this.id,
    required this.titulo,
    required this.descripcion,
  });

  // Deserializar desde JSON
  static Observacion fromJson(Map<String, dynamic> json) {
    return Observacion(
      id: json['id'] as int,
      titulo: json['titulo'] as String,
      descripcion: json['descripcion'] as String,
    );
  }

  // Serializar a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
    };
  }
}

// Clase Categoria
class Categoria {
  late int id;
  late String tipo;

  Categoria({
    required this.id,
    required this.tipo,
  });

  // Deserializar desde JSON
  static Categoria fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'] as int,
      tipo: json['tipo'] as String,
    );
  }

  // Serializar a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipo': tipo,
    };
  }
}
