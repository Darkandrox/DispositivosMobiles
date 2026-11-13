import 'package:flutter/animation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Mueve la cámara del mapa de forma suave (interpolando centro y zoom)
/// en lugar de saltar directamente al destino.
class AnimacionMapaControlador {
  final MapController mapController;
  final TickerProvider vsync;

  AnimationController? _animacionActual;

  AnimacionMapaControlador({required this.mapController, required this.vsync});

  void moverA(LatLng destino, double zoomDestino) {
    _animacionActual?.dispose();

    final camara = mapController.camera;
    final latitud = Tween<double>(
      begin: camara.center.latitude,
      end: destino.latitude,
    );
    final longitud = Tween<double>(
      begin: camara.center.longitude,
      end: destino.longitude,
    );
    final zoom = Tween<double>(begin: camara.zoom, end: zoomDestino);

    final controlador = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: vsync,
    );
    final curva = CurvedAnimation(
      parent: controlador,
      curve: Curves.fastOutSlowIn,
    );

    controlador.addListener(() {
      mapController.move(
        LatLng(latitud.evaluate(curva), longitud.evaluate(curva)),
        zoom.evaluate(curva),
      );
    });

    _animacionActual = controlador;
    controlador.forward();
  }

  void dispose() {
    _animacionActual?.dispose();
  }
}
