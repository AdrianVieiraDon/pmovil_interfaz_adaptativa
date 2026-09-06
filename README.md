# domicilios_sensores_app (RapidoYa)

Versión temática de domicilios (estilo Rappi) del proyecto adaptativo original,
manteniendo el mismo patrón de layout (compact/medium/expanded) y sensores reales.

## Pantallas

1. **Restaurantes** — Lista simple de restaurantes/menú para pedir (sin sensores).
2. **Repartidor** — Info real del celular asignado al repartidor (`device_info_plus`).
3. **Seguimiento** — Usa acelerómetro + giroscopio reales para detectar si el
   pedido está "En camino" o "Detenido".
4. **Batería** — Batería real del celular del repartidor, con alerta si baja de 20%.

## Ejecutar

```
flutter pub get
flutter run
```
