class Avios {
  int id;
  String nombre;
  String
      proveedores; // Este campo puede ser un List<Proveedor> si deseas tener varios proveedores

  Avios({
    this.id = 0,
    required this.nombre,
    required this.proveedores,
  });

  // Método para deserializar desde JSON
  static Avios fromJson(Map<String, dynamic> json) {
    return Avios(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      proveedores: json['proveedores']
          as String, // Si cambias a List<Proveedor>, cambia la lógica aquí
    );
  }

  // Método para serializar a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'proveedores':
          proveedores, // Si es una lista de proveedores, cambia a proveedores.map((p) => p.toJson()).toList()
    };
  }
}
