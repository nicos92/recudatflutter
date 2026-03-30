import 'package:flutter/material.dart';
import '../../data/models/sector.dart';
import '../../data/services/sector_service.dart';
import 'sector_form_page.dart';

class SectorListPage extends StatefulWidget {
  const SectorListPage({super.key});

  @override
  _SectorListPageState createState() => _SectorListPageState();
}

class _SectorListPageState extends State<SectorListPage> {
  final SectorService _sectorService = SectorService();
  List<Sector> _sectores = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSectores();
  }

  Future<void> _loadSectores() async {
    try {
      _sectores = await _sectorService.getAllSectores();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar los sectores: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteSector(int id) async {
    try {
      await _sectorService.deleteSector(id);
      if (mounted) {
        await _loadSectores();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sector eliminado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al eliminar el sector: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _confirmDelete(int id, String sectorName) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: Text(
          '¿Está seguro que desea eliminar el sector "$sectorName"?',
        ),
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
      await _deleteSector(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Sectores'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Botón para agregar nuevo sector
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        bool? result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SectorFormPage(),
                          ),
                        );

                        if (result == true) {
                          await _loadSectores();
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Nuevo Sector'),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Lista de sectores
                  Expanded(
                    child: _sectores.isEmpty
                        ? const Center(
                            child: Text(
                              'No hay sectores registrados',
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _sectores.length,
                            itemBuilder: (context, index) {
                              final sector = _sectores[index];
                              return Card(
                                child: ListTile(
                                  title: Text(sector.sector),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () async {
                                          bool? result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SectorFormPage(
                                                    sector: sector,
                                                  ),
                                            ),
                                          );

                                          if (result == true) {
                                            await _loadSectores();
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () => _confirmDelete(
                                          sector.id!,
                                          sector.sector,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
