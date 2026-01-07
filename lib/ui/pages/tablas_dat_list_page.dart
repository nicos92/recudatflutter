import 'package:flutter/material.dart';
import '../../data/models/tablas_dat.dart';
import '../../data/models/sector.dart';
import '../../data/services/tablas_dat_service.dart';
import '../../data/services/sector_service.dart';
import 'tablas_dat_form_page.dart';
import '../widgets/dat_table.dart';

class TablasDatListPage extends StatefulWidget {
  const TablasDatListPage({Key? key}) : super(key: key);

  @override
  _TablasDatListPageState createState() => _TablasDatListPageState();
}

class _TablasDatListPageState extends State<TablasDatListPage> {
  final TablasDatService _tablasDatService = TablasDatService();
  final SectorService _sectorService = SectorService();

  List<TablasDat> _tablasDat = [];
  List<Sector> _sectores = [];
  TablasDat? _selectedForDeletion; // Track selected row for deletion
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      _tablasDat = await _tablasDatService.getAllTablasDat();
      _sectores = await _sectorService.getAllSectores();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar los datos: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteTablasDat(int id) async {
    try {
      await _tablasDatService.deleteTablasDat(id);
      if (mounted) {
        await _loadData();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tabla DAT eliminada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al eliminar la tabla DAT: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _confirmDelete(int id, String nombre) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: Text('¿Está seguro que desea eliminar la tabla DAT "$nombre"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _deleteTablasDat(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Tablas DAT'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Botón para agregar nueva tabla DAT
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        bool? result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TablasDatFormPage(),
                          ),
                        );
                        
                        if (result == true) {
                          await _loadData();
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Nueva Tabla DAT'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Tabla de datos
                  Expanded(
                    child: _tablasDat.isEmpty
                        ? const Center(
                            child: Text(
                              'No hay tablas DAT registradas',
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        : DatTable(
                            data: _tablasDat,
                            sectores: _sectores,
                            selectedRow: _selectedForDeletion, // Highlight the selected row for deletion
                            onRowSelected: (tablasDat) {
                              // Handle row selection for deletion
                              setState(() {
                                _selectedForDeletion = tablasDat;
                              });
                            },
                          ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Botones para editar y eliminar seleccionado
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _selectedForDeletion != null
                            ? () async {
                                bool? result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                      TablasDatFormPage(tablasDat: _selectedForDeletion),
                                  ),
                                );

                                if (result == true) {
                                  await _loadData();
                                }
                              }
                            : null,
                        icon: const Icon(Icons.edit),
                        label: const Text('Editar Seleccionado'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: _selectedForDeletion != null
                            ? () {
                                _confirmDelete(_selectedForDeletion!.id!, _selectedForDeletion!.nombre);
                              }
                            : null,
                        icon: const Icon(Icons.delete),
                        label: const Text('Eliminar Seleccionado'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}