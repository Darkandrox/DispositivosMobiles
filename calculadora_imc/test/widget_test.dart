import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calculadora_imc/main.dart';

void main() {
  testWidgets('Calcula el IMC y muestra la categoría', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AplicacionImc());

    expect(find.text('Calculadora de IMC'), findsWidgets);

    await tester.enterText(find.widgetWithText(TextFormField, 'Peso (kg)'), '70');
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Altura (m)'),
      '1.72',
    );

    await tester.tap(find.widgetWithText(ElevatedButton, 'Calcular IMC'));
    await tester.pump();

    expect(find.text('Tu IMC es: 23.66'), findsOneWidget);
    expect(find.text('Categoría: Peso normal'), findsOneWidget);
  });

  testWidgets('Muestra errores de validación con campos vacíos', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AplicacionImc());

    await tester.tap(find.widgetWithText(ElevatedButton, 'Calcular IMC'));
    await tester.pump();

    expect(
      find.text('El campo peso no puede estar vacío'),
      findsOneWidget,
    );
    expect(
      find.text('El campo altura no puede estar vacío'),
      findsOneWidget,
    );
  });
}
