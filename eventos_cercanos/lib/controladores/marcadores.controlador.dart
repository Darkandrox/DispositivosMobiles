import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../config/config.dart';
import '../modelos/evento.modelo.dart';

/// Construye los marcadores (pins) que se dibujan en el MarkerLayer.
class MarcadoresControlador {
  static Marker marcadorUsuario(LatLng ubicacion) {
    return Marker(
      point: ubicacion,
      width: Config.tamanoMarcador,
      height: Config.tamanoMarcador,
      child: const Icon(
        Config.iconoUsuario,
        color: Config.colorUsuario,
        size: 32,
      ),
    );
  }

  static List<Marker> marcadoresEventos(
    List<Evento> eventos,
    void Function(Evento) alTocar,
  ) {
    return eventos.map((evento) {
      return Marker(
        point: evento.coordenadas,
        width: Config.tamanoMarcador,
        height: Config.tamanoMarcador,
        // La punta del pin debe quedar sobre la coordenada.
        alignment: Alignment.topCenter,
        child: GestureDetector(
          onTap: () => alTocar(evento),
          child: const Icon(
            Config.iconoEvento,
            color: Config.colorEvento,
            size: Config.tamanoMarcador,
          ),
        ),
      );
    }).toList();
  }
}
