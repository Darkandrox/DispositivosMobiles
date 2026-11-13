import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

import 'package:eventos_cercanos/modelos/evento.modelo.dart';

void main() {
  test('Evento.desdeJson lee los campos anidados de Ticketmaster', () {
    final evento = Evento.desdeJson({
      'name': 'World Cup: Match 49 Group C - Scotland vs Brazil',
      'id': 'Z7r9jZ1A743fw',
      'dates': {
        'start': {'localDate': '2026-06-24', 'localTime': '18:00:00'},
        'status': {'code': 'onsale'},
      },
      '_embedded': {
        'venues': [
          {
            'name': 'Hard Rock Stadium',
            'city': {'name': 'Miami'},
            'location': {'longitude': '-80.245697000', 'latitude': '25.948900000'},
          },
        ],
      },
    });

    expect(evento, isNotNull);
    expect(evento!.fecha, '2026-06-24');
    expect(evento.hora, '18:00');
    expect(evento.estado, 'onsale');
    expect(evento.lugar, 'Hard Rock Stadium');
    expect(evento.coordenadas, const LatLng(25.9489, -80.245697));
  });

  test('Evento.desdeJson descarta eventos sin coordenadas', () {
    expect(Evento.desdeJson({'id': 'x', 'name': 'Sin lugar'}), isNull);
  });
}
