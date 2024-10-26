class Proveedor {
  int id;
  String nombre;
  String telefono;

  Proveedor({
    required this.id,
    required this.nombre,
    required this.telefono,
  });
  factory Proveedor.fromJson(Map<String, dynamic> json) {
    return Proveedor(
      id: json['id'] ?? 0, // Valor por defecto si 'id' es nulo
      nombre: json['nombre'] ?? 'Sin nombre',
      telefono: json['telefono'] ?? 'Sin telefono',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'telefono': telefono,
    };
  }
}
