import 'package:flutter/material.dart';
import '../../data/models/tablas_dat.dart';
import '../../data/models/sector.dart';
import '../../data/services/tablas_dat_service.dart';
import '../../data/services/sector_service.dart';

class TablasDatFormPage extends StatefulWidget {
  final TablasDat? tablasDat;

  const TablasDatFormPage({Key? key, this.tablasDat}) : super(key: key);

  @override
  _TablasDatFormPageState createState() => _TablasDatFormPageState();
}

class _TablasDatFormPageState extends State<TablasDatFormPage> {
  final TablasDatService _tablasDatService = TablasDatService();
  final SectorService _sectorService = SectorService();
  
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _archivoController = TextEditingController();
  final _errorController = TextEditingController();
  final _imgErrorController = TextEditingController();
  final _observacionController = TextEditingController();
  
  int? _selectedSectorId;
  List<Sector> _sectores = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      _sectores = await _sectorService.getAllSectores();
      
      if (widget.tablasDat != null) {
        _nombreController.text = widget.tablasDat!.nombre;
        _archivoController.text = widget.tablasDat!.archivo;
        _errorController.text = widget.tablasDat!.error;
        _imgErrorController.text = widget.tablasDat!.imgError;
        _observacionController.text = widget.tablasDat!.observacion;
        _selectedSectorId = widget.tablasDat!.idSector;
      } else if (_sectores.isNotEmpty) {
        _selectedSectorId = _sectores.first.id;
      }
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

  @override
  void dispose() {
    _nombreController.dispose();
    _archivoController.dispose();
    _errorController.dispose();
    _imgErrorController.dispose();
    _observacionController.dispose();
    super.dispose();
  }

  Future<void> _saveTablasDat() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (widget.tablasDat != null) {
          // Actualizar tablas_dat existente
          await _tablasDatService.updateTablasDat(
            TablasDat(
              id: widget.tablasDat!.id,
              nombre: _nombreController.text,
              archivo: _archivoController.text,
              error: _errorController.text,
              imgError: _imgErrorController.text,
              observacion: _observacionController.text,
              idSector: _selectedSectorId ?? 0,
            ),
          );
        } else {
          // Crear nuevo tablas_dat
          await _tablasDatService.createTablasDat(
            TablasDat(
              nombre: _nombreController.text,
              archivo: _archivoController.text,
              error: _errorController.text,
              imgError: _imgErrorController.text,
              observacion: _observacionController.text,
              idSector: _selectedSectorId ?? 0,
            ),
          );
        }
        
        if (mounted) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al guardar los datos: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tablasDat != null ? 'Editar Tabla DAT' : 'Nueva Tabla DAT'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _nombreController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese un nombre';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _archivoController,
                      decoration: const InputDecoration(
                        labelText: 'Archivo',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el nombre del archivo';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _errorController,
                      decoration: const InputDecoration(
                        labelText: 'Error',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el error';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _imgErrorController,
                      decoration: const InputDecoration(
                        labelText: 'Imagen de Error',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese la imagen de error';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _observacionController,
                      decoration: const InputDecoration(
                        labelText: 'Observación',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: _selectedSectorId,
                      decoration: const InputDecoration(
                        labelText: 'Sector',
                        border: OutlineInputBorder(),
                      ),
                      items: _sectores.map((sector) {
                        return DropdownMenuItem(
                          value: sector.id,
                          child: Text(sector.sector),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedSectorId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Por favor seleccione un sector';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _saveTablasDat,
                          child: Text(widget.tablasDat != null ? 'Actualizar' : 'Guardar'),
                        ),
                        const SizedBox(width: 12),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancelar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}