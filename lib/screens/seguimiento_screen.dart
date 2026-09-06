import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class SeguimientoScreen extends StatefulWidget {
  const SeguimientoScreen({super.key});

  @override
  State<SeguimientoScreen> createState() => _SeguimientoScreenState();
}

class _SeguimientoScreenState extends State<SeguimientoScreen> {
  AccelerometerEvent? _accel;
  GyroscopeEvent? _gyro;
  StreamSubscription<AccelerometerEvent>? _accelSub;
  StreamSubscription<GyroscopeEvent>? _gyroSub;
  bool _enMovimiento = false;

  // Umbral simple: si la magnitud del acelerómetro se aleja de la gravedad
  // (9.8 m/s^2) o el giroscopio detecta giro, asumimos que el pedido se mueve.
  static const _umbralAccel = 1.5;
  static const _umbralGyro = 0.5;

  @override
  void initState() {
    super.initState();
    _pedirPermisoYEscuchar();
  }

  Future<void> _pedirPermisoYEscuchar() async {
    await Permission.sensors.request();

    _accelSub = accelerometerEventStream().listen((e) {
      _accel = e;
      _actualizarMovimiento();
    });
    _gyroSub = gyroscopeEventStream().listen((e) {
      _gyro = e;
      _actualizarMovimiento();
    });
  }

  void _actualizarMovimiento() {
    final a = _accel;
    final g = _gyro;
    if (a == null || g == null) return;

    final magnitudAccel = sqrt(a.x * a.x + a.y * a.y + a.z * a.z);
    final desviacion = (magnitudAccel - 9.8).abs();
    final magnitudGyro = sqrt(g.x * g.x + g.y * g.y + g.z * g.z);

    final movimiento = desviacion > _umbralAccel || magnitudGyro > _umbralGyro;
    if (mounted && movimiento != _enMovimiento) {
      setState(() => _enMovimiento = movimiento);
    }
  }

  @override
  void dispose() {
    _accelSub?.cancel();
    _gyroSub?.cancel();
    super.dispose();
  }

  Widget _ejes(String titulo, double? x, double? y, double? z) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('x: ${x?.toStringAsFixed(2) ?? '-'}'),
            Text('y: ${y?.toStringAsFixed(2) ?? '-'}'),
            Text('z: ${z?.toStringAsFixed(2) ?? '-'}'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Seguimiento del pedido', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          Card(
            color: _enMovimiento
                ? Colors.green.withValues(alpha: 0.15)
                : Colors.orange.withValues(alpha: 0.15),
            child: ListTile(
              leading: Icon(
                _enMovimiento ? Icons.two_wheeler : Icons.pause_circle,
                color: _enMovimiento ? Colors.green : Colors.orange,
              ),
              title: Text(_enMovimiento ? 'En camino' : 'Detenido'),
              subtitle: const Text('Estado calculado con sensores del celular'),
            ),
          ),
          const SizedBox(height: 12),
          _ejes('Acelerómetro', _accel?.x, _accel?.y, _accel?.z),
          const SizedBox(height: 12),
          _ejes('Giroscopio', _gyro?.x, _gyro?.y, _gyro?.z),
        ],
      ),
    );
  }
}
