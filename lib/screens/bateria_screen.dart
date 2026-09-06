import 'dart:async';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';

class BateriaScreen extends StatefulWidget {
  const BateriaScreen({super.key});

  @override
  State<BateriaScreen> createState() => _BateriaScreenState();
}

class _BateriaScreenState extends State<BateriaScreen> {
  final Battery _battery = Battery();
  int? _nivel;
  BatteryState? _estado;
  StreamSubscription<BatteryState>? _sub;

  @override
  void initState() {
    super.initState();
    _cargarNivel();
    _sub = _battery.onBatteryStateChanged.listen((estado) {
      _estado = estado;
      _cargarNivel();
    });
  }

  Future<void> _cargarNivel() async {
    final nivel = await _battery.batteryLevel;
    if (mounted) setState(() => _nivel = nivel);
  }

  String _estadoTexto(BatteryState? e) {
    switch (e) {
      case BatteryState.charging:
        return 'Cargando';
      case BatteryState.discharging:
        return 'Descargando';
      case BatteryState.full:
        return 'Completa';
      case BatteryState.connectedNotCharging:
        return 'Conectada, sin cargar';
      default:
        return 'Desconocido';
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Batería del repartidor', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          Icon(
            _estado == BatteryState.charging
                ? Icons.battery_charging_full
                : Icons.battery_std,
            size: 64,
          ),
          const SizedBox(height: 12),
          Text('${_nivel ?? '--'}%', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(_estadoTexto(_estado)),
          const SizedBox(height: 8),
          if ((_nivel ?? 100) < 20)
            const Text('⚠️ Batería baja: notificar al soporte',
                style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}
