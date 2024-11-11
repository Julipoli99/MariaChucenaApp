import 'package:gestion_indumentaria/models/Proveedor.dart';

// ignore: camel_case_types
class Avio {
  final int id;
  final String codigoProveedor;
  final int proveedorId;
  final int tipoProductoId;
  final String nombre;
  final int stock;
  final Proveedor proveedor;

  Avio({
    required this.id,
    required this.codigoProveedor,
    required this.proveedorId,
    required this.tipoProductoId,
    required this.nombre,
    required this.stock,
    required this.proveedor,
  });

  factory Avio.fromJson(Map<String, dynamic> json) {
    return Avio(
      id: json['id'] ?? 0,
      codigoProveedor: json['codigoProveedor'] ?? '',
      proveedorId: json['proveedorId'] ?? 0,
      tipoProductoId: json['tipoProductoId'] ?? 0,
      nombre: json['nombre'],
      stock: json['stock'] ?? 0,
      proveedor: Proveedor.fromJson(json['proveedor'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'codigoProveedor': codigoProveedor,
      'proveedorId': proveedorId,
      'tipoProductoId': tipoProductoId,
      'stock': stock,
      'proveedor': proveedor.toJson(),
    };
  }
}
