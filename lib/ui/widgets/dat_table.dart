import 'package:flutter/material.dart';
import '../../data/models/tablas_dat.dart';
import '../../data/models/sector.dart';

class DatTable extends StatefulWidget {
  final List<TablasDat> data;
  final List<Sector> sectores;
  final Function(TablasDat)? onRowSelected;
  final Function(TablasDat)? onRowTapped;  // Cambiado a onRowTapped para manejar el toque simple
  final TablasDat? selectedRow;

  const DatTable({
    Key? key,
    required this.data,
    required this.sectores,
    this.onRowSelected,
    this.onRowTapped,
    this.selectedRow,
  }) : super(key: key);

  @override
  _DatTableState createState() => _DatTableState();
}

class _DatTableState extends State<DatTable> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: Theme.of(context).colorScheme.primary,
          ),
        ),
        child: Scrollbar(  // Add scrollbar for better UX
          controller: _scrollController,  // Connect the scrollbar to the scroll controller
          child: SingleChildScrollView(  // Make the table scrollable
            controller: _scrollController,  // Connect the scroll view to the scroll controller
            scrollDirection: Axis.vertical,  // Allow vertical scrolling
            child: DataTable(
              columnSpacing: 16,
              horizontalMargin: 12,
              headingRowHeight: 48,
              dataRowHeight: 40,
              headingRowColor: MaterialStateProperty.all<Color>(
                Theme.of(context).colorScheme.primaryContainer,
              ),
              columns: const [
                DataColumn(
                  label: Text(
                    'Nombre',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Archivo',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Error',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Observación',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Sector',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows: widget.data.map((tablasDat) {
                final sector = widget.sectores.firstWhere(
                  (s) => s.id == tablasDat.idSector,
                  orElse: () => Sector(id: 0, sector: 'N/A'),
                );

                bool isSelected = widget.selectedRow?.id == tablasDat.id;

                return DataRow(
                  color: isSelected
                      ? MaterialStateProperty.all(
                      Theme.of(context).colorScheme.primary.withOpacity(0.2))
                      : MaterialStateProperty.all(Colors.transparent),
                  selected: isSelected,
                  onSelectChanged: (selected) {
                    // Maneja la selección visual
                    widget.onRowSelected?.call(tablasDat);

                    // Si la fila fue seleccionada (no deseleccionada), ejecuta la acción de toque
                    if (selected == true) {
                      widget.onRowTapped?.call(tablasDat);
                    }
                  },
                  cells: [
                    DataCell(
                      Text(tablasDat.nombre),
                    ),
                    DataCell(Text(tablasDat.archivo)),
                    DataCell(Text(tablasDat.error)),
                    DataCell(Text(tablasDat.observacion)),
                    DataCell(Text(sector.sector)),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}