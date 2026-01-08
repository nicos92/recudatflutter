import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ui/pages/home_page.dart';
import 'ui/pages/config_page.dart';
import 'ui/pages/sector_list_page.dart';
import 'ui/pages/tablas_dat_list_page.dart';
import 'data/database/db_helper.dart';
import 'data/services/theme_service.dart';

void main() async {
  // Asegurar que Flutter esté completamente inicializado
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar la base de datos
  await DatabaseHelper().database;
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Listen to theme changes
    themeService.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    // Remove listener when disposing
    themeService.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    // Trigger a rebuild when theme changes
    setState(() {});
  }

  ThemeMode _getThemeMode() {
    switch (themeService.currentThemeMode) {
      case 0: // Light theme
        return ThemeMode.light;
      case 1: // Dark theme
        return ThemeMode.dark;
      case 2: // System theme
      default:
        return ThemeMode.system;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Archivos DAT',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey, brightness: Brightness.dark),
      ),
      themeMode: _getThemeMode(),
      home: const MainScreen(),
      routes: {
        '/home': (context) => const HomePage(),
        '/config': (context) => ConfigPage(),
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