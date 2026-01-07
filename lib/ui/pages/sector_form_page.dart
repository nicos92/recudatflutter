import 'package:flutter/material.dart';
import '../../data/models/sector.dart';
import '../../data/services/sector_service.dart';

class SectorFormPage extends StatefulWidget {
  final Sector? sector;

  const SectorFormPage({Key? key, this.sector}) : super(key: key);

  @override
  _SectorFormPageState createState() => _SectorFormPageState();
}

class _SectorFormPageState extends State<SectorFormPage> {
  final SectorService _sectorService = SectorService();
  final _formKey = GlobalKey<FormState>();
  final _sectorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.sector != null) {
      _sectorController.text = widget.sector!.sector;
    }
  }

  @override
  void dispose() {
    _sectorController.dispose();
    super.dispose();
  }

  Future<void> _saveSector() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (widget.sector != null) {
          // Actualizar sector existente
          await _sectorService.updateSector(
            Sector(
              id: widget.sector!.id,
              sector: _sectorController.text,
            ),
          );
        } else {
          // Crear nuevo sector
          await _sectorService.createSector(
            Sector(sector: _sectorController.text),
          );
        }
        
        if (mounted) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al guardar el sector: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sector != null ? 'Editar Sector' : 'Nuevo Sector'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _sectorController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del Sector',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre para el sector';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _saveSector,
                    child: Text(widget.sector != null ? 'Actualizar' : 'Guardar'),
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