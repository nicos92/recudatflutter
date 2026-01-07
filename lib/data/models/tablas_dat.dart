class TablasDat {
  final int? id;
  final String nombre;
  final String archivo;
  final String error;
  final String imgError;
  final String observacion;
  final int idSector;

  TablasDat({
    this.id,
    required this.nombre,
    required this.archivo,
    required this.error,
    required this.imgError,
    required this.observacion,
    required this.idSector,
  });

  // Convertir de Map a TablasDat
  factory TablasDat.fromMap(Map<String, dynamic> map) {
    return TablasDat(
      id: map['id'] != null ? map['id'] as int : null,
      nombre: map['nombre'] as String,
      archivo: map['archivo'] as String,
      error: map['error'] as String,
      imgError: map['img_error'] as String,
      observacion: map['observacion'] as String,
      idSector: map['id_sector'] as int,
    );
  }

  // Convertir de TablasDat a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'archivo': archivo,
      'error': error,
      'img_error': imgError,
      'observacion': observacion,
      'id_sector': idSector,
    };
  }
}