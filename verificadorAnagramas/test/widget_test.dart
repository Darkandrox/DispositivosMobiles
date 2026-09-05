import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:verificador_anagramas/main.dart';

void main() {
  Future<void> verificar(
    WidgetTester tester,
    String frase1,
    String frase2,
  ) async {
    final campos = find.byType(TextField);
    await tester.enterText(campos.at(0), frase1);
    await tester.enterText(campos.at(1), frase2);
    await tester.tap(find.widgetWithText(ElevatedButton, 'Verificar'));
    await tester.pump();
  }

  testWidgets('Detecta anagramas ignorando mayúsculas y espacios', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await verificar(tester, 'amor', 'roma');
    expect(find.text('Las frases son anagramas'), findsOneWidget);
  });

  testWidgets('Detecta anagramas con frases y puntuación', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await verificar(tester, 'televisor', 'revelisto');
    expect(find.text('Las frases son anagramas'), findsOneWidget);
  });

  testWidgets('Detecta frases que NO son anagramas', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await verificar(tester, 'hola', 'mundo');
    expect(find.text('Las frases NO son anagramas'), findsOneWidget);
  });
}
