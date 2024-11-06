class RolloTizada {
  int rolloCorteId;
  int? capas;

  RolloTizada({
    required this.rolloCorteId,
    this.capas,
  });

  factory RolloTizada.fromJson(Map<String, dynamic> json) {
    return RolloTizada(
      rolloCorteId: json['rolloCorteId'] ?? 'Sin rolloCorte definido',
      capas: json['capas'] ?? 'Sin capas definidas',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rolloCorteId': rolloCorteId,
      'capas': capas,
    };
  }
}
