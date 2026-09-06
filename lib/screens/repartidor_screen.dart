import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class RepartidorScreen extends StatefulWidget {
  const RepartidorScreen({super.key});

  @override
  State<RepartidorScreen> createState() => _RepartidorScreenState();
}

class _RepartidorScreenState extends State<RepartidorScreen> {
  String _resumen = 'Cargando datos del celular del repartidor...';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _cargarInfo());
  }

  Future<void> _cargarInfo() async {
    final plugin = DeviceInfoPlugin();
    String texto;
    try {
      final platform = Theme.of(context).platform;
      if (platform == TargetPlatform.android) {
        final info = await plugin.androidInfo;
        texto = 'Modelo: ${info.model}\n'
            'Fabricante: ${info.manufacturer}\n'
            'SO: Android ${info.version.release} (SDK ${info.version.sdkInt})\n'
            'Físico: ${info.isPhysicalDevice ? 'Sí' : 'Emulador'}';
      } else if (platform == TargetPlatform.iOS) {
        final info = await plugin.iosInfo;
        texto = 'Modelo: ${info.utsname.machine}\n'
            'Nombre: ${info.name}\n'
            'SO: iOS ${info.systemVersion}\n'
            'Físico: ${info.isPhysicalDevice ? 'Sí' : 'Simulador'}';
      } else {
        texto = 'Plataforma no soportada en esta demo.';
      }
    } catch (e) {
      texto = 'No se pudo leer la información del dispositivo: $e';
    }
    if (mounted) setState(() => _resumen = texto);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Celular del repartidor', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          Text(_resumen),
          const Divider(height: 32),
          const ListTile(
            leading: Icon(Icons.badge),
            title: Text('Repartidor asignado'),
            subtitle: Text('Carlos M. · Moto · Placa ABC-123'),
          ),
        ],
      ),
    );
  }
}
