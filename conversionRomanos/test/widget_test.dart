import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:conversion_romanos/main.dart';

void main() {
  testWidgets('Convierte un número arábigo válido a romano', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.byType(TextFormField), '1994');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Convertir'));
    await tester.pump();

    expect(find.text('Resultado: MCMXCIV'), findsOneWidget);
  });

  testWidgets('Muestra un error si el número está fuera de rango', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.byType(TextFormField), '4000');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Convertir'));
    await tester.pump();

    expect(find.text('Ingresa un número entre 1 y 3999'), findsOneWidget);
    expect(find.textContaining('Resultado: M'), findsNothing);
  });
}
