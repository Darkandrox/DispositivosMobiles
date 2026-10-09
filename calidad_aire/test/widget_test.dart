// Prueba básica de widgets para la Calculadora de Calidad del Aire.
//
// Verifica que la aplicación carga correctamente y muestra los campos
// principales del formulario.

import 'package:flutter_test/flutter_test.dart';

import 'package:calidad_aire/main.dart';

void main() {
  testWidgets('La app carga y muestra el formulario de consulta', (WidgetTester tester) async {
    await tester.pumpWidget(const AplicacionCalidadAire());

    expect(find.text('Calculadora de Calidad del Aire'), findsOneWidget);
    expect(find.text('Ciudad'), findsOneWidget);
    expect(find.text('Fecha de consulta'), findsOneWidget);
    expect(find.text('Horas de exposición diaria'), findsOneWidget);
    expect(find.text('Calcular Índice de Exposición'), findsOneWidget);
  });
}
