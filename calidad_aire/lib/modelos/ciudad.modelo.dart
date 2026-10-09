/// Representa una ciudad de Colombia con sus coordenadas geográficas,
/// necesarias para consultar la API de calidad del aire de Open-Meteo.
class Ciudad {
  final String nombre;
  final double latitud;
  final double longitud;

  const Ciudad({
    required this.nombre,
    required this.latitud,
    required this.longitud,
  });
}

/// Listado de ciudades principales de Colombia disponibles para la consulta.
const List<Ciudad> ciudadesColombia = [
  Ciudad(nombre: 'Bogotá', latitud: 4.61, longitud: -74.08),
  Ciudad(nombre: 'Medellín', latitud: 6.25, longitud: -75.56),
  Ciudad(nombre: 'Cali', latitud: 3.45, longitud: -76.53),
  Ciudad(nombre: 'Barranquilla', latitud: 10.96, longitud: -74.80),
  Ciudad(nombre: 'Cartagena', latitud: 10.39, longitud: -75.51),
  Ciudad(nombre: 'Bucaramanga', latitud: 7.12, longitud: -73.12),
];
