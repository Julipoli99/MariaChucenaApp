enum TipoUsuario { USUARIO, ADMINISTRADOR, MODERADOR }

class Autentificacion {
  final String id;
  final String email;
  final String nombre;
  final String apellido;
  final String token;
  final TipoUsuario tipoUsuario;

  Autentificacion({
    required this.id,
    required this.email,
    required this.nombre,
    required this.apellido,
    required this.token,
    required this.tipoUsuario,
  });

  factory Autentificacion.fromJson(Map<String, dynamic> json) {
    return Autentificacion(
      id: json['id'],
      email: json['email'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      token: json['token'],
      tipoUsuario: TipoUsuario.values.firstWhere(
          (e) => e.toString().split('.').last == json['tipoUsuario']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nombre': nombre,
      'apellido': apellido,
      'token': token,
      'tipoUsuario': tipoUsuario.toString().split('.').last,
    };
  }
}
