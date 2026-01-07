import '../models/tablas_dat.dart';
import '../database/db_helper.dart';

class TablasDatService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> createTablasDat(TablasDat tablasDat) async {
    return await _dbHelper.insertTablasDat(tablasDat);
  }

  Future<List<TablasDat>> getAllTablasDat({int? idSector, String? keyword}) async {
    return await _dbHelper.getTablasDat(idSector: idSector, keyword: keyword);
  }

  Future<TablasDat?> getTablasDatById(int id) async {
    return await _dbHelper.getTablasDatById(id);
  }

  Future<int> updateTablasDat(TablasDat tablasDat) async {
    return await _dbHelper.updateTablasDat(tablasDat);
  }

  Future<int> deleteTablasDat(int id) async {
    return await _dbHelper.deleteTablasDat(id);
  }
}