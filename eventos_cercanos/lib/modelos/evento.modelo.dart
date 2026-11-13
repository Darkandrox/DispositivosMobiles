import 'package:latlong2/latlong.dart';

/// Representa un evento retornado por la API Discovery de Ticketmaster.
class Evento {
  final String id;
  final String nombre;
  final String? fecha;
  final String? hora;
  final String? estado;
  final String? lugar;
  final String? ciudad;
  final String? categoria;
  final String? url;
  final LatLng coordenadas;

  const Evento({
    required this.id,
    required this.nombre,
    required this.coordenadas,
    this.fecha,
    this.hora,
    this.estado,
    this.lugar,
    this.ciudad,
    this.categoria,
    this.url,
  });

  /// Construye un [Evento] a partir del JSON de Ticketmaster.
  /// Retorna null si el evento no tiene coordenadas (no se puede ubicar
  /// en el mapa).
  ///
  /// Estructura relevante del JSON:
  /// name, dates.start.localDate, dates.start.localTime, dates.status.code,
  /// _embedded.venues[0].location.latitude / longitude (vienen como texto).
  static Evento? desdeJson(Map<String, dynamic> json) {
    final fechas = json['dates'] as Map<String, dynamic>?;
    final inicio = fechas?['start'] as Map<String, dynamic>?;
    final estado = fechas?['status'] as Map<String, dynamic>?;

    final embebido = json['_embedded'] as Map<String, dynamic>?;
    final lugares = embebido?['venues'] as List<dynamic>?;
    if (lugares == null || lugares.isEmpty) return null;

    final lugar = lugares.first as Map<String, dynamic>;
    final ubicacion = lugar['location'] as Map<String, dynamic>?;
    final latitud = double.tryParse('${ubicacion?['latitude']}');
    final longitud = double.tryParse('${ubicacion?['longitude']}');
    if (latitud == null || longitud == null) return null;

    final clasificaciones = json['classifications'] as List<dynamic>?;
    final segmento = clasificaciones != null && clasificaciones.isNotEmpty
        ? (clasificaciones.first as Map<String, dynamic>)['segment']
            as Map<String, dynamic>?
        : null;

    final horaCompleta = inicio?['localTime'] as String?;

    return Evento(
      id: json['id'] as String,
      nombre: json['name'] as String? ?? 'Evento sin nombre',
      fecha: inicio?['localDate'] as String?,
      // "18:00:00" → "18:00"
      hora: horaCompleta != null && horaCompleta.length >= 5
          ? horaCompleta.substring(0, 5)
          : horaCompleta,
      estado: estado?['code'] as String?,
      lugar: lugar['name'] as String?,
      ciudad: (lugar['city'] as Map<String, dynamic>?)?['name'] as String?,
      categoria: segmento?['name'] as String?,
      url: json['url'] as String?,
      coordenadas: LatLng(latitud, longitud),
    );
  }
}
