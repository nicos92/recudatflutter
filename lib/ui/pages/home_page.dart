import 'package:flutter/material.dart';
import '../../data/models/tablas_dat.dart';
import '../../data/models/sector.dart';
import '../../data/services/sector_service.dart';
import '../../data/services/tablas_dat_service.dart';
import '../../data/services/command_service.dart';
import '../widgets/dat_table.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SectorService _sectorService = SectorService();
  final TablasDatService _tablasDatService = TablasDatService();
  final CommandService _commandService = CommandService();

  List<Sector> _sectores = [];
  List<TablasDat> _allTablasDat = [];
  List<TablasDat> _filteredTablasDat = [];

  int? _selectedSectorId;
  String _searchKeyword = '';
  TablasDat? _selectedTablasDat;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _commandService.initialize(); // Inicializar el servicio de comandos
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _sectores = await _sectorService.getAllSectores();
      _allTablasDat = await _tablasDatService.getAllTablasDat();
      _filteredTablasDat = _allTablasDat;
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al cargar los datos: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _filterData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _filteredTablasDat = await _tablasDatService.getAllTablasDat(
        idSector: _selectedSectorId,
        keyword: _searchKeyword,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al filtrar los datos: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _executeRecoverCommand() async {
    if (_selectedTablasDat == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Ejecutar el comando recover1
      final result = await _commandService.executeRecover1Command(
        _selectedTablasDat!.archivo,
      );

      if (result.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Comando ejecutado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al ejecutar el comando: ${result.error}'),
            backgroundColor: Colors.red.shade300,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error inesperado: $e'),
          backgroundColor: Colors.red.shade300,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _copyFileWithTimestamp() async {
    if (_selectedTablasDat == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Copiar el archivo con timestamp
      final result = await _commandService.copyFileWithTimestamp(
        _selectedTablasDat!.archivo,
      );

      if (result.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.output), backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al copiar el archivo: ${result.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error inesperado al copiar archivo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccioná y ejecutá'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filtros
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Filtros',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Sector:'),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<int>(
                                initialValue: _selectedSectorId,
                                hint: const Text('Seleccionar sector'),
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                items: [
                                  const DropdownMenuItem(
                                    value: null,
                                    child: Text('Todos los sectores'),
                                  ),
                                  ..._sectores.map(
                                    (sector) => DropdownMenuItem(
                                      value: sector.id,
                                      child: Text(sector.sector),
                                    ),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedSectorId = value;
                                  });
                                  _filterData();
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Buscar:'),
                              const SizedBox(height: 8),
                              TextField(
                                decoration: const InputDecoration(
                                  hintText:
                                      'Buscar por nombre, archivo, error u observación...',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.search),
                                ),
                                onChanged: (value) {
                                  _searchKeyword = value;
                                  _filterData();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Botones para ejecutar comandos
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _selectedTablasDat != null && !_isLoading
                      ? () async {
                          await _copyFileWithTimestamp();
                        }
                      : null,
                  icon: const Icon(Icons.copy),
                  label: const Text('Copiar Archivo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade400, // Yellow color
                    foregroundColor: Colors.black, // Text/icon color
                  ),
                ),

                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _selectedTablasDat != null && !_isLoading
                      ? () async {
                          await _executeRecoverCommand();
                        }
                      : null,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Ejecutar Recover1 zz'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow.shade400, // Yellow color
                    foregroundColor: Colors.black, // Text/icon color
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Tabla de datos
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: DatTable(
                          data: _filteredTablasDat,
                          sectores: _sectores,
                          onRowSelected: (tablasDat) {
                            // Solo maneja la selección visual
                          },
                          onRowTapped: (tablasDat) {
                            // Solo selecciona la fila sin ejecutar comandos
                            setState(() {
                              _selectedTablasDat = tablasDat;
                            });
                          },
                          selectedRow: _selectedTablasDat,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
