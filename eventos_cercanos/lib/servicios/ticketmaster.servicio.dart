import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../config/config.dart';
import '../modelos/evento.modelo.dart';
import '../modelos/filtro.modelo.dart';

/// Se encarga de consultar la API Discovery de Ticketmaster para buscar
/// eventos cercanos a una ubicación.
class TicketmasterServicio {
  /// Busca eventos alrededor de [ubicacion] dentro del radio del [filtro],
  /// aplicando opcionalmente ciudad, categoría y palabra clave.
  /// Lanza una [Exception] si la consulta falla.
  static Future<List<Evento>> buscarEventos({
    required LatLng ubicacion,
    required Filtro filtro,
  }) async {
    if (Config.apiKey.isEmpty) {
      throw Exception(Config.textoSinApiKey);
    }

    final parametros = <String, String>{
      'apikey': Config.apiKey,
      'latlong': '${ubicacion.latitude},${ubicacion.longitude}',
      'radius': filtro.radioKm.toString(),
      'unit': 'km',
      'size': Config.tamanoPagina.toString(),
      'sort': 'date,asc',
    };
    if (filtro.ciudad.trim().isNotEmpty) {
      parametros['city'] = filtro.ciudad.trim();
    }
    if (filtro.categoria.isNotEmpty) {
      parametros['classificationName'] = filtro.categoria;
    }
    if (filtro.palabraClave.trim().isNotEmpty) {
      parametros['keyword'] = filtro.palabraClave.trim();
    }

    final uri = Uri.parse(Config.urlEventos).replace(queryParameters: parametros);
    final respuesta = await http.get(uri);

    if (respuesta.statusCode == 401) {
      throw Exception('API Key inválida (código 401)');
    }
    if (respuesta.statusCode != 200) {
      throw Exception('No se pudo consultar la API (código ${respuesta.statusCode})');
    }

    final datos = jsonDecode(respuesta.body) as Map<String, dynamic>;
    final embebido = datos['_embedded'] as Map<String, dynamic>?;
    final eventosJson = embebido?['events'] as List<dynamic>?;

    // Si no hay eventos la API no incluye "_embedded".
    if (eventosJson == null) return [];

    return eventosJson
        .map((json) => Evento.desdeJson(json as Map<String, dynamic>))
        .whereType<Evento>()
        .toList();
  }
}
