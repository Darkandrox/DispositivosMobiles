import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

/// Configuración centralizada de la aplicación: textos, colores, íconos,
/// categorías y parámetros de la API, para evitar "hardcoded strings".
class Config {
  // ---------------- API Ticketmaster ----------------

  /// Consumer Key obtenida en https://developer.ticketmaster.com/
  /// Se puede pegar aquí directamente o pasar al ejecutar con:
  /// flutter run --dart-define=TICKETMASTER_API_KEY=TU_CONSUMER_KEY
  static const String apiKey = String.fromEnvironment(
    'TICKETMASTER_API_KEY',
    defaultValue: '',
  );

  static const String urlEventos =
      'https://app.ticketmaster.com/discovery/v2/events.json';

  /// Cantidad máxima de eventos por consulta (la API permite hasta 200).
  static const int tamanoPagina = 100;

  // ---------------- Mapa ----------------

  static const String urlTiles =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String paqueteUserAgent = 'com.pascualbravo.eventos_cercanos';

  /// Coordenada base usada si no se puede obtener la ubicación (Nueva York).
  static const LatLng ubicacionPorDefecto = LatLng(40.7128, -74.0060);

  static const double zoomInicial = 13;
  static const double zoomEvento = 16;

  // ---------------- Filtros ----------------

  /// Radios disponibles en km. El mínimo exigido es 5 km.
  static const List<int> radiosKm = [5, 10, 25, 50, 100];
  static const int radioPorDefecto = 5;

  /// Categorías (classificationName en Ticketmaster) → texto en pantalla.
  /// La clave vacía significa "todas las categorías".
  static const Map<String, String> categorias = {
    '': 'Todas',
    'Music': 'Música',
    'Sports': 'Deportes',
    'Arts & Theatre': 'Arte y teatro',
    'Film': 'Cine',
    'Miscellaneous': 'Varios',
  };

  static const Map<String, IconData> iconosCategoria = {
    '': Icons.event,
    'Music': Icons.music_note,
    'Sports': Icons.sports_soccer,
    'Arts & Theatre': Icons.theater_comedy,
    'Film': Icons.movie,
    'Miscellaneous': Icons.category,
  };

  // ---------------- Textos ----------------

  static const String tituloApp = 'Eventos Cercanos';
  static const String textoFiltros = 'Filtros de búsqueda';
  static const String textoCiudad = 'Ciudad (opcional)';
  static const String textoPalabraClave = 'Palabra clave (opcional)';
  static const String textoCategoria = 'Categoría';
  static const String textoRadio = 'Radio de búsqueda';
  static const String textoBuscar = 'BUSCAR';
  static const String textoIrAhora = 'IR AHORA';
  static const String textoSinEventos =
      'No se encontraron eventos con los filtros actuales';
  static const String textoSinApiKey =
      'Falta la API Key de Ticketmaster. Configúrala en lib/config/config.dart';
  static const String textoNoDisponible = 'No disponible';

  // ---------------- Colores ----------------

  static const Color colorPrimario = Color(0xFF1E88E5);
  static const Color colorEvento = Color(0xFFE53935);
  static const Color colorUsuario = Color(0xFF1E88E5);

  // ---------------- Íconos ----------------

  static const IconData iconoEvento = Icons.location_pin;
  static const IconData iconoUsuario = Icons.my_location;
  static const IconData iconoFiltros = Icons.tune;
  static const IconData iconoRecentrar = Icons.gps_fixed;
  static const IconData iconoIrAhora = Icons.near_me;

  static const double tamanoMarcador = 45;
}
