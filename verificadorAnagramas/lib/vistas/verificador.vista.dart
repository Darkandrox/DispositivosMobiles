import 'package:flutter/material.dart';

class VerificadorVista extends StatefulWidget {
  const VerificadorVista({super.key});

  @override
  State<StatefulWidget> createState() => _VerificadorState();
}

class _VerificadorState extends State<VerificadorVista> {
  final _txtFrase1 = TextEditingController();
  final _txtFrase2 = TextEditingController();
  String _resultado = '';

  // Deja solo las letras (sin espacios, signos de puntuación) y en minúscula
  String _normalizar(String texto) {
    final soloLetras = texto
        .toLowerCase()
        .replaceAll(RegExp(r'[^\p{L}]', unicode: true), '');
    final letras = soloLetras.split('')..sort();
    return letras.join();
  }

  bool _sonAnagramas(String frase1, String frase2) {
    return _normalizar(frase1) == _normalizar(frase2);
  }

  // Se ejecuta cuando el usuario presiona el botón
  void _verificar() {
    final esAnagrama = _sonAnagramas(_txtFrase1.text, _txtFrase2.text);
    setState(() {
      _resultado = esAnagrama
          ? 'Las frases son anagramas'
          : 'Las frases NO son anagramas';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificador de Anagramas'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _txtFrase1,
              decoration: const InputDecoration(
                labelText: 'Ingresa primera frase',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _txtFrase2,
              decoration: const InputDecoration(
                labelText: 'Ingresa segunda frase',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _verificar,
              child: const Text('Verificar'),
            ),
            const SizedBox(height: 32),
            Text(
              _resultado,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
