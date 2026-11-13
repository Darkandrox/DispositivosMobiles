import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

/// Encapsula el uso de geolocator: verifica el servicio de ubicación,
/// solicita permisos y obtiene la posición actual del dispositivo.
class UbicacionServicio {
  /// Retorna la ubicación actual. Lanza una [Exception] con un mensaje
  /// claro si el GPS está apagado o si los permisos fueron negados.
  static Future<LatLng> obtenerUbicacionActual() async {
    final servicioActivo = await Geolocator.isLocationServiceEnabled();
    if (!servicioActivo) {
      throw Exception('El servicio de ubicación (GPS) está desactivado');
    }

    var permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied) {
        throw Exception('Permiso de ubicación denegado');
      }
    }

    if (permiso == LocationPermission.deniedForever) {
      throw Exception(
        'Permiso de ubicación denegado permanentemente. '
        'Actívalo desde los ajustes del dispositivo',
      );
    }

    final Position posicion = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
    return LatLng(posicion.latitude, posicion.longitude);
  }

  /// Abre los ajustes de la app para que el usuario conceda el permiso.
  static Future<void> abrirAjustes() => Geolocator.openAppSettings();
}
