import 'package:flutter/material.dart';

import 'vistas/calidad_aire.vista.dart';

void main() {
  runApp(const AplicacionCalidadAire());
}

class AplicacionCalidadAire extends StatelessWidget {
  const AplicacionCalidadAire({super.key});

  @override
  Widget build(BuildContext context) {
    final esquemaColores = ColorScheme.fromSeed(
      seedColor: Colors.teal,
      brightness: Brightness.light,
    ).copyWith(
      primary: Colors.teal.shade700,
      onPrimary: Colors.white,
      secondary: Colors.blueGrey.shade700,
      surface: Colors.grey.shade50,
      onSurface: Colors.grey.shade900,
      primaryContainer: Colors.teal.shade50,
      onPrimaryContainer: Colors.teal.shade900,
    );

    return MaterialApp(
      title: 'Calidad del Aire',
      theme: ThemeData(
        colorScheme: esquemaColores,
        scaffoldBackgroundColor: Colors.grey.shade50,
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.teal.shade700,
          foregroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.teal.shade700, width: 2),
          ),
          labelStyle: TextStyle(color: Colors.grey.shade800),
          prefixIconColor: Colors.teal.shade700,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      home: const CalidadAireVista(),
    );
  }
}
