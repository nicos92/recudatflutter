import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ui/pages/home_page.dart';
import 'ui/pages/config_page.dart';
import 'ui/pages/sector_list_page.dart';
import 'ui/pages/tablas_dat_list_page.dart';
import 'data/database/db_helper.dart';

void main() async {
  // Asegurar que Flutter esté completamente inicializado
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar la base de datos
  await DatabaseHelper().database;
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Archivos DAT',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
      ),
      home: const MainScreen(),
      routes: {
        '/home': (context) => const HomePage(),
        '/config': (context) => const ConfigPage(),
        '/sectores': (context) => const SectorListPage(),
        '/tablas_dat': (context) => const TablasDatListPage(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    SectorListPage(),
    TablasDatListPage(),
    ConfigPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Archivos DAT'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.business),
            label: 'Sectores',
          ),
          NavigationDestination(
            icon: Icon(Icons.table_chart),
            label: 'Tablas DAT',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Configuración',
          ),
        ],
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
      ),
    );
  }
}