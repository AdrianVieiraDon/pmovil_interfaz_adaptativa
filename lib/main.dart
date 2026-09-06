import 'package:flutter/material.dart';
import 'screens/restaurantes_screen.dart';
import 'screens/repartidor_screen.dart';
import 'screens/seguimiento_screen.dart';
import 'screens/bateria_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RapidoYa - Domicilios',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.deepOrange, useMaterial3: true),
      home: const AdaptiveShell(),
    );
  }
}

enum _Breakpoint { compact, medium, expanded }

class AdaptiveShell extends StatefulWidget {
  const AdaptiveShell({super.key});

  @override
  State<AdaptiveShell> createState() => _AdaptiveShellState();
}

class _AdaptiveShellState extends State<AdaptiveShell> {
  int _index = 0;

  static const _destinations = [
    NavigationDestination(icon: Icon(Icons.restaurant), label: 'Restaurantes'),
    NavigationDestination(icon: Icon(Icons.delivery_dining), label: 'Repartidor'),
    NavigationDestination(icon: Icon(Icons.pin_drop), label: 'Seguimiento'),
    NavigationDestination(icon: Icon(Icons.battery_full), label: 'Batería'),
  ];

  static const _railDestinations = [
    NavigationRailDestination(icon: Icon(Icons.restaurant), label: Text('Restaurantes')),
    NavigationRailDestination(icon: Icon(Icons.delivery_dining), label: Text('Repartidor')),
    NavigationRailDestination(icon: Icon(Icons.pin_drop), label: Text('Seguimiento')),
    NavigationRailDestination(icon: Icon(Icons.battery_full), label: Text('Batería')),
  ];

  static const _screens = [
    RestaurantesScreen(),
    RepartidorScreen(),
    SeguimientoScreen(),
    BateriaScreen(),
  ];

  _Breakpoint _breakpointFor(double width) {
    if (width < 600) return _Breakpoint.compact;
    if (width < 840) return _Breakpoint.medium;
    return _Breakpoint.expanded;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bp = _breakpointFor(constraints.maxWidth);

        if (bp == _Breakpoint.compact) {
          return Scaffold(
            appBar: AppBar(title: const Text('RapidoYa')),
            body: SafeArea(child: _screens[_index]),
            bottomNavigationBar: NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: (i) => setState(() => _index = i),
              destinations: _destinations,
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('RapidoYa')),
          body: SafeArea(
            child: Row(
              children: [
                NavigationRail(
                  extended: bp == _Breakpoint.expanded,
                  selectedIndex: _index,
                  onDestinationSelected: (i) => setState(() => _index = i),
                  destinations: _railDestinations,
                ),
                const VerticalDivider(width: 1),
                Expanded(child: _screens[_index]),
              ],
            ),
          ),
        );
      },
    );
  }
}
