import '../models/sector.dart';
import '../database/db_helper.dart';

class SectorService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> createSector(Sector sector) async {
    return await _dbHelper.insertSector(sector);
  }

  Future<List<Sector>> getAllSectores() async {
    return await _dbHelper.getSectores();
  }

  Future<Sector?> getSectorById(int id) async {
    return await _dbHelper.getSectorById(id);
  }

  Future<int> updateSector(Sector sector) async {
    return await _dbHelper.updateSector(sector);
  }

  Future<int> deleteSector(int id) async {
    return await _dbHelper.deleteSector(id);
  }
}