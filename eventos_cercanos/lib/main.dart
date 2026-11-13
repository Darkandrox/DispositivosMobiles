import 'package:flutter/material.dart';

import 'config/config.dart';
import 'vistas/eventos_cercanos.vista.dart';

void main() {
  runApp(const AplicacionEventosCercanos());
}

class AplicacionEventosCercanos extends StatelessWidget {
  const AplicacionEventosCercanos({super.key});

  @override
  Widget build(BuildContext context) {
    final esquemaColores = ColorScheme.fromSeed(
      seedColor: Config.colorPrimario,
      brightness: Brightness.light,
    );

    return MaterialApp(
      title: Config.tituloApp,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: esquemaColores,
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Config.colorPrimario,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      home: const EventosCercanosVista(),
    );
  }
}
