import '../config/config.dart';

/// Agrupa los criterios de búsqueda que el usuario puede aplicar.
class Filtro {
  final String ciudad;
  final String categoria;
  final String palabraClave;
  final int radioKm;

  const Filtro({
    this.ciudad = '',
    this.categoria = '',
    this.palabraClave = '',
    this.radioKm = Config.radioPorDefecto,
  });

  /// Cantidad de filtros opcionales activos (para mostrarlo en la UI).
  int get filtrosActivos => [ciudad, categoria, palabraClave]
      .where((valor) => valor.trim().isNotEmpty)
      .length;
}
