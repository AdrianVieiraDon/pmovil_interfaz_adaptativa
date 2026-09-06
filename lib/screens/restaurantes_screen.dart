import 'package:flutter/material.dart';

class Restaurante {
  final String nombre;
  final String categoria;
  final String tiempo;
  final IconData icono;

  const Restaurante(this.nombre, this.categoria, this.tiempo, this.icono);
}

const _restaurantes = [
  Restaurante('La Brasa Roja', 'Comida rápida', '25-35 min', Icons.local_fire_department),
  Restaurante('Sushi Express', 'Japonesa', '30-40 min', Icons.set_meal),
  Restaurante('Pizza Nonna', 'Italiana', '20-30 min', Icons.local_pizza),
  Restaurante('Verde Bowl', 'Saludable', '15-25 min', Icons.eco),
  Restaurante('El Corral Criollo', 'Colombiana', '25-35 min', Icons.rice_bowl),
];

class RestaurantesScreen extends StatelessWidget {
  const RestaurantesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _restaurantes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final r = _restaurantes[i];
        return Card(
          child: ListTile(
            leading: CircleAvatar(child: Icon(r.icono)),
            title: Text(r.nombre),
            subtitle: Text('${r.categoria} · ${r.tiempo}'),
            trailing: FilledButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Pedido enviado a ${r.nombre}')),
                );
              },
              child: const Text('Pedir'),
            ),
          ),
        );
      },
    );
  }
}
