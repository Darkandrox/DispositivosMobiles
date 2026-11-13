import 'package:flutter/material.dart';

import '../config/config.dart';
import '../modelos/evento.modelo.dart';

/// Panel inferior (BottomSheet) con la información de un evento.
class DetalleEventoVista extends StatelessWidget {
  final Evento evento;
  final VoidCallback alIrAhora;

  const DetalleEventoVista({
    super.key,
    required this.evento,
    required this.alIrAhora,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    evento.nombre,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            _Dato(icono: Icons.calendar_today, texto: 'Fecha: ${evento.fecha ?? Config.textoNoDisponible}'),
            _Dato(icono: Icons.access_time, texto: 'Horario: ${evento.hora ?? Config.textoNoDisponible}'),
            _Dato(icono: Icons.confirmation_number, texto: 'Estado: ${evento.estado ?? Config.textoNoDisponible}'),
            if (evento.lugar != null)
              _Dato(
                icono: Icons.stadium,
                texto: 'Lugar: ${evento.lugar}${evento.ciudad != null ? ' - ${evento.ciudad}' : ''}',
              ),
            if (evento.categoria != null)
              _Dato(icono: Icons.category, texto: 'Categoría: ${evento.categoria}'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: alIrAhora,
                icon: const Icon(Config.iconoIrAhora),
                label: const Text(Config.textoIrAhora),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dato extends StatelessWidget {
  final IconData icono;
  final String texto;

  const _Dato({required this.icono, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icono, size: 18, color: Config.colorPrimario),
          const SizedBox(width: 10),
          Expanded(child: Text(texto)),
        ],
      ),
    );
  }
}
