import 'package:flutter/material.dart';

class ConversorVista extends StatefulWidget {
  const ConversorVista({super.key});

  @override
  State<StatefulWidget> createState() => _ConversorState();
}

class _ConversorState extends State<ConversorVista>{

final _txtNumero = TextEditingController();
  final _estadoFormulario = GlobalKey<FormState>();
  String _resultado = '';

  // Lógica de conversión de número arábigo a romano
  String _convertirARomano(int numero) {
    if (numero <= 0 || numero > 3999) {
      return 'Número fuera de rango (1-3999)';
    }

    const Map<int, String> numerosRomanos = {
      1000: 'M',
      900: 'CM',
      500: 'D',
      400: 'CD',
      100: 'C',
      90: 'XC',
      50: 'L',
      40: 'XL',
      10: 'X',
      9: 'IX',
      5: 'V',
      4: 'IV',
      1: 'I',
    };

    // obtener el numero romano
    String romano = "";
    while (numero > 0) {
      for (var valor in numerosRomanos.keys) {
        if (numero >= valor) {
          romano += numerosRomanos[valor]!;
          numero -= valor;
          break;
        }
      }
    }

    return romano;
  }

  // Se ejecuta cuando el usuario presiona el botón
  void _calcular() {
    if (_estadoFormulario.currentState!.validate()) {
      final int? numero = int.tryParse(_txtNumero.text);
      if (numero != null) {
        final romano = _convertirARomano(numero);
        setState(() {
          _resultado = romano;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Conversor a Números Romanos"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _estadoFormulario,
          child: Column(
            children: [
              const Text(
                'Ingresa un número para convertirlo a romano.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _txtNumero,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Número Arábigo (1-3999)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un número';
                  }
                  final int? numero = int.tryParse(value);
                  if (numero == null || numero <= 0 || numero > 3999) {
                    return 'Ingresa un número entre 1 y 3999';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _calcular,
                child: const Text('Convertir'),
              ),
              const SizedBox(height: 32),
              Text(
                'Resultado: $_resultado',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      )
    );
  }
  
}
