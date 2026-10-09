import 'dart:convert';
import 'package:http/http.dart' as http;

/// Se encarga de consultar la API pública de calidad del aire de Open-Meteo
/// y calcular el promedio diario de PM2.5 para una ciudad y fecha dadas.
class OpenMeteoServicio {
  static const String _urlBase = 'https://air-quality-api.open-meteo.com/v1/air-quality';

  /// Consulta el promedio diario de PM2.5 (µg/m³) para la ciudad y fecha
  /// indicadas. Lanza una [Exception] si la consulta falla o no hay datos.
  static Future<double> obtenerPromedioPm25({
    required double latitud,
    required double longitud,
    required DateTime fecha,
  }) async {
    final fechaTexto = _formatearFecha(fecha);

    final uri = Uri.parse(_urlBase).replace(queryParameters: {
      'latitude': latitud.toString(),
      'longitude': longitud.toString(),
      'hourly': 'pm2_5',
      'start_date': fechaTexto,
      'end_date': fechaTexto,
    });

    final respuesta = await http.get(uri);

    if (respuesta.statusCode != 200) {
      throw Exception('No se pudo consultar la API (código ${respuesta.statusCode})');
    }

    final datos = jsonDecode(respuesta.body) as Map<String, dynamic>;
    final horario = datos['hourly'] as Map<String, dynamic>?;
    final valoresPm25 = horario?['pm2_5'] as List<dynamic>?;

    if (valoresPm25 == null || valoresPm25.isEmpty) {
      throw Exception('La API no retornó datos de PM2.5 para esta fecha');
    }

    final valoresValidos = valoresPm25
        .where((valor) => valor != null)
        .map((valor) => (valor as num).toDouble())
        .toList();

    if (valoresValidos.isEmpty) {
      throw Exception('No hay registros válidos de PM2.5 para esta fecha');
    }

    final suma = valoresValidos.reduce((a, b) => a + b);
    return suma / valoresValidos.length;
  }

  static String _formatearFecha(DateTime fecha) {
    final anio = fecha.year.toString().padLeft(4, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    final dia = fecha.day.toString().padLeft(2, '0');
    return '$anio-$mes-$dia';
  }
}
