class Sector {
  final int? id;
  final String sector;

  Sector({
    this.id,
    required this.sector,
  });

  // Convertir de Map a Sector
  factory Sector.fromMap(Map<String, dynamic> map) {
    return Sector(
      id: map['id'] != null ? map['id'] as int : null,
      sector: map['sector'] as String,
    );
  }

  // Convertir de Sector a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sector': sector,
    };
  }
}