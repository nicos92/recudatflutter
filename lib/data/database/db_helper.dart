import 'dart:async';
import 'dart:io' show Platform;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Importar sqflite_ffi para Windows
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../models/sector.dart';
import '../models/tablas_dat.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Inicializar sqflite_ffi para Windows
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      databaseFactory = databaseFactoryFfi;
    }

    String path = join(await getDatabasesPath(), 'tablas_dat.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Crear tabla sectores
    await db.execute('''
      CREATE TABLE sectores (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sector TEXT NOT NULL
      )
    ''');

    // Crear tabla tablas_dat
    await db.execute('''
      CREATE TABLE tablas_dat (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        archivo TEXT NOT NULL,
        error TEXT NOT NULL,
        img_error TEXT NOT NULL,
        observacion TEXT NOT NULL,
        id_sector INTEGER NOT NULL,
        FOREIGN KEY (id_sector) REFERENCES sectores (id)
      )
    ''');

    // Insertar sectores predeterminados
    await _insertDefaultSectores(db);
  }

  Future<void> _insertDefaultSectores(Database db) async {
    List<String> sectores = [
      'Producción de Despostada',
      'Control de Stock',
      'Producción de Cuarteo',
      'Ingreso de Hacienda',
      'Ventas Carne Sub - Prod',
      'Compras de Hacienda',
      'Proveedores Varios',
      'Proveedores Carnes-Sub Prod.',
      'Gestión Exportación',
      'Caja y Bancos',
      'Contabilidad General',
      'Sueldos y Jornales',
      'Bascula de Entrada',
      'Archivos de Sistema',
      'Faena Porcina',
      'Ciclo 3',
      'Cámara Remate'
    ];

    for (String sector in sectores) {
      await db.insert('sectores', {'sector': sector});
    }
  }

  // Métodos CRUD para Sectores
  Future<int> insertSector(Sector sector) async {
    final db = await database;
    return await db.insert('sectores', sector.toMap());
  }

  Future<List<Sector>> getSectores() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('sectores', orderBy: 'sector');

    return List.generate(maps.length, (i) {
      return Sector.fromMap(maps[i]);
    });
  }

  Future<Sector?> getSectorById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'sectores',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Sector.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> updateSector(Sector sector) async {
    final db = await database;
    return await db.update(
      'sectores',
      sector.toMap(),
      where: 'id = ?',
      whereArgs: [sector.id],
    );
  }

  Future<int> deleteSector(int id) async {
    final db = await database;
    return await db.delete(
      'sectores',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Métodos CRUD para TablasDat
  Future<int> insertTablasDat(TablasDat tablasDat) async {
    final db = await database;
    return await db.insert('tablas_dat', tablasDat.toMap());
  }

  Future<List<TablasDat>> getTablasDat({int? idSector, String? keyword}) async {
    final db = await database;

    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (idSector != null && idSector > 0) {
      whereClause += 'id_sector = ?';
      whereArgs.add(idSector);
    }

    if (keyword != null && keyword.isNotEmpty) {
      if (whereClause.isNotEmpty) {
        whereClause += ' AND ';
      }
      whereClause += '(nombre LIKE ? OR archivo LIKE ? OR error LIKE ? OR observacion LIKE ?)';
      whereArgs.addAll(['%$keyword%', '%$keyword%', '%$keyword%', '%$keyword%']);
    }

    final List<Map<String, dynamic>> maps = await db.query(
      'tablas_dat',
      where: whereClause.isNotEmpty ? whereClause : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
      orderBy: 'nombre',
    );

    return List.generate(maps.length, (i) {
      return TablasDat.fromMap(maps[i]);
    });
  }

  Future<TablasDat?> getTablasDatById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tablas_dat',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return TablasDat.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> updateTablasDat(TablasDat tablasDat) async {
    final db = await database;
    return await db.update(
      'tablas_dat',
      tablasDat.toMap(),
      where: 'id = ?',
      whereArgs: [tablasDat.id],
    );
  }

  Future<int> deleteTablasDat(int id) async {
    final db = await database;
    return await db.delete(
      'tablas_dat',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}